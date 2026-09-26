import SwiftUI

/// What a restore tells the reader. Both "Restore purchases" buttons — the
/// paywall's and the one in Settings — share it, so neither ends in silence
/// again. `.cancelled` shows nothing: closing the password sheet is a choice.
extension View {
    func restoreResultAlert(_ result: Binding<SubscriptionStore.RestoreResult?>) -> some View {
        let titulo: String
        let mensagem: String
        switch result.wrappedValue {
        case .restored:
            titulo = L.string("Subscription restored", table: "SettingsDetail")
            mensagem = L.string("Your subscription is active on this device.", table: "SettingsDetail")
        case .nothingFound:
            titulo = L.string("No active subscription found", table: "SettingsDetail")
            mensagem = L.string("This Apple ID has no active Missale subscription. If you subscribed with another Apple ID, sign in with it in the App Store and try again.", table: "SettingsDetail")
        case .failed:
            titulo = L.string("Couldn't restore", table: "SettingsDetail")
            mensagem = L.string("The App Store couldn't be reached. Check your connection and try again.", table: "SettingsDetail")
        case .cancelled, nil:
            titulo = ""
            mensagem = ""
        }
        return alert(
            titulo,
            isPresented: Binding(
                get: { !titulo.isEmpty },
                set: { if !$0 { result.wrappedValue = nil } }
            )
        ) {
            Button(L.string("OK", table: "Onboarding"), role: .cancel) {}
        } message: {
            Text(mensagem)
        }
    }
}
