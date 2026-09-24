import XCTest

/// The Bible from the Prayers hub: English reads the Douay-Rheims down to a
/// psalm with its Hebrew number, Portuguese the Matos Soares, Spanish the
/// Torres Amat.
final class BibleUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch(_ language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-subscribed", "1", "-hasCompletedOnboarding", "1", "-appLanguageOverride", language]
        app.launch()
        return app
    }

    private func screenshot(_ name: String, _ app: XCUIApplication) {
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = name
        shot.lifetime = .keepAlways
        add(shot)
    }

    private func openBible(_ tab: String, _ row: String, in app: XCUIApplication) {
        let prayers = app.buttons[tab]
        XCTAssertTrue(prayers.waitForExistence(timeout: 10), "a aba de orações não apareceu")
        prayers.tap()
        let read = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", row)).firstMatch
        XCTAssertTrue(read.waitForExistence(timeout: 5), "a entrada da Bíblia não apareceu")
        read.tap()
    }

    func testReadsAPsalmInEnglish() {
        let app = launch("en")
        openBible("Prayers", "Read the Bible", in: app)

        XCTAssertTrue(app.staticTexts["Old Testament"].waitForExistence(timeout: 15), "a lista de livros não carregou")
        screenshot("bible-books", app)

        let psalms = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Psalms'")).firstMatch
        for _ in 0..<12 where !psalms.isHittable { app.swipeUp() }
        psalms.tap()

        let chapter = app.buttons["22"]
        XCTAssertTrue(chapter.waitForExistence(timeout: 5))
        screenshot("bible-chapters", app)
        chapter.tap()

        XCTAssertTrue(app.staticTexts["Psalm 22 (23)"].waitForExistence(timeout: 5), "o salmo não mostrou a numeração hebraica")
        screenshot("bible-psalm", app)

        app.swipeUp(); app.swipeUp()
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Next chapter'")).firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Psalm 23 (24)"].waitForExistence(timeout: 5), "o próximo capítulo não abriu")
    }

    func testReadsAPsalmInPortuguese() {
        let app = launch("pt")
        openBible("Orações", "Ler a Bíblia", in: app)

        XCTAssertTrue(app.staticTexts["Antigo Testamento"].waitForExistence(timeout: 15), "a Matos Soares não carregou")
        let psalms = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Salmos'")).firstMatch
        for _ in 0..<12 where !psalms.isHittable { app.swipeUp() }
        psalms.tap()
        app.buttons["22"].tap()

        XCTAssertTrue(app.staticTexts["Salmo 22 (23)"].waitForExistence(timeout: 5))
        screenshot("bible-psalm-pt", app)
    }

    func testReadsAPsalmInSpanish() {
        let app = launch("es")
        openBible("Oraciones", "Leer la Biblia", in: app)

        XCTAssertTrue(app.staticTexts["Antiguo Testamento"].waitForExistence(timeout: 15), "la Torres Amat no cargó")
        let psalms = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Salmos'")).firstMatch
        for _ in 0..<12 where !psalms.isHittable { app.swipeUp() }
        psalms.tap()
        app.buttons["22"].tap()

        XCTAssertTrue(app.staticTexts["Salmo 22 (23)"].waitForExistence(timeout: 5))
        screenshot("bible-psalm-es", app)
    }
}
