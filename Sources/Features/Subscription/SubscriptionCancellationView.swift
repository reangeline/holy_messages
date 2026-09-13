import SwiftUI
import UIKit

/// Screen 30 (eIs30) — subscription cancellation, "the door stays open". No
/// retention discount, no guilt; billing management deep-links to system Settings.
struct SubscriptionCancellationView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button("‹ Ajustes") { dismiss() }
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.wine)
                        Spacer()
                    }

                    Eyebrow(text: "Sua assinatura")
                    Text("A porta fica aberta")
                        .font(MissaleFont.display(28, weight: .semibold))
                        .foregroundStyle(Palette.ink)
                    Text("Você desligou a renovação. O acesso completo continua até \(MockSubscription.renewalOffDate), e depois disso nada é cobrado.")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Eyebrow(text: "O que continua seu, para sempre")
                            ForEach(MockSubscription.keepsForever, id: \.self) { line in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•").foregroundStyle(Palette.wine)
                                    Text(line).font(MissaleFont.body(15)).foregroundStyle(Palette.ink.opacity(0.82))
                                }
                            }
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Se o motivo for dinheiro, escreva para nós: acesso completo, liberado sem perguntas e sem comprovação. Isso não é exceção, é política.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.8))
                            Text(MockSubscription.hardshipEmail)
                                .font(MissaleFont.body(15, weight: .medium))
                                .foregroundStyle(Palette.wine)
                        }
                    }

                    Text("A cobrança é feita pela App Store. O cancelamento acontece nos ajustes do sistema, e este botão leva direto para lá.")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))

                    VStack(spacing: 10) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Voltar ao app")
                                .font(MissaleFont.body(17))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(.ultraThinMaterial, in: Capsule())
                                .overlay(Capsule().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                                .foregroundStyle(Palette.ink)
                        }
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Gerenciar nos ajustes do iPhone")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.wine)
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    SubscriptionCancellationView()
}
