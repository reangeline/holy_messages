import Foundation

/// From the morning intention, Jev picks one verse for the day out of the
/// reviewed Word of the Day pool (the same 90 passages, in the reader's
/// language). The verse is shown under the intention on Today, recalled at
/// Compline and kept on the calendar. Only the catalog's text is ever shown.
///
/// Asked when the intention is saved, never while it is typed; saving a
/// different text the same day asks again. Nil from `JevPicker` (off, not
/// subscribed), no confident answer, or every call failing (offline, the
/// server, the daily limit): nothing is stored, and the screens stay as they
/// were. A stored verse and "Jev was asked" are the same thing here — there is
/// no separate flag — so a failed attempt naturally leaves room for another:
/// `IntentionVerseSection` asks again when the app becomes active while
/// today has an intention and no verse.
enum IntentionVerse {
    static let versePick = "verse"

    /// The pool is spread over three rounds of ~30; the final among ~30
    /// candidates spreads the probability thinner than the Rosary's 20.
    static let minimumConfidence = 0.2

    @MainActor
    static var pick: JevPicker.Pick {
        pick(pool: MockWordOfDay.pool, english: englishPool)
    }

    static func pick(pool: [WordOfDay], english: [WordOfDay]) -> JevPicker.Pick {
        JevPicker.Pick(key: versePick,
                       instructions: "Which Bible verse best accompanies what this person hopes for and prays for today?",
                       candidates: candidates(pool: pool, english: english),
                       minimumConfidence: minimumConfidence)
    }

    /// Ids are the pool's own (they differ by language); the description is
    /// the same passage in the English catalog, which Jev reads best, or the
    /// entry itself when no English match exists.
    static func candidates(pool: [WordOfDay], english: [WordOfDay]) -> [JevPicker.Candidate] {
        let bySignature = Dictionary(english.compactMap { word in signature(word.reference).map { ($0, word) } },
                                     uniquingKeysWith: { first, _ in first })
        return pool.map { word in
            let described = signature(word.reference).flatMap { bySignature[$0] } ?? word
            let text = "\(described.reference): \(described.quote) Context: \(described.context)"
            return JevPicker.Candidate(id: word.id, description: JevPicker.clip(text, to: JevPicker.maxCriterionChars - 1))
        }
    }

    @MainActor
    private static var englishPool: [WordOfDay] {
        RemoteContent.items("word_of_day", language: .en, as: WordOfDay.self) ?? MockWordOfDay.catalog[.en]
    }

    // MARK: - Asking

    typealias Picker = @MainActor (_ text: String, _ picks: [JevPicker.Pick]) async -> JevPicker.Result?

    /// Fire and forget: the flow never waits on it. The answer is stored only
    /// if the day's intention is still the text that was asked about.
    @MainActor
    static func request(for intention: String, on date: Date = Date(), store: DailyRoutineStore = .shared) {
        Task { await resolve(intention, on: date, store: store) }
    }

    @MainActor
    static func resolve(_ intention: String, on date: Date = Date(), store: DailyRoutineStore,
                        pick: [JevPicker.Pick]? = nil,
                        picker: Picker = { await JevPicker.pick(from: $0, $1) }) async {
        let text = intention.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, let result = await picker(text, pick ?? [self.pick]) else { return }
        store.recordIntentionVerse(result[versePick], showCrisisFirst: result.showCrisisFirst, for: text, on: date)
    }

    // MARK: - Showing

    /// The stored verse in the current language. A verse picked in another
    /// language is found again by its reference.
    @MainActor
    static func verse(id: String) -> WordOfDay? {
        let pool = MockWordOfDay.pool
        if let word = pool.first(where: { $0.id == id }) { return word }
        let others = AppLanguage.allCases.flatMap { MockWordOfDay.catalog[$0] }
        guard let original = others.first(where: { $0.id == id }),
              let wanted = signature(original.reference) else { return nil }
        return pool.first { signature($0.reference) == wanted }
    }

    // MARK: - Matching across languages

    /// "Mateus 5, 3", "Matthew 5:3" and "Mateo 5, 3" → "matthew 5:3". Nil for
    /// a reference that doesn't read as "Book chapter, verses".
    static func signature(_ reference: String) -> String? {
        let folded = reference.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
            .replacingOccurrences(of: "–", with: "-")
        guard let match = folded.firstMatch(of: referencePattern),
              let book = match.output[1].substring, let chapter = match.output[2].substring,
              let verses = match.output[3].substring else { return nil }
        let name = book.trimmingCharacters(in: .whitespaces)
        return "\(bookAliases[name] ?? name) \(chapter):\(verses.filter { !$0.isWhitespace })"
    }

    // The project builds in Swift 5 mode, without bare /regex/ literals.
    private static let referencePattern = try! Regex(#"^(.+?)\s+(\d+)\s*[,:]\s*([\d\s\-.,]+)$"#)

    /// Portuguese and Spanish book names in the pool, folded, to English.
    private static let bookAliases: [String: String] = [
        "mateus": "matthew", "mateo": "matthew", "marcos": "mark", "lucas": "luke",
        "joao": "john", "juan": "john", "atos": "acts", "hechos": "acts",
        "romanos": "romans", "1 corintios": "1 corinthians", "2 corintios": "2 corinthians",
        "galatas": "galatians", "hebreus": "hebrews", "hebreos": "hebrews",
        "tiago": "james", "santiago": "james", "apocalipse": "revelation", "apocalipsis": "revelation",
        "isaias": "isaiah", "jeremias": "jeremiah", "ezequiel": "ezekiel", "sofonias": "zephaniah",
        "salmo": "psalm", "salmos": "psalm", "psalms": "psalm",
    ]
}
