import SwiftUI

/// t4 screen 9 — detail for a specific past day. Push/detail screen, no tab bar.
struct CalendarDayDetailView: View {
    let mark: CalendarDayMark
    @ObservedObject private var moodHistory = MoodHistoryStore.shared

    /// This pass only has real detail content authored for one example day (Sept 8);
    /// other days reuse it so the drill-down never dead-ends. Today's cell is the
    /// exception: if you've actually logged something in the Exame, this shows that
    /// real entry instead of the canned example — the calendar overlay in spec §1.5
    /// is a real registro for the one live day this mock has, not just a mockup.
    private var detail: DayDetail {
        if mark.dateKey == MockLiturgical.today.dateKey, let latest = moodHistory.entries.last {
            let relief = MockMood.relief(for: latest.stateID).content
            return DayDetail(
                dateLabel: MockLiturgical.today.dayMonthLabel,
                feastName: MockLiturgical.today.feastName,
                color: MockLiturgical.today.color,
                loggedStateTitle: latest.stateLabel,
                loggedNote: latest.note,
                psalmRef: relief.psalmRef,
                psalmText: relief.psalmText,
                liturgyNote: MockLiturgical.today.explanation,
                otherActivity: nil
            )
        }
        return MockLiturgical.sampleDayDetail
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
                                Eyebrow(text: L.string( "You logged", table: "CalendarSaints"))
                                Text(title).font(MissaleFont.body(19, weight: .medium))
                                if let note = detail.loggedNote {
                                    Text("\u{201C}\(note)\u{201D}")
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.72))
                                }
                            }
                        }
                    }

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string( "That day's passage", table: "CalendarSaints"), color: Palette.goldBright)
                            Text(detail.psalmText)
                                .font(MissaleFont.display(21, italic: true))
                                .foregroundStyle(.white)
                            Text(detail.psalmRef)
                                .font(MissaleFont.body(14))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: L.string( "That day in the liturgy", table: "CalendarSaints"))
                            Text(detail.liturgyNote).font(MissaleFont.body(17))
                        }
                    }

                    if let other = detail.otherActivity {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: L.string( "Also that day", table: "CalendarSaints"))
                                Text(other).font(MissaleFont.body(17))
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
