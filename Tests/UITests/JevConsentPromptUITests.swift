import XCTest

/// The one-time "Personalizar com o que você escreve?" prompt (`JevConsent`),
/// shown the first time a personalized feature would send what the reader
/// wrote — here, the Rosary intention (`RosarySuggestionUITests` and the
/// other three Jev UI test classes all pass `-jev_consent granted` so they
/// don't hit this prompt at all). Jev itself stays faked offline
/// (`-fakeJevPick`, see JevPicker.debugFakeResult).
final class JevConsentPromptUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    /// `-resetJevConsent 1`: the app installation is shared across this
    /// file's test methods (and whatever ran before them), and an earlier
    /// method's tap on "Permitir"/"Agora não" persists — so each launch
    /// clears it back to "not asked" first (see `JevConsent.resetForUITestsOnce`).
    /// `-routine_intentions "{}"` clears a leftover morning intention too, so
    /// `PersonalizedWordOfDay`'s own automatic refresh on Today can't ask
    /// Jev — and so show this same prompt — before the test ever reaches
    /// the Rosary screen.
    private func launch(_ extra: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1",
                               "-hasCompletedOnboarding", "1", "-appLanguageOverride", "en",
                               "-resetJevConsent", "1", "-routine_intentions", "{}"] + extra
        app.launch()
        return app
    }

    private func button(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: predicate)).firstMatch
    }

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

    func testThePromptAppearsOnTheFirstSend() {
        let app = launch(["-fakeJevPick", "sorrowful,sorrowful.0"])
        writeIntention("For my father's surgery tomorrow", in: app)
        XCTAssertTrue(app.staticTexts["Personalize with what you write?"].waitForExistence(timeout: 5),
                      "o pedido de consentimento não apareceu no primeiro envio")
        XCTAssertTrue(app.buttons["jevConsentAllow"].exists)
        XCTAssertTrue(app.buttons["jevConsentDecline"].exists)
    }

    func testDecliningSendsNothing() {
        let app = launch(["-fakeJevPick", "sorrowful,sorrowful.0"])
        writeIntention("For my father's surgery tomorrow", in: app)
        XCTAssertTrue(app.buttons["jevConsentDecline"].waitForExistence(timeout: 5))
        app.buttons["jevConsentDecline"].tap()

        XCTAssertFalse(app.buttons["rosarySuggestionAccept"].waitForExistence(timeout: 3),
                       "recusar não deveria deixar nada ser sugerido")
        XCTAssertTrue(button("label == 'Start'", in: app).exists, "o caminho de sempre sumiu")

        // Not asked again on its own: editing the intention to something new
        // (still on this screen) shows no prompt and still sends nothing.
        let field = app.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText(" and my mother\n")
        XCTAssertFalse(app.staticTexts["Personalize with what you write?"].waitForExistence(timeout: 3),
                       "recusar não deveria pedir de novo sozinho")
        XCTAssertFalse(app.buttons["rosarySuggestionAccept"].waitForExistence(timeout: 2),
                       "recusar não deveria deixar nada ser sugerido, nem depois")
    }

    func testAllowingLetsTheSuggestionThrough() {
        let app = launch(["-fakeJevPick", "sorrowful,sorrowful.0"])
        writeIntention("For my father's surgery tomorrow", in: app)
        XCTAssertTrue(app.buttons["jevConsentAllow"].waitForExistence(timeout: 5))
        app.buttons["jevConsentAllow"].tap()

        let headline = app.staticTexts["For your intention: Sorrowful Mysteries — highlight: The Agony in the Garden"]
        XCTAssertTrue(headline.waitForExistence(timeout: 5), "permitir deveria deixar a sugestão aparecer")
    }
}
