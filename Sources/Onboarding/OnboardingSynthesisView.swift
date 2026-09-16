import SwiftUI

/// dIs14 — formation track synthesis. Back to the flat/practical register.
struct OnboardingSynthesisView: View {
    let onNext: () -> Void
    @Environment(\.locale) private var locale

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
                            ForEach(Array(MockOnboarding.planSteps(for: AppLanguage.current(from: locale)).enumerated()), id: \.offset) { _, step in
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
                                Text("September 15 · Our Lady of Sorrows")
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
                                Text("The verse of the day, the saint of the day, and part 1 of The Mass, part by part.")
                                    .font(MissaleFont.body(13))
                                    .foregroundStyle(Palette.ink.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                OnboardingPrimaryButton(title: L.string("This is mine", table: "Onboarding"), action: onNext)
                    .padding(.vertical, 20)
            }
        }
    }
}
