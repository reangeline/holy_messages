import XCTest

/// The Examen's saint and prayer, with Jev faked offline (`-fakeJevPick`, see
/// JevPicker.debugFakeResult): after the four steps the closing screen shows
/// the card, each row opens its page, and the choice is kept for the history;
/// a risk sign brings the crisis card; with personalization off, nothing.
final class ExamenSuggestionUITests: XCTestCase {

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

    private func tapMiddle(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func openExamenIntro(in app: XCUIApplication) {
        let card = button("label CONTAINS[c] 'TONIGHT'", in: app)
        XCTAssertTrue(card.waitForExistence(timeout: 10), "o card noturno não apareceu")
        app.swipeUp()
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        tapMiddle(card)
    }

    /// Writes `text` at the review step and skips the others.
    private func doTheExamen(writing text: String, in app: XCUIApplication) {
        openExamenIntro(in: app)
        let start = button("label CONTAINS[c] 'Start the Examen'", in: app)
        XCTAssertTrue(start.waitForExistence(timeout: 5), "a intro do Exame não abriu")
        tapMiddle(start)

        for step in 1...4 {
            let counter = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "STEP \(step) OF")).firstMatch
            XCTAssertTrue(counter.waitForExistence(timeout: 5), "o passo \(step) não apareceu")
            if step == 3 {
                let editor = app.textViews.firstMatch
                XCTAssertTrue(editor.waitForExistence(timeout: 5))
                editor.tap()
                editor.typeText(text)
                let continueButton = button("label == 'Continue'", in: app)
                XCTAssertTrue(continueButton.waitForExistence(timeout: 5))
                continueButton.tap()
            } else {
                button("label BEGINSWITH 'Skip'", in: app).tap()
            }
        }
        XCTAssertTrue(app.staticTexts["That's all for today."].waitForExistence(timeout: 5), "o encerramento não apareceu")
    }

    func testTheSaintAndPrayerAreShownOpenedAndKept() {
        let app = launch(["-fakeJevPick", "notburga,the-magnificat-en"])
        doTheExamen(writing: "I was impatient at work and did not help a colleague.", in: app)

        let saint = app.buttons["examenSuggestionSaint"]
        XCTAssertTrue(saint.waitForExistence(timeout: 5), "o santo escolhido não apareceu")
        XCTAssertTrue(app.staticTexts["CHOSEN FROM YOUR EXAMEN"].exists || app.staticTexts["Chosen from your Examen"].exists,
                      "falta dizer de onde veio a escolha")
        XCTAssertTrue(app.staticTexts["St Notburga of Eben"].exists)
        XCTAssertTrue(app.staticTexts["The Magnificat"].exists, "a oração escolhida não apareceu")

        saint.tap()
        XCTAssertTrue(app.staticTexts["Why it matters today"].waitForExistence(timeout: 5)
                      || app.staticTexts["WHY IT MATTERS TODAY"].exists, "o santo não abriu")
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let prayer = app.buttons["examenSuggestionPrayer"]
        XCTAssertTrue(prayer.waitForExistence(timeout: 5))
        prayer.tap()
        XCTAssertTrue(app.staticTexts["Canticle of Mary"].waitForExistence(timeout: 5), "a oração não abriu")
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Kept with the entry: the history shows it again.
        let finish = button("label == 'Finish'", in: app)
        XCTAssertTrue(finish.waitForExistence(timeout: 5))
        finish.tap()
        openExamenIntro(in: app)
        let history = button("label BEGINSWITH 'See past Examens'", in: app)
        XCTAssertTrue(history.waitForExistence(timeout: 5))
        history.tap()
        XCTAssertTrue(app.buttons["examenSuggestionSaint"].firstMatch.waitForExistence(timeout: 5),
                      "a escolha não ficou no histórico")
    }

    func testARiskSignBringsTheCrisisCard() {
        let app = launch(["-fakeJevPick", "crisis"])
        doTheExamen(writing: "A heavy day.", in: app)
        XCTAssertTrue(app.staticTexts["What you wrote calls for care"].waitForExistence(timeout: 5)
                      || app.otherElements["crisisSupportCard"].exists,
                      "o sinal de risco não trouxe a orientação de crise")
    }

    func testPersonalizationOffShowsNothing() {
        let app = launch(["-fakeJevPick", "notburga,the-magnificat-en", "-jev_personalization_enabled", "NO"])
        doTheExamen(writing: "I was impatient at work.", in: app)
        XCTAssertFalse(app.buttons["examenSuggestionSaint"].waitForExistence(timeout: 3),
                       "com a personalização desligada, nada deveria ser sugerido")
        XCTAssertTrue(button("label == 'Finish'", in: app).exists, "o caminho de sempre sumiu")
    }
}
