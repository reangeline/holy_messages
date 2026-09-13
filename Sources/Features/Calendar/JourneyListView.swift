import SwiftUI

/// t4 screen 10 — liturgical seasons as a "journey," not a calendar month. Hub screen.
struct JourneyListView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.green.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Eyebrow(text: "A jornada")
                    Text("Você atravessou isso")
                        .font(MissaleFont.display(30))
                    Text("Por tempo litúrgico, como a Igreja conta o ano. Não por mês, e sem comparação entre eles.")
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

                    Text("Sem curva de progresso e sem percentual: desolação não é fracasso, e aridez não é queda de desempenho.")
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
                Text("Setembro").font(MissaleFont.body(15, weight: .medium))
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
                    Text("Ainda não atravessado")
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.4))
                }
            }
        }
        .opacity(disabled ? 0.6 : 1)
    }
}
