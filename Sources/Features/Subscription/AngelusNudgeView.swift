import SwiftUI

/// Screen 29 (eIs29) — scheduled prayer nudge (Angelus), full-bleed, no guilt for
/// dismissing. In the real product this fires from a schedule; this pass has no
/// scheduler, so it's only reachable from Today's debug menu.
struct AngelusNudgeView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(colors: [Palette.wine.opacity(0.94), Color(hex: 0x421018).opacity(0.96)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()
                CrossGlyph(size: 34, color: Palette.goldBright)
                Eyebrow(text: "Meio-dia · vermelho · \(MockLiturgical.today.feastName)", color: Palette.goldBright)
                    .multilineTextAlignment(.center)
                Text("É a hora do Angelus")
                    .font(MissaleFont.display(30, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text("Você separou esta janela antes, quando estava tranquilo. Ela dura três minutos e termina sozinha.")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(.white.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Rezar o Angelus")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Palette.goldBright, in: Capsule())
                            .foregroundStyle(Color(hex: 0x2A1A1C))
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Ficar em silêncio até 12h03")
                            .font(MissaleFont.body(16))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .overlay(Capsule().strokeBorder(.white.opacity(0.5), lineWidth: 1))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 8)

                Button {
                    dismiss()
                } label: {
                    Text("Abrir o Instagram agora")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()
                Text("A saída está sempre aqui. Sem cobrança, sem contador de recaída.")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    AngelusNudgeView()
}
