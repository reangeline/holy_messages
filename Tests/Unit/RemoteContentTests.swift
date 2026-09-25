import XCTest
@testable import Missale

/// Content published from the admin page replaces the bundled lists, and
/// anything wrong with a download falls back to them — never an empty screen.
final class RemoteContentTests: XCTestCase {

    private let collection = "word_of_day"
    private var language: AppLanguage { AppLanguagePreference.resolveCurrent() }

    override func tearDown() {
        for c in [collection, "saints"] {
            if let url = RemoteContent.fileURL(collection: c, lang: language.rawValue) {
                try? FileManager.default.removeItem(at: url)
            }
        }
        RemoteContent.invalidate()
    }

    private func publish(_ data: Data, to collection: String = "word_of_day") throws {
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

    // MARK: - Santos

    /// Every bundled saint survives the trip through the published format —
    /// the seed the admin page starts from is exactly the app's content.
    func testEverySaintRoundTripsThroughThePublishedFormat() throws {
        for language in AppLanguage.allCases {
            for entry in MockSaints.catalog[language] {
                let viaJSON = try JSONDecoder().decode(PublishedSaint.self,
                                                       from: JSONEncoder().encode(PublishedSaint(entry)))
                XCTAssertEqual(viaJSON.saintOfDay, entry, "\(entry.saint.id) em \(language)")
            }
        }
    }

    func testPublishedSaintsReplaceTheCalendar() throws {
        // As the server publishes: every field present, empty ones as "" or [].
        let json = #"""
        [{"id":"teste-santo","dateKey":"09-25","name":"São Teste","lifespan":"","role":"Mártir",
          "rank":"Memória","calendarNote":"Nota","bioParagraphs":["Primeiro.","Segundo."],
          "whyItMattersToday":"Hoje.","prayer":"Rogai por nós.","artworkName":"","stories":[]}]
        """#
        try publish(Data(json.utf8), to: "saints")

        XCTAssertEqual(MockSaints.calendar.map(\.saint.id), ["teste-santo"])
        let santo = try XCTUnwrap(MockSaints.saint(on: "09-25"))
        XCTAssertEqual(santo.bioParagraphs, ["Primeiro.", "Segundo."])
        XCTAssertNil(santo.artworkName, "arte vazia deve virar sem arte, não uma imagem inexistente")
        XCTAssertTrue(santo.stories.isEmpty)
    }
}
