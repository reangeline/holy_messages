import SwiftUI

/// Root of the onboarding flow (t3/option 3a — 17 valid screens; the design's own
/// screen 19 "home" is superseded by the main app's Today tab, so it's skipped).
struct OnboardingFlow: View {
    var onFinished: () -> Void

    @StateObject private var viewModel = OnboardingViewModel()
    /// Black layer used to dip between the dark story screens and the light
    /// ones, so the flow never cuts straight from black to parchment.
    @State private var curtain = 0.0

    var body: some View {
        Group {
            switch viewModel.current {
            case .verseIntro:
                OnboardingVerseIntroView(onContinue: viewModel.advanceFromVerseIntro)

            case .promise:
                OnboardingPromiseView(onContinue: { dip(viewModel.advanceFromPromise) })

            case .life(let index):
                OnboardingLifeQuestionView(
                    viewModel: viewModel,
                    index: index,
                    onBack: viewModel.back,
                    onNext: { viewModel.advanceFromLife(index: index) }
                )

            case .spiritualIntro:
                OnboardingSpiritualIntroView(
                    onBack: viewModel.back,
                    onAnswer: viewModel.advanceFromSpiritualIntro,
                    onSkipAll: viewModel.skipAllSpiritual
                )

            case .spiritual(let index):
                OnboardingSpiritualQuestionView(
                    viewModel: viewModel,
                    index: index,
                    onBack: viewModel.back,
                    onNext: { viewModel.advanceFromSpiritual(index: index) },
                    onSkipAll: viewModel.skipAllSpiritual
                )

            case .relief:
                OnboardingReliefView(viewModel: viewModel, onBack: viewModel.back, onNext: { dip(viewModel.advanceFromRelief) })

            case .prayer:
                OnboardingPrayerView(onNext: { dip(viewModel.advanceFromPrayer) })

            case .loader:
                OnboardingLoaderView(onFinished: viewModel.advanceFromLoader)

            case .synthesis:
                OnboardingSynthesisView(viewModel: viewModel, onNext: viewModel.advanceFromSynthesis)

            case .signIn:
                SignInView(onSignedIn: viewModel.advanceFromSignIn)

            case .notificationTime:
                OnboardingNotificationTimeView(viewModel: viewModel, onBack: viewModel.back, onNext: viewModel.advanceFromNotificationTime)

            case .notificationPreview:
                OnboardingNotificationPreviewView(
                    viewModel: viewModel,
                    onBack: viewModel.back,
                    onAllow: viewModel.requestNotificationsThenAdvance,
                    onNotNow: viewModel.skipNotifications
                )

            case .paywall:
                OnboardingPaywallView(onFinish: onFinished)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isStepChanging)
        .overlay {
            Color.black.opacity(curtain).ignoresSafeArea().allowsHitTesting(false)
        }
    }

    private func dip(_ advance: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.6)) { curtain = 1 }
        Task {
            try? await Task.sleep(for: .milliseconds(650))
            advance()
            withAnimation(.easeInOut(duration: 1.6)) { curtain = 0 }
        }
    }

    // A simple string projection of the current step, just so `.animation(value:)`
    // has something Equatable to compare without exposing OnboardingStep's associated
    // values as the animation trigger (which would also fire on option selection).
    private var isStepChanging: String {
        String(describing: viewModel.current)
    }
}
