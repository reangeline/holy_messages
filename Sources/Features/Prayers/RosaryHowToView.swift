import SwiftUI

/// t4 screen 24 — "O terço, peça por peça": bead-diagram explainer + how-to cards.
struct RosaryHowToView: View {
    private struct DiagramItem: Identifiable {
        let id = UUID()
        let label: String
        let detail: String
        let size: CGFloat
        let color: Color
    }

    private var diagram: [DiagramItem] {
        [
            .init(label: L.string( "Crucifix", table: "Prayers"), detail: L.string( "the Creed", table: "Prayers"), size: 22, color: Palette.ink.opacity(0.7)),
            .init(label: L.string( "Larger bead", table: "Prayers"), detail: L.string( "one Our Father", table: "Prayers"), size: 16, color: Palette.goldMuted),
            .init(label: L.string( "Three beads", table: "Prayers"), detail: L.string( "three Hail Marys, for faith, hope, and charity", table: "Prayers"), size: 11, color: Palette.wine.opacity(0.6)),
            .init(label: L.string( "Medal", table: "Prayers"), detail: L.string( "the mystery is announced", table: "Prayers"), size: 18, color: Palette.goldMuted),
            .init(label: L.string( "Decade", table: "Prayers"), detail: L.string( "ten Hail Marys, and the Glory Be closes it", table: "Prayers"), size: 11, color: Palette.wine.opacity(0.6)),
        ]
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(L.string("The rosary, piece by piece", table: "Prayers"))
                            .font(MissaleFont.display(28))
                        Text(L.string("If you've never prayed it, start here. Almost everyone gets stuck on the mechanics, not the faith.", table: "Prayers"))
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    GlassCard {
                        VStack(spacing: 16) {
                            ForEach(diagram) { item in
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: item.size, height: item.size)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(item.label)
                                            .font(MissaleFont.body(16, weight: .medium))
                                            .foregroundStyle(Palette.ink)
                                        Text(item.detail)
                                            .font(MissaleFont.body(14))
                                            .foregroundStyle(Palette.ink.opacity(0.65))
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }

                    VStack(spacing: 10) {
                        ForEach(MockRosary.howTo) { item in
                            GlassCard {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.title)
                                        .font(MissaleFont.body(17, weight: .medium))
                                        .foregroundStyle(Palette.ink)
                                    Text(item.body)
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.72))
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
