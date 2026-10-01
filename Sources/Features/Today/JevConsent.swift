import SwiftUI

/// Whether the reader has allowed what they write to be sent to Jev — the
/// permission Apple's guideline 5.1.2(i) requires before any personal text
/// reaches a third-party AI. Separate from the Settings toggle
/// (`JevPicker.storageKey`): the toggle says the reader *wants* personalization
/// on; this says they were actually asked and answered.
enum JevConsent: String {
    case notAsked
    case granted
    case declined

    static let storageKey = "jev_consent"

#if DEBUG
    /// Runs once per process. `-resetJevConsent 1` clears any consent left
    /// over from an earlier UI test run sharing this simulator install, so a
    /// test that needs "not asked yet" doesn't inherit an old answer. Unlike
    /// `-jev_consent <value>` (what the other Jev UI tests pass, to force one
    /// state for their whole run — a launch argument sits in the highest­
    /// priority domain and would otherwise mask every write for the rest of
    /// the process), this only clears the starting value: answering the
    /// prompt during the run still persists normally.
    private static let resetForUITestsOnce: Void = {
        if UserDefaults.standard.volatileDomain(forName: UserDefaults.argumentDomain)["resetJevConsent"] as? String == "1" {
            UserDefaults.standard.removeObject(forKey: storageKey)
        }
    }()
#endif

    static var state: JevConsent {
        get {
#if DEBUG
            _ = resetForUITestsOnce
#endif
            return UserDefaults.standard.string(forKey: storageKey).flatMap(JevConsent.init) ?? .notAsked
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: storageKey) }
    }

    /// Granted → proceeds. Declined → nothing is sent, and the reader isn't
    /// asked again on their own. Not asked → shows the prompt
    /// (`JevConsentCoordinator`) and waits for the answer — the caller's
    /// `await` is the "don't block the flow" part: whatever screen the reader
    /// is on keeps working while this hangs in the background.
    @MainActor
    static func ensureGranted() async -> Bool {
        switch state {
        case .granted: return true
        case .declined: return false
        case .notAsked: return await JevConsentCoordinator.shared.requestConsent()
        }
    }
}

/// One pending request at a time, shared by every screen that might ask: the
/// screen that happens to be in front presents `JevConsentPromptView` (see
/// `TodayRootView`, `PrayersRootView`, `MoodCheckInSheet`) and calls `answer`
/// when the reader taps a button. If several features ask before the answer
/// comes back, they all share the one prompt and the one answer.
@MainActor
final class JevConsentCoordinator: ObservableObject {
    static let shared = JevConsentCoordinator()

    /// True while a screen should be showing the prompt.
    @Published private(set) var isPending = false

    private var waiters: [CheckedContinuation<Bool, Never>] = []

    private init() {}

    func requestConsent() async -> Bool {
        isPending = true
        return await withCheckedContinuation { waiters.append($0) }
    }

    func answer(granted: Bool) {
        JevConsent.state = granted ? .granted : .declined
        isPending = false
        let pending = waiters
        waiters = []
        pending.forEach { $0.resume(returning: granted) }
    }

    /// A screen's sheet was dismissed (a swipe, or the screen itself closing)
    /// without a tap on either button — counted as "Agora não", the same as a
    /// declined answer, so nothing is left waiting forever.
    func answerIfStillPending() {
        guard isPending else { return }
        answer(granted: false)
    }
}

/// The one-time prompt, in the app's own design language: a card, not a
/// system alert, so the copy and the link to the privacy policy fit. Shown by
/// whichever screen is on top when a personalized feature would first send
/// what the reader wrote — see `JevConsent.ensureGranted()`.
struct JevConsentPromptView: View {
    var onAllow: () -> Void
    var onDecline: () -> Void
    @State private var showPrivacyPolicy = false

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.parchment.ignoresSafeArea()
                VStack(spacing: 18) {
                    Spacer()
                    CrossGlyph(size: 30, color: Palette.wine)
                    Text("Personalizar com o que você escreve?", tableName: "Today")
                        .font(MissaleFont.display(25, weight: .semibold))
                        .foregroundStyle(Palette.ink)
                        .multilineTextAlignment(.center)
                    Text("Para escolher textos do acervo para você, o Missale envia o que você escreve a serviços de IA de outras empresas. O texto não é guardado. Você pode mudar isso nos Ajustes.", tableName: "Today")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.72))
                        .multilineTextAlignment(.center)

                    Button {
                        showPrivacyPolicy = true
                    } label: {
                        Text("Privacy Policy", tableName: "SettingsDetail")
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.wine)
                            .underline()
                    }

                    Spacer()

                    Button(action: onAllow) {
                        Text("Permitir", tableName: "Today")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Palette.wine, in: Capsule())
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("jevConsentAllow")

                    Button(action: onDecline) {
                        Text("Agora não", tableName: "Today")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 6)
                    .accessibilityIdentifier("jevConsentDecline")
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                NavigationStack { LegalDocumentView(document: .privacy) }
                    .appLanguageLocale()
            }
        }
        .interactiveDismissDisabled()
    }
}
