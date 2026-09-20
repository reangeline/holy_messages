import XCTest

/// Reported: "a formação não troca de idioma".
///
/// The split this checks: the tab's chrome (headers, "Part 3 of 14", buttons)
/// must follow the interface language, while the lessons themselves stay in the
/// language their content catalog was authored in — Portuguese, for now. The bug
/// was that the chrome was hardcoded Portuguese too, so the whole tab looked
/// frozen.
final class FormationLanguageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        // No -appLanguageOverride: it would outrank what the picker writes.
        app.launchArguments = ["-hasCompletedOnboarding", "1", "-openScreen", "settings"]
        app.launch()
        return app
    }

    private func button(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: predicate)).firstMatch
    }

    private func tapMiddle(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    /// Puts the app in `language` through the real picker, then closes Settings.
    private func choose(_ language: String, in app: XCUIApplication) {
        let row = button("label BEGINSWITH 'Idioma' OR label BEGINSWITH 'Language'", in: app)
        XCTAssertTrue(row.waitForExistence(timeout: 10), "a lista de ajustes não abriu")
        tapMiddle(row)

        let option = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", language)).firstMatch
        XCTAssertTrue(option.waitForExistence(timeout: 5), "opção \(language) não apareceu")
        tapMiddle(option)

        app.navigationBars.buttons.element(boundBy: 0).tap()
        let close = app.buttons.matching(NSPredicate(format: "label == 'Close' OR label == 'Fechar' OR label == 'Cerrar'")).firstMatch
        XCTAssertTrue(close.waitForExistence(timeout: 5))
        close.tap()
    }

    private func openFormation(in app: XCUIApplication) {
        let tab = app.buttons.matching(NSPredicate(format: "label == 'Formation' OR label == 'Formação' OR label == 'Formación'")).firstMatch
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "a aba de formação não apareceu")
        tab.tap()
    }

    func testFormationChromeFollowsTheLanguage() {
        let app = launch()

        choose("English", in: app)
        openFormation(in: app)

        XCTAssertTrue(
            app.staticTexts["Tracks"].waitForExistence(timeout: 5),
            "o cabeçalho da formação não está em inglês"
        )
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'One part a day'")).firstMatch.exists,
            "a linha de apoio não seguiu o idioma"
        )
        // The track's own title is content, and stays Portuguese on purpose.
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'A Missa, parte por parte'")).firstMatch.exists,
            "o título da trilha deveria continuar em português (conteúdo)"
        )
    }

    /// Inside a track: the part counters and the "all parts" header are chrome.
    func testTrackDetailChromeFollowsTheLanguage() {
        let app = launch()

        choose("English", in: app)
        openFormation(in: app)

        let trackCard = app.buttons.matching(NSPredicate(format: "label CONTAINS 'A Missa, parte por parte'")).firstMatch
        XCTAssertTrue(trackCard.waitForExistence(timeout: 5), "o card da trilha não apareceu")
        tapMiddle(trackCard)

        XCTAssertTrue(
            app.staticTexts["ALL PARTS"].waitForExistence(timeout: 5),
            "o cabeçalho da lista de partes não seguiu o idioma"
        )
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'parts completed'")).firstMatch.exists,
            "o contador de partes não seguiu o idioma"
        )
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Part 1'")).firstMatch.exists,
            "os rótulos de parte não seguiram o idioma"
        )
    }

    /// And back in Portuguese, so the test doesn't depend on run order.
    func testFormationChromeBackInPortuguese() {
        let app = launch()

        choose("Português", in: app)
        openFormation(in: app)

        XCTAssertTrue(
            app.staticTexts["Trilhas"].waitForExistence(timeout: 5),
            "o cabeçalho da formação não voltou ao português"
        )
    }
}
