import AuthenticationServices
import UIKit

/// Asks Apple, right before deleting the account, for one fresh Sign in with
/// Apple authorization code — not a new session, just proof we still hold
/// this Apple ID, and a code the server exchanges to revoke Missale's Apple
/// grant (App Store guideline 5.1.1(v)). We never store an Apple token: the
/// code is used once and thrown away.
///
/// `ASAuthorizationController`'s delegate callbacks are bridged to
/// async/await here; the original sign-in flow stays on the SwiftUI
/// `SignInWithAppleButton` in `SignInView`.
final class AppleReauthorization: NSObject, ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding {

    enum Failure: Error {
        /// The person dismissed the Apple sheet.
        case cancelled
        case failed
    }

    /// Fetches one authorization code, presenting the system Apple sheet.
    static func authorizationCode() async throws -> String {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        let authorization = try await AppleReauthorization().perform(request)
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let codeData = credential.authorizationCode,
              let code = String(data: codeData, encoding: .utf8)
        else { throw Failure.failed }
        return code
    }

    private var continuation: CheckedContinuation<ASAuthorization, Error>?
    // Keeps this delegate alive for the request's lifetime; released once
    // `perform` returns, right after the continuation resumes.
    private var retained: AppleReauthorization?

    private func perform(_ request: ASAuthorizationAppleIDRequest) async throws -> ASAuthorization {
        retained = self
        defer { retained = nil }
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        continuation?.resume(returning: authorization)
        continuation = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let error = error as? ASAuthorizationError, error.code == .canceled {
            continuation?.resume(throwing: Failure.cancelled)
        } else {
            continuation?.resume(throwing: Failure.failed)
        }
        continuation = nil
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
