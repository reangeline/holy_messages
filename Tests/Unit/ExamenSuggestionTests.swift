import XCTest
@testable import Missale

/// The Examen's saint and prayer from Jev (ExamenSuggestion): what is asked,
/// that it stays within two calls, the fallbacks, and that entries stored
/// before the new fields still load. The network is a recording fake.
@MainActor
final class ExamenSuggestionTests: XCTestCase {

    private final class FakeJev {
        var calls: [[String: [String: Any]]] = []
        var states: [String] = []
        var wanted: Set<String> = []
        var probability = 0.9
        var risk = 0.0

        func decide(_ state: String, _ questions: [String: [String: Any]]) async throws -> [String: Any] {
            calls.append(questions)
            states.append(state)
            var answers: [String: Any] = [:]
            for (key, question) in questions {
                if question["type"] as? String == "noul" {
                    answers[key] = ["noul": risk]
                } else if let criteria = question["criteria"] as? [String: String] {
                    let choice = criteria.keys.first(where: wanted.contains) ?? criteria.keys.sorted()[0]
                    answers[key] = ["choice": choice, "probabilities": [choice: probability]]
                }
            }
            return answers
        }
    }

    private let entry = ExamenEntry(gratitude: "My sister called.", lightRequest: "",
                                    review: "I lost patience with my mother, who is ill.",
                                    response: "Tomorrow I will visit her.")

    private func run(_ fake: FakeJev, entry: ExamenEntry? = nil,
                     enabled: Bool = true, subscribed: Bool = true) async -> JevPicker.Result? {
        await JevPicker.pick(from: ExamenSuggestion.text(of: entry ?? self.entry), ExamenSuggestion.picks,
                             enabled: enabled, subscribed: subscribed, decide: fake.decide)
    }

    func testTheAnswersAreJoinedWithoutTheEmptyOnes() {
        XCTAssertEqual(ExamenSuggestion.text(of: entry),
                       "My sister called.\n\nI lost patience with my mother, who is ill.\n\nTomorrow I will visit her.")
    }

    /// A saint from every saint the app can open, a prayer from every
    /// devotional prayer — each id resolving to a record that can be shown.
    func testThePicksCoverTheSaintsAndThePrayers() {
        let picks = ExamenSuggestion.picks
        XCTAssertEqual(picks.map(\.key), ["saint", "prayer"])

        let saints = ExamenSuggestion.saintCandidates
        XCTAssertGreaterThan(saints.count, 32, "o acervo de santos devia pedir rodadas")
        XCTAssertEqual(Set(saints.map(\.id)).count, saints.count, "santo repetido")
        for candidate in saints {
            XCTAssertNotNil(ExamenSuggestion(saintID: candidate.id, prayerID: nil).saint, candidate.id)
            XCTAssertFalse(candidate.description.isEmpty)
        }

        let prayers = ExamenSuggestion.prayerCandidates
        XCTAssertGreaterThanOrEqual(prayers.count, 2)
        XCTAssertLessThanOrEqual(prayers.count, JevPicker.maxCriteria, "as orações cabem numa pergunta só")
        for candidate in prayers {
            XCTAssertNotNil(ExamenSuggestion(saintID: nil, prayerID: candidate.id).prayer, candidate.id)
        }
    }

    /// Jev reads English best: the saints are described from the English
    /// record, whatever language the app is in.
    func testSaintsAreDescribedInEnglish() {
        let records = RemoteContent.items("saints", language: .en, as: PublishedSaint.self)?.map(\.saintOfDay)
            ?? MockSaints.catalog[.en]
        let english = Dictionary(records.map { ($0.saint.id, $0.saint) }, uniquingKeysWith: { a, _ in a })
        let described = ExamenSuggestion.saintCandidates.filter { english[$0.id] != nil }
        XCTAssertFalse(described.isEmpty)
        for candidate in described {
            XCTAssertTrue(candidate.description.hasPrefix(english[candidate.id]!.name), candidate.description)
        }
    }

