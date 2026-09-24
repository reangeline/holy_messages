import XCTest

/// The account is required: a reader who finished the onboarding but has no
/// session (everyone who installed before accounts existed) meets the sign-in
/// screen, not the app. The sign-in itself can't run here — the simulator has
/// no human at the Apple sheet — so the rest of the suite passes -signedIn.
final class SignInGateUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testWithoutAnAccountTheAppAsksToSignIn() {
        let app = XCUIApplication()
        app.launchArguments = ["-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1", "-appLanguageOverride", "pt"]
        app.launch()

        XCTAssertTrue(app.buttons["signInWithApple"].waitForExistence(timeout: 15), "a tela de entrar não apareceu")
        XCTAssertTrue(app.staticTexts["Crie sua conta no Missale"].exists)
        XCTAssertFalse(app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Hoje'")).firstMatch.exists,
                       "o app abriu sem conta")
    }

    func testSignedInOpensTheApp() {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1", "-appLanguageOverride", "pt"]
        app.launch()

        XCTAssertFalse(app.buttons["signInWithApple"].waitForExistence(timeout: 5))
    }
}
