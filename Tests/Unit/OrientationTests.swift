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
}
