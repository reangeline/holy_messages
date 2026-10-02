import XCTest
@testable import Missale

/// The art batch delivered five Marian titles — Aparecida, Fátima, Graças,
/// Guadalupe, Lourdes — and the second research batch gave Aparecida, Lourdes
/// and Graças (Rue du Bac) their sourced records. Knock still has a record and
/// no picture. These tests keep any mismatch measurable instead of leaving
/// unused images in the bundle and a silent gap in the archive.
final class MarianApparitionArtTests: XCTestCase {

    func testEveryRecordExistsInAllThreeLanguages() {
        let ids = [AppLanguage.pt, .en, .es].map { language in
            Set(MockMarianApparitions.catalog[language].map(\.id))
        }
        XCTAssertEqual(Set(ids).count, 1, "os idiomas não têm as mesmas aparições")
        XCTAssertFalse(ids[0].isEmpty, "o acervo de aparições está vazio")
    }

    /// Art is mapped by record id, and every mapping must point at a record
    /// that exists — a mapping to a missing id would draw nothing and hide it.
    func testEveryMappedArtworkBelongsToARealRecord() {
        let ids = Set(MockMarianApparitions.all.map(\.id))
        for id in ids {
            guard let arte = MarianApparitionArt.artwork(forID: id) else { continue }
            XCTAssertFalse(arte.isEmpty, "\(id) mapeia para um nome de arte vazio")
        }
        // E o contrário: a arte declarada como sem ficha não deve ter virado
        // ficha sem que alguém atualizasse o mapa.
        for nome in MarianApparitionArt.semFicha {
            XCTAssertFalse(
                ids.contains(where: { MarianApparitionArt.artwork(forID: $0) == nome }),
                "\(nome) já tem ficha: mova-o para o mapa de arte e saia de `semFicha`"
            )
        }
    }

    /// The record that has no art must report none, so the UI draws the
    /// placeholder rather than borrowing another shrine's image.
    func testARecordWithoutArtReportsNone() {
        let semArte = MockMarianApparitions.all.filter { $0.artworkName == nil }
        XCTAssertEqual(semArte.map(\.id), ["knock-1879"],
                       "mudou quem está sem arte; confira o mapa em MarianApparitionArt")
    }

    /// Every record must name its source — this archive exists to be checkable.
    func testEveryRecordNamesASource() {
        for language in [AppLanguage.pt, .en, .es] {
            for apparition in MockMarianApparitions.catalog[language] {
                XCTAssertTrue(apparition.source.contains("http"),
                              "\(language)/\(apparition.id) não traz fonte consultável")
                XCTAssertFalse(apparition.ecclesialRecognition.isEmpty,
                               "\(language)/\(apparition.id) não diz como a Igreja recebeu")
            }
        }
    }
}

/// O hero da ficha precisa continuar compacto no telefone, mas não pode esticar
/// a mesma altura de 190 pt por toda a largura de um iPad e recortar a gravura.
final class SaintDetailHeroLayoutTests: XCTestCase {

    func testHeroAdaptsFromPhoneToIPadWithoutCroppingTheArtwork() {
        let phone = SaintDetailHeroLayout.frame(availableWidth: 350)
        XCTAssertEqual(phone.width, 350, accuracy: 0.01)
        XCTAssertEqual(phone.height, 190, accuracy: 0.01)

        let portraitIPad = SaintDetailHeroLayout.frame(availableWidth: 992)
        XCTAssertEqual(portraitIPad.width, 760, accuracy: 0.01)
        XCTAssertEqual(portraitIPad.height, 760 / (1206.0 / 648.0), accuracy: 0.01)

        let landscapeIPad = SaintDetailHeroLayout.frame(availableWidth: 1326)
        XCTAssertEqual(landscapeIPad, portraitIPad)
        // Fill: same result as fit for the bundled 1206:648 art, and a square
        // upload covers the band instead of sitting small in the middle.
        XCTAssertEqual(SaintDetailHeroLayout.artworkContentMode, .fill)
    }
}

