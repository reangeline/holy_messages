import XCTest
@testable import Missale

/// Content published from the admin page replaces the bundled lists, and
/// anything wrong with a download falls back to them — never an empty screen.
final class RemoteContentTests: XCTestCase {

    private let collection = "word_of_day"
    private var language: AppLanguage { AppLanguagePreference.resolveCurrent() }

    override func tearDown() {
        if let url = RemoteContent.fileURL(collection: collection, lang: language.rawValue) {
            try? FileManager.default.removeItem(at: url)
        }
        RemoteContent.invalidate()
    }

    private func publish(_ data: Data) throws {
        let url = try XCTUnwrap(RemoteContent.fileURL(collection: collection, lang: language.rawValue),
                                "o App Group não está disponível")
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url)
        RemoteContent.invalidate()
    }

    func testAPublishedListReplacesTheBundledOne() throws {
        let publicada = WordOfDay(id: "teste-1", quote: "Q", reference: "Mt 1, 1", translationNote: "N", context: "C")
        try publish(JSONEncoder().encode([publicada]))

        XCTAssertEqual(MockWordOfDay.pool, [publicada])
        XCTAssertEqual(MockWordOfDay.wordOfDay(for: "2026-09-25"), publicada)
    }

    func testWithoutADownloadTheBundledListIsUsed() {
        XCTAssertNil(RemoteContent.items(collection, language: language, as: WordOfDay.self))
        XCTAssertEqual(MockWordOfDay.pool, MockWordOfDay.catalog[language])
        XCTAssertFalse(MockWordOfDay.pool.isEmpty)
    }

    func testABrokenOrEmptyFileFallsBackToTheBundledList() throws {
        for ruim in [Data("não é json".utf8), Data("[]".utf8), Data(#"[{"id":"x"}]"#.utf8)] {
            try publish(ruim)
            XCTAssertEqual(MockWordOfDay.pool, MockWordOfDay.catalog[language],
                           "arquivo \(String(decoding: ruim, as: UTF8.self)) deveria cair na lista embutida")
        }
    }

    func testHashMatchesWhatTheServerPublishes() {
        // sha256("abc"), as Go's crypto/sha256 prints it in the manifest.
        XCTAssertEqual(RemoteContentUpdater.sha256(Data("abc".utf8)),
                       "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    }
}
