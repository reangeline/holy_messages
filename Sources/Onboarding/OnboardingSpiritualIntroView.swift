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
                        Text("Now four questions the Church has always asked", tableName: "Onboarding")
                            .font(MissaleFont.display(28))
                            .foregroundStyle(Palette.ink)
                        // Was four blocks of text before the first question ("tá com
                        // muito texto", TestFlight 2.0 (2)); one line each now.
                        Text("The Church's words for what a soul carries. Not a test, not a diagnosis.", tableName: "Onboarding")
                            .font(MissaleFont.body(17))
                            .foregroundStyle(Palette.ink.opacity(0.75))
                        Label {
                            Text("It stays on this device. Every question can be skipped.", tableName: "Onboarding")
                        } icon: {
                            Image(systemName: "lock")
                        }
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.6))

                        Eyebrow(text: L.string("If any of this is heavier than a question", table: "Onboarding"))
                            .padding(.top, 6)
                        GlassCard {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Talk to a priest", tableName: "Onboarding")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Confession, or simply a conversation.", tableName: "Onboarding")
                                    .font(MissaleFont.body(16))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        LiturgicalGradientCard(color: .red) {
                            // Generic by decision, with no number of our own — see CrisisLines.
                            let crisis = CrisisLines.current
                            VStack(alignment: .leading, spacing: 8) {
                                Text(crisis.title)
                                    .font(MissaleFont.display(24))
                                    .foregroundStyle(.white)
                                Text(crisis.message)
                                    .font(MissaleFont.body(16))
                                    .foregroundStyle(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        Text("This app offers formation and prayer. It is not confession, spiritual direction, or therapy, and it never pretends to be.", tableName: "Onboarding")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
                OnboardingPrimaryButton(title: L.string("I'll answer", table: "Onboarding"), action: onAnswer)
                OnboardingTextLink(title: L.string("Skip all four", table: "Onboarding"), action: onSkipAll)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            }
        }
    }
}
