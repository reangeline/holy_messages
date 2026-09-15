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
                Text(L.string("Part {n} read. Now close the app.", table: "FormationWordOfDay")
                    .replacingOccurrences(of: "{n}", with: "\(lesson.partNumber)"))
                    .font(MissaleFont.display(25, weight: .medium))
                    .multilineTextAlignment(.center)
                Text("Tomorrow's part will wait. What you read today is learned by praying, not by reading more.", tableName: "FormationWordOfDay")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.65))
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    quietLine(L.string( "Pray an Act of Contrition now", table: "FormationWordOfDay"))
                    quietLine(L.string( "See confession times near you", table: "FormationWordOfDay"))
                    quietLine(L.string( "Find adoration today", table: "FormationWordOfDay"))
                }
                .padding(.top, 8)

                Text("No next content queued. That's on purpose.", tableName: "FormationWordOfDay")
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
