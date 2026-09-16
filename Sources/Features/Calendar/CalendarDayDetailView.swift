import SwiftUI

/// t4 screen 9 — detail for a specific day. Push/detail screen, no tab bar.
/// Genuinely functional, not a mockup: only "today" (the one real-interactive
/// day this fixed-date calendar has) can ever show a registro, and it shows the
/// real one from MoodHistoryStore or an honest "nothing registered" state —
/// never a canned example. See spec §1.5.
struct CalendarDayDetailView: View {
    let mark: CalendarDayMark
    @ObservedObject private var moodHistory = MoodHistoryStore.shared

    private var isToday: Bool { mark.dateKey == MockLiturgical.today.dateKey }
    private var feastInfo: (feastName: String, note: String?)? { MockLiturgical.dayFeastInfo(for: mark.dateKey) }

    private var detail: DayDetail {
        let latest = isToday ? moodHistory.entries.last : nil
        let relief = latest.map { MockMood.relief(for: $0.stateID).content }
        return DayDetail(
            dateLabel: "\(mark.dayNumber) de setembro",
            feastName: feastInfo?.feastName ?? "Feria do Tempo Comum",
            color: mark.color,
            loggedStateTitle: latest?.stateLabel,
            loggedNote: latest?.note,
            psalmRef: relief?.psalmRef,
            psalmText: relief?.psalmText,
            liturgyNote: feastInfo?.note
        )
    }

    var body: some View {
        ZStack {
            detail.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text(detail.color.name)
                            .font(MissaleFont.body(12, weight: .semibold))
                            .tracking(1.2)
                            .foregroundStyle(detail.color.accent)
                        Spacer()
                    }
                    Eyebrow(text: detail.dateLabel)
                    Text(detail.feastName)
                        .font(MissaleFont.display(29))

                    if let title = detail.loggedStateTitle {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: L.string("You logged", table: "CalendarSaints"))
                                Text(title).font(MissaleFont.body(19, weight: .medium))
                                if let note = detail.loggedNote {
                                    Text("\u{201C}\(note)\u{201D}")
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.72))
                                }
                            }
                        }
                    } else {
                        DashedUtilityCard {
                            Text(isToday
                                 ? L.string("Nothing logged today yet.", table: "CalendarSaints")
                                 : L.string("Nothing logged that day.", table: "CalendarSaints"))
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.7))
                        }
                    }

                    if let psalmText = detail.psalmText, let psalmRef = detail.psalmRef {
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: L.string("That day's passage", table: "CalendarSaints"), color: Palette.goldBright)
                                Text(psalmText)
                                    .font(MissaleFont.display(21, italic: true))
                                    .foregroundStyle(.white)
                                Text(psalmRef)
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }
                    }

                    if let liturgyNote = detail.liturgyNote {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: L.string("That day in the liturgy", table: "CalendarSaints"))
                                Text(liturgyNote).font(MissaleFont.body(17))
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("September", tableName: "CalendarSaints").font(MissaleFont.body(15, weight: .medium))
            }
        }
    }
}
