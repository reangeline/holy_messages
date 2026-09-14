import SwiftUI

/// t5 screen 8 (fIs8) — human support contact, the explicit no-questions-asked
/// hardship policy, parish/catechesis licensing, and links (FAQ, Terms, Privacy).
struct SupportView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Suporte")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("Gente responde, não um formulário.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Escrever para nós").font(MissaleFont.body(18, weight: .medium))
                            Text("Respondemos em até dois dias úteis, em português ou inglês. Quem responde é uma das três pessoas que fazem o app.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.74))
                            Text(MockSettings.supportEmail)
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.wine)
                        }
                    }

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("ACESSO GRATUITO")
                                .font(MissaleFont.body(11, weight: .semibold))
                                .tracking(1.4)
                                .foregroundStyle(Palette.goldBright)
                            Text("Se o preço for o problema, ele deixa de ser")
                                .font(MissaleFont.body(19, weight: .medium))
                                .foregroundStyle(.white)
                            Text("Escreva pedindo e liberamos o acesso completo. Sem comprovação de renda, sem explicação e sem prazo. Isso não é exceção, é política — ninguém fica de fora da formação por dinheiro.")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(.white.opacity(0.92))
                            Text(MockSettings.accessEmail)
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.goldBright)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Paróquias e catequese").font(MissaleFont.body(18, weight: .medium))
                            Text("Licenças em bloco para grupos, catecúmenos de OCIA e pastorais, também gratuitas. Fale com a gente.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.74))
                        }
                    }

                    VStack(spacing: 0) {
                        linkRow("Perguntas frequentes", destination: .faq)
                        Divider().opacity(0.5)
                        linkRow("Termos de uso", destination: .termsPlaceholder("Termos de uso"))
                        Divider().opacity(0.5)
                        linkRow("Política de privacidade", destination: .termsPlaceholder("Política de privacidade"))
                    }
                    .background(Color.white.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.58), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func linkRow(_ title: String, destination: SettingsDestination) -> some View {
        NavigationLink(value: destination) {
            HStack {
                Text(title).font(MissaleFont.body(17)).foregroundStyle(Palette.ink)
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13)).foregroundStyle(Palette.ink.opacity(0.35))
            }
            .padding(14)
        }
        .buttonStyle(.plain)
    }
}
