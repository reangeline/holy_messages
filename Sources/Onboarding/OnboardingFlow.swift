import SwiftUI

/// Root of the onboarding flow (t3/option 3a — 18 valid screens; the design's own
/// screen 19 "home" is superseded by the main app's Today tab, so it's skipped).
struct OnboardingFlow: View {
    var onFinished: () -> Void

    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        Group {
            switch viewModel.current {
            case .feed:
                OnboardingFeedView(onContinue: viewModel.advanceFromFeed)

            case .sample:
                OnboardingSampleView(onBack: viewModel.back, onContinue: viewModel.advanceFromSample)

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
                OnboardingReliefView(viewModel: viewModel, onBack: viewModel.back, onNext: viewModel.advanceFromRelief)

            case .crisis:
                OnboardingCrisisView(onNext: viewModel.advanceFromCrisis)

            case .loader:
                OnboardingLoaderView(onFinished: viewModel.advanceFromLoader)

            case .synthesis:
                OnboardingSynthesisView(onNext: viewModel.advanceFromSynthesis)

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
    }

    // A simple string projection of the current step, just so `.animation(value:)`
    // has something Equatable to compare without exposing OnboardingStep's associated
    // values as the animation trigger (which would also fire on option selection).
    private var isStepChanging: String {
        String(describing: viewModel.current)
    }
}
