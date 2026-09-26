import SwiftUI

/// The Examen's real end-of-session screen — unlike Formation's (where "close
/// the app" read as bossy for a daily microlesson), the instruction to close
/// the app belongs here: this is nightly prayer, and the point is to stop
/// looking at a screen and continue the conversation with God in silence.
struct ExamenClosingView: View {
    let onFinished: () -> Void
    var suggestion: ExamenSuggestion? = nil
    var showCrisis = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                if showCrisis {
                    // A risk sign in what was written: the support comes
                    // before anything else, including "close the app now".
                    ScrollView {
                        VStack(spacing: 18) {
                            CrisisSupportCard()
                                .padding(16)
                                .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            closing
                        }
                        .padding(.top, 12)
                    }
                    .scrollIndicators(.hidden)
                } else {
                    Spacer()
                    closing
                    Spacer()
                    Spacer()
                }

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

    @ViewBuilder private var closing: some View {
        CrossGlyph(size: 30, color: Palette.goldBright)
        Text("Por hoje, é só isso.", tableName: "Today")
            .font(MissaleFont.display(28, weight: .semibold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
        Text("Feche o aplicativo agora. O que começou aqui continua em silêncio — a conversa com Deus não precisa de mais tela, só do seu íntimo.", tableName: "Today")
            .font(MissaleFont.body(16))
            .foregroundStyle(.white.opacity(0.7))
            .multilineTextAlignment(.center)
        // Jev's saint and prayer, whenever they arrive; nothing waits on them.
        if let suggestion {
            ExamenSuggestionCard(suggestion: suggestion)
                .padding(.top, 8)
        }
    }
}

#Preview {
    ExamenClosingView(onFinished: {})
}
