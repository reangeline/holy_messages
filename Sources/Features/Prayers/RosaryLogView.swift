import SwiftUI

/// t4 screen 27 — rosary history/log. A record, not a scoreboard: dot grid, no streak/percent.
struct RosaryLogView: View {
    @ObservedObject private var history = RosaryHistoryStore.shared
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 9)

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Terços rezados")
                            .font(MissaleFont.display(28))
                        Text("Registro, não placar. Sem sequência para perder.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Eyebrow(text: "Devoção em curso")
                            Text(MockRosary.novena.title)
                                .font(MissaleFont.body(18, weight: .medium))
                                .foregroundStyle(Palette.ink)
                            LazyVGrid(columns: columns, spacing: 5) {
                                ForEach(0..<MockRosary.novena.totalDays, id: \.self) { day in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(day < MockRosary.novena.currentDay ? Palette.wine : Palette.ink.opacity(0.12))
                                        .aspectRatio(1, contentMode: .fit)
                                }
                            }
                            Text("Dia \(MockRosary.novena.currentDay) de \(MockRosary.novena.totalDays) · a contagem é da própria devoção")
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.55))
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Histórico")
                            .font(MissaleFont.body(13, weight: .semibold))
                            .tracking(1.2)
                            .foregroundStyle(Palette.goldDim)
                        if history.recent.isEmpty {
                            DashedUtilityCard {
                                Text("Nenhum terço registrado ainda. Ele aparece aqui assim que você concluir um.")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.7))
                            }
                        } else {
                            ForEach(history.recent) { entry in
                                GlassCard {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(entry.title)
                                                .font(MissaleFont.body(16, weight: .medium))
                                                .foregroundStyle(Palette.ink)
                                            Text(entry.subtitle)
                                                .font(MissaleFont.body(14))
                                                .foregroundStyle(Palette.ink.opacity(0.6))
                                        }
                                        Spacer()
                                        Text(entry.dateLabel)
                                            .font(MissaleFont.body(13))
                                            .foregroundStyle(Palette.ink.opacity(0.5))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