/// O arquivo de santos lista um registro por linha; com o id só de região e
/// data, os vários santos de um mesmo dia viravam cópias do primeiro.
final class SaintArchiveIdentityTests: XCTestCase {

    func testSaintsSharingADateHaveDistinctRowIDs() {
        func saint(_ id: String) -> Saint {
            Saint(id: id, name: id, lifespan: "", role: "", rank: "", calendarNote: "",
                  bioParagraphs: [], whyItMattersToday: "", prayer: "")
        }
        let dia = ["paulo-da-cruz", "isaac-jogues", "joao-lalande", "jerzy-popieluszko"]
            .map { SaintOfDay(dateKey: "10-19", region: .general, saint: saint($0)) }
        XCTAssertEqual(Set(dia.map(\.id)).count, dia.count)
    }

    func testTheShippedArchiveHasNoRepeatedRowIDs() {
        let ids = MockSaints.archive.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }
}

/// Santos e aparições têm duas imagens enviadas pelo painel: a larga, para o
/// topo da ficha, e a quadrada, para as miniaturas. Cada lugar prefere a sua,
/// depois a outra, depois a arte embutida.
final class ArtworkChoiceTests: XCTestCase {

    func testEachPlacePrefersItsOwnShape() {
        XCTAssertEqual(ArtworkChoice.thumbnail(square: "q", wide: "l", bundled: "e"), "q")
        XCTAssertEqual(ArtworkChoice.hero(square: "q", wide: "l", bundled: "e"), "l")
    }

    func testEachPlaceFallsBackToTheOtherUploadThenToTheBundledArt() {
        XCTAssertEqual(ArtworkChoice.thumbnail(square: nil, wide: "l", bundled: "e"), "l")
        XCTAssertEqual(ArtworkChoice.hero(square: "q", wide: nil, bundled: "e"), "q")
        XCTAssertEqual(ArtworkChoice.thumbnail(square: nil, wide: nil, bundled: "e"), "e")
        XCTAssertEqual(ArtworkChoice.hero(square: nil, wide: nil, bundled: "e"), "e")
        XCTAssertNil(ArtworkChoice.hero(square: nil, wide: nil, bundled: ""))
        XCTAssertNil(ArtworkChoice.thumbnail(square: nil, wide: nil, bundled: nil))
    }

    /// O painel publica os dois campos, às vezes vazios; uma aparição sem
    /// imagem enviada continua com a arte embutida, e a 2.0 ignorava os campos.
    func testAnApparitionDecodesBothUploadsAndKeepsItsBundledArtWithoutThem() throws {
        let json = #"{"id":"fatima-1917","name":"N","place":"P","year":"1917","visionaries":"V","summary":"S","ecclesialRecognition":"R","source":"https://x","artworkURL":"","wideArtworkURL":"https://cdn/images/a.jpg"}"#
        let apparition = try JSONDecoder().decode(MarianApparition.self, from: Data(json.utf8))
        XCTAssertEqual(apparition.wideArtworkURL, "https://cdn/images/a.jpg")
        // A imagem não foi baixada neste teste: fica a embutida.
        XCTAssertEqual(apparition.artworkName, "fatima")
        XCTAssertEqual(apparition.heroArtworkName, "fatima")
    }

    func testAPublishedSaintDecodesTheWideUpload() throws {
        let json = #"{"id":"x","dateKey":"01-01","name":"N","lifespan":"","role":"R","rank":"Memória","calendarNote":"C","bioParagraphs":["b"],"whyItMattersToday":"w","prayer":"p","artworkName":"notburga","artworkURL":"","wideArtworkURL":"https://cdn/images/w.jpg"}"#
        let saint = try JSONDecoder().decode(PublishedSaint.self, from: Data(json.utf8)).saintOfDay.saint
        XCTAssertEqual(saint.artworkName, "notburga")
        XCTAssertEqual(saint.heroArtworkName, "notburga")
    }
}
