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
                        Text("Consolation and desolation, dryness, doubt, weight. Not a mood test, not a score, no diagnosis — the vocabulary the Church uses for what a soul carries.", tableName: "Onboarding")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.75))

                        GlassCard {
                            Text("These answers stay on this device. They are never sent to a server, never used for ads, never used to sell you anything. Every question can be left unanswered.", tableName: "Onboarding")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.85))
                        }

                        // Static, always shown here — not gated behind detecting a
                        // "crisis" answer below. If any of the next four questions
                        // touch something heavier than an app should handle alone,
                        // this is already the same place you saw it.
                        Eyebrow(text: L.string("If any of this is heavier than a question", table: "Onboarding"))
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Talk to a priest", tableName: "Onboarding")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Confession, or simply a conversation. We can show you the nearest parish office and its hours.", tableName: "Onboarding")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                        }
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Catholic Charities", tableName: "Onboarding")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Grief support, counseling, and material help through your diocese.", tableName: "Onboarding")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                        }
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                // The line for the reader's own country — see CrisisLines.
                                let crisis = CrisisLines.current
                                Eyebrow(text: L.string("If you are in crisis · {region}", table: "Onboarding")
                                    .replacingOccurrences(of: "{region}", with: crisis.regionLabel),
                                        color: Palette.goldBright)
                                Text(crisis.number)
                                    .font(MissaleFont.display(30))
                                    .foregroundStyle(.white)
                                Text("\(crisis.serviceName). \(crisis.detail)")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(.white.opacity(0.9))
                                HStack(spacing: 12) {
                                    if let tel = URL(string: crisis.telURL) {
                                        Link(destination: tel) {
                                            Text(L.string("Call {number}", table: "Onboarding")
                                                .replacingOccurrences(of: "{number}", with: crisis.number))
                                        }
                                    }
                                    if let smsURL = crisis.smsURL, let sms = URL(string: smsURL) {
                                        Link(destination: sms) {
                                            Text(L.string("Text {number}", table: "Onboarding")
                                                .replacingOccurrences(of: "{number}", with: crisis.number))
                                        }
                                    }
                                }
                                .font(MissaleFont.body(15, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.top, 4)
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
