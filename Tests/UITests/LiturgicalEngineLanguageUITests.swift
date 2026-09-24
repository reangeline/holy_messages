import XCTest

/// The liturgical engine computes a name for every date — seasons, movable
/// feasts, Sunday titles — and those names were Portuguese-only. The home
/// screen's two demo days had been given per-language catalogs, so the front
/// door read correctly while every other day in the Calendar fell back to
/// Portuguese.
///
/// This walks the Calendar to a month the engine has to compute (not the fixed
/// demo day) and checks the season label in each language.
final class LiturgicalEngineLanguageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1", "-hasCompletedOnboarding", "1", "-openScreen", "settings"]
        app.launch()
        return app
    }

    private func button(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: predicate)).firstMatch
    }

    private func tapMiddle(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func choose(_ language: String, in app: XCUIApplication) {
        let row = button("label BEGINSWITH 'Idioma' OR label BEGINSWITH 'Language'", in: app)
        XCTAssertTrue(row.waitForExistence(timeout: 10), "a lista de ajustes não abriu")
        tapMiddle(row)
        let option = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", language)).firstMatch
        XCTAssertTrue(option.waitForExistence(timeout: 5), "opção \(language) não apareceu")
        tapMiddle(option)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let close = button("label == 'Close' OR label == 'Fechar' OR label == 'Cerrar'", in: app)
        XCTAssertTrue(close.waitForExistence(timeout: 5))
        close.tap()
    }

    /// Opens a day the engine has to compute. Deliberately not the 14th or the
    /// 15th: those two are the hand-authored demo days, and they would pass this
    /// test without the engine being involved at all.
    private func openComputedDay(in app: XCUIApplication) {
        let tab = button("label == 'Calendar' OR label == 'Calendário' OR label == 'Calendario'", in: app)
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "a aba do calendário não apareceu")
        tab.tap()

        // The grid's cells are labelled by day number.
        let day = button("label == '22'", in: app)
        XCTAssertTrue(day.waitForExistence(timeout: 5), "a grade do calendário não apareceu")
        tapMiddle(day)
    }

    func testSeasonLabelsAreEnglishInEnglish() {
        let app = launch()
        choose("English", in: app)
        openComputedDay(in: app)

        // The engine names Ordinary Time for this week; the label is its own,
        // not the two hand-written demo days'.
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Ordinary Time'")).firstMatch.waitForExistence(timeout: 5),
            "o motor não nomeou o tempo litúrgico em inglês"
        )
        XCTAssertFalse(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Tempo Comum'")).firstMatch.exists,
            "o motor ainda mostra o tempo litúrgico em português num app em inglês"
        )
    }

    func testSeasonLabelsAreSpanishInSpanish() {
        let app = launch()
        choose("Español", in: app)
        openComputedDay(in: app)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Tiempo Ordinario'")).firstMatch.waitForExistence(timeout: 5),
            "o motor não nomeou o tempo litúrgico em espanhol"
        )
    }

    func testSeasonLabelsAreBackInPortuguese() {
        let app = launch()
        choose("Português", in: app)
        openComputedDay(in: app)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Tempo Comum'")).firstMatch.waitForExistence(timeout: 5),
            "o motor não voltou ao português"
        )
    }
}
