import XCTest
@testable import Missale

/// JevPicker's call planning against the server's limits (missale-backend,
/// core/domain/decision.go), its fallbacks, and the Rosary's use of it. The
/// network is a recording fake: these tests never reach the API.
final class JevPickerTests: XCTestCase {

    /// Records every call and answers each choice question with `wanted` when
    /// it is among the criteria, else the first criterion alphabetically.
    private final class FakeJev {
        var calls: [(state: String, questions: [String: [String: Any]])] = []
        var wanted: Set<String> = []
        var probability = 0.9
        var risk = 0.0
        var fails = false

        func decide(_ state: String, _ questions: [String: [String: Any]]) async throws -> [String: Any] {
            calls.append((state, questions))
            if fails { throw MissaleAPI.Failure.unavailable }
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

    private func pick(_ key: String, _ count: Int, description: (Int) -> String = { "item \($0)" }) -> JevPicker.Pick {
        JevPicker.Pick(key: key, instructions: "Which one?",
                       candidates: (0..<count).map { .init(id: "\(key)\($0)", description: description($0)) })
    }

    private func run(_ text: String, _ picks: [JevPicker.Pick], _ fake: FakeJev,
                     enabled: Bool = true, subscribed: Bool = true) async -> JevPicker.Result? {
        await JevPicker.pick(from: text, picks, enabled: enabled, subscribed: subscribed, decide: fake.decide)
    }

    /// Every call the fake saw must pass the server's validation, and carry the
    /// risk question.
    private func assertWithinLimits(_ fake: FakeJev, file: StaticString = #filePath, line: UInt = #line) {
        for call in fake.calls {
            XCTAssertLessThanOrEqual(call.questions.count, 3, "perguntas demais numa chamada", file: file, line: line)
            XCTAssertEqual((call.questions["risk"])?["type"] as? String, "noul", "chamada sem a pergunta de risco", file: file, line: line)
            XCTAssertLessThanOrEqual(call.state.unicodeScalars.count, 2000, file: file, line: line)
            for question in call.questions.values {
                XCTAssertLessThanOrEqual((question["instructions"] as? String ?? "").unicodeScalars.count, 300, file: file, line: line)
                guard let criteria = question["criteria"] as? [String: String] else { continue }
                XCTAssertTrue((2...32).contains(criteria.count), "\(criteria.count) critérios", file: file, line: line)
                for text in criteria.values {
                    XCTAssertFalse(text.isEmpty, file: file, line: line)
                    XCTAssertLessThanOrEqual(text.unicodeScalars.count, 400, file: file, line: line)
                }
            }
        }
    }

    // MARK: - Planning

    func testSmallPicksShareOneCall() {
        let plan = JevPicker.plan([4, 20])
        XCTAssertEqual(plan.count, 1)
        XCTAssertEqual(plan[0].count, 1, "risco + conjunto + mistério cabem numa chamada")
        XCTAssertEqual(plan[0][0].count, 2)
    }

    func testSixtyFiveCandidatesAreChunkedIntoTwoCalls() {
        let plan = JevPicker.plan([65])
        XCTAssertEqual(plan.count, 2, "uma rodada de blocos e uma final")
        XCTAssertEqual(plan[0].map(\.count), [2])
        XCTAssertEqual(plan[0][0].map(\.kind), [.chunk(0..<22), .chunk(22..<44)])
        XCTAssertEqual(plan[1][0].map(\.kind), [.final(leftover: 44..<65)])
    }

    /// For every size up to 96, alone and next to other picks: at most two
    /// picks besides the risk per call, every candidate reaches exactly one
    /// question, and the final fits in 32.
    func testEveryPlanStaysWithinTheLimits() {
        for n in 2...96 {
            for others in [[], [4], [4, 20], [40]] {
                let counts = [n] + others
                let plan = JevPicker.plan(counts)
                XCTAssertLessThanOrEqual(plan.count, 2)
                for call in plan.flatMap({ $0 }) {
                    XCTAssertLessThanOrEqual(call.count, JevPicker.picksPerCall, "n=\(n) \(others)")
                }
                for (index, count) in counts.enumerated() {
                    let slots = plan.flatMap { $0.flatMap { $0 } }.filter { $0.pick == index }
                    var covered: [Int] = []
                    var chunks = 0
                    var sawFinal = false
                    for slot in slots {
                        switch slot.kind {
                        case .direct: covered += Array(0..<count)
                        case .chunk(let range):
                            XCTAssertLessThanOrEqual(range.count, 32, "n=\(count)")
                            covered += Array(range); chunks += 1
                        case .final(let leftover):
                            covered += Array(leftover); sawFinal = true
                            XCTAssertLessThanOrEqual(leftover.count + chunks, 32, "final grande demais para n=\(count)")
                        }
                    }
                    XCTAssertEqual(covered.sorted(), Array(0..<count), "n=\(count): candidatos perdidos ou repetidos")
                    XCTAssertEqual(sawFinal, count > 32)
                }
            }
        }
    }

    // MARK: - Calls

    func testAChunkedPickReachesTheRightWinnerWithinTheLimits() async {
        let fake = FakeJev()
        fake.wanted = ["saint50", "set2"]
        let result = await run("Minha mãe está doente", [pick("saint", 65), pick("set", 4)], fake)
        XCTAssertEqual(result?["saint"], "saint50", "o vencedor da sobra precisa chegar à final")
        XCTAssertEqual(result?["set"], "set2")
        XCTAssertEqual(fake.calls.count, 2, "65 + 4 candidatos cabem em duas chamadas")
        assertWithinLimits(fake)
    }

    func testThreeChunksForNinetySix() async {
        let fake = FakeJev()
        fake.wanted = ["s90"]
        let result = await run("texto", [pick("s", 96)], fake)
        XCTAssertEqual(result?["s"], "s90")
        XCTAssertEqual(fake.calls.count, 3, "três blocos (duas chamadas) e a final")
        assertWithinLimits(fake)
    }

    func testTextAndDescriptionsAreTrimmedToTheServerLimits() async {
        let fake = FakeJev()
        let long = String(repeating: "é", count: 3000)
        // Accents as combining marks: Swift counts one character, the server two.
        let decomposed = String(repeating: "e\u{301}", count: 300)
        _ = await run(long, [pick("p", 3, description: { $0 == 0 ? decomposed : String(repeating: "x", count: 500) })], fake)
        XCTAssertEqual(fake.calls.first?.state.unicodeScalars.count, 2000)
        assertWithinLimits(fake)
    }

    func testLowConfidenceFallsBack() async {
        let fake = FakeJev()
        fake.probability = 0.2
        var loose = pick("b", 20)
        loose.minimumConfidence = 0.1
        let result = await run("texto", [pick("a", 4), loose], fake)
        XCTAssertNotNil(result)
        XCTAssertNil(result?["a"], "abaixo da confiança mínima, quem chama volta ao comportamento de antes")
        XCTAssertEqual(result?["b"], "b0")
    }

    func testOffUnsubscribedOrEmptyMakesNoCall() async {
        let fake = FakeJev()
        let off = await run("texto", [pick("a", 4)], fake, enabled: false)
        let unsubscribed = await run("texto", [pick("a", 4)], fake, subscribed: false)
        let empty = await run("   \n", [pick("a", 4)], fake)
        XCTAssertNil(off)
        XCTAssertNil(unsubscribed)
        XCTAssertNil(empty)
        XCTAssertTrue(fake.calls.isEmpty, "nada pode sair do aparelho nesses casos")
    }

    func testRiskFromJevOrFromThePhrasesEvenOffline() async {
        let fake = FakeJev()
        fake.risk = 0.5
        let fromJev = await run("Rezo pela minha família", [pick("a", 4)], fake)
        XCTAssertEqual(fromJev?.showCrisisFirst, true)
        XCTAssertEqual(fromJev?.answered, true, "a chamada foi respondida")

        let offline = FakeJev()
        offline.fails = true
        let fromPhrase = await run("Não quero mais viver", [pick("a", 4)], offline)
        XCTAssertEqual(fromPhrase, JevPicker.Result(choices: [:], showCrisisFirst: true, answered: false),
                       "sem rede: nenhuma escolha, mas a frase de risco ainda abre a orientação de crise")

        let calm = FakeJev()
        let ordinary = await run("Rezo pela minha família", [pick("a", 4)], calm)
        XCTAssertEqual(ordinary?.showCrisisFirst, false)
    }

    func testPersonalizationIsOnByDefault() {
        let defaults = UserDefaults.standard
        let saved = defaults.object(forKey: JevPicker.storageKey)
        defer { defaults.set(saved, forKey: JevPicker.storageKey) }
        defaults.removeObject(forKey: JevPicker.storageKey)
        XCTAssertTrue(JevPicker.isEnabled)
        defaults.set(false, forKey: JevPicker.storageKey)
        XCTAssertFalse(JevPicker.isEnabled)
    }

    // MARK: - Rosary

    func testTheRosarySuggestionIsOneCall() async {
        XCTAssertEqual(RosarySuggestion.mysteryCandidates.count, 20)
        XCTAssertEqual(Set(RosarySuggestion.mysteryCandidates.map(\.id)).count, 20)
        let fake = FakeJev()
        fake.wanted = ["sorrowful", "sorrowful.0"]
        let result = await run("Pela cirurgia do meu pai amanhã", RosarySuggestion.picks, fake)
        XCTAssertEqual(fake.calls.count, 1, "risco + conjunto + mistério numa chamada só")
        assertWithinLimits(fake)
        XCTAssertEqual(result.flatMap(RosarySuggestion.from), RosarySuggestion(mysterySet: .sorrowful, decadeIndex: 0))
    }

    func testWhenSetAndMysteryDisagreeTheSetWins() {
        let disagree = JevPicker.Result(choices: ["set": "joyful", "mystery": "sorrowful.0"], showCrisisFirst: false)
        XCTAssertEqual(RosarySuggestion.from(disagree), RosarySuggestion(mysterySet: .joyful, decadeIndex: nil))
        let onlyMystery = JevPicker.Result(choices: ["mystery": "glorious.3"], showCrisisFirst: false)
        XCTAssertEqual(RosarySuggestion.from(onlyMystery), RosarySuggestion(mysterySet: .glorious, decadeIndex: 3))
        XCTAssertNil(RosarySuggestion.from(JevPicker.Result(choices: [:], showCrisisFirst: true)))
    }
}
