import XCTest
@testable import Missale

/// Content published from the admin page replaces the bundled lists, and
/// anything wrong with a download falls back to them — never an empty screen.
final class RemoteContentTests: XCTestCase {

    private let collection = "word_of_day"
    private var language: AppLanguage { AppLanguagePreference.resolveCurrent() }

    override func tearDown() {
        for c in [collection, "saints", "mood_reliefs", "formation_tracks", "formation_lessons"] {
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

    // MARK: - Respostas do check-in

    func testEveryReplyRoundTripsThroughThePublishedFormat() throws {
        for language in AppLanguage.allCases where MockMood.reliefCatalog.hasOwnCatalog(for: language) {
            let catalog = MockMood.reliefCatalog[language]
            let flat = try JSONDecoder().decode([PublishedRelief].self,
                                                from: JSONEncoder().encode(PublishedRelief.flatten(catalog)))
            var regrouped: [String: [ReliefContent]] = [:]
            for item in flat { regrouped[item.stateID, default: []].append(item.relief) }
            for (state, replies) in catalog {
                XCTAssertEqual(regrouped[state]?.map(\.title), replies.map(\.title), "\(state) em \(language): ordem ou conteúdo mudou")
                XCTAssertEqual(regrouped[state]?.map(\.saintID), replies.map(\.saintID))
                XCTAssertEqual(regrouped[state]?.map(\.stepBody), replies.map(\.stepBody))
            }
        }
    }

    func testPublishedRepliesKeepTheAdminsOrderPerState() throws {
        func reply(_ id: String, _ state: String) -> String {
            #"{"id":"\#(id)","stateID":"\#(state)","title":"\#(id)","psalmRef":"Sl 1","psalmText":"t","psalmWhy":"w","saintID":"","saintName":"S","saintWhy":"sw","stepTitle":"Passo","stepBody":"b"}"#
        }
        let json = "[" + [reply("grief-02", "grief"), reply("peace-01", "peace"), reply("grief-01", "grief")].joined(separator: ",") + "]"
        try publish(Data(json.utf8), to: "mood_reliefs")

        XCTAssertEqual(MockMood.reliefVariants(for: "grief")?.map(\.title), ["grief-02", "grief-01"],
                       "a ordem dentro do estado é a do painel")
        XCTAssertEqual(MockMood.reliefVariants(for: "peace")?.count, 1)
        XCTAssertNil(MockMood.reliefVariants(for: "grief")?.first?.saintID, "santo vazio vira sem link")
        XCTAssertEqual(MockMood.relief(for: "grief", excluding: 0).index, 1, "sem repetir a última mostrada")
    }

    // MARK: - Formação

    /// Taking the tracks apart into the two published lists and assembling
    /// them again gives back the same lessons — part numbers included, which
    /// the published format derives from order instead of storing.
    func testFormationRoundTripsThroughThePublishedFormat() throws {
        for language in AppLanguage.allCases where MockFormation.trackCatalog.hasOwnCatalog(for: language) {
            let bundled = [MockFormation.trackCatalog[language]] + MockFormation.otherTracksCatalog[language]
            let tracks = try JSONDecoder().decode([PublishedFormationTrack].self, from: JSONEncoder().encode(
                bundled.map { PublishedFormationTrack(id: $0.id, title: $0.title, meta: $0.meta) }))
            let lessons = try JSONDecoder().decode([PublishedFormationLesson].self, from: JSONEncoder().encode(
                bundled.flatMap(\.lessons).map(PublishedFormationLesson.init)))
            let assembled = PublishedFormationLesson.assemble(tracks: tracks, lessons: lessons)

            XCTAssertEqual(assembled.map(\.id), bundled.map(\.id), "\(language)")
            XCTAssertEqual(assembled.map(\.title), bundled.map(\.title))
            for (a, b) in zip(assembled, bundled) {
                XCTAssertEqual(a.lessons, b.lessons, "\(b.id) em \(language)")
            }
        }
    }

    func testFormationNeedsBothListsPublished() throws {
        let tracks = #"[{"id":"t1","title":"Trilha","meta":"m"}]"#
        try publish(Data(tracks.utf8), to: "formation_tracks")
        XCTAssertEqual(MockFormation.track.id, MockFormation.trackCatalog[language].id,
                       "só as trilhas publicadas: a formação embutida continua")

        let lessons = #"""
        [{"id":"l2","trackID":"t1","kicker":"K","title":"Segunda","bodyParagraphs":["p"],"quoteText":"","quoteAttribution":"","glossaryTerms":[]},
         {"id":"l1","trackID":"t1","kicker":"K","title":"Primeira","bodyParagraphs":["p"],"quoteText":"","quoteAttribution":"","glossaryTerms":[]},
         {"id":"x","trackID":"sem-trilha","kicker":"K","title":"Órfã","bodyParagraphs":["p"],"quoteText":"","quoteAttribution":"","glossaryTerms":[]}]
        """#
        try publish(Data(lessons.utf8), to: "formation_lessons")
        XCTAssertEqual(MockFormation.allTracks.map(\.id), ["t1"], "lição sem trilha fica de fora")
        XCTAssertEqual(MockFormation.track.lessons.map(\.title), ["Segunda", "Primeira"])
        XCTAssertEqual(MockFormation.track.lessons.map(\.partNumber), [1, 2], "a parte sai da ordem")
        XCTAssertNil(MockFormation.track.lessons[0].quoteText, "citação vazia vira sem citação")
    }
}
