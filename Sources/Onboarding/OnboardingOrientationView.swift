import SwiftUI

/// The orientação offered in the onboarding, free: right after the account,
/// before the notice times and the plans, the reader writes what they feel and
/// receives a reviewed reply chosen for it. The server allows each account one
/// orientação without a subscription; after that it lives in "Hoje eu estou…"
/// for subscribers.
///
/// Skippable, and it never blocks the onboarding: any failure turns into a
/// short note and "Continuar".
struct OnboardingOrientationView: View {
    let onBack: () -> Void
    let onNext: () -> Void

    private enum Phase: Equatable {
        case writing
        case guiding
        case crisis(MoodStateOption?, Int?, OrientationPassage?)
        /// `String?`: what the reader wrote, when a reflection may be asked.
        case reply(MoodStateOption, Int?, OrientationPassage?, String?)
        case notice(String)
    }

    @State private var phase: Phase = .writing
    @State private var text = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.parchment.ignoresSafeArea()
                switch phase {
                case .writing:
                    writing
                case .guiding:
                    VStack(spacing: 18) {
                        CrossGlyph(size: 30, color: Palette.wine)
                        ProgressView().tint(Palette.wine)
                        Text("Buscando nas Escrituras e nos santos uma palavra para você…", tableName: "Today")
                            .font(MissaleFont.display(22))
                            .foregroundStyle(Palette.ink)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 36)
                case .crisis(let option, let index, let passage):
                    OrientationCrisisView {
                        if let option { show(option, index, passage, reflectionText: nil) } else { onNext() }
                    }
                case .reply(let option, let index, let passage, let reflectionText):
                    MoodReliefView(state: option, chosenIndex: index, chosenPassage: passage,
                                   continueTitle: L.string("Continue", table: "Onboarding"),
                                   reflectionText: reflectionText, reflectionFree: true,
                                   onDone: onNext)
                case .notice(let message):
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                        Text(message)
                            .font(MissaleFont.body(18))
                            .foregroundStyle(Palette.ink)
                            .accessibilityIdentifier("onboardingOrientationNotice")
                        Spacer()
                        OnboardingPrimaryButton(title: L.string("Continue", table: "Onboarding"), isEnabled: true, action: onNext)
                            .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 28)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: phase)
        }
    }

    private var writing: some View {
        VStack(spacing: 0) {
            OnboardingTopBar(onBack: onBack)
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Tell us what you are feeling right now", tableName: "Onboarding")
                        .font(MissaleFont.display(27))
                        .foregroundStyle(Palette.ink)
                        .padding(.top, 16)
                    Text("From what you write, we'll look in the Bible for a passage connected to that feeling, to guide you in the Word of the Lord, and a saint who went through the same.", tableName: "Onboarding")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.7))
                    OrientationWritingCard(text: $text, onSend: send, onLocked: {}, isFree: true)
                        .padding(.top, 6)
                }
                .padding(.horizontal, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            Button(action: onNext) {
                Text("Skip for now", tableName: "Onboarding")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.6))
            }
            .accessibilityIdentifier("onboardingOrientationSkip")
            .padding(.vertical, 18)
        }
    }

    private func send() {
        let written = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !written.isEmpty else { return }
        phase = .guiding
        Task {
            do {
                let result = try await OrientationService.orient(written, free: true)
                let option = result.stateID.flatMap { id in MockMood.stateGroups.flatMap(\.items).first { $0.id == id } }
                if let option {
                    _ = MoodHistoryStore.shared.record(state: option, note: written)
                }
                if result.showCrisisFirst {
                    phase = .crisis(option, result.reliefIndex, result.passage)
                } else if let option {
                    show(option, result.reliefIndex, result.passage, reflectionText: written)
                } else {
                    phase = .notice(L.string("I couldn't quite tell how you are. In the app, \"Today I am…\" lets you choose it with one tap.", table: "Onboarding"))
                }
            } catch {
                if CrisisPhrases.matches(written) {
                    phase = .crisis(nil, nil, nil)
                } else {
                    phase = .notice(OrientationFailureMessage(error).text)
                }
            }
        }
    }

    private func show(_ option: MoodStateOption, _ index: Int?, _ passage: OrientationPassage?, reflectionText: String?) {
        phase = .reply(option, index, passage, reflectionText)
    }
}

/// The notice shown when `send()`'s request fails. Pulled out of `send()` so
/// the mapping from error to text is testable without a network call.
///
/// `subscriptionRequired` (402: the account's free orientação is already
/// spent) and `dailyLimit` (429) aren't a connection problem — trying again
/// does nothing — so they get their own wording pointing at "Hoje eu
/// estou…" instead of the generic one, which reads as worth retrying.
enum OrientationFailureMessage: Equatable {
    case limitReached
    case unavailable

    init(_ error: Error) {
        switch error {
        case MissaleAPI.Failure.subscriptionRequired, MissaleAPI.Failure.dailyLimit:
            self = .limitReached
        default:
            self = .unavailable
        }
    }

    var text: String {
        switch self {
        case .limitReached:
            return L.string("Written guidance isn't available on this account right now. In the app, \"Today I am…\" lets you choose how you are with one tap.", table: "Onboarding")
        case .unavailable:
            return L.string("I couldn't get the guidance right now. You'll find it in the app, in \"Today I am…\".", table: "Onboarding")
        }
    }
}
