import XCTest
@testable import Missale

/// Content published from the admin page replaces the bundled lists, and
/// anything wrong with a download falls back to them — never an empty screen.
final class RemoteContentTests: XCTestCase {

    private let collection = "word_of_day"
    private var language: AppLanguage { AppLanguagePreference.resolveCurrent() }

    override func tearDown() {
        for c in [collection, "saints", "mood_reliefs", "formation_tracks", "formation_lessons", "prayer_categories", "prayers", "apparitions", "sunday_readings", "feasts"] {
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

    // MARK: - Orações

    func testPrayersRoundTripThroughThePublishedFormat() throws {
        for language in AppLanguage.allCases where MockDevotionalPrayers.catalog.hasOwnCatalog(for: language) {
            let bundled = MockDevotionalPrayers.catalog[language]
            let categories = try JSONDecoder().decode([PublishedPrayerCategory].self, from: JSONEncoder().encode(
                bundled.map { PublishedPrayerCategory(id: $0.id, title: $0.title) }))
            let prayers = try JSONDecoder().decode([PublishedPrayer].self, from: JSONEncoder().encode(
                bundled.flatMap { c in c.prayers.map { PublishedPrayer($0, categoryID: c.id) } }))
            XCTAssertEqual(PublishedPrayer.assemble(categories: categories, prayers: prayers),
                           bundled.filter { !$0.prayers.isEmpty }, "\(language)")
        }
    }

    func testPublishedPrayersReplaceTheCatalog() throws {
        try publish(Data(#"[{"id":"c1","title":"Paz"},{"id":"vazia","title":"Vazia"}]"#.utf8), to: "prayer_categories")
        XCTAssertEqual(MockDevotionalPrayers.categories, MockDevotionalPrayers.catalog[language],
                       "sem as orações publicadas, fica o catálogo embutido")
        try publish(Data(#"[{"id":"p1","categoryID":"c1","title":"Oração","attribution":"","focus":"f","saintID":"","fullText":"Amém."}]"#.utf8), to: "prayers")
        XCTAssertEqual(MockDevotionalPrayers.categories.map(\.id), ["c1"], "categoria vazia fica de fora")
        let oracao = try XCTUnwrap(MockDevotionalPrayers.categories.first?.prayers.first)
        XCTAssertNil(oracao.attribution)
        XCTAssertNil(oracao.saintID)
    }

    // MARK: - Aparições

    func testPublishedApparitionsReplaceTheCatalogAndKeepTheirArt() throws {
        let json = #"""
        [{"id":"lourdes-1858","name":"Nossa Senhora de Lourdes","place":"Lourdes, França","year":"1858",
          "visionaries":"Bernadette Soubirous","summary":"Resumo.","ecclesialRecognition":"Reconhecida em 1862.",
          "source":"Santuário de Lourdes"}]
        """#
        try publish(Data(json.utf8), to: "apparitions")
        XCTAssertEqual(MockMarianApparitions.all.map(\.id), ["lourdes-1858"])
        XCTAssertEqual(MockMarianApparitions.all.first?.artworkName, "lourdes", "a arte continua saindo do id")
    }

    func testEveryApparitionRoundTrips() throws {
        for language in AppLanguage.allCases where MockMarianApparitions.catalog.hasOwnCatalog(for: language) {
            let bundled = MockMarianApparitions.catalog[language]
            XCTAssertEqual(try JSONDecoder().decode([MarianApparition].self, from: JSONEncoder().encode(bundled)), bundled)
        }
    }

    // MARK: - Lecionário e festas

    func testLiturgyRoundTripsThroughThePublishedFormat() throws {
        for language in AppLanguage.allCases where MockLectionary.catalog.hasOwnCatalog(for: language) {
            let bundled = MockLectionary.catalog[language]
            let flat = try JSONDecoder().decode([PublishedSundayReadings].self, from: JSONEncoder().encode(
                bundled.map { PublishedSundayReadings(key: $0.key, $0.value) }))
            XCTAssertEqual(Dictionary(flat.map { ($0.key, $0.readings) }, uniquingKeysWith: { a, _ in a }), bundled, "\(language)")
        }
        for language in AppLanguage.allCases where LiturgicalSanctoral.catalog.hasOwnCatalog(for: language) {
            let bundled = LiturgicalSanctoral.catalog[language]
            let flat = try JSONDecoder().decode([PublishedFeast].self, from: JSONEncoder().encode(bundled.map(PublishedFeast.init)))
            XCTAssertEqual(flat.compactMap(\.feast), bundled, "\(language)")
        }
    }

    func testAFeastWithAnUnknownRankOrColourIsDropped() throws {
        let json = #"""
        [{"id":"12-25","monthDay":"12-25","name":"Natal","rank":"Solenidade","color":"white"},
         {"id":"12-26","monthDay":"12-26","name":"Errada","rank":"Solene","color":"white"},
         {"id":"12-27","monthDay":"12-27","name":"Errada","rank":"Festa","color":"azul"}]
        """#
        try publish(Data(json.utf8), to: "feasts")
        XCTAssertEqual(LiturgicalSanctoral.feasts.map(\.name), ["Natal"])
    }

    // MARK: - Imagens enviadas pelo painel

    private var imagemDeTeste: String { MissaleAPI.contentBaseURL.absoluteString + "/images/teste-unitario.png" }

    private func removeImagemDeTeste() {
        if let file = RemoteContent.imagesDirectory?.appendingPathComponent("teste-unitario.png") {
            try? FileManager.default.removeItem(at: file)
        }
    }

    func testOnlyImagesFromTheContentHostAreCollected() {
        let json: [String: Any] = [
            "artworkURL": imagemDeTeste,
            "stories": [["source": "https://outro.site/images/x.png"], ["body": imagemDeTeste]],
            "outro": MissaleAPI.contentBaseURL.absoluteString + "/v3/saints/pt.json",
            "subindo": MissaleAPI.contentBaseURL.absoluteString + "/images/../manifest.json",
        ]
        XCTAssertEqual(RemoteContentUpdater.imageURLs(in: json), [imagemDeTeste])
    }

    func testUploadedArtWinsOnlyOnceDownloaded() throws {
        removeImagemDeTeste()
        defer { removeImagemDeTeste() }
        let json = #"""
        [{"id":"agostinho","dateKey":"08-28","name":"Santo Agostinho","lifespan":"354–430","role":"Bispo",
          "rank":"Memória","calendarNote":"n","bioParagraphs":["p"],"whyItMattersToday":"w","prayer":"r",
          "artworkName":"agostinho","artworkURL":"\#(imagemDeTeste)","stories":[]}]
        """#
        try publish(Data(json.utf8), to: "saints")
        XCTAssertEqual(MockSaints.saint(on: "08-28")?.artworkName, "agostinho", "antes de baixar: a arte embutida")

        let folder = try XCTUnwrap(RemoteContent.imagesDirectory)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let png = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4)).pngData { ctx in
            UIColor.red.setFill(); ctx.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
        }
        try png.write(to: folder.appendingPathComponent("teste-unitario.png"))

        let nome = try XCTUnwrap(MockSaints.saint(on: "08-28")?.artworkName)
        XCTAssertEqual(nome, "remote:teste-unitario.png", "depois de baixar: a arte enviada")
        XCTAssertNotNil(DownloadedImages.image(named: "teste-unitario.png"), "o retrato carrega o arquivo baixado")
    }
}
