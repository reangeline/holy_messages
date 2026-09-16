import SwiftUI

/// Spec §10 — formation on virtue/freedom around pornography, substances, and
/// gambling, with mandatory referral out of the app. Unlike the other Formation
/// tracks, this screen is reachable for free even though its lessons are still a
/// locked placeholder — a safety/referral surface shouldn't sit behind a paywall.
///
/// Tone rules from the spec, followed literally: freedom/virtue language, never
/// shame or disgust; relapse is not spiritual failure; no ranking, no social
/// comparison; the day counter is optional and off by default, and never
/// notifies about a broken streak.
struct FreedomVirtueView: View {
    @AppStorage("freedomVirtueCounterEnabled") private var counterEnabled = false

    var body: some View {
        ZStack {
            LiturgicalColor.purple.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Eyebrow(text: "Liberdade e virtude")
                        Text("Isso é caminho, não isolamento")
                            .font(MissaleFont.display(28, weight: .semibold))
                            .foregroundStyle(Palette.ink)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("O que este espaço é")
                                .font(MissaleFont.body(17, weight: .medium))
                            Text("Formação sobre o que a Igreja ensina a respeito de temperança, castidade e liberdade — e sobre o bem verdadeiro que o vício imita, mal. O caminho sacramental: confissão frequente, um confessor fixo, adoração. E ajuda de verdade para pedir ajuda.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.8))
                        }
                    }

                    DashedUtilityCard {
                        Text("O que não é: tratamento, terapia, programa de recuperação, nem substituto de acompanhamento profissional. Isso é formação e oração — o resto precisa de gente qualificada, indicada abaixo.")
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.75))
                    }

                    Text("Encaminhamento")
                        .font(MissaleFont.body(13, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(Palette.ink.opacity(0.5))
                        .padding(.top, 4)

                    referralCard(
                        title: "Um confessor fixo",
                        body: "Não confissões avulsas com padres diferentes — alguém que conheça sua história e possa acompanhar o caminho inteiro, não só o incidente mais recente."
                    )
                    referralCard(
                        title: "Profissional de saúde",
                        body: "Dependência química e transtorno de jogo têm tratamento clínico real. Formação espiritual acompanha esse tratamento — não substitui."
                    )
                    referralCard(
                        title: "Grupos de apoio",
                        body: "Alcoólicos Anônimos, Narcóticos Anônimos, Jogadores Anônimos, SMART Recovery. Nos EUA, a linha nacional de jogo compulsivo: 1-800-GAMBLER."
                    )

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Contar dias")
                                        .font(MissaleFont.body(17, weight: .medium))
                                    Text("Opcional. Ajuda algumas pessoas e atrapalha outras — desligado por padrão.")
                                        .font(MissaleFont.body(13))
                                        .foregroundStyle(Palette.ink.opacity(0.6))
                                }
                                Spacer()
                                Toggle("", isOn: $counterEnabled).labelsHidden().tint(Palette.wine)
                            }
                            Text("Sem notificação de recaída, sem contador zerado à vista de todos. Uma recaída não apaga o caminho percorrido antes dela.")
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.55))
                        }
                    }

                    Text("Recaída não é fracasso espiritual. A resposta é voltar à confissão e ao acompanhamento humano, sem drama e sem punição — aqui ou em qualquer outro lugar.")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.65))
                        .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func referralCard(title: String, body: String) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(MissaleFont.body(17, weight: .medium)).foregroundStyle(Palette.ink)
                Text(body).font(MissaleFont.body(15)).foregroundStyle(Palette.ink.opacity(0.72))
            }
        }
    }
}

#Preview {
    NavigationStack { FreedomVirtueView() }
}
