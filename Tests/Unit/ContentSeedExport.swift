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
        for language in AppLanguage.allCases where MockWordOfDay.catalog.hasOwnCatalog(for: language) {
            let pasta = destino.appendingPathComponent("word_of_day")
            try FileManager.default.createDirectory(at: pasta, withIntermediateDirectories: true)
            try encoder.encode(MockWordOfDay.catalog[language])
                .write(to: pasta.appendingPathComponent("\(language.rawValue).json"))
        }
    }
}
