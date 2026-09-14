import SwiftUI

/// t5 screen 2 (fIs2) — active subscription detail, explicit restore button,
/// what's included vs. free-forever, and the path to cancellation (fIs9).
struct SubscriptionDetailView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Assinatura")
                        .font(MissaleFont.display(29, weight: .semibold))

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("ATIVA")
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.4)
                                    .foregroundStyle(Palette.goldBright)
                                Spacer()
                                Text("US$ 39,99/ano")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                            Text("Missale Premium · anual")
                                .font(MissaleFont.display(21, weight: .medium))
                                .foregroundStyle(.white)
                            Text("Renova automaticamente em 14 de outubro de 2026. Cobrança pela App Store.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(.white.opacity(0.88))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 9) {
                            Eyebrow(text: "O que está incluído")
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Todas as trilhas de formação, e as novas conforme saem")
                                Text("O calendário litúrgico completo, com cada festa explicada")
                                Text("Orações e devoções da tradição, offline")
                                Text("Terço guiado com voz, modo iniciante e tela apagada")
                            }
                            .font(MissaleFont.body(16))

                            Divider().padding(.vertical, 4)

                            Eyebrow(text: "Grátis para sempre, com ou sem assinatura")
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Palavra do dia e santo do dia")
                                Text("O Terço completo")
                                Text("Seu calendário e tudo o que você registrou")
                                Text("A rede de encaminhamento pastoral")
                            }
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.78))
                        }
                    }

                    Button {
                        // UI-only for this pass — no real StoreKit transaction to restore.
                    } label: {
                        Text("Restaurar compras")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                            .foregroundStyle(Palette.ink)
                    }

                    NavigationLink {
                        SubscriptionCancellationView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Cancelar a renovação")
                                    .font(MissaleFont.body(17))
                                    .foregroundStyle(Palette.ink)
                                Text("Sem perguntas e sem oferta de desconto")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.64))
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(16)
                    .background(Color.white.opacity(0.36))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 4])).foregroundStyle(Palette.ink.opacity(0.22)))

                    HStack(spacing: 16) {
                        NavigationLink("Termos de uso", value: SettingsDestination.termsPlaceholder("Termos de uso"))
                        NavigationLink("Política de privacidade", value: SettingsDestination.termsPlaceholder("Política de privacidade"))
                    }
                    .font(MissaleFont.body(15))
                    .tint(Palette.wine)

                    Text("A assinatura renova sozinha até ser cancelada. O cancelamento acontece nos ajustes da conta da App Store, ao menos 24 horas antes do fim do período.")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
