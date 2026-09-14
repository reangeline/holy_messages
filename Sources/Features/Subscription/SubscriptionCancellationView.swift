import SwiftUI
import UIKit

/// t5 screen 9 (fIs9) — cancellation detail: what happens, what stays yours
/// forever, what pauses, and the hardship policy — no retention discount anywhere.
/// Reached from Settings › Assinatura › "Cancelar a renovação".
struct SubscriptionCancellationView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cancelar a renovação")
                            .font(MissaleFont.display(28, weight: .semibold))
                        Text("Sem perguntas de saída e sem oferta de desconto. Só o que muda e o que não muda.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 9) {
                            Eyebrow(text: "O que acontece")
                            ForEach(MockSubscription.cancelWhatHappens, id: \.self) { line in
                                Text(line)
                                    .font(MissaleFont.body(16))
                                    .foregroundStyle(Palette.ink.opacity(0.84))
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 9) {
                            Eyebrow(text: "Continua seu, para sempre")
                            ForEach(MockSubscription.keepsForever, id: \.self) { line in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•").foregroundStyle(Palette.wine)
                                    Text(line).font(MissaleFont.body(16)).foregroundStyle(Palette.ink.opacity(0.86))
                                }
                            }
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "Fica em pausa")
                            Text(MockSubscription.cancelPausedNote)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Se o motivo for dinheiro, não cancele: escreva e liberamos o acesso completo, sem comprovação e sem prazo.")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.84))
                        Text(MockSubscription.hardshipEmail)
                            .font(MissaleFont.body(16, weight: .medium))
                            .foregroundStyle(Palette.wine)
                    }
                    .padding(16)
                    .background(Palette.wine.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Palette.wine.opacity(0.26), lineWidth: 1))

                    VStack(spacing: 10) {
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Cancelar nos ajustes do iPhone")
                                .font(MissaleFont.body(17))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Palette.wine, in: Capsule())
                                .foregroundStyle(.white)
                        }
                        Button {
                            dismiss()
                        } label: {
                            Text("Manter minha assinatura")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.65))
                        }
                        Text("O cancelamento é feito pela App Store. Este botão abre a tela do sistema.")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
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
}

#Preview {
    NavigationStack { SubscriptionCancellationView() }
}
