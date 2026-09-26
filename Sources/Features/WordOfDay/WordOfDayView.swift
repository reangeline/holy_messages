import SwiftUI

/// t4 screen 15 — Word of the day. Standalone/independently navigable: push it with
/// `NavigationLink { WordOfDayView() }` from within an existing `NavigationStack`
/// (e.g. from Today), or wrap it in your own `NavigationStack` to present as a sheet.
struct WordOfDayView: View {
    /// Read on every render, so a word chosen for the reader while the
    /// screen is open crossfades in, and matches Today and the widget.
    @ObservedObject private var personalWord = PersonalizedWordOfDay.shared
    private var word: WordOfDay { MockWordOfDay.today }
    private let day = MockLiturgical.today

    /// The real day, from the engine — `MockLiturgical.today` is the demo day
    /// the design was drawn around, and the lectionary is keyed by the engine.
    private let computedDay = LiturgicalEngine.day(for: Date())

    /// The lectionary holds Sundays only, so most days have nothing to show.
    /// The card appears when there is something behind it, rather than opening
    /// a screen with four "not registered yet" slots.
    private var hasReadingsToday: Bool { MockLectionary.readings(for: computedDay) != nil }

    var body: some View {
        ZStack {
            day.color.pageBackground
            ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink {
                            ShareCardView()
                        } label: {
                            Text("Share ›", tableName: "FormationWordOfDay")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.wine)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        if personalWord.showCrisisFirst {
                            CrisisSupportCard()
                        }

                        LiturgicalGradientCard(color: day.color) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("WORD OF THE DAY", tableName: "FormationWordOfDay")
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.6)
                                    .foregroundStyle(Palette.goldBright)
                                if personalWord.isChosen {
                                    WordChosenLabel(color: .white.opacity(0.85))
                                }
                                Text(word.quote)
                                    .font(MissaleFont.display(24, italic: true))
                                    .foregroundStyle(.white)
                                // Só a referência: a edição citada fica nos Termos de Uso, §3.
                                Text(word.reference)
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                            .id(word.id)
                            .transition(.opacity)
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: L.string( "The context", table: "FormationWordOfDay"))
                                Text(word.context)
                                    .font(MissaleFont.body(16))
                                    .foregroundStyle(Palette.ink.opacity(0.85))
                                    .lineSpacing(3)
                            }
                        }

                        if hasReadingsToday {
                            NavigationLink {
                                MassBulletinView(day: computedDay)
                            } label: {
                                GlassCard {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("What's read at Mass today", tableName: "FormationWordOfDay")
                                                .font(MissaleFont.body(17, weight: .medium))
                                                .foregroundStyle(Palette.ink)
                                            Text("First reading, psalm, and Gospel", tableName: "FormationWordOfDay")
                                                .font(MissaleFont.body(14))
                                                .foregroundStyle(Palette.ink.opacity(0.65))
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
            }
        }
        .navigationTitle(L.string( "Word of the day", table: "FormationWordOfDay"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { WordOfDayView() }
}
