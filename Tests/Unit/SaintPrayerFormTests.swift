import XCTest
@testable import Missale

/// Every saint's prayer in the acervo is the invocation of the Litany of
/// Saints — "N., rogai por nós" / "pray for us" / "ruega por nosotros" — taken
/// from a published form rather than composed here. The Roman Missal
/// rubricates adding saints' names to the Litany at the Easter Vigil (no. 43),
/// which is what makes the insertion legitimate.
///
/// Notburga and John Gabriel Perboyre, the two records written by hand before
/// the imported sanctoral, carried our own Portuguese compositions instead
/// ("Deus, que ensinastes a vossa serva Notburga a repartir o pouco que
/// tinha…"). This test is what keeps an authored prayer from coming back.
final class SaintPrayerFormTests: XCTestCase {

    /// The invocation ends with the litany's response, per language.
    /// Em espanhol a resposta muda no plural ("Santos Pedro y Pablo, rueguen
    /// por nosotros"), o que o português e o inglês não distinguem.
    private let respostas: [AppLanguage: [String]] = [
        .pt: ["rogai por nós", "rogai por nós."],
        .en: ["pray for us", "pray for us."],
        .es: ["ruega por nosotros", "ruega por nosotros.",
              "rueguen por nosotros", "rueguen por nosotros."],
    ]

    /// The per-language sanctoral carries every record the app can show —
    /// the two hand-written ones and the 35 imported.
    private func todos(_ language: AppLanguage) -> [Saint] {
        MockSaints.catalog[language].map(\.saint)
    }

    func testEveryPrayerIsTheLitanyInvocation() {
        for (language, terminacoes) in respostas {
            for saint in todos(language) {
                let oracao = saint.prayer.trimmingCharacters(in: .whitespacesAndNewlines)
                XCTAssertTrue(
                    terminacoes.contains(where: { oracao.hasSuffix($0) }),
                    "\(language)/\(saint.id): a oração não é a invocação da Ladainha — \(oracao)"
                )
            }
        }
    }

    /// An authored prayer is long and addresses God directly; the invocation is
    /// short and addresses the saint. Length alone separates the two.
    func testNoPrayerReadsAsAnAuthoredComposition() {
        for language in respostas.keys {
            for saint in todos(language) {
                XCTAssertLessThanOrEqual(
                    saint.prayer.split(separator: " ").count, 9,
                    "\(language)/\(saint.id): oração longa demais para uma invocação — provavelmente autoral"
                )
                XCTAssertFalse(
                    saint.prayer.contains("Amém") || saint.prayer.contains("Amen") || saint.prayer.contains("Amén"),
                    "\(language)/\(saint.id): a invocação da Ladainha não termina em Amém"
                )
            }
        }
    }

    /// And the invocation names the saint, so it can't be a generic line. The
    /// record's name can carry a place the invocation drops ("Santa Notburga de
    /// Eben" is invoked as "Santa Notburga"), so it is enough that one
    /// substantial word of the name appears.
    func testEachInvocationNamesItsSaint() {
        let semInformacao: Set<String> = [
            "Santa", "Santo", "Santos", "São", "Saint", "Saints", "St", "San",
            "Sant", "Blessed", "Beato", "Beata", "de", "da", "do", "of", "del",
            "the", "and", "y", "e",
        ]
        for language in respostas.keys {
            for saint in todos(language) {
                let nomes = saint.name
                    .split(whereSeparator: { " ,·".contains($0) })
                    .map(String.init)
                    .filter { $0.count > 2 && !semInformacao.contains($0) }
                XCTAssertFalse(nomes.isEmpty, "\(saint.id): nome sem nenhuma palavra própria")
                XCTAssertTrue(
                    nomes.contains(where: { saint.prayer.contains($0) }),
                    "\(language)/\(saint.id): a invocação não nomeia o santo — \(saint.prayer)"
                )
            }
        }
    }
}
