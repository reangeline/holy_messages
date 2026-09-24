import XCTest

/// Covers the reported bug: "clico e ele não seleciona o novo idioma".
///
/// Two things keep these tests honest and are worth not undoing:
///
/// - No `-appLanguageOverride` launch argument. It lands in NSArgumentDomain,
///   which outranks what the app writes to its own defaults, so the picker's
///   write would be shadowed forever and the test would fail against a healthy
///   app.
/// - Nothing assumes the starting language: every run leaves the choice
///   persisted, which is the whole point of the feature. The tests switch in
///   both directions instead.
final class LanguageSwitchUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launchInSettings() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1", "-openScreen", "settings"]
        app.launch()
        return app
    }

    private func button(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: predicate)).firstMatch
    }

    /// The Settings row, whichever language the list is currently in. Its label
    /// is composed ("Language, App interface, English").
    private func languageRow(in app: XCUIApplication) -> XCUIElement {
        button("label BEGINSWITH 'Idioma' OR label BEGINSWITH 'Language'", in: app)
    }

    /// Taps the centre of an element: the dead gap between a row's title and its
    /// trailing value is exactly what made the picker look unresponsive.
    private func tapMiddle(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    func testRowAcceptsATapAcrossItsWholeWidth() {
        let app = launchInSettings()
        let row = languageRow(in: app)
        XCTAssertTrue(row.waitForExistence(timeout: 10), "a lista de ajustes não abriu")

        tapMiddle(row)

        XCTAssertTrue(
            button("label BEGINSWITH 'Português'", in: app).waitForExistence(timeout: 5),
            "tocar no meio da linha não abriu a tela de idioma"
        )
    }

    /// Switches both ways, so it doesn't depend on what the last run left behind
    /// — and proves the interface follows immediately, with no relaunch.
    func testSwitchingLanguageChangesTheInterfaceBothWays() {
        let app = launchInSettings()
        XCTAssertTrue(languageRow(in: app).waitForExistence(timeout: 10))
        tapMiddle(languageRow(in: app))

        let english = button("label BEGINSWITH 'English'", in: app)
        XCTAssertTrue(english.waitForExistence(timeout: 5), "a tela de idioma não abriu")

        tapMiddle(english)
        // This screen's own title goes through L.string: if it turned English,
        // the choice registered and the tree re-resolved.
        XCTAssertTrue(app.navigationBars["Language"].waitForExistence(timeout: 5),
                      "escolher English não trocou a interface")

        tapMiddle(button("label BEGINSWITH 'Português'", in: app))
        XCTAssertTrue(app.navigationBars["Idioma"].waitForExistence(timeout: 5),
                      "escolher Português não trocou a interface de volta")

        // The list behind the picker has to follow too — it used to be hardcoded
        // Portuguese no matter the language.
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(
            button("label BEGINSWITH 'Calendário litúrgico'", in: app).waitForExistence(timeout: 5),
            "a lista de ajustes não seguiu o idioma"
        )
    }

    /// The choice has to survive closing Settings and reopening it.
    func testChoiceSurvivesReopeningSettings() {
        let app = launchInSettings()
        XCTAssertTrue(languageRow(in: app).waitForExistence(timeout: 10))
        tapMiddle(languageRow(in: app))

        let english = button("label BEGINSWITH 'English'", in: app)
        XCTAssertTrue(english.waitForExistence(timeout: 5))
        tapMiddle(english)
        XCTAssertTrue(app.navigationBars["Language"].waitForExistence(timeout: 5))

        app.navigationBars.buttons.element(boundBy: 0).tap()   // back to the list
        let close = button("label == 'Close'", in: app)
        XCTAssertTrue(close.waitForExistence(timeout: 5), "o botão de fechar não seguiu o idioma")
        close.tap()

        let gear = app.buttons["gearshape.fill"].firstMatch
        XCTAssertTrue(gear.waitForExistence(timeout: 5), "a engrenagem não apareceu")
        gear.tap()

        XCTAssertTrue(
            button("label BEGINSWITH 'Language'", in: app).waitForExistence(timeout: 5),
            "ao reabrir, Ajustes não estava no idioma escolhido"
        )
    }
}
