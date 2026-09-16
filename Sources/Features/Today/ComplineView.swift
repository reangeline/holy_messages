import SwiftUI

/// Screen 5 (eIs5) — Compline / night prayer. Full-text reading with a dark-mode
/// toggle; "Terminar e apagar a tela" is this flow's literal end-of-session action.
struct ComplineView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var darkScreen = true

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x181315).opacity(0.94), Color(hex: 0x28181C).opacity(0.94)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(L.string("‹ Voltar", table: "Today")) { dismiss() }
                        .foregroundStyle(Palette.goldBright)
                    Spacer()
                    HStack(spacing: 8) {
                        Text("Tela escura", tableName: "Today").font(MissaleFont.body(13)).foregroundStyle(.white.opacity(0.55))
                        Toggle("", isOn: $darkScreen)
                            .labelsHidden()
                            .tint(Palette.goldBright)
                    }
                }
                .padding(.top, 8)

                Eyebrow(text: L.string("Completas · oração da noite", table: "Today"), color: Palette.goldBright)
                    .padding(.top, 18)
                Text("\(MockLiturgical.today.weekdayLabel), \(MockLiturgical.today.feastName)")
                    .font(MissaleFont.display(28, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 6)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Convertei-nos, ó Deus, nosso salvador.")
                            .font(MissaleFont.display(21, italic: true))
                            .foregroundStyle(Palette.goldBright)
                        Text("Ó Deus, vinde em meu auxílio. Senhor, apressai-vos em socorrer-me. Glória ao Pai e ao Filho e ao Espírito Santo.")
                            .font(MissaleFont.body(18))
                            .foregroundStyle(.white.opacity(0.88))
                        Text("SALMO 90")
                            .font(MissaleFont.body(12, weight: .semibold))
                            .tracking(1.4)
                            .foregroundStyle(.white.opacity(0.5))
                        Text("Quem habita ao abrigo do Altíssimo e mora à sombra do Onipotente diz ao Senhor: sois meu refúgio e minha cidadela, meu Deus, em quem confio.")
                            .font(MissaleFont.body(18))
                            .foregroundStyle(.white.opacity(0.88))
                        Text("Texto completo, offline. Rolagem lenta e nenhuma notificação enquanto esta tela está aberta.", tableName: "Today")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(.white.opacity(0.55))
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Terminar e apagar a tela", tableName: "Today")
                        .font(MissaleFont.body(17))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.clear)
                        .overlay(Capsule().strokeBorder(.white.opacity(0.4), lineWidth: 1))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .brightness(darkScreen ? 0 : 0.15)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack { ComplineView() }
}
