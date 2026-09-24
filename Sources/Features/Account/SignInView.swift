import AuthenticationServices
import SwiftUI

/// The sign-in screen: a step of the onboarding, and what a reader who
/// installed before accounts existed sees when the app opens.
///
/// Sign in with Apple only. Apple lets the reader hide their email, and there
/// is no password for us to keep.
struct SignInView: View {
    var onSignedIn: () -> Void

    @ObservedObject private var account = AccountStore.shared
    @State private var working = false
    @State private var failed = false

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 24)
                CrossGlyph(size: 30, color: Palette.wine)
                    .padding(.bottom, 20)
                Text("Create your Missale account", tableName: "Account")
                    .font(MissaleFont.display(30))
                    .foregroundStyle(Palette.ink)
                    .padding(.bottom, 12)
                Text("It keeps your subscription and opens the way to the personal guidance — you write what you feel and receive a word from Scripture and the saints.", tableName: "Account")
                    .font(MissaleFont.body(17))
                    .foregroundStyle(Palette.ink.opacity(0.78))
                    .padding(.bottom, 22)

                VStack(alignment: .leading, spacing: 12) {
                    point("lock", Text("What you write and log stays on your iPhone, as before.", tableName: "Account"))
                    point("envelope", Text("Apple lets you hide your email. There is no password to create.", tableName: "Account"))
                    point("trash", Text("You can delete the account in Settings whenever you want.", tableName: "Account"))
                }

                Spacer(minLength: 24)

                if failed {
                    Text("We couldn't sign you in. Check your connection and try again.", tableName: "Account")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.wine)
                        .padding(.bottom, 12)
                        .accessibilityIdentifier("signInError")
                }

                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.email]
                } onCompletion: { result in
                    handle(result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 54)
                .clipShape(Capsule())
                .disabled(working)
                .overlay { if working { ProgressView().tint(.white) } }
                .accessibilityIdentifier("signInWithApple")
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 20)
        }
    }

    private func point(_ symbol: String, _ text: Text) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 15))
                .foregroundStyle(Palette.wine)
                .frame(width: 20)
            text
                .font(MissaleFont.body(16))
                .foregroundStyle(Palette.ink.opacity(0.8))
        }
    }

    private func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .failure(let error):
            // Closing the Apple sheet is a choice, not an error.
            failed = (error as? ASAuthorizationError)?.code != .canceled
        case .success(let authorization):
            working = true
            failed = false
            Task {
                do {
                    try await account.signIn(with: authorization)
                    onSignedIn()
                } catch {
                    failed = true
                }
                working = false
            }
        }
    }
}
