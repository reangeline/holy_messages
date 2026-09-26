import XCTest

/// The Rosary suggestion from the intention, with Jev faked offline
/// (`-fakeJevPick`, see JevPicker.debugFakeResult): the card appears after the
/// intention is written, can be accepted, and marks the chosen mystery during
/// the prayer; a risk sign brings the crisis card; with personalization off,
/// nothing appears.
final class RosarySuggestionUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch(_ extra: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1",
                               "-hasCompletedOnboarding", "1", "-appLanguageOverride", "en"] + extra
        app.launch()
        return app
    }

    private func button(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: predicate)).firstMatch
    }

    /// Opens the mysteries screen and writes the intention, ending with return.
    private func writeIntention(_ text: String, in app: XCUIApplication) {
        let tab = button("label == 'Prayers'", in: app)
        XCTAssertTrue(tab.waitForExistence(timeout: 10), "a aba de orações não apareceu")
        tab.tap()
        let todaysRosary = button("label CONTAINS 'Mysteries'", in: app)
        XCTAssertTrue(todaysRosary.waitForExistence(timeout: 5), "o card do terço de hoje não apareceu")
        todaysRosary.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        let field = app.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5), "o campo da intenção não apareceu")
        field.tap()
        field.typeText(text + "\n")
    }

    func testTheSuggestionIsOfferedAndMarksTheMystery() {
        let app = launch(["-fakeJevPick", "sorrowful,sorrowful.0"])
        writeIntention("For my father's surgery tomorrow", in: app)

        let headline = app.staticTexts["For your intention: Sorrowful Mysteries — highlight: The Agony in the Garden"]
        XCTAssertTrue(headline.waitForExistence(timeout: 5), "a sugestão não apareceu")
        XCTAssertTrue(app.staticTexts["Fruit: Contrition for sin and perseverance in prayer."].exists,
                      "o fruto do catálogo não apareceu")
        XCTAssertTrue(app.buttons["rosarySuggestionKeepToday"].exists)

        app.buttons["rosarySuggestionAccept"].tap()
        let start = button("label == 'Start'", in: app)
        XCTAssertTrue(start.waitForExistence(timeout: 5))
        start.tap()

        // Crucifix, intentions, offering, creed, Our Father, three Hail Marys,
        // Glory: the ninth tap reaches the first mystery's announcement.
        XCTAssertTrue(button("label == '‹ Exit'", in: app).waitForExistence(timeout: 5))
        for _ in 0..<9 {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.55)).tap()
        }
        XCTAssertTrue(app.staticTexts["For your intention"].waitForExistence(timeout: 5)
                      || app.otherElements["rosaryHighlightMarker"].exists,
                      "o mistério destacado ficou sem marca")
    }

    func testARiskSignBringsTheCrisisCard() {
        let app = launch(["-fakeJevPick", "crisis"])
        writeIntention("For my family", in: app)
        XCTAssertTrue(app.staticTexts["What you wrote calls for care"].waitForExistence(timeout: 5)
                      || app.otherElements["crisisSupportCard"].exists,
                      "o sinal de risco não trouxe a orientação de crise")
    }

    func testPersonalizationOffShowsNothing() {
        let app = launch(["-fakeJevPick", "sorrowful,sorrowful.0", "-jev_personalization_enabled", "NO"])
        writeIntention("For my father's surgery tomorrow", in: app)
        XCTAssertFalse(app.buttons["rosarySuggestionAccept"].waitForExistence(timeout: 3),
                       "com a personalização desligada, nada deveria ser sugerido")
        XCTAssertTrue(button("label == 'Start'", in: app).exists, "o caminho de sempre sumiu")
    }
}
