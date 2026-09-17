import Foundation

/// Minimal, widget-only copy of "today" — mirrors MockLiturgical.today,
/// MockWordOfDay.pool and MockSaints.notburga in the main app target. A widget
/// extension runs in its own process, so this duplicates just what the two
/// widgets need instead of pulling in the app's full mock-data graph (which
/// drags in Settings/onboarding types that have nothing to do with a widget).
/// Update both copies together when Acervo content changes — the same manual
/// porting step the rest of the app's content already goes through.
enum WidgetContent {
    static let todayDateKey = "2026-09-14"
    static let todayColor: LiturgicalColor = .red

    struct WordOfDay {
        let quote: String
        let reference: String
    }

    static let wordOfDayPool: [WordOfDay] = [
        .init(
            quote: "Como Moisés levantou a serpente no deserto, assim deve ser levantado o Filho do Homem, para que todo o que nele crer tenha a vida eterna.",
            reference: "João 3, 14-15"
        ),
    ]

    /// Same FNV-1a stable hash as MockWordOfDay.stableHash in the app target —
    /// deterministic across launches, unlike Swift's own randomized Hasher, so
    /// the widget and the app agree on which pool entry is "today's".
    static var wordOfDay: WordOfDay {
        var hash: UInt64 = 14_695_981_039_346_656_037
        for byte in todayDateKey.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1_099_511_628_211
        }
        return wordOfDayPool[Int(hash % UInt64(wordOfDayPool.count))]
    }

    struct SaintOfDay {
        let name: String
        let role: String
    }

    static let saintOfDay = SaintOfDay(name: "Santa Notburga de Eben", role: "Serva, padroeira dos pobres")
}
