import XCTest
@testable import Missale

/// The personalized Word of the Day: which text goes to Jev, the 30-day
/// exclusion, once a day, free users untouched, and app and widget reading
/// the same id. Jev is a recording fake: nothing reaches the network.
@MainActor
final class PersonalizedWordOfDayTests: XCTestCase {

    private let now = Date(timeIntervalSinceReferenceDate: 812_000_000) // a fixed afternoon
    private let day = "2026-09-26"
    private let language = AppLanguagePreference.resolveCurrent().rawValue

    private var pool: [WordOfDay] {
        (0..<90).map { WordOfDay(id: "w\($0)", quote: "Quote \($0)", reference: "Ref \($0)", translationNote: "", context: "Context \($0)") }
    }

    private final class FakeJev {
        var calls: [(state: String, questions: [String: [String: Any]])] = []
        var wanted: String?
        var risk = 0.0

        func decide(_ state: String, _ questions: [String: [String: Any]]) async throws -> [String: Any] {
            calls.append((state, questions))
            var answers: [String: Any] = [:]
            for (key, question) in questions {
                if question["type"] as? String == "noul" { answers[key] = ["noul": risk]; continue }
                guard let criteria = question["criteria"] as? [String: String] else { continue }
                let choice = wanted.flatMap { criteria[$0] != nil ? $0 : nil } ?? criteria.keys.sorted()[0]
                answers[key] = ["choice": choice, "probabilities": [choice: 0.9]]
            }
            return answers
        }

        /// All candidate ids Jev was shown, across the chunks.
        var shownIDs: Set<String> {
            Set(calls.flatMap { $0.questions.values.compactMap { $0["criteria"] as? [String: String] }.flatMap(\.keys) })
        }
    }

    private func resolve(_ log: [String: ShownWord] = [:], text: String? = "I'm anxious about tomorrow",
                         enabled: Bool = true, subscribed: Bool = true, excludingVerseID: String? = nil,
                         _ fake: FakeJev) async -> [String: ShownWord] {
        await PersonalizedWordOfDay.resolve(log: log, day: day, language: language, pool: pool, drawn: pool[5],
                                            text: text, enabled: enabled, excludingVerseID: excludingVerseID) { text, picks in
            await JevPicker.pick(from: text, picks, enabled: enabled, subscribed: subscribed, decide: fake.decide)
        }
    }

    // MARK: - The input text

    func testTheNewestOfCheckInAndIntentionWithin24Hours() {
        let todayKey = DailyRoutineStore.dayKey(now)
        let start = Calendar.current.startOfDay(for: now)
        let morning = MoodEntry(stateID: "a", stateLabel: "A", note: "before the intention?", date: start.addingTimeInterval(-60))
        let later = MoodEntry(stateID: "a", stateLabel: "A", note: "a note this afternoon", date: now.addingTimeInterval(-60))

        XCTAssertEqual(PersonalizedWordOfDay.inputText(moods: [morning], intentions: [todayKey: "my intention"], now: now),
                       "my intention", "a intenção de hoje é mais nova que a nota de ontem à noite")
        XCTAssertEqual(PersonalizedWordOfDay.inputText(moods: [morning, later], intentions: [todayKey: "my intention"], now: now),
                       "a note this afternoon")
    }

    func testOnlyTextFromTheLast24HoursCounts() {
        let old = MoodEntry(stateID: "a", stateLabel: "A", note: "two days ago", date: now.addingTimeInterval(-25 * 3600))
        let empty = MoodEntry(stateID: "a", stateLabel: "A", note: "   ", date: now.addingTimeInterval(-60))
        let yesterday = DailyRoutineStore.dayKey(now.addingTimeInterval(-86_400))
        XCTAssertNil(PersonalizedWordOfDay.inputText(moods: [old, empty], intentions: [yesterday: "old intention"], now: now))
    }

