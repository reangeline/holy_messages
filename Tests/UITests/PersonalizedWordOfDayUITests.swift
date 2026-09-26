import XCTest

/// The Word of the Day chosen from what the reader wrote, with Jev faked
/// offline (`-fakeJevPick`): today's intention is seeded through the launch
/// arguments, and the Today card and the word screen show the chosen verse
/// with its label; a risk sign brings the crisis card; with personalization
/// off, the date draw stays and nothing is labelled.
final class PersonalizedWordOfDayUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private var todayKey: String {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }

    private func launch(_ extra: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-subscribed", "1", "-hasCompletedOnboarding", "1",
                               "-appLanguageOverride", "en", "-resetWordOfDay", "1",
                               "-routine_intentions", "{\"\(todayKey)\" = \"Patience with my family today\";}"] + extra
        app.launch()
        return app
    }

    private func any(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any).matching(NSPredicate(format: predicate)).firstMatch
    }

    func testTheChosenWordShowsOnTodayAndOnTheWordScreen() {
        let app = launch(["-fakeJevPick", "mateus-5-4-en"])
        let card = any("label CONTAINS 'Matthew 5:4'", in: app)
        XCTAssertTrue(card.waitForExistence(timeout: 10), "a palavra escolhida não apareceu no Hoje")
        XCTAssertTrue(any("label CONTAINS[c] 'Chosen from what you wrote'", in: app).exists, "a palavra escolhida ficou sem o rótulo")

        card.tap()
        XCTAssertTrue(app.staticTexts["Matthew 5:4"].waitForExistence(timeout: 5), "a tela da palavra mostrou outro versículo")
        XCTAssertTrue(any("label CONTAINS[c] 'Chosen from what you wrote'", in: app).exists)
    }

    func testARiskSignBringsTheCrisisCard() {
        let app = launch(["-fakeJevPick", "crisis"])
        XCTAssertTrue(app.staticTexts["What you wrote calls for care"].waitForExistence(timeout: 10)
                      || app.otherElements["crisisSupportCard"].exists,
                      "o sinal de risco não trouxe a orientação de crise")
    }

    func testPersonalizationOffKeepsTheDateDraw() {
        let app = launch(["-fakeJevPick", "mateus-5-4-en", "-jev_personalization_enabled", "NO"])
        XCTAssertTrue(any("label CONTAINS 'Word of the day' OR label CONTAINS[c] 'Today' ", in: app).waitForExistence(timeout: 10))
        XCTAssertFalse(any("label CONTAINS[c] 'Chosen from what you wrote'", in: app).waitForExistence(timeout: 3),
                       "com a personalização desligada, nada deveria ser escolhido")
    }
}
