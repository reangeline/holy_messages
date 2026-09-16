import SwiftUI

/// dIs0 — Today's feast / free feed. First screen, no account required.
struct OnboardingFeedView: View {
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Spacer().frame(height: 44)

                    HStack(spacing: 8) {
                        Circle().fill(Palette.wine).frame(width: 8, height: 8)
                        Text("FEAST · RED")
                            .font(MissaleFont.body(11, weight: .semibold))
                            .tracking(1.6)
                            .foregroundStyle(Palette.wine)
                    }

                    Text("Exaltation of the Holy Cross")
                        .font(MissaleFont.display(30))
                        .foregroundStyle(Palette.ink)

                    Text("Monday, September 14. Red vestments today — the color of blood and of the Cross. This screen carries the color of the day, and it changes when the calendar does.")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    Button(action: onContinue) {
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: L.string("Today's verse", table: "Onboarding"), color: Palette.goldBright)
                                Text("\u{201C}And as Moses lifted up the serpent in the desert, so must the Son of Man be lifted up.\u{201D}")
                                    .font(MissaleFont.display(21, italic: true))
                                    .foregroundStyle(.white)
                                Text("John 3:14")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    Button(action: onContinue) {
                        HStack(spacing: 13) {
                            SaintPortraitPlaceholder().frame(width: 50, height: 50)
                            VStack(alignment: .leading, spacing: 2) {
                                Eyebrow(text: L.string("Saint of the day", table: "Onboarding"))
                                Text("St. Notburga of Eben")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("Servant and patron of the poor · 3 min")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.6))
                            }
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Palette.wine.opacity(0.12)))
                    }
                    .buttonStyle(.plain)

                    Button(action: onContinue) {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: L.string("The Mass, part by part · 1 of 14", table: "Onboarding"))
                            Text("The Introductory Rites")
                                .font(MissaleFont.body(18, weight: .medium))
                                .foregroundStyle(Palette.ink)
                            Text("Before anything is read or offered, the Church gathers and admits what it is. Why the sign of the cross comes first, and what the greeting actually claims.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                            Text("Read now \u{2192}", tableName: "Onboarding")
                                .font(MissaleFont.body(15, weight: .medium))
                                .foregroundStyle(Palette.wine)
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Palette.wine.opacity(0.12)))
                    }
                    .buttonStyle(.plain)

                    Spacer().frame(height: 8)
                }
                .padding(.horizontal, 24)

                OnboardingPrimaryButton(title: L.string("Look around \u{2014} no account needed", table: "Onboarding"), action: onContinue)

                Spacer().frame(height: 30)
            }
        }
    }
}
