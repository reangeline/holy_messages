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
                    Eyebrow(text: L.string("Uma nota, sem alarme", table: "Today"))
                    Text("Faz algumas semanas que os dias têm vindo pesados", tableName: "Today")
                        .font(MissaleFont.display(28, weight: .semibold))
                        .foregroundStyle(Palette.ink)
                    Text("Não é um diagnóstico e não é uma conta a pagar. É só que mais um Salmo talvez não seja o que você precisa agora, e há gente para isso.", tableName: "Today")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Falar com um padre", tableName: "Today").font(MissaleFont.body(18, weight: .medium))
                            Text(L.string("Confissão, ou apenas uma conversa. Mostramos a {parish} mais perto e os horários.", table: "Today")
                                .replacingOccurrences(of: "{parish}", with: MockMood.pastoralCareParishName.lowercased()))
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }
                    GlassCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Acompanhamento na sua diocese", tableName: "Today").font(MissaleFont.body(18, weight: .medium))
                            Text("Apoio no luto, escuta e ajuda material pela Caritas local.", tableName: "Today")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }
                    LiturgicalGradientCard(color: .red) {
                        // Generic by decision, with no number of our own — see CrisisLines.
                        let crisis = CrisisLines.current
                        VStack(alignment: .leading, spacing: 6) {
                            Text(crisis.title)
                                .font(MissaleFont.display(24))
                                .foregroundStyle(.white)
                            Text(crisis.message)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(.white.opacity(0.92))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Text("Este app oferece formação e oração. Não é terapia nem atendimento clínico, e não finge ser.", tableName: "Today")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.55))

                    Button {
                        dismiss()
                    } label: {
                        Text("Entendi, fechar", tableName: "Today")
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
