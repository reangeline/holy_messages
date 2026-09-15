import SwiftUI

/// t4 screen 10 — liturgical seasons as a "journey," not a calendar month. Hub screen.
struct JourneyListView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.green.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Eyebrow(text: L.string( "The Journey", table: "CalendarSaints"))
                    Text("You crossed through this", tableName: "CalendarSaints")
                        .font(MissaleFont.display(30))
                    Text("By liturgical time, the way the Church counts the year. Not by month, and without comparing them.", tableName: "CalendarSaints")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.7))
                        .padding(.bottom, 6)

                    ForEach(MockLiturgical.seasons) { season in
                        if season.id == MockLiturgical.lentRetrospective.seasonID {
                            NavigationLink {
                                SeasonRetrospectiveView(retrospective: MockLiturgical.lentRetrospective)
                            } label: {
                                seasonRow(season)
                            }
                            .buttonStyle(.plain)
                        } else {
                            seasonRow(season, disabled: true)
                        }
                    }

                    Text("No progress curve and no percentage: desolation isn't failure, and dryness isn't a performance dip.", tableName: "CalendarSaints")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(20)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("September", tableName: "CalendarSaints").font(MissaleFont.body(15, weight: .medium))
            }
        }
    }

    private func seasonRow(_ season: LiturgicalSeason, disabled: Bool = false) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    HStack(spacing: 9) {
                        Circle().fill(season.color.accent).frame(width: 10, height: 10)
                        Text(season.name).font(MissaleFont.body(19, weight: .medium))
                    }
                    Spacer()
                    Text(season.dateRange)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                Text(season.summaryLine)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.74))
                if disabled {
                    Text("Not yet crossed", tableName: "CalendarSaints")
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.4))
                }
            }
        }
        .opacity(disabled ? 0.6 : 1)
    }
}
