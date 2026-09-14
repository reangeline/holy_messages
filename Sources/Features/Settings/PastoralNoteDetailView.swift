import SwiftUI

/// t5 screen 6 (fIs6) — "O que este app é, e o que ele não é": the three static
/// declarations (not confession, not spiritual direction, not therapy), what the
/// app actually offers, and where a grave question actually belongs.
struct PastoralNoteDetailView: View {
    @State private var showFullResources = false

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Eyebrow(text: "Nota pastoral")
                        Text("O que este app é, e o que ele não é")
                            .font(MissaleFont.display(28, weight: .semibold))
                    }

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("TRÊS DECLARAÇÕES")
                                .font(MissaleFont.body(11, weight: .semibold))
                                .tracking(1.4)
                                .foregroundStyle(Palette.goldBright)
                            declaration("Não é confissão.", "Nada registrado aqui é matéria de absolvição, e nenhum texto deste app perdoa pecado. Só o sacramento faz isso, e ele acontece com um sacerdote.")
                            declaration("Não é direção espiritual.", "As respostas são as mesmas para todos que escolhem o mesmo estado. Direção espiritual é alguém que conhece a sua história e responde a você.")
                            declaration("Não é terapia.", "Não há avaliação clínica, diagnóstico nem acompanhamento. Sofrimento psíquico pede profissional, e os dois caminhos não competem.")
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "O que ele é")
                            Text("Um lugar para receber a palavra do dia, conhecer o santo do dia, entender os ritos e rezar com a Igreja. Quando você registra como está, ele oferece o que a tradição já tem para aquele estado: um salmo, alguém que passou por isso e um passo concreto. Nada além disso.")
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.ink.opacity(0.86))
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: "Se a pergunta for grave")
                            Text("Pecado grave, dúvida de consciência, decisão de vida, crise: leve a um padre. Este app mostra a paróquia mais perto e os horários de confissão, e é o melhor que ele tem a oferecer nesse ponto.")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                            Button("Encontrar uma paróquia →") {
                                showFullResources = true
                            }
                            .font(MissaleFont.body(16, weight: .medium))
                            .foregroundStyle(Palette.wine)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showFullResources) {
            PastoralCareNudgeView()
        }
    }

    private func declaration(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(MissaleFont.body(17, weight: .semibold)).foregroundStyle(.white)
            Text(body).font(MissaleFont.body(15)).foregroundStyle(.white.opacity(0.88))
        }
    }
}
