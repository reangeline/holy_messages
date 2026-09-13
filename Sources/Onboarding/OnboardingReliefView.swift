import SwiftUI

/// dIs11 — immediate relief: Psalm + saint + concrete step, personalized by the
/// spiritual-check-in answers. Pays off the questions before any synthesis/paywall.
struct OnboardingReliefView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onNext: () -> Void

    private var relief: ReliefContent { viewModel.reliefContent }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Eyebrow(text: "Before anything else")
                        Text(relief.title)
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)

                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(relief.psalmRef.uppercased())
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.4)
                                    .foregroundStyle(Palette.goldBright)
                                Text(relief.psalmText)
                                    .font(MissaleFont.display(20, italic: true))
                                    .foregroundStyle(.white)
                                Text(relief.psalmWhy)
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: "Someone who went through it")
                                Text(relief.saintName)
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text(relief.saintWhy)
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.75))
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: relief.stepTitle)
                                Text(relief.stepBody)
                                    .font(MissaleFont.body(16))
                                    .foregroundStyle(Palette.ink.opacity(0.85))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                OnboardingPrimaryButton(title: "Continue", action: onNext)
                Text("Yours to keep, free, whether or not you ever pay.")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                    .padding(.vertical, 10)
            }
        }
    }
}
