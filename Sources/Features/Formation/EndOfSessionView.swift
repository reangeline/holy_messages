import SwiftUI

/// t4 screen 20 — end-of-session screen. Deliberately quiet/under-interactive: no
/// tab bar, no obvious path back into more content, per the design's own spec rule
/// ("fim de sessão manda fechar o app").
struct EndOfSessionView: View {
    let lesson: FormationLesson

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 18) {
                Spacer()
                CrossGlyph(size: 30, color: Palette.goldMuted)
                Text("Parte \(lesson.partNumber) lida. Agora feche o app.")
                    .font(MissaleFont.display(25, weight: .medium))
                    .multilineTextAlignment(.center)
                Text("A próxima parte espera até amanhã. O que você leu hoje se aprende rezando, não lendo mais.")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.65))
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    quietLine("Rezar um Ato de Contrição agora")
                    quietLine("Ver horários de confissão perto de você")
                    quietLine("Encontrar adoração hoje")
                }
                .padding(.top, 8)

                Text("Sem próximo conteúdo na fila. É de propósito.")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.45))
                    .padding(.top, 4)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        // Deliberately keeps the standard back button (rather than hiding it) so the
        // screen is still QA-navigable — the design's "close the app" intent is carried
        // by the copy and the lack of any forward path, not by trapping the user here.
    }

    private func quietLine(_ text: String) -> some View {
        Text(text)
            .font(MissaleFont.body(16))
            .foregroundStyle(Palette.ink.opacity(0.7))
    }
}

#Preview {
    NavigationStack { EndOfSessionView(lesson: MockFormation.atoPenitencial) }
}
