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
