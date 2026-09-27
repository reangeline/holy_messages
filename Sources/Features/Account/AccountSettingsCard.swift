import SwiftUI

/// Settings › Account: sign out, and delete the account (App Store guideline
/// 5.1.1(v) requires deletion inside the app for any app with sign-up).
struct AccountSettingsCard: View {
    @ObservedObject private var account = AccountStore.shared
    @State private var confirmDelete = false
    @State private var deleting = false
    @State private var deleteFailed = false
    /// Apple couldn't confirm the reader's identity (not a cancel): offers to
    /// delete anyway, without revoking the Sign in with Apple grant.
    @State private var appleReauthFailed = false

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Eyebrow(text: L.string("Account", table: "Account"))
                Text("Signed in with Apple", tableName: "Account")
                    .font(MissaleFont.body(17))
                    .foregroundStyle(Palette.ink)

                Divider()

                Button {
                    account.signOut()
                } label: {
                    Text("Sign out", tableName: "Account")
                        .font(MissaleFont.body(17))
                        .foregroundStyle(Palette.ink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("signOut")

                Button {
                    confirmDelete = true
                } label: {
                    HStack {
                        Text("Delete account", tableName: "Account")
                            .font(MissaleFont.body(17))
                            .foregroundStyle(Palette.wine)
                        Spacer()
                        if deleting { ProgressView() }
                    }
                }
                .buttonStyle(.plain)
                .disabled(deleting)
                .accessibilityIdentifier("deleteAccount")
            }
        }
        .confirmationDialog(
            L.string("Delete your account?", table: "Account"),
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button(L.string("Delete account", table: "Account"), role: .destructive) { delete() }
            Button(L.string("Cancel", table: "Account"), role: .cancel) {}
        } message: {
            Text("Your account is erased from our server. What you wrote stays on this iPhone — erase it in Your data. A subscription is not cancelled by this: cancel it in the App Store.", tableName: "Account")
                + Text("\n\n")
                + Text("To disconnect Missale from your Apple ID, confirm with Apple.", tableName: "Account")
        }
        .alert(L.string("We couldn't delete the account. Check your connection and try again.", table: "Account"),
               isPresented: $deleteFailed) {
            Button(L.string("Got it", table: "Account"), role: .cancel) {}
        }
        .alert(L.string("We couldn't confirm with Apple.", table: "Account"), isPresented: $appleReauthFailed) {
            Button(L.string("Delete anyway", table: "Account"), role: .destructive) { delete(revokeApple: false) }
            Button(L.string("Cancel", table: "Account"), role: .cancel) {}
        } message: {
            Text("Your account will be deleted, but the Apple sign-in link may remain active. You can remove it later in Settings › Apple ID › Sign in with Apple.", tableName: "Account")
        }
    }

    private func delete(revokeApple: Bool = true) {
        deleting = true
        Task {
            do {
                try await account.deleteAccount(revokeApple: revokeApple)
            } catch AppleReauthorization.Failure.cancelled {
                // Closing the Apple sheet cancels the deletion; nothing was sent.
            } catch AppleReauthorization.Failure.failed {
                appleReauthFailed = true
            } catch {
                deleteFailed = true
            }
            deleting = false
        }
    }
}