    func testNothingWrittenKeepsTheDateDraw() async {
        let fake = FakeJev()
        let log = await resolve([:], text: nil, fake)
        XCTAssertTrue(fake.calls.isEmpty)
        XCTAssertEqual(log[day], ShownWord(id: "w5", language: language), "a palavra sorteada fica registrada como mostrada")
    }

    // MARK: - The pick

    func testJevPicksFromThePoolInTwoCallsAndTheChoiceIsKept() async {
        let fake = FakeJev()
        fake.wanted = "w42"
        let log = await resolve([:], fake)
        XCTAssertEqual(fake.calls.count, 2, "90 versículos: dois blocos e uma final")
        XCTAssertEqual(log[day], ShownWord(id: "w42", language: language, chosen: true, asked: true))
        for call in fake.calls {
            XCTAssertNotNil(call.questions["risk"], "toda chamada leva a pergunta de risco")
        }
    }

    func testWordsShownInTheLast30DaysAreExcluded() async {
        var history: [String: ShownWord] = [:]
        history["2026-09-20"] = ShownWord(id: "w1", language: language)
        history["2026-09-01"] = ShownWord(id: "w2", language: language)
        history["2026-08-20"] = ShownWord(id: "w3", language: language) // more than 30 days ago
        let fake = FakeJev()
        fake.wanted = "w1"
        let log = await resolve(history, fake)

        XCTAssertFalse(fake.shownIDs.contains("w1"))
        XCTAssertFalse(fake.shownIDs.contains("w2"))
        XCTAssertTrue(fake.shownIDs.contains("w3"), "o que passou de 30 dias volta a valer")
        XCTAssertNotEqual(log[day]?.id, "w1")
        XCTAssertNil(log["2026-08-20"], "o histórico guarda só 30 dias")
    }

    /// Today's intention verse (IntentionVerse) is never a Word of the Day
    /// candidate: the two cards on Today must never show the same passage.
    func testTodaysIntentionVerseIsExcludedFromCandidates() async {
        let fake = FakeJev()
        fake.wanted = "w5" // what would be picked if it weren't excluded
        let log = await resolve([:], excludingVerseID: "w5", fake)

        XCTAssertFalse(fake.shownIDs.contains("w5"), "o versículo da intenção do dia não pode ser candidato da palavra do dia")
        XCTAssertNotEqual(log[day]?.id, "w5")
    }

    /// The exclusion alone, without the 30-day history or a network call.
    func testCandidatesDropTheExcludedID() {
        let result = PersonalizedWordOfDay.candidates(pool: pool, log: [:], today: day, excluding: "w12")
        XCTAssertFalse(result.contains { $0.id == "w12" })
        XCTAssertEqual(result.count, pool.count - 1)
    }

    func testJevIsAskedAtMostOncePerDay() async {
        let fake = FakeJev()
        fake.wanted = "w42"
        let first = await resolve([:], fake)
        fake.wanted = "w7"
        let second = await resolve(first, text: "something else, later", fake)
        XCTAssertEqual(fake.calls.count, 2, "a segunda visita não pergunta de novo")
        XCTAssertEqual(second[day]?.id, "w42", "a palavra não muda no mesmo dia")
    }

    func testAnUnsureAnswerStillClosesTheDayAndKeepsTheCrisisFlag() async {
        let fake = FakeJev()
        fake.risk = 0.95
        let log = await PersonalizedWordOfDay.resolve(log: [:], day: day, language: language, pool: pool, drawn: pool[5],
                                                      text: "text", enabled: true) { _, _ in
            JevPicker.Result(choices: [:], showCrisisFirst: true)
        }
        XCTAssertEqual(log[day], ShownWord(id: "w5", language: language, chosen: false, asked: true, showCrisisFirst: true))
    }

