import XCTest
@testable import Missale

/// Writes the content bundled in the app as the JSON the admin page stores
/// (`content-seed/<collection>/<lang>.json`), to seed the backend. Runs only
/// when asked:
///
///     TEST_RUNNER_EXPORT_CONTENT=1 xcodebuild test -only-testing:MissaleTests/ContentSeedExport …
///
/// Encoding the app's own structs is the point: the published files decode
/// back into exactly these types.
final class ContentSeedExport: XCTestCase {

    private var destino: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("content-seed")
    }

    func testExportBundledContent() throws {
        try XCTSkipUnless(ProcessInfo.processInfo.environment["EXPORT_CONTENT"] == "1", "exportação só quando pedida")
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        for language in AppLanguage.allCases where MockMarianApparitions.catalog.hasOwnCatalog(for: language) {
            let pasta = destino.appendingPathComponent("apparitions")
            try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
            try encoder.encode(MockMarianApparitions.catalog[language])
                .write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
        }
        for language in AppLanguage.allCases where MockDevotionalPrayers.catalog.hasOwnCatalog(for: language) {
            let categorias = MockDevotionalPrayers.catalog[language]
            for (nome, valor) in [
                ("prayer_categories", try encoder.encode(categorias.map { PublishedPrayerCategory(id: $0.id, title: $0.title) })),
                ("prayers", try encoder.encode(categorias.flatMap { c in c.prayers.map { PublishedPrayer($0, categoryID: c.id) } })),
            ] {
                let pasta = destino.appendingPathComponent(nome)
                try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
                try valor.write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
            }
        }
        for language in AppLanguage.allCases where MockFormation.trackCatalog.hasOwnCatalog(for: language) {
            let tracks = [MockFormation.trackCatalog[language]] + MockFormation.otherTracksCatalog[language]
            for (nome, valor) in [
                ("formation_tracks", try encoder.encode(tracks.map { PublishedFormationTrack(id: $0.id, title: $0.title, meta: $0.meta) })),
                ("formation_lessons", try encoder.encode(tracks.flatMap(\.lessons).map(PublishedFormationLesson.init))),
            ] {
                let pasta = destino.appendingPathComponent(nome)
                try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
                try valor.write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
            }
        }
        for language in AppLanguage.allCases where MockMood.reliefCatalog.hasOwnCatalog(for: language) {
            let pasta = destino.appendingPathComponent("mood_reliefs")
            try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
            try encoder.encode(PublishedRelief.flatten(MockMood.reliefCatalog[language]))
                .write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
        }
        for language in AppLanguage.allCases where MockSaints.catalog.hasOwnCatalog(for: language) {
            let pasta = destino.appendingPathComponent("saints")
            try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
            try encoder.encode(MockSaints.catalog[language].map(PublishedSaint.init))
                .write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
        }
        for language in AppLanguage.allCases where MockWordOfDay.catalog.hasOwnCatalog(for: language) {
            let pasta = destino.appendingPathComponent("word_of_day")
            try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
            try encoder.encode(MockWordOfDay.catalog[language])
                .write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
        }
    }
}
