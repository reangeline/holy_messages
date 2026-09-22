import XCTest

/// The Calendar tab. Two things share this screen and must not be confused:
///
/// - chrome (month name, weekday labels, section titles, the reading labels on
///   the Sunday bulletin) follows the interface language;
/// - liturgical nomenclature computed by LiturgicalEngine (season labels and
///   movable feast names like "Exaltação da Santa Cruz") stays Portuguese until
///   each language's own Missal wording is authored. Translating those myself
///   would be inventing liturgical names, which this app doesn't do.
final class CalendarLanguageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        // No -appLanguageOverride: it would outrank what the picker writes.
        app.launchArguments = ["-subscribed", "1", "-hasCompletedOnboarding", "1", "-openScreen", "settings"]
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

    private func openCalendar(in app: XCUIApplication) {
        let tab = button("label == 'Calendar' OR label == 'Calendário' OR label == 'Calendario'", in: app)
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "a aba do calendário não apareceu")
        tab.tap()
    }

    func testCalendarChromeFollowsTheLanguage() {
        let app = launch()
        choose("English", in: app)
        openCalendar(in: app)

        // The month name comes from Foundation, not a translated string.
        // CONTAINS[c]: the name is capitalized for display ("Setembro"), and the
        // casing isn't what's being tested here.
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'September'")).firstMatch.waitForExistence(timeout: 5),
            "o nome do mês não seguiu o idioma"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS 'The liturgical year'")).firstMatch.exists,
            "o atalho do ano litúrgico não seguiu o idioma"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS 'The week in 7 days'")).firstMatch.exists,
            "o atalho da semana não seguiu o idioma"
        )
    }

    /// The year ribbon carries the longest sentence on the tab.
    func testYearRibbonFollowsTheLanguage() {
        let app = launch()
        choose("English", in: app)
        openCalendar(in: app)

        let ribbon = button("label CONTAINS 'The liturgical year'", in: app)
        XCTAssertTrue(ribbon.waitForExistence(timeout: 5), "o atalho do ano litúrgico não apareceu")
        tapMiddle(ribbon)

        XCTAssertTrue(
            app.staticTexts["A year, in one strip"].waitForExistence(timeout: 5),
            "o título da faixa não seguiu o idioma"
        )
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'the Triduum barely shows'")).firstMatch.exists,
            "a explicação da faixa não seguiu o idioma"
        )
        XCTAssertTrue(
            app.staticTexts["you are here"].exists,
            "o marcador de posição no ano não seguiu o idioma"
        )
    }

    func testCalendarChromeBackInPortuguese() {
        let app = launch()
        choose("Português", in: app)
        openCalendar(in: app)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'setembro'")).firstMatch.waitForExistence(timeout: 5),
            "o nome do mês não voltou ao português"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS 'O ano litúrgico'")).firstMatch.exists,
            "o atalho do ano litúrgico não voltou ao português"
        )
    }
}
