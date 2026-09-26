import XCTest
@testable import Missale

/// The morning intention's verse: the pick sent to Jev (the whole Word of the
/// Day pool, described in English, within the server's limits), where the
/// answer is kept, the re-pick when the intention is edited, and the fallback
/// when Jev isn't asked or isn't sure. The network is a fake.
@MainActor
final class IntentionVerseTests: XCTestCase {
    private var defaults: UserDefaults!

    override func setUp() {
        defaults = UserDefaults(suiteName: "IntentionVerseTests")
        defaults.removePersistentDomain(forName: "IntentionVerseTests")
    }

    private func day(_ n: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: n, hour: 8))!
    }

    private var ptPick: JevPicker.Pick {
        IntentionVerse.pick(pool: MockWordOfDay.catalog[.pt], english: MockWordOfDay.catalog[.en])
    }

    /// Answers each choice with `wanted` when offered, else the first id.
    private final class FakeJev {
        var calls: [[String: [String: Any]]] = []
        var wanted = ""
        var probability = 0.9
        var risk = 0.0

        func decide(_ state: String, _ questions: [String: [String: Any]]) async throws -> [String: Any] {
            calls.append(questions)
            var answers: [String: Any] = [:]
            for (key, question) in questions {
                if question["type"] as? String == "noul" {
                    answers[key] = ["noul": risk]
                } else if let criteria = question["criteria"] as? [String: String] {
                    let choice = criteria[wanted] != nil ? wanted : criteria.keys.sorted()[0]
                    answers[key] = ["choice": choice, "probabilities": [choice: probability]]
                }
            }
            return answers
        }
    }

    private func resolve(_ text: String, on date: Date, _ store: DailyRoutineStore, _ fake: FakeJev,
                         enabled: Bool = true, subscribed: Bool = true) async {
        await IntentionVerse.resolve(text, on: date, store: store, pick: [ptPick]) { text, picks in
            await JevPicker.pick(from: text, picks, enabled: enabled, subscribed: subscribed, decide: fake.decide)
        }
    }

    // MARK: - The pick

    func testThePickOffersTheWholePoolDescribedInEnglish() {
        let pick = ptPick
        let pool = MockWordOfDay.catalog[.pt]
        XCTAssertEqual(pick.candidates.count, pool.count)
        XCTAssertEqual(pick.candidates.map(\.id), pool.map(\.id), "os ids devem ser os do acervo no idioma da pessoa")
        for candidate in pick.candidates {
            XCTAssertLessThan(candidate.description.unicodeScalars.count, 400)
            XCTAssertFalse(candidate.description.contains("Mateus"), "descrição em português: \(candidate.description)")
        }
        let first = pick.candidates.first { $0.id == "mateus-5-4-pt" }
        XCTAssertEqual(first?.description.hasPrefix("Matthew 5:4: Blessed are they that mourn"), true)
    }

    /// Every Portuguese and Spanish passage finds its English twin, so none
    /// is described to Jev in another language.
    func testEveryPassageHasAnEnglishTwin() {
        let english = Set(MockWordOfDay.catalog[.en].compactMap { IntentionVerse.signature($0.reference) })
        for language in [AppLanguage.pt, .es] {
            for word in MockWordOfDay.catalog[language] {
                let signature = IntentionVerse.signature(word.reference)
                XCTAssertNotNil(signature, word.reference)
                XCTAssertTrue(signature.map(english.contains) ?? false, "\(word.reference) sem par em inglês")
            }
        }
        XCTAssertEqual(IntentionVerse.signature("1 Coríntios 13, 4"), IntentionVerse.signature("1 Corinthians 13:4"))
        XCTAssertEqual(IntentionVerse.signature("Salmo 121, 1-2"), IntentionVerse.signature("Psalm 121:1-2"))
    }

    /// Ninety candidates cost two calls, each with the risk question, and the
    /// verse Jev chose is stored for the day.
    func testTheRequestStoresTheChosenVerse() async {
        let store = DailyRoutineStore(defaults: defaults)
        store.saveIntention("Pela cirurgia do meu pai", on: day(3))
        let fake = FakeJev()
        fake.wanted = "mateus-5-4-pt"

        await resolve("Pela cirurgia do meu pai", on: day(3), store, fake)

        XCTAssertEqual(fake.calls.count, 2)
        for call in fake.calls {
            XCTAssertEqual(call["risk"]?["type"] as? String, "noul", "chamada sem a pergunta de risco")
            XCTAssertLessThanOrEqual(call.count, 3)
        }
        XCTAssertEqual(store.intentionVerseID(on: day(3)), "mateus-5-4-pt")
        XCTAssertNil(store.intentionVerseID(on: day(4)), "o versículo é do dia, não de todos")
        XCTAssertFalse(store.showsCrisisForIntention(on: day(3)))
    }

    // MARK: - Storage

    func testTheVerseIsKeptPerDayAndRegisteredAsPersonalData() {
        XCTAssertTrue(LocalData.personalKeys.contains(DailyRoutineStore.intentionVersesKey),
                      "a chave nova precisa estar em LocalData, entre os dados pessoais")

        let store = DailyRoutineStore(defaults: defaults)
        store.saveIntention("Paciência", on: day(1))
        store.saveIntention("Paz em casa", on: day(2))
        store.recordIntentionVerse("mateus-5-9-pt", showCrisisFirst: false, for: "Paz em casa", on: day(2))
        store.recordIntentionVerse("mateus-5-5-pt", showCrisisFirst: false, for: "Paciência", on: day(1))

        let reopened = DailyRoutineStore(defaults: defaults)
        XCTAssertEqual(reopened.intentionVerseID(on: day(1)), "mateus-5-5-pt")
        XCTAssertEqual(reopened.intentionVerseID(on: day(2)), "mateus-5-9-pt")

        let export = String(decoding: LocalData.exportJSON(from: defaults), as: UTF8.self)
        XCTAssertTrue(export.contains("routine_intention_verses"), "a exportação não leva o versículo")

        LocalData.personalKeys.forEach(defaults.removeObject(forKey:))
        reopened.reload()
        XCTAssertNil(reopened.intentionVerseID(on: day(2)), "apagar os dados não levou o versículo")
    }

    /// No verse for a day without intention: an answer for a day whose text
    /// is gone, or changed, is dropped.
    func testAnAnswerForOtherWordsIsDropped() {
        let store = DailyRoutineStore(defaults: defaults)
        store.recordIntentionVerse("mateus-5-4-pt", showCrisisFirst: true, for: "Sem intenção", on: day(5))
        XCTAssertNil(store.intentionVerseID(on: day(5)))
        XCTAssertFalse(store.showsCrisisForIntention(on: day(5)))
    }

    // MARK: - Editing

    func testEditingTheIntentionDropsTheVerseAndPicksAgain() async {
        let store = DailyRoutineStore(defaults: defaults)
        let fake = FakeJev()
        XCTAssertTrue(store.saveIntention("Pela minha mãe", on: day(3)))
        fake.wanted = "mateus-5-4-pt"
        await resolve("Pela minha mãe", on: day(3), store, fake)
        XCTAssertEqual(store.intentionVerseID(on: day(3)), "mateus-5-4-pt")

        XCTAssertFalse(store.saveIntention("  Pela minha mãe ", on: day(3)), "o mesmo texto não é uma edição")
        XCTAssertEqual(store.intentionVerseID(on: day(3)), "mateus-5-4-pt")

        XCTAssertTrue(store.saveIntention("Coragem na entrevista", on: day(3)))
        XCTAssertNil(store.intentionVerseID(on: day(3)), "o versículo da intenção antiga ficou")

        // The late answer for the old words must not come back.
        store.recordIntentionVerse("mateus-5-4-pt", showCrisisFirst: false, for: "Pela minha mãe", on: day(3))
        XCTAssertNil(store.intentionVerseID(on: day(3)))

        fake.wanted = "mateus-6-34-pt"
        await resolve("Coragem na entrevista", on: day(3), store, fake)
        XCTAssertEqual(store.intentionVerseID(on: day(3)), "mateus-6-34-pt")
    }

    // MARK: - Fallback

    func testNothingIsSentOrStoredWhenJevIsOff() async {
        let store = DailyRoutineStore(defaults: defaults)
        store.saveIntention("Pela minha família", on: day(3))
        let fake = FakeJev()
        await resolve("Pela minha família", on: day(3), store, fake, enabled: false)
        await resolve("Pela minha família", on: day(3), store, fake, subscribed: false)
        XCTAssertTrue(fake.calls.isEmpty, "com a personalização desligada ou sem assinatura, nada vai ao Jev")
        XCTAssertNil(store.intentionVerseID(on: day(3)))
        XCTAssertFalse(store.showsCrisisForIntention(on: day(3)))
    }

    func testAnUnsureAnswerStoresNothingButKeepsTheRisk() async {
        let store = DailyRoutineStore(defaults: defaults)
        store.saveIntention("Não aguento mais", on: day(3))
        let fake = FakeJev()
        fake.probability = 0.05
        fake.risk = 0.9
        await resolve("Não aguento mais", on: day(3), store, fake)
        XCTAssertNil(store.intentionVerseID(on: day(3)), "sem confiança, nenhum versículo")
        XCTAssertTrue(store.showsCrisisForIntention(on: day(3)), "o sinal de risco se perdeu")

        store.saveIntention("Pela minha família", on: day(3))
        XCTAssertFalse(store.showsCrisisForIntention(on: day(3)), "o aviso ficou preso a outro texto")
    }
}
