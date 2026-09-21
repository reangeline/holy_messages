import XCTest
@testable import Missale

/// Compline's texts were hardcoded in the view, in Portuguese, using the
/// CNBB's licensed Liturgia das Horas wording — and an English or Spanish
/// reader got that same Portuguese. Each language now quotes a public-domain
/// edition of its own.
final class ComplineTextTests: XCTestCase {

    private let idiomas: [AppLanguage] = [.pt, .en, .es]

    private func texto(_ language: AppLanguage) -> ComplineText {
        MockCompline.catalog[language]
    }

    func testEveryLanguageHasItsOwnCatalog() {
        for language in idiomas {
            XCTAssertTrue(
                MockCompline.catalog.hasOwnCatalog(for: language),
                "\(language) cairia no português"
            )
        }
    }

    func testNoFieldIsEmpty() {
        for language in idiomas {
            let t = texto(language)
            for (campo, valor) in [("opening", t.opening), ("invitatory", t.invitatory),
                                   ("gloryBe", t.gloryBe), ("psalmLabel", t.psalmLabel),
                                   ("psalmText", t.psalmText), ("source", t.source),
                                   ("note", t.note)] {
                XCTAssertFalse(valor.trimmingCharacters(in: .whitespaces).isEmpty,
                               "\(language)/\(campo) está vazio")
            }
        }
    }

    /// No two languages may share a text: that is what a silent fallback to
    /// Portuguese looks like from the outside.
    func testNoTextIsSharedBetweenLanguages() {
        let campos: [(String, (ComplineText) -> String)] = [
            ("opening", \.opening), ("invitatory", \.invitatory), ("gloryBe", \.gloryBe),
            ("psalmText", \.psalmText), ("source", \.source), ("note", \.note),
        ]
        for (nome, ler) in campos {
            let valores = idiomas.map { ler(texto($0)) }
            XCTAssertEqual(Set(valores).count, valores.count,
                           "\(nome) repetido entre idiomas — algum caiu no português")
        }
    }

    /// The editions are named on the screen, so the reader knows what they read.
    func testEachSourceNamesItsEdition() {
        XCTAssertTrue(texto(.pt).source.contains("Matos Soares"))
        XCTAssertTrue(texto(.en).source.contains("Douay-Rheims"))
        XCTAssertTrue(texto(.es).source.contains("Torres Amat"))
        // A edição espanhola é um fac-símile: a página fica registrada.
        XCTAssertTrue(texto(.es).source.contains("fac-símile"))
    }

    /// The doxology is a fixed formula and the app must carry one wording of
    /// it, so Compline quotes exactly what the prayer catalog already has.
    func testTheDoxologyMatchesThePrayerCatalog() {
        for language in idiomas {
            let noAcervo = MockDevotionalPrayers.catalog[language]
                .flatMap(\.prayers)
                .first { $0.fullText.hasPrefix("Glória ao Pai") || $0.fullText.hasPrefix("Glory be to the Father") || $0.fullText.hasPrefix("Gloria al Padre") }
            guard let noAcervo else {
                return XCTFail("\(language): a doxologia não está no acervo de orações")
            }
            XCTAssertEqual(
                texto(language).gloryBe, noAcervo.fullText,
                "\(language): a doxologia das Completas divergiu do acervo de orações"
            )
        }
    }

    /// The note must not promise the complete office, which this screen is not.
    func testTheNoteDoesNotPromiseTheFullOffice() {
        XCTAssertFalse(texto(.pt).note.contains("Texto completo"))
        XCTAssertFalse(texto(.en).note.lowercased().contains("full text"))
        XCTAssertFalse(texto(.es).note.lowercased().contains("texto íntegro"))
    }

    /// The psalm is displayed in Hebrew numbering, as everywhere else in the
    /// app, while the source records the Vulgate number the editions print —
    /// in Arabic figures in Matos Soares and Douay-Rheims, in Roman numerals
    /// in Torres Amat, which is how the 1836 facsimile prints it.
    func testThePsalmIsLabelledInHebrewNumbering() {
        for language in idiomas {
            XCTAssertTrue(texto(language).psalmLabel.contains("91"),
                          "\(language): o rótulo não usa a numeração hebraica")
        }
        XCTAssertTrue(texto(.pt).source.contains("90,1-2"))
        XCTAssertTrue(texto(.en).source.contains("90:1-2"))
        XCTAssertTrue(texto(.es).source.contains("Salmo XC, 1-2"))
    }
}
