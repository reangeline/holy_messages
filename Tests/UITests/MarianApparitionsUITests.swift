import XCTest

/// The apparitions archive moved from Calendar to Prayers, after the Rosary
/// and the devotions: what a reader does with a shrine is pray there. Each row
/// carries the shrine's art when the catalog has it, and the striped
/// placeholder when it doesn't — Knock has a sourced record and no picture,
/// and inventing one would be worse than showing none.
final class MarianApparitionsUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func openPrayers(_ language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1", "-hasCompletedOnboarding", "1", "-appLanguageOverride", language]
        app.launch()

        let tab = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Orações' OR label CONTAINS[c] 'Prayers' OR label CONTAINS[c] 'Oraciones'")
        ).firstMatch
        XCTAssertTrue(tab.waitForExistence(timeout: 15), "não achei a aba de orações")
        tab.tap()
        return app
    }

    /// Scrolls to an element that starts below the fold, rather than swiping a
    /// fixed number of times and hoping.
    private func scroll(_ app: XCUIApplication, to element: XCUIElement) {
        for _ in 0..<8 where !element.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(element.isHittable, "não consegui rolar até \(element)")
    }

    func testTheApparitionsSectionLivesInPrayers() {
        let app = openPrayers("pt")
        let header = app.staticTexts["Aparições marianas"]
        scroll(app, to: header)

        // A ordem pedida: Terço, Devoções, e por fim as Aparições.
        let devotions = app.staticTexts["Devoções"]
        XCTAssertTrue(devotions.exists, "a seção de devoções desapareceu")
        XCTAssertLessThan(devotions.frame.minY, header.frame.minY,
                          "as Aparições devem vir depois das Devoções")
    }

    func testARecordOpensWithItsSourceAndReception() {
        let app = openPrayers("pt")
        let row = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Fátima'")).firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 10), "a ficha de Fátima não está na lista")
        scroll(app, to: row)
        row.tap()

        XCTAssertTrue(app.staticTexts["RECEPÇÃO ECLESIAL"].waitForExistence(timeout: 5),
                      "a ficha não mostra a recepção eclesial")
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'santuario-fatima.pt'")).firstMatch.exists,
                      "a ficha não declara a fonte")
    }

    /// The section follows the interface language like the rest of the hub.
    func testTheSectionFollowsTheLanguage() {
        let app = openPrayers("es")
        let header = app.staticTexts["Apariciones marianas"]
        scroll(app, to: header)
        XCTAssertTrue(header.exists, "o cabeçalho não saiu em espanhol")
    }

    /// Calendar must no longer offer it: two doors to the same small archive
    /// was the reason to move it, not to duplicate it.
    func testCalendarNoLongerLinksToApparitions() {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1", "-hasCompletedOnboarding", "1", "-appLanguageOverride", "pt"]
        app.launch()

        let tab = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Calendário'")).firstMatch
        XCTAssertTrue(tab.waitForExistence(timeout: 15), "não achei a aba do calendário")
        tab.tap()
        for _ in 0..<6 { app.swipeUp() }

        XCTAssertFalse(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Aparições marianas'")).firstMatch.exists,
            "o calendário ainda leva às aparições"
        )
    }
}
