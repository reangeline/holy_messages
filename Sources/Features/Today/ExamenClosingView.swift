import SwiftUI

/// The Examen's real end-of-session screen — unlike Formation's (where "close
/// the app" read as bossy for a daily microlesson), the instruction to close
/// the app belongs here: this is nightly prayer, and the point is to stop
/// looking at a screen and continue the conversation with God in silence.
struct ExamenClosingView: View {
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer()
                CrossGlyph(size: 30, color: Palette.goldBright)
                Text("Por hoje, é só isso.", tableName: "Today")
                    .font(MissaleFont.display(28, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text("Feche o aplicativo agora. O que começou aqui continua em silêncio — a conversa com Deus não precisa de mais tela, só do seu íntimo.", tableName: "Today")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                Spacer()
                Spacer()

                Button {
                    onFinished()
                } label: {
                    Text("Encerrar", tableName: "Today")
                        .font(MissaleFont.body(17))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.clear)
                        .overlay(Capsule().strokeBorder(.white.opacity(0.4), lineWidth: 1))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 32)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ExamenClosingView(onFinished: {})
}
