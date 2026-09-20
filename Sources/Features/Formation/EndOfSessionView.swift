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
                Text(L.string("Part {n} completed", table: "FormationWordOfDay")
                    .replacingOccurrences(of: "{n}", with: "\(lesson.partNumber)"))
                    .font(MissaleFont.display(25, weight: .medium))
                    .multilineTextAlignment(.center)
                Text(L.string("\u{201C}{title}\u{201D} is yours now. Come back whenever you want to continue the track.", table: "FormationWordOfDay")
                    .replacingOccurrences(of: "{title}", with: lesson.title))
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.65))
                    .multilineTextAlignment(.center)

                Button {
                    onBackToTracks()
                } label: {
                    Text(L.string("Back to the tracks", table: "FormationWordOfDay"))
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
