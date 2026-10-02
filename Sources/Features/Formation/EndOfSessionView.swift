import SwiftUI

/// t4 screen 20 — shown right after finishing a Formation part. Deliberately
/// light-touch: a short confirmation and one way back into the trilha, no
/// "close the app now" instruction (dropped per user feedback — it read as
/// bossy and didn't fit someone who wants to keep browsing other parts).
/// When the track has a next part, "Continue" is the main action and opens it
/// straight away; going back to the tracks becomes the quiet option.
struct EndOfSessionView: View {
    let lesson: FormationLesson
    let onBackToTracks: () -> Void
    var onContinue: (FormationLesson) -> Void = { _ in }

    private var next: FormationLesson? { lesson.next(in: MockFormation.allTracks) }
    private var trackTitle: String { MockFormation.track(withID: lesson.trackID)?.title ?? "" }

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

                if let next {
                    Button {
                        onContinue(next)
                    } label: {
                        primaryLabel(L.string("Continue: Part {n}: {title}", table: "FormationWordOfDay")
                            .replacingOccurrences(of: "{n}", with: "\(next.partNumber)")
                            .replacingOccurrences(of: "{title}", with: next.title))
                    }
                    .padding(.top, 8)

                    Button {
                        onBackToTracks()
                    } label: {
                        Text(L.string("Back to the tracks", table: "FormationWordOfDay"))
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.wine)
                            .padding(.vertical, 6)
                    }
                } else {
                    Text(L.string("You finished the track \u{201C}{track}\u{201D}.", table: "FormationWordOfDay")
                        .replacingOccurrences(of: "{track}", with: trackTitle))
                        .font(MissaleFont.body(15, weight: .medium))
                        .foregroundStyle(Palette.wine)
                        .multilineTextAlignment(.center)
                    Button {
                        onBackToTracks()
                    } label: {
                        primaryLabel(L.string("Back to the tracks", table: "FormationWordOfDay"))
                    }
                    .padding(.top, 8)
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }

    private func primaryLabel(_ text: String) -> some View {
        Text(text)
            .font(MissaleFont.body(17, weight: .medium))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 12)
            .background(Palette.wine, in: Capsule())
    }
}

extension FormationLesson {
    /// The part that follows this one in its own track, or nil when this is the
    /// last part or the track isn't in `tracks`.
    func next(in tracks: [FormationTrack]) -> FormationLesson? {
        guard let lessons = tracks.first(where: { $0.id == trackID })?.lessons,
              let index = lessons.firstIndex(where: { $0.id == id }),
              lessons.indices.contains(index + 1) else { return nil }
        return lessons[index + 1]
    }
}

#Preview {
    NavigationStack { EndOfSessionView(lesson: MockFormation.atoPenitencial, onBackToTracks: {}) }
}
