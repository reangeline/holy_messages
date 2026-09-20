import SwiftUI

/// Spec §8 — screen-time lock anchored to the Church's hours, not generic
/// productivity triggers. This is a UI mockup: no ManagedSettings/DeviceActivity
/// integration exists behind it — see SocialLockRule for why. It exists so the
/// design (rules + the lock surface itself) can be reviewed and iterated on
/// before the real entitlement and native extensions are in place.
struct SocialLockSetupView: View {
    @State private var rules = MockSocialLock.rules
    @State private var lentWindowEnabled = false
    @State private var showPreview = false

    var body: some View {
        ZStack {
            LiturgicalColor.purple.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Eyebrow(text: "Protótipo · ainda não funcional")
                        Text("Bloqueio de tela")
                            .font(MissaleFont.display(28, weight: .semibold))
                            .foregroundStyle(Palette.ink)
                        Text("Ancorado nos horários da própria Igreja, não num cronômetro de produtividade. Você define a regra antes; a oração não é o preço da janela, é o que ela protege.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    DashedUtilityCard {
                        Text("Esta tela é um protótipo de design. O bloqueio de verdade depende de uma autorização da Apple (family-controls) que ainda não foi concedida, e de um componente nativo que ainda não existe. Nada aqui bloqueia nada por enquanto.")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    Text("Gatilhos")
                        .font(MissaleFont.body(13, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(Palette.ink.opacity(0.5))

                    ForEach($rules) { $rule in
                        GlassCard {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(rule.title).font(MissaleFont.body(16, weight: .medium))
                                    Text(rule.subtitle).font(MissaleFont.body(13)).foregroundStyle(Palette.wine)
                                    Text(rule.detail).font(MissaleFont.body(13)).foregroundStyle(Palette.ink.opacity(0.6))
                                }
                                Spacer()
                                Toggle("", isOn: $rule.isEnabled).labelsHidden().tint(Palette.wine)
                            }
                        }
                    }

                    GlassCard {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Jejum de Quaresma").font(MissaleFont.body(16, weight: .medium))
                                Text(MockSocialLock.lentWindowNote)
                                    .font(MissaleFont.body(13))
                                    .foregroundStyle(Palette.ink.opacity(0.6))
                            }
                            Spacer()
                            Toggle("", isOn: $lentWindowEnabled).labelsHidden().tint(Palette.wine)
                        }
                    }

                    Button {
                        showPreview = true
                    } label: {
                        Text("Ver a tela de bloqueio")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Palette.wine, in: Capsule())
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 4)

                    Text("Sempre com saída: nunca bloqueia telefone, mensagens, mapas ou emergência; lista de exceções configurável; sem streak de dias sem rede social e sem notificação de recaída.")
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
        .fullScreenCover(isPresented: $showPreview) {
            SocialLockPreviewView(
                trigger: rules.first { $0.isEnabled } ?? rules[0],
                onDismiss: { showPreview = false }
            )
            .appLanguageLocale()
        }
    }
}

#Preview {
    NavigationStack { SocialLockSetupView() }
}
