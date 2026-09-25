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
        case crisis(MoodStateOption?, Int?)
        case reply(MoodStateOption, Int?)
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
                case .crisis(let option, let index):
                    OrientationCrisisView {
                        if let option { show(option, index) } else { onNext() }
                    }
                case .reply(let option, let index):
                    MoodReliefView(state: option, chosenIndex: index,
                                   continueTitle: L.string("Continue", table: "Onboarding"),
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
                    Text("Your first guidance is a gift: a word from Scripture and the saints, chosen for what you write.", tableName: "Onboarding")
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
                    phase = .crisis(option, result.reliefIndex)
                } else if let option {
                    show(option, result.reliefIndex)
                } else {
                    phase = .notice(L.string("I couldn't quite tell how you are. In the app, \"Today I am…\" lets you choose it with one tap.", table: "Onboarding"))
                }
            } catch {
                if CrisisPhrases.matches(written) {
                    phase = .crisis(nil, nil)
                } else {
                    phase = .notice(L.string("I couldn't get the guidance right now. You'll find it in the app, in \"Today I am…\".", table: "Onboarding"))
                }
            }
        }
    }

    private func show(_ option: MoodStateOption, _ index: Int?) {
        phase = .reply(option, index)
    }
}
