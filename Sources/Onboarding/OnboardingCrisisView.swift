import SwiftUI

/// dIs12 — crisis safety net, shown only when the spiritual-check-in flagged
/// grief/anger/guilt. A verse is explicitly not offered as a substitute for real help.
struct OnboardingCrisisView: View {
    let onNext: () -> Void

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Eyebrow(text: "You don't have to carry this alone")
                        Text("A verse is not a substitute for real help")
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)
                        Text("What you marked is heavier than anything an app should try to answer by itself. These are people, not features.")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.75))

                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: "If you are in crisis · United States", color: Palette.goldBright)
                                Text("988")
                                    .font(MissaleFont.display(34))
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

                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Talk to a priest")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Confession, or simply a conversation. We can show you the nearest parish office and its hours.")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                                Text("Find a parish \u{2192}")
                                    .font(MissaleFont.body(14, weight: .medium))
                                    .foregroundStyle(Palette.wine)
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
                                Text("See what's near you \u{2192}")
                                    .font(MissaleFont.body(14, weight: .medium))
                                    .foregroundStyle(Palette.wine)
                            }
                        }

                        Text("This app offers formation and prayer. It is not counseling or medical care, and it never pretends to be.")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
                }
                OnboardingPrimaryButton(title: "Continue", action: onNext)
                    .padding(.vertical, 20)
            }
        }
    }
}
