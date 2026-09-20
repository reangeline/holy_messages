import SwiftUI

/// The Sunday Mass bulletin ("folheto litúrgico") — liturgical header plus the
/// day's reading references. Shows only citations (book, chapter, verse),
/// never the reading text itself: the translation is licensed (CNBB/USCCB),
/// the citation is not. See MockLectionary — most Sundays honestly show
/// "ainda não cadastrado" rather than a guessed reference.
struct MassBulletinView: View {
    let day: LiturgicalEngine.ComputedDay

    private var readings: MassReadings? { MockLectionary.readings(for: day) }

    /// The evangelist read through the cycle. A book name, so it follows the
    /// interface language like the rest of the citations on this screen.
    private var gospelWriter: String {
        switch day.sundayCycle {
        case "A": L.string("Matthew", table: "CalendarSaints")
        case "B": L.string("Mark", table: "CalendarSaints")
        case "C": L.string("Luke", table: "CalendarSaints")
        default: ""
        }
    }

    var body: some View {
        ZStack {
            day.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Circle().fill(day.color.accent).frame(width: 9, height: 9)
                            Text("\(day.seasonLabel) · \(L.string("Year {cycle}", table: "CalendarSaints").replacingOccurrences(of: "{cycle}", with: day.sundayCycle))")
                                .font(MissaleFont.body(12, weight: .semibold))
                                .tracking(1.1)
                                .foregroundStyle(day.color.accent)
                        }
                        Text(day.feastName)
                            .font(MissaleFont.display(28))
                            .foregroundStyle(Palette.ink)
                    }

                    if !gospelWriter.isEmpty {
                        DashedUtilityCard {
                            Text(L.string("Year {cycle}: this cycle's Sunday Gospel is read mostly from {writer}.", table: "CalendarSaints")
                                .replacingOccurrences(of: "{cycle}", with: day.sundayCycle)
                                .replacingOccurrences(of: "{writer}", with: gospelWriter))
                                .font(MissaleFont.body(14))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }

                    readingBlock(label: L.string("First Reading", table: "CalendarSaints"), reference: readings?.firstReading)
                    readingBlock(label: L.string("Responsorial Psalm", table: "CalendarSaints"), reference: readings?.psalm)
                    if let second = readings?.secondReading {
                        readingBlock(label: L.string("Second Reading", table: "CalendarSaints"), reference: second)
                    } else if readings == nil {
                        readingBlock(label: L.string("Second Reading", table: "CalendarSaints"), reference: nil)
                    }
                    readingBlock(label: L.string("Gospel", table: "CalendarSaints"), reference: readings?.gospel)

                    Text(L.string("Only the citation is shown — the text of the readings is licensed by the USCCB and can't be reproduced here without permission.", table: "CalendarSaints"))
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.5))
                }
                .padding(20)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L.string("Sunday bulletin", table: "CalendarSaints")).font(MissaleFont.body(15, weight: .medium))
            }
        }
    }

    private func readingBlock(label: String, reference: String?) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Eyebrow(text: label)
                if let reference {
                    Text(reference)
                        .font(MissaleFont.display(20, weight: .medium))
                        .foregroundStyle(Palette.ink)
                } else {
                    Text(L.string("Not registered yet", table: "CalendarSaints"))
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.4))
                        .italic()
                }
            }
        }
    }
}

#Preview {
    NavigationStack { MassBulletinView(day: LiturgicalEngine.day(for: Date())) }
}
