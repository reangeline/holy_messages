import XCTest
@testable import Missale

/// The orientação's local rules: the crisis phrases that work without the
/// network, and questions that fit what the Missale API accepts (the server
/// rejects oversized requests with 400, which would silently turn every
/// orientação into "choose below").
final class OrientationTests: XCTestCase {

    func testCrisisPhrasesCatchTheRiskSentencesFromTheSpike() {
        // The risk sentences of the laya-spike, including the one Jev missed.
        let risco = [
            "Não aguento mais viver, queria dormir e não acordar.",
            "Às vezes penso que minha família ficaria melhor sem mim.",
            "Estou pensando em acabar com tudo hoje.",
            "Já separei os remédios, só falta coragem.",
            "Me corto pra aliviar a dor por dentro.",
            "Não vejo saída, pensei em me matar.",
            "Escrevi cartas de despedida pra todo mundo.",
            "Queria sumir para sempre, desaparecer de vez.",
            "I don't want to live anymore",
            "Ya no quiero vivir",
            "PENSEI EM SUICÍDIO",
        ]
        for frase in risco {
            XCTAssertTrue(CrisisPhrases.matches(frase), "não reconheceu: \(frase)")
        }
    }

    func testCrisisPhrasesLeaveOrdinaryDaysAlone() {
        let comuns = [
            "Estou morto de cansaço depois do plantão.",
            "Esse trânsito me mata todo dia.",
            "Minha tia morreu de câncer ano passado e hoje lembrei dela.",
            "Meu pai faleceu semana passada e a casa ficou muito silenciosa.",
            "Tenho medo da morte quando penso no juízo final.",
            "Rezo o terço mas parece que as palavras batem no teto.",
        ]
        for frase in comuns {
            XCTAssertFalse(CrisisPhrases.matches(frase), "alarme falso: \(frase)")
        }
    }

    func testEveryMoodStateCanBeChosenByJev() {
        let estados = Set(MockMood.stateGroups.flatMap(\.items).map(\.id))
        XCTAssertEqual(Set(OrientationService.stateCriteria.keys), estados,
                       "os estados do Jev e os do check-in divergiram")
    }

    /// Mirrors the server's limits (missale-backend, core/domain/decision.go).
    func testQuestionsFitTheServerLimits() {
        XCTAssertLessThanOrEqual(OrientationService.stateCriteria.count, 32)
        for descricao in OrientationService.stateCriteria.values {
            XCTAssertLessThanOrEqual(descricao.count, 400)
        }
        for language in AppLanguage.allCases {
            for id in OrientationService.stateCriteria.keys {
                guard let variantes = MockMood.reliefVariants(for: id, language: language) else { continue }
                XCTAssertLessThanOrEqual(variantes.count, 32, "\(id)/\(language): respostas demais para uma pergunta")
            }
        }
    }

    // MARK: - The passage question

    private func grief(_ language: AppLanguage = .pt) throws -> (variants: [ReliefContent], pool: [WordOfDay], english: [WordOfDay]) {
        (try XCTUnwrap(MockMood.reliefVariants(for: "grief", language: language)),
         MockWordOfDay.catalog[language], MockWordOfDay.catalog[.en])
    }

    func testPassageCandidatesMixPsalmsAndTheStatesVerses() throws {
        let (variants, pool, english) = try grief()
        let found = try XCTUnwrap(OrientationService.passageCandidates(
            stateID: "grief", variants: variants, pool: pool, english: english))
        XCTAssertLessThanOrEqual(found.criteria.count, 32)
        XCTAssertTrue(found.criteria.keys.contains { $0.hasPrefix("p") })
        XCTAssertFalse(found.verses.isEmpty)
        let linked = Set(MockWordOfDay.moodStatesByEnglishReference.filter { $0.value.contains("grief") }
            .compactMap { IntentionVerse.signature($0.key) })
        for (key, text) in found.criteria {
            XCTAssertLessThanOrEqual(text.count, 400, key)
            guard key.hasPrefix("v") else { continue }
            let word = try XCTUnwrap(found.verses[String(key.dropFirst())], key)
            XCTAssertTrue(pool.contains { $0.id == word.id }, "id fora do idioma atual: \(key)")
            XCTAssertTrue(linked.contains(IntentionVerse.signature(word.reference) ?? ""), "versículo de outro estado: \(key)")
            // Described in English, though the id is the Portuguese one.
            XCTAssertTrue(text.hasPrefix(english.first { IntentionVerse.signature($0.reference) == IntentionVerse.signature(word.reference) }!.reference))
        }
        let psalms = found.criteria.keys.filter { $0.hasPrefix("p") }
        XCTAssertEqual(psalms.count, Set(variants.map(\.psalmRef)).count, "salmos duplicados")
    }

    func testPassageCandidatesCutVersesFirstAndNeedTwo() throws {
        let (variants, pool, english) = try grief()
        let many = (0..<32).map { _ in variants[0] }.enumerated().map { index, relief in
            ReliefContent(title: "t", psalmRef: "Salmo \(index + 1)", psalmText: "x", psalmWhy: "w",
                          saintName: "s", saintWhy: "w", stepTitle: "s", stepBody: "b")
        }
        let full = try XCTUnwrap(OrientationService.passageCandidates(stateID: "grief", variants: many, pool: pool, english: english))
        XCTAssertEqual(full.criteria.count, 32)
        XCTAssertTrue(full.verses.isEmpty)
        XCTAssertNil(OrientationService.passageCandidates(stateID: "grief", variants: [variants[0]], pool: [], english: []))
    }

    func testChosenVerseShowsTheVerseWithItsContext() throws {
        let (variants, pool, english) = try grief()
        let found = try XCTUnwrap(OrientationService.passageCandidates(stateID: "grief", variants: variants, pool: pool, english: english))
        let (id, word) = try XCTUnwrap(found.verses.first)
        let answer: [String: Any] = ["choice": "v\(id)", "probabilities": ["v\(id)": 0.6]]
        let shown = OrientationService.chosenPassage(from: answer, verses: found.verses, variants: variants, replyIndex: 1)
        XCTAssertEqual(shown, OrientationPassage(reference: word.reference, text: word.quote, why: word.context))
    }

    func testChosenPsalmShowsThatReflectionsPsalm() throws {
        let (variants, _, _) = try grief()
        let answer: [String: Any] = ["choice": "p3", "probabilities": ["p3": 0.5]]
        let shown = OrientationService.chosenPassage(from: answer, verses: [:], variants: variants, replyIndex: 1)
        XCTAssertEqual(shown, OrientationPassage(psalmOf: variants[3]))
    }

    func testLowMissingOrBrokenAnswerFallsBackToTheRepliesPsalm() throws {
        let (variants, pool, english) = try grief()
        let found = try XCTUnwrap(OrientationService.passageCandidates(stateID: "grief", variants: variants, pool: pool, english: english))
        let id = try XCTUnwrap(found.verses.keys.first)
        let fallback = OrientationPassage(psalmOf: variants[1])
        let answers: [[String: Any]?] = [
            ["choice": "v\(id)", "probabilities": ["v\(id)": 0.05]],
            ["choice": "v\(id)"],
            ["choice": "vnao-existe", "probabilities": ["vnao-existe": 0.9]],
            ["choice": "p99", "probabilities": ["p99": 0.9]],
            nil,
        ]
        for answer in answers {
            XCTAssertEqual(OrientationService.chosenPassage(from: answer, verses: found.verses, variants: variants, replyIndex: 1), fallback)
        }
    }
}
