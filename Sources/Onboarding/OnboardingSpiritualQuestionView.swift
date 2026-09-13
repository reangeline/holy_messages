import SwiftUI

/// dIsSpirit × 4 — spiritual check-in questions. "Sacred/glass" visual register:
/// each option is its own frosted glass pill rather than a flat white card.
struct OnboardingSpiritualQuestionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let index: Int
    let onBack: () -> Void
    let onNext: () -> Void
    let onSkipAll: () -> Void

    private var question: SpiritualQuestion { MockOnboarding.spiritualQuestions[index] }
    private var total: Int { MockOnboarding.spiritualQuestions.count }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack, trailingText: "Skip all four", trailingAction: onSkipAll)

                HStack(spacing: 6) {
                    ForEach(0..<total, id: \.self) { i in
                        Capsule()
                            .fill(i <= index ? Palette.wine : Palette.wine.opacity(0.18))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(question.title)
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)
                            .padding(.top, 24)
                        if !question.subtitle.isEmpty {
                            Text(question.subtitle)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.65))
                        }

                        VStack(spacing: 10) {
                            ForEach(question.options) { option in
                                OnboardingOptionChip(
                                    text: option.text,
                                    isSelected: viewModel.spiritualAnswers[question.id] == option.id,
                                    glass: true
                                ) {
                                    viewModel.selectSpiritual(questionID: question.id, optionID: option.id)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }

                OnboardingPrimaryButton(
                    title: "Continue",
                    isEnabled: viewModel.spiritualAnswers[question.id] != nil,
                    action: onNext
                )
                OnboardingTextLink(title: "I'd rather not answer", action: onNext)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            }
        }
    }
}