    func testBothPicksComeBackInTwoCallsWithinTheLimits() async {
        let saint = ExamenSuggestion.saintCandidates.last!.id
        let prayer = ExamenSuggestion.prayerCandidates.last!.id
        let fake = FakeJev()
        fake.wanted = [saint, prayer]

        let result = await run(fake)

        XCTAssertEqual(fake.calls.count, 2, "o Exame devia custar duas chamadas")
        for call in fake.calls {
            XCTAssertLessThanOrEqual(call.count, 3)
            XCTAssertEqual(call["risk"]?["type"] as? String, "noul", "chamada sem a pergunta de risco")
            for question in call.values {
                guard let criteria = question["criteria"] as? [String: String] else { continue }
                XCTAssertTrue((2...32).contains(criteria.count))
                XCTAssertTrue(criteria.values.allSatisfy { $0.unicodeScalars.count <= 400 })
            }
        }
        XCTAssertTrue(fake.states.allSatisfy { $0 == ExamenSuggestion.text(of: entry) })

        let suggestion = result.flatMap(ExamenSuggestion.from)
        XCTAssertEqual(suggestion, ExamenSuggestion(saintID: saint, prayerID: prayer))
        XCTAssertEqual(result?.showCrisisFirst, false)
    }

    func testARiskSignIsCarried() async {
        let fake = FakeJev()
        fake.risk = 0.9
        let result = await run(fake)
        XCTAssertEqual(result?.showCrisisFirst, true)
    }

    /// Off, unsubscribed, or nothing written: nothing is sent, and the Examen
    /// closes as it always did.
    func testFallsBackWithoutSendingAnything() async {
        let fake = FakeJev()
        let off = await run(fake, enabled: false)
        let unsubscribed = await run(fake, subscribed: false)
        let empty = await run(fake, entry: ExamenEntry(gratitude: " ", lightRequest: "", review: "\n", response: ""))
        XCTAssertNil(off)
        XCTAssertNil(unsubscribed)
        XCTAssertNil(empty)
        XCTAssertTrue(fake.calls.isEmpty)
    }

    /// Not confident: no suggestion, so no card and nothing stored.
    func testUnsureShowsNothing() async {
        let fake = FakeJev()
        fake.probability = 0.1
        let result = await run(fake)
        XCTAssertNotNil(result)
        XCTAssertNil(result.flatMap(ExamenSuggestion.from))
    }

    func testOnlyTheConfidentPickIsKept() {
        let onlyPrayer = ExamenSuggestion.from(.init(choices: ["prayer": "p"], showCrisisFirst: false))
        XCTAssertEqual(onlyPrayer, ExamenSuggestion(saintID: nil, prayerID: "p"))
        XCTAssertNil(ExamenSuggestion.from(.init(choices: [:], showCrisisFirst: true)))
    }

    /// Entries stored before the saint and prayer existed must still load.
    func testOldEntriesStillDecode() throws {
        let old = """
        [{"id":"6F9619FF-8B86-D011-B42D-00CF4FC964FF","date":780000000,"gratitude":"a","lightRequest":"b","review":"c","response":"d"}]
        """
        let entries = try JSONDecoder().decode([ExamenEntry].self, from: Data(old.utf8))
        XCTAssertEqual(entries.first?.review, "c")
        XCTAssertNil(entries.first?.saintID)
        XCTAssertNil(entries.first?.suggestion)

        var entry = entries[0]
        entry.saintID = "notburga"
        let again = try JSONDecoder().decode(ExamenEntry.self, from: JSONEncoder().encode(entry))
        XCTAssertEqual(again.suggestion, ExamenSuggestion(saintID: "notburga", prayerID: nil))
    }

    func testTheListUpdatesOneEntryAndKeepsIt() {
        let key = "examen_suggestion_test_\(UUID().uuidString)"
        defer { UserDefaults.standard.removeObject(forKey: key) }
        let list = PersistedList<ExamenEntry>(storageKey: key)
        list.append(entry)
        list.update(where: { $0.id == entry.id }) { $0.prayerID = "p" }
        XCTAssertEqual(PersistedList<ExamenEntry>(storageKey: key).items.first?.prayerID, "p")
    }
}
