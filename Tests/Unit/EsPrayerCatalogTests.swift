import XCTest
@testable import Missale

/// O lote oracoes-21-en-es (es) foi retirado do app: títulos em inglês e texto
/// sem fonte. Fica fora até a pesquisa reentregar o lote verificado.
final class EsPrayerCatalogTests: XCTestCase {
    private var esPrayers: [DevotionalPrayer] {
        MockDevotionalPrayers.esImportedPrayers.values.flatMap { $0 }
    }

    func testRetainedBatchIsNotInSpanishCatalog() {
        let retidos = [
            "memorare-es", "sub-tuum-praesidium-es", "prayer-of-trust-es", "suscipe-es",
            "prayer-of-st-thomas-more-es", "st-patrick-s-breastplate-es", "prayer-to-the-holy-cross-es",
            "prayer-to-st-raphael-es", "prayer-to-the-guardian-angel-es", "the-leonine-prayer-es",
            "act-of-contrition-es", "prayer-to-our-lady-of-lourdes-es", "prayer-to-the-sacred-heart-es",
            "prayer-of-st-augustine-es", "prayer-for-the-sick-es", "the-jesus-prayer-es",
            "come-holy-spirit-es", "nunc-dimittis-es", "te-deum-es",
        ]
        let ids = Set(esPrayers.map(\.id))
        XCTAssertEqual(ids.intersection(retidos), [], "oração retida voltou ao catálogo es")
    }

    func testSpanishCatalogIsOfficialPlusSaintMichael() {
        // 14 do Compêndio + a Oração a São Miguel Arcanjo (lote próprio, com fonte).
        let esperadas: Set<String> = [
            "padre-nuestro-es", "ave-mar-a-es", "el-ngelus-es", "reina-del-cielo-es", "salve-regina-es",
            "ngel-de-dios-es", "bajo-tu-protecci-n-es", "el-eterno-reposo-es", "se-al-de-la-cruz-es",
            "gloria-al-padre-es", "magnificat-es", "benedictus-es", "s-mbolo-de-los-ap-stoles-es",
            "credo-niceno-constantinopolitano-es",
            "san-miguel-arc-ngel-es",
        ]
        XCTAssertEqual(esPrayers.count, 15)
        XCTAssertEqual(Set(esPrayers.map(\.id)), esperadas)
    }

    func testSpanishMetadataHasNoEnglishMarkers() throws {
        let marker = try NSRegularExpression(
            pattern: #"\b(Prayer|The|of|to|for|St|Traditional|tradition)\b"#)
        for p in esPrayers {
            for (campo, texto) in [("title", p.title), ("attribution", p.attribution ?? ""), ("focus", p.focus)] {
                let range = NSRange(texto.startIndex..., in: texto)
                XCTAssertNil(marker.firstMatch(in: texto, range: range), "\(p.id).\(campo) tem inglês: \(texto)")
            }
        }
    }
}
