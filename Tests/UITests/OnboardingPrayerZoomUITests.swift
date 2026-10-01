import XCTest

/// Screenshots of the Our Father zoom (`onboardingPrayerEmphasis`) in the
/// three app languages, English and Spanish above all: they're longer than
/// Portuguese and were never actually verified to fit.
///
/// Reaching the prayer screen by walking the onboarding's ~9 screens by hand,
/// in three languages, would be slow and brittle to automate from scratch —
/// especially since the questionnaire in the middle branches on answers. So
/// this jumps straight there with `-openScreen prayer` (see AppRootView),
/// instead of duplicating `OnboardingStoryUITests.testStoryBeatsInPortuguese`,
/// which already covers the full flow (in Portuguese only) and its own timing
/// assertions.
final class OnboardingPrayerZoomUITests: XCTestCase {

    /// The emphasized text is laid out at 27pt on its final three lines and
    /// grows by scale from the resting 17pt look: 1.588x in theory, measured
    /// ~66.7pt resting → 106pt emphasized on the iPhone 17 Pro Max. 1.4 leaves
    /// room for rendering differences across simulators while still catching
    /// a regression that stops the text from growing.
    private let minGrowthRatio: CGFloat = 1.4
    /// Height of 3 lines at 27pt (MissaleFont.body) plus ~15% slack.
    /// Measured at exactly 106pt on both iPhone 17 (C99CC429) and iPhone 17e
    /// (685F7BF9), in pt, en and es alike — the line count, not the text
    /// length, drives the height. A 4th line (~141pt) clears this by a wide
    /// margin.
    private let maxEmphasisHeight: CGFloat = 122

    override func setUp() {
        continueAfterFailure = false
    }

    private func snapshot(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func abrir(_ language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1",
                               "-appLanguageOverride", language, "-openScreen", "prayer"]
        app.launch()
        return app
    }

    private func capturaDoZoom(language: String, prayerStart: String, screenshotName: String) {
        let app = abrir(language)
        let pray = app.buttons[prayerStart]
        XCTAssertTrue(pray.waitForExistence(timeout: 15), "o botão de rezar não apareceu (\(language))")
        let emphasis = app.staticTexts["onboardingPrayerEmphasis"]
        XCTAssertTrue(emphasis.exists, "o corpo do convite precisa estar na tela antes do zoom (\(language))")
        let restingHeight = emphasis.frame.height
        pray.tap()

        // 0.2 + 0.7 + 0.9 s: mesma soma das três capturas intermediárias de
        // OnboardingStoryUITests, tempo suficiente para o spring de
        // crescimento (0.9 s) assentar, ainda dentro do hold de 4.5 s.
        usleep(1_800_000)

        XCTAssertTrue(emphasis.exists, "o texto ampliado sumiu antes da hora (\(language))")
        let emphasizedFrame = emphasis.frame

        // Sanity check: o texto ampliado não pode sair dos limites da janela,
        // precisa ter crescido de verdade, e não pode passar do teto de 3
        // linhas a 27pt (ver as constantes no topo da classe).
        let windowFrame = app.windows.firstMatch.frame
        XCTAssertTrue(windowFrame.contains(emphasizedFrame), "o texto ampliado saiu dos limites da janela (\(language))")
        XCTAssertGreaterThanOrEqual(
            emphasizedFrame.height, restingHeight * minGrowthRatio,
            "o texto não cresceu o suficiente em \(language) (repouso: \(restingHeight), ampliado: \(emphasizedFrame.height))"
        )
        XCTAssertLessThanOrEqual(
            emphasizedFrame.height, maxEmphasisHeight,
            "o texto ampliado passou do teto de 3 linhas em \(language) (altura: \(emphasizedFrame.height))"
        )

        snapshot(app, screenshotName)
    }

    func testZoomInPortuguese() {
        capturaDoZoom(language: "pt", prayerStart: "Vamos rezar juntos", screenshotName: "zoom-pt")
    }

    func testZoomInEnglish() {
        capturaDoZoom(language: "en", prayerStart: "Let's pray together", screenshotName: "zoom-en")
    }

    func testZoomInSpanish() {
        capturaDoZoom(language: "es", prayerStart: "Recemos juntos", screenshotName: "zoom-es")
    }
}
