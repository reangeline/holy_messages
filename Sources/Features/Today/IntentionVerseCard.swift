import SwiftUI

/// The verse Jev chose for the morning intention, as the catalog has it —
/// quote and reference, never generated text — labeled as chosen from what
/// the reader wrote. Today wraps it in a card; the calendar shows it bare.
struct IntentionVerseText: View {
    let verse: WordOfDay
    var title: String?
    var ink: Color = Palette.ink
    var accent: Color = Palette.wine

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Eyebrow(text: L.string("Escolhido a partir da sua intenção", table: "Today"), color: accent)
            if let title {
                Text(title)
                    .font(MissaleFont.body(14, weight: .medium))
                    .foregroundStyle(ink.opacity(0.6))
            }
            Text("\u{201C}\(verse.quote)\u{201D}")
                .font(MissaleFont.display(18, italic: true))
                .foregroundStyle(ink)
            Text(verse.reference)
                .font(MissaleFont.body(13, weight: .semibold))
                .foregroundStyle(ink.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("intentionVerse")
    }
}

/// Under the morning row on Today: the crisis card first when Jev flagged the
/// intention, then the day's verse. Nothing at all until an answer arrives.
struct IntentionVerseSection: View {
    @ObservedObject private var routine = DailyRoutineStore.shared

    var body: some View {
        if let intention = routine.intention() {
            Group {
                if routine.showsCrisisForIntention() {
                    GlassCard { CrisisSupportCard() }
                }
                if let id = routine.intentionVerseID(), let verse = IntentionVerse.verse(id: id) {
                    GlassCard {
                        IntentionVerseText(verse: verse, title: L.string("Para a sua intenção de hoje", table: "Today"))
                    }
                }
            }
            // A failed pick (offline, the server, the daily limit) stores no
            // verse without marking the intention as answered: try again
            // whenever the app comes back, instead of staying silent all day.
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                guard routine.intentionVerseID() == nil else { return }
                IntentionVerse.request(for: intention)
            }
        }
    }
}
