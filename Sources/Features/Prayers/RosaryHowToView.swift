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
            .init(label: "Crucifixo", detail: "o Credo", size: 22, color: Palette.ink.opacity(0.7)),
            .init(label: "Conta maior", detail: "um Pai-Nosso", size: 16, color: Palette.goldMuted),
            .init(label: "Três contas", detail: "três Ave-Marias, pela fé, esperança e caridade", size: 11, color: Palette.wine.opacity(0.6)),
            .init(label: "Medalha", detail: "anuncia-se o mistério", size: 18, color: Palette.goldMuted),
            .init(label: "Dezena", detail: "dez Ave-Marias, e o Glória fecha", size: 11, color: Palette.wine.opacity(0.6)),
        ]
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("O terço, peça por peça")
                            .font(MissaleFont.display(28))
                        Text("Se nunca rezou, comece aqui. Quase todo mundo trava na mecânica, não na fé.")
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
