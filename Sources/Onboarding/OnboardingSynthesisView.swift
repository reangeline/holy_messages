import SwiftUI

/// dIs14 — formation track synthesis. Back to the flat/practical register.
struct OnboardingSynthesisView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Eyebrow(text: L.string("Your formation track", table: "Onboarding"))
                        Text("A short plan, starting today", tableName: "Onboarding")
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)
                        Text("Built from what you told us — a few minutes a day, nothing more.", tableName: "Onboarding")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.65))

                        VStack(spacing: 10) {
                            ForEach(Array(MockOnboarding.planSteps(for: AppLanguagePreference.resolveCurrent()).enumerated()), id: \.offset) { _, step in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(step.number)")
                                        .font(MissaleFont.display(20, weight: .medium))
                                        .foregroundStyle(Palette.goldMuted)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(step.title)
                                            .font(MissaleFont.body(17, weight: .medium))
                                            .foregroundStyle(Palette.ink)
                                        Text(step.subtitle)
                                            .font(MissaleFont.body(14))
                                            .foregroundStyle(Palette.ink.opacity(0.65))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.black.opacity(0.06)))
                            }
                        }

                        DashedUtilityCard {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Next in the calendar for you", tableName: "Onboarding")
                                    .font(MissaleFont.body(14, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("\(MockLiturgical.tomorrow.dayMonthLabel) · \(MockLiturgical.tomorrow.feastName)")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.7))
                                Text("White vestments. The app changes color that morning.", tableName: "Onboarding")
                                    .font(MissaleFont.body(13))
                                    .foregroundStyle(Palette.ink.opacity(0.55))
                            }
                        }

                        DashedUtilityCard {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tomorrow morning you get", tableName: "Onboarding")
                                    .font(MissaleFont.body(14, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text(L.string("The verse of the day, the saint of the day, and part 1 of {track}.", table: "Onboarding")
                                    .replacingOccurrences(of: "{track}", with: MockFormation.track.title))
                                    .font(MissaleFont.body(13))
                                    .foregroundStyle(Palette.ink.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                VStack(spacing: 8) {
                    Eyebrow(text: OnboardingStory.text(OnboardingStory.commitmentEyebrow))
                    Text("\u{201C}\(viewModel.commitment)\u{201D}")
                        .font(MissaleFont.display(22, italic: true))
                        .foregroundStyle(Palette.ink)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 16)
                OnboardingHoldButton(title: OnboardingStory.text(OnboardingStory.holdToCommit), action: onNext)
                    .padding(.vertical, 20)
            }
        }
    }
}
