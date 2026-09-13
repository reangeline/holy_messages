import SwiftUI

/// t4 screen 11 — narrative retrospective for a completed liturgical season.
/// No progress curve, no percentage — a qualitative accompaniment list instead.
struct SeasonRetrospectiveView: View {
    let retrospective: SeasonRetrospective

    var body: some View {
        ZStack {
            retrospective.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 9) {
                        Circle().fill(retrospective.color.accent).frame(width: 10, height: 10)
                        Eyebrow(text: retrospective.seasonLabel, color: retrospective.color.accent)
                    }
                    Text(retrospective.title)
                        .font(MissaleFont.display(30))

                    GlassCard {
                        Text(retrospective.narrative)
                            .font(MissaleFont.display(22, italic: true))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Eyebrow(text: "O que acompanhou o caminho")
                            VStack(alignment: .leading, spacing: 9) {
                                ForEach(retrospective.accompaniments, id: \.self) { line in
                                    Text(line).font(MissaleFont.body(16))
                                }
                            }
                        }
                    }

                    LiturgicalGradientCard(color: retrospective.color) {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: retrospective.milestoneTitle, color: Palette.goldBright)
                            Text(retrospective.milestoneBody)
                                .font(MissaleFont.body(17))
                                .foregroundStyle(.white)
                        }
                    }

                    Text(retrospective.closingLine)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(20)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("A jornada").font(MissaleFont.body(15, weight: .medium))
            }
        }
    }
}
