import SwiftUI

/// t4 screen 20 — shown right after finishing a Formation part. Deliberately
/// light-touch: a short confirmation and one way back into the trilha, no
/// "close the app now" instruction (dropped per user feedback — it read as
/// bossy and didn't fit someone who wants to keep browsing other parts).
struct EndOfSessionView: View {
    let lesson: FormationLesson
    let onBackToTracks: () -> Void

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 18) {
                Spacer()
                CrossGlyph(size: 30, color: Palette.goldMuted)
                Text("Parte \(lesson.partNumber) concluída")
                    .font(MissaleFont.display(25, weight: .medium))
                    .multilineTextAlignment(.center)
                Text("\u{201C}\(lesson.title)\u{201D} já é sua. Volte quando quiser continuar a trilha.")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.65))
                    .multilineTextAlignment(.center)

                Button {
                    onBackToTracks()
                } label: {
                    Text("Voltar para as trilhas")
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Palette.wine, in: Capsule())
                }
                .padding(.top, 8)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    NavigationStack { EndOfSessionView(lesson: MockFormation.atoPenitencial, onBackToTracks: {}) }
}
