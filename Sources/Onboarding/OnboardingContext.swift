import Foundation

/// The onboarding answers, as text for the AI: one line per answered
/// question, "<question>: <answer(s) joined by ', '>". Skipped questions are
/// left out. Built twice: in English for Jev (which reads English best) and in
/// the app's current language for the reflection. Kept only in memory; the
/// view model's answers are the only source, nothing here is saved.
struct OnboardingContext: Equatable {
    static let empty = OnboardingContext(englishLines: [], localLines: [])

    let englishLines: [String]
    let localLines: [String]

    static let jevHeader = "Context from their onboarding answers:\n"
    /// The server's limits: `state` <= 2000 on /v1/decisions, `context` <= 1500
    /// on /v1/reflections (Unicode scalars).
    static let stateLimit = 2000
    static let reflectionLimit = 1500

    init(englishLines: [String], localLines: [String]) {
        self.englishLines = englishLines
        self.localLines = localLines
    }

    init(life: [String: Set<String>], spiritual: [String: String], language: AppLanguage) {
        englishLines = Self.lines(life: life, spiritual: spiritual, language: .en)
        localLines = Self.lines(life: life, spiritual: spiritual, language: language)
    }

    static func lines(life: [String: Set<String>], spiritual: [String: String], language: AppLanguage) -> [String] {
        var lines: [String] = []
        for question in MockOnboarding.lifeQuestions(for: language) {
            // Catalog order, so the line doesn't depend on Set ordering.
            let answers = question.options.filter { life[question.id]?.contains($0.id) ?? false }.map(\.text)
            if !answers.isEmpty { lines.append("\(question.title): \(answers.joined(separator: ", "))") }
        }
        for question in MockOnboarding.spiritualQuestions(for: language) {
            if let id = spiritual[question.id], let option = question.options.first(where: { $0.id == id }) {
                lines.append("\(question.title): \(option.text)")
            }
        }
        return lines
    }

    /// What Jev gets as `state`: the reader's text first, then the English
    /// context block. The text has priority: the context is cut first, by
    /// whole lines, to fit `stateLimit`; with no room for even one line (or no
    /// answers) the text goes alone, as outside the onboarding.
    func jevState(for text: String) -> String {
        let prefix = text + "\n\n" + Self.jevHeader
        let room = Self.stateLimit - prefix.unicodeScalars.count
        guard let block = Self.fit(englishLines, limit: room) else { return text }
        return prefix + block
    }

    /// The reflection's `context`, in the app's language, cut by whole lines
    /// to `reflectionLimit`. Nil when there is nothing to send.
    var reflectionContext: String? { Self.fit(localLines, limit: Self.reflectionLimit) }

    /// The longest run of leading lines, joined by newlines, within `limit`.
    private static func fit(_ lines: [String], limit: Int) -> String? {
        var kept: [String] = []
        var used = 0
        for line in lines {
            let cost = line.unicodeScalars.count + (kept.isEmpty ? 0 : 1)
            if used + cost > limit { break }
            kept.append(line)
            used += cost
        }
        return kept.isEmpty ? nil : kept.joined(separator: "\n")
    }
}
