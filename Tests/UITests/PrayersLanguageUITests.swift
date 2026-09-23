import XCTest

/// The Prayers tab, same split as Formation: the chrome follows the interface
/// language, the prayers themselves follow their content catalog. Here the
/// content side is real in all three languages (the rosary and the devotional
/// prayers were authored per language), so this tab should change almost
/// entirely — which is what makes it worth asserting.
final class PrayersLanguageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        // No -appLanguageOverride: it would outrank what the picker writes.
        app.launchArguments = ["-demoDate", "2026-09-14", "-subscribed", "1", "-hasCompletedOnboarding", "1", "-openScreen", "settings"]
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

    private func openPrayers(in app: XCUIApplication) {
        let tab = button("label == 'Prayers' OR label == 'Orações' OR label == 'Oraciones'", in: app)
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "a aba de orações não apareceu")
        tab.tap()
    }

    func testPrayersTabFollowsTheLanguage() {
        let app = launch()
        choose("English", in: app)
        openPrayers(in: app)

        XCTAssertTrue(app.staticTexts["Rosary"].waitForExistence(timeout: 5),
                      "o título da seção do terço não seguiu o idioma")
        XCTAssertTrue(app.staticTexts["Devotions"].exists,
                      "o título da seção de devoções não seguiu o idioma")
        // Content side: the rosary catalog has English, so the mysteries change too.
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Mysteries'")).firstMatch.exists,
            "os mistérios não seguiram o idioma"
        )
    }

    func testPrayersTabBackInPortuguese() {
        let app = launch()
        choose("Português", in: app)
        openPrayers(in: app)

        XCTAssertTrue(app.staticTexts["Terço"].waitForExistence(timeout: 5),
                      "a seção do terço não voltou ao português")
        XCTAssertTrue(app.staticTexts["Devoções"].exists,
                      "a seção de devoções não voltou ao português")
    }

    /// The guided rosary is where the imported prayer texts and the bead labels
    /// meet: its exit and screen-off controls were hardcoded Portuguese.
    func testGuidedRosaryControlsFollowTheLanguage() {
        let app = launch()
        choose("English", in: app)
        openPrayers(in: app)

        let todaysRosary = button("label CONTAINS 'Mysteries'", in: app)
        XCTAssertTrue(todaysRosary.waitForExistence(timeout: 5), "o card do terço de hoje não apareceu")
        tapMiddle(todaysRosary)

        let start = button("label == 'Start' OR label BEGINSWITH 'Start'", in: app)
        XCTAssertTrue(start.waitForExistence(timeout: 5), "a tela de mistérios não abriu")
        tapMiddle(start)

        XCTAssertTrue(
            button("label == '‹ Exit'", in: app).waitForExistence(timeout: 5),
            "o botão de sair continuou em português"
        )
        XCTAssertTrue(
            button("label == 'Turn off the screen'", in: app).exists,
            "o botão de apagar a tela continuou em português"
        )
    }
}
