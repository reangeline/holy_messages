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

                        // Static, always shown here — not gated behind detecting a
                        // "crisis" answer below. If any of the next four questions
                        // touch something heavier than an app should handle alone,
                        // this is already the same place you saw it.
                        Eyebrow(text: "If any of this is heavier than a question")
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Talk to a priest")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Confession, or simply a conversation. We can show you the nearest parish office and its hours.")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                        }
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Catholic Charities")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Grief support, counseling, and material help through your diocese.")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                        }
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: "If you are in crisis · United States", color: Palette.goldBright)
                                Text("988")
                                    .font(MissaleFont.display(30))
                                    .foregroundStyle(.white)
                                Text("Suicide & Crisis Lifeline. Call or text, any hour, free and confidential.")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(.white.opacity(0.9))
                                HStack(spacing: 12) {
                                    Link("Call 988", destination: URL(string: "tel:988")!)
                                    Link("Text 988", destination: URL(string: "sms:988")!)
                                }
                                .font(MissaleFont.body(15, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.top, 4)
                            }
                        }
                        Text("This app offers formation and prayer. It is not confession, spiritual direction, or therapy, and it never pretends to be.")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
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
