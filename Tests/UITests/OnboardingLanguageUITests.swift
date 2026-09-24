import XCTest

/// The onboarding, which had never been covered: its opening verse must be
/// shown in the reader's language.
///
/// These launch with `hasCompletedOnboarding` false, and leave it false: the
/// flow is never completed here, so the tests don't disturb the main app's state.
final class OnboardingLanguageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    /// The language can't be chosen from inside the onboarding — there is no
    /// Settings yet — so here the launch argument is the right tool: it is the
    /// only way to reach the flow in a given language.
    private func launch(language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1",
            "-demoDate", "2026-09-14",
            "-hasCompletedOnboarding", "0",
            "-appLanguageOverride", language,
        ]
        app.launch()
        return app
    }

    private func text(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.staticTexts.matching(NSPredicate(format: predicate)).firstMatch
    }

    /// The first screen reveals a random Gospel verse; its reference must
    /// follow the reader's language.
    func testVerseIntroFollowsEnglish() {
        let app = launch(language: "en")

        XCTAssertTrue(
            text("label CONTAINS 'JOHN' OR label CONTAINS 'MATTHEW'", in: app).waitForExistence(timeout: 20),
            "a referência do versículo não está em inglês"
        )
    }

    func testVerseIntroFollowsPortuguese() {
        let app = launch(language: "pt")

        XCTAssertTrue(
            text("label CONTAINS 'JOÃO' OR label CONTAINS 'MATEUS'", in: app).waitForExistence(timeout: 20),
            "a referência do versículo não está em português"
        )
    }
}
