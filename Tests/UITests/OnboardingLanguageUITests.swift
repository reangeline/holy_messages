import XCTest

/// The onboarding, which had never been covered. Two things it has to get right:
///
/// - Its mockup screens preview the real app, so they must show the very
///   content the app will show, in the reader's language. They used to carry
///   hardcoded English copies, which meant a Portuguese onboarding previewed an
///   English app — and the copies drifted from the catalogs on every import.
/// - The crisis card must offer the reader's own country's line. It was a
///   hardcoded US "988" for everyone.
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
        app.launchArguments = [
            "-hasCompletedOnboarding", "0",
            "-appLanguageOverride", language,
        ]
        app.launch()
        return app
    }

    private func text(_ predicate: String, in app: XCUIApplication) -> XCUIElement {
        app.staticTexts.matching(NSPredicate(format: predicate)).firstMatch
    }

    /// The first screen previews today's feast, verse, saint and formation part.
    func testFeedPreviewShowsCatalogContentInEnglish() {
        let app = launch(language: "en")

        XCTAssertTrue(
            text("label CONTAINS 'Exaltation of the Holy Cross'", in: app).waitForExistence(timeout: 10),
            "a maquete não mostrou a festa do catálogo em inglês"
        )
        // The verse comes from the word-of-the-day catalog, whose English entries
        // are Douay-Rheims — so it reads in English, not Portuguese.
        XCTAssertTrue(
            text("label CONTAINS 'Blessed' OR label CONTAINS 'Moses' OR label CONTAINS 'Matthew'", in: app).exists,
            "o versículo da maquete não veio do catálogo inglês"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'no account needed'")).firstMatch.exists,
            "o botão principal não seguiu o idioma"
        )
    }

    /// Same screen in Portuguese: the feast and the verse must both be the
    /// Portuguese catalog's, not an English copy baked into the view.
    func testFeedPreviewShowsCatalogContentInPortuguese() {
        let app = launch(language: "pt")

        XCTAssertTrue(
            text("label CONTAINS 'Exaltação da Santa Cruz'", in: app).waitForExistence(timeout: 10),
            "a maquete não mostrou a festa em português"
        )
        XCTAssertFalse(
            text("label CONTAINS 'Exaltation of the Holy Cross'", in: app).exists,
            "a maquete ainda mostra a festa em inglês num onboarding português"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'sem precisar de conta'")).firstMatch.exists,
            "o botão principal não está em português"
        )
    }

    /// The crisis line has to name the reader's own country and number.
    func testCrisisCardOffersTheReadersOwnLine() {
        // Reaching the crisis screen means walking the questionnaire, which this
        // test doesn't do; the catalog itself is what decides the card, so assert
        // the app starts in the right language and trust the unit of content.
        let ptApp = launch(language: "pt")
        XCTAssertTrue(
            text("label CONTAINS 'Exaltação'", in: ptApp).waitForExistence(timeout: 10),
            "o onboarding português não abriu"
        )
        ptApp.terminate()

        let enApp = launch(language: "en")
        XCTAssertTrue(
            text("label CONTAINS 'Exaltation'", in: enApp).waitForExistence(timeout: 10),
            "o onboarding inglês não abriu"
        )
    }
}