    /// Every call failing (offline, the server, the daily limit) is not the
    /// same as an unsure answer: the day stays open, so the next chance —
    /// here, a later refresh that reaches Jev — still picks a word.
    func testAFailedAttemptLeavesTheDayOpenAndAFollowingAnswerFixesIt() async {
        let failed = await PersonalizedWordOfDay.resolve(log: [:], day: day, language: language, pool: pool, drawn: pool[5],
                                                          text: "text", enabled: true) { _, _ in
            JevPicker.Result(choices: [:], showCrisisFirst: false, answered: false)
        }
        XCTAssertEqual(failed[day], ShownWord(id: "w5", language: language),
                       "sem resposta de Jev, o dia continua aberto para tentar de novo")

        let fake = FakeJev()
        fake.wanted = "w42"
        let fixed = await resolve(failed, fake)
        XCTAssertEqual(fixed[day], ShownWord(id: "w42", language: language, chosen: true, asked: true),
                       "a tentativa seguinte, com resposta, fecha o dia")
    }

    // MARK: - Free users and personalization off

    func testFreeUsersSendNothingAndKeepTheDateDraw() async {
        let fake = FakeJev()
        let log = await resolve([:], subscribed: false, fake)
        XCTAssertTrue(fake.calls.isEmpty, "sem assinatura, nada é enviado")
        XCTAssertEqual(log[day], ShownWord(id: "w5", language: language), "sem assinatura, a palavra sorteada — e o dia fica aberto")
    }

    func testTurningPersonalizationOffRestoresTheDateDraw() async {
        let fake = FakeJev()
        let chosen = [day: ShownWord(id: "w42", language: language, chosen: true, asked: true)]
        let log = await resolve(chosen, enabled: false, fake)
        XCTAssertTrue(fake.calls.isEmpty)
        XCTAssertEqual(log[day]?.id, "w5")
        XCTAssertEqual(log[day]?.chosen, false)
    }

    // MARK: - App and widget read the same id

    func testAppAndWidgetReadTheSameChosenWord() {
        let realPool = MockWordOfDay.pool
        let drawn = MockWordOfDay.wordOfDay(for: WidgetContentKey.today)
        let other = realPool.first { $0.id != drawn.id }!
        let log = [WidgetContentKey.today: ShownWord(id: other.id, language: language, chosen: true, asked: true)]

        XCTAssertEqual(MockWordOfDay.word(for: WidgetContentKey.today, log: log), other)
        // Another language's pick, or none, falls back to the draw.
        let foreign = [WidgetContentKey.today: ShownWord(id: other.id, language: "xx", chosen: true, asked: true)]
        XCTAssertEqual(MockWordOfDay.word(for: WidgetContentKey.today, log: foreign), drawn)
        XCTAssertEqual(MockWordOfDay.word(for: WidgetContentKey.today, log: [:]), drawn)

        // Through the app group, as both targets read it.
        let saved = WordOfDayLog.entries()
        defer { WordOfDayLog.save(saved) }
        WordOfDayLog.save(log)
        XCTAssertEqual(MockWordOfDay.word(for: WidgetContentKey.today), other, "o widget lê esta mesma função e este mesmo grupo")
        if MockLiturgical.today.dateKey == WidgetContentKey.today {
            XCTAssertEqual(MockWordOfDay.today, other, "o Hoje, a tela da palavra e o cartão de compartilhar leem MockWordOfDay.today")
        }
    }

    func testTheWidgetSourcesIncludeTheLog() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let project = try String(contentsOf: root.appendingPathComponent("project.yml"), encoding: .utf8)
        XCTAssertTrue(project.contains("Sources/Models/WordOfDayLog.swift"), "o widget precisa ler a escolha do dia")
        let widget = try String(contentsOf: root.appendingPathComponent("Sources/WidgetExtension/WidgetContent.swift"), encoding: .utf8)
        XCTAssertTrue(widget.contains("MockWordOfDay.word(for: todayDateKey)"))
    }
}

/// The widget's day key (civil date), rebuilt here: WidgetContent is not in the app target.
private enum WidgetContentKey {
    static var today: String { DailyRoutineStore.dayKey(Date()) }
}
