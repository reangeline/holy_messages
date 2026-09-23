import SwiftUI

/// dIs0 — Today's feast / free feed. First screen, no account required.
/// Every card here mirrors a card the app itself shows, so the content comes
/// from the very same catalogs the real screens read — not from copies written
/// into this file. Those copies were hardcoded in English, which meant the
/// Portuguese onboarding previewed an English app, and they would drift from the
/// real screens on every content import.
struct OnboardingFeedView: View {
    let onContinue: () -> Void

    private let day = MockLiturgical.today
    private var word: WordOfDay { MockWordOfDay.today }
    private var saint: Saint {
        MockSaints.saintOfDay(on: String(MockLiturgical.today.dateKey.suffix(5))).saint
    }
    private var firstLesson: FormationLesson? { MockFormation.track.lessons.first }

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Spacer().frame(height: 44)

                    HStack(spacing: 8) {
                        Circle().fill(Palette.wine).frame(width: 8, height: 8)
                        Text("\(day.rank.displayName) · \(day.color.name)".uppercased())
                            .font(MissaleFont.body(11, weight: .semibold))
                            .tracking(1.6)
                            .foregroundStyle(Palette.wine)
                    }

                    Text(day.feastName)
                        .font(MissaleFont.display(30))
                        .foregroundStyle(Palette.ink)

                    Text("\(day.weekdayLabel), \(day.dayMonthLabel). \(day.explanation)")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    Button(action: onContinue) {
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: L.string("Today's verse", table: "Onboarding"), color: Palette.goldBright)
                                Text("\u{201C}\(word.quote)\u{201D}")
                                    .lineLimit(3)
                                    .font(MissaleFont.display(21, italic: true))
                                    .foregroundStyle(.white)
                                Text(word.reference)
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    Button(action: onContinue) {
                        HStack(spacing: 13) {
                            SaintPortrait(artworkName: saint.artworkName).frame(width: 50, height: 50)
                            VStack(alignment: .leading, spacing: 2) {
                                Eyebrow(text: L.string("Saint of the day", table: "Onboarding"))
                                Text(saint.name)
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text("\(saint.role) · 3 min")
                                    .lineLimit(1)
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
                            Text(firstLesson?.title ?? "")
                                .font(MissaleFont.body(18, weight: .medium))
                                .foregroundStyle(Palette.ink)
                            Text(firstLesson?.bodyParagraphs.first ?? "")
                                .lineLimit(3)
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
