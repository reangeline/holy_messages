import SwiftUI

/// Screen 6 (eIs6) — discreet, non-diagnostic pastoral care nudge. In the real
/// product this fires from a longitudinal pattern (weeks of hard days); this pass
/// has no such detector, so it's only reachable from Today's debug menu.
struct PastoralCareNudgeView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Eyebrow(text: "Uma nota, sem alarme")
                    Text("Faz algumas semanas que os dias têm vindo pesados")
                        .font(MissaleFont.display(28, weight: .semibold))
                        .foregroundStyle(Palette.ink)
                    Text("Não é um diagnóstico e não é uma conta a pagar. É só que mais um Salmo talvez não seja o que você precisa agora, e há gente para isso.")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Falar com um padre").font(MissaleFont.body(18, weight: .medium))
                            Text("Confissão, ou apenas uma conversa. Mostramos a \(MockMood.pastoralCareParishName.lowercased()) mais perto e os horários.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }
                    GlassCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Acompanhamento na sua diocese").font(MissaleFont.body(18, weight: .medium))
                            Text("Apoio no luto, escuta e ajuda material pela Caritas local.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }
                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "Se for crise · Estados Unidos", color: Palette.goldBright)
                            Text("988").font(MissaleFont.display(28)).foregroundStyle(.white)
                            Text("Suicide & Crisis Lifeline. Ligação ou mensagem, a qualquer hora.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }

                    Text("Este app oferece formação e oração. Não é terapia nem atendimento clínico, e não finge ser.")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.55))

                    Button {
                        dismiss()
                    } label: {
                        Text("Entendi, fechar")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                            .foregroundStyle(Palette.ink)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    PastoralCareNudgeView()
}
