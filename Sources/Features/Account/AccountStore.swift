import AuthenticationServices
import Foundation

/// The reader's Missale account: Sign in with Apple, the session that follows,
/// and deleting it.
///
/// An account is required to use the app (a product decision). It holds no
/// content: what the reader writes stays on the device, as before. The server
/// knows the Apple user identifier and, for the orientação, how many requests
/// were made per day.
@MainActor
final class AccountStore: ObservableObject {
    static let shared = AccountStore()

    @Published private(set) var session: StoredSession?

    var isSignedIn: Bool {
#if DEBUG
        if debugForcedSignIn { return true }
#endif
        return session != nil
    }

#if DEBUG
    /// Lets the UI suite past the sign-in screen: a simulator can't complete
    /// Sign in with Apple without an Apple ID signed in and a human at the sheet.
    ///
    ///     app.launchArguments = ["-signedIn", "1"]
    private var debugForcedSignIn: Bool {
        UserDefaults.standard
            .volatileDomain(forName: UserDefaults.argumentDomain)["signedIn"] as? String == "1"
    }
#endif

    private init() {
        // Keychain items outlive the app: deleting Missale and installing it
        // again would find the old session. A fresh install hasn't finished
        // the onboarding, so its session is left over from before and goes.
        if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            SessionKeychain.clear()
        }
        session = SessionKeychain.load()
    }

    // MARK: - Sign in

    enum SignInError: Error {
        case cancelled
        case failed
    }

    func signIn(with authorization: ASAuthorization) async throws {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let identityToken = String(data: tokenData, encoding: .utf8)
        else { throw SignInError.failed }
        let issued = try await MissaleAPI.signInWithApple(identityToken: identityToken)
        try store(issued, appleUserID: credential.user)
    }

    // MARK: - Using the session

    /// An access token good for at least a minute, refreshed when needed.
    /// Signs out when the server says the session is over.
    func validAccessToken() async throws -> String {
        guard var current = session else { throw MissaleAPI.Failure.unauthorized }
        if current.expiresAt.timeIntervalSinceNow > 60 { return current.accessToken }
        do {
            let renewed = try await MissaleAPI.refresh(refreshToken: current.refreshToken)
            current.accessToken = renewed.accessToken
            current.expiresAt = Date().addingTimeInterval(TimeInterval(renewed.expiresIn))
            save(current)
            return current.accessToken
        } catch MissaleAPI.Failure.unauthorized {
            signOut()
            throw MissaleAPI.Failure.unauthorized
        }
    }

    /// Called when the app comes to the foreground: if the reader stopped using
    /// Sign in with Apple for Missale (Settings › Apple ID › Sign in with
    /// Apple), the session ends here too.
    func checkAppleCredential() async {
        guard let appleUserID = session?.appleUserID else { return }
        let state = try? await ASAuthorizationAppleIDProvider().credentialState(forUserID: appleUserID)
        if state == .revoked || state == .notFound { signOut() }
    }

    func signOut() {
        SessionKeychain.clear()
        session = nil
    }

    /// Deletes the account on the server, then signs out. What the reader
    /// wrote is on the device and is not touched — Settings › Your data erases it.
    func deleteAccount() async throws {
        let token = try await validAccessToken()
        try await MissaleAPI.deleteAccount(accessToken: token)
        signOut()
    }

    // MARK: -

    private func store(_ issued: MissaleAPI.Session, appleUserID: String) throws {
        guard let refreshToken = issued.refreshToken else { throw SignInError.failed }
        save(StoredSession(
            accessToken: issued.accessToken,
            refreshToken: refreshToken,
            expiresAt: Date().addingTimeInterval(TimeInterval(issued.expiresIn)),
            appleUserID: appleUserID))
    }

    private func save(_ new: StoredSession) {
        SessionKeychain.save(new)
        session = new
    }
}
