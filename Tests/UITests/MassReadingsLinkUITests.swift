import XCTest

/// The Word of the Day's "what's read at Mass today" card used to open a
/// mock-up: four readings hand-written for the design's demo day (14 September),
/// in Portuguese, shown on every date and in every language. It now opens the
/// real Sunday bulletin, which reads the imported lectionary.
///
/// The lectionary holds Sundays only, so the card is there on a Sunday with a
/// registered key and absent otherwise — these tests cover whichever branch the
/// day they run on falls into, and both assert the mock-up is gone.
final class MassReadingsLinkUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch(_ language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-hasCompletedOnboarding", "1", "-appLanguageOverride", language]
        app.launch()
        return app
    }

    /// Opens the Word of the Day from the Today tab.
    private func openWordOfDay(_ app: XCUIApplication) {
        let card = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Palavra de hoje' OR label CONTAINS[c] 'Word of the day' OR label CONTAINS[c] 'Palabra de hoy'")
        ).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 10), "não achei o cartão da Palavra do dia")
        card.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func massCard(_ app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'se lê hoje na Missa' OR label CONTAINS[c] \"read at Mass today\" OR label CONTAINS[c] 'se lee hoy en la Misa'")
        ).firstMatch
    }

    /// The demo day's readings must not appear on a date that isn't it. The
    /// book name is the same in all three languages, so one predicate covers it.
    func testTheDemoDaysReadingsAreGone() {
        let app = launch("pt")
        openWordOfDay(app)

        let mockup = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Números 21' OR label CONTAINS[c] 'Numbers 21'")
        ).firstMatch
        XCTAssertFalse(mockup.waitForExistence(timeout: 2), "a maquete do dia 14 voltou à tela")

        if massCard(app).exists {
            massCard(app).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
            XCTAssertTrue(
                app.staticTexts["Folheto do domingo"].waitForExistence(timeout: 5),
                "o cartão não abriu o folheto do domingo"
            )
        }
    }

    /// Whatever the card leads to must follow the interface language — the
    /// mock-up it replaced was Portuguese in all three.
    func testTheBulletinFollowsTheLanguage() {
        let app = launch("es")
        openWordOfDay(app)

        guard massCard(app).exists else {
            // Um dia de semana: o cartão não deve existir, e é isso que se afirma.
            XCTAssertFalse(massCard(app).exists)
            return
        }

        massCard(app).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertTrue(
            app.staticTexts["Hoja del domingo"].waitForExistence(timeout: 5),
            "o boletim não saiu em espanhol"
        )
    }
}
