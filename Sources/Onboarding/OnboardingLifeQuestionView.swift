import SwiftUI

/// dIsLife × 4 — state-of-life questions. Flat/practical visual register.
struct OnboardingLifeQuestionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let index: Int
    let onBack: () -> Void
    let onNext: () -> Void

    private var questions: [LifeQuestion] { MockOnboarding.lifeQuestions(for: AppLanguagePreference.resolveCurrent()) }
    private var question: LifeQuestion { questions[index] }
    private var total: Int { questions.count }

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                OnboardingTopBar(
                    onBack: onBack,
                    trailingText: question.skippable ? L.string("Skip this one", table: "Onboarding") : nil,
                    trailingAction: question.skippable ? onNext : nil
                )
                OnboardingProgressBar(progress: Double(index + 1) / Double(total))
                    .padding(.top, 16)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L.string("{n} of {total}", table: "Onboarding")
                            .replacingOccurrences(of: "{n}", with: "\(index + 1)")
                            .replacingOccurrences(of: "{total}", with: "\(total)"))
                            .font(MissaleFont.body(13, weight: .semibold))
                            .foregroundStyle(Palette.ink.opacity(0.45))
                            .padding(.top, 24)
                        Text(question.title)
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)
                        if !question.subtitle.isEmpty {
                            Text(question.subtitle)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.6))
                        }

                        VStack(spacing: 10) {
                            ForEach(question.options) { option in
                                OnboardingOptionChip(
                                    text: option.text,
                                    subtitle: option.subtitle,
                                    isSelected: viewModel.isLifeSelected(questionID: question.id, optionID: option.id)
                                ) {
                                    viewModel.selectLife(questionID: question.id, optionID: option.id, multiSelect: question.multiSelect)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }

                OnboardingPrimaryButton(
                    title: L.string("Continue", table: "Onboarding"),
                    isEnabled: viewModel.hasAnyLifeAnswer(questionID: question.id),
                    action: onNext
                )
                .padding(.bottom, 24)
            }
        }
    }
}
