import SwiftUI

/// dIs6 — spiritual block intro / privacy declaration. First "sacred/glass" screen.
struct OnboardingSpiritualIntroView: View {
    let onBack: () -> Void
    let onAnswer: () -> Void
    let onSkipAll: () -> Void

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        CrossGlyph(size: 32)
                            .padding(.top, 12)
                        Text("Now four questions the Church has always asked")
                            .font(MissaleFont.display(28))
                            .foregroundStyle(Palette.ink)
                        Text("Consolation and desolation, dryness, doubt, weight. Not a mood test, not a score, no diagnosis — the vocabulary the Church uses for what a soul carries.")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.75))

                        GlassCard {
                            Text("These answers stay on this device. They are never sent to a server, never used for ads, never used to sell you anything. Every question can be left unanswered.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.85))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
                OnboardingPrimaryButton(title: "I'll answer", action: onAnswer)
                OnboardingTextLink(title: "Skip all four", action: onSkipAll)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            }
        }
    }
}
