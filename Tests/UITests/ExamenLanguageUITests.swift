import XCTest

/// The Examen. Its chrome was the last tab still showing Portuguese in every
/// language: the step counter, the "nothing written" placeholder, and the
/// 9:30 PM hour, which the home card localized but this screen printed raw.
///
/// The four step titles are content, not chrome — they name the parts of the
/// Ignatian Examen and come from the same catalog the flow itself reads, so the
/// history can't drift from the flow.
final class ExamenLanguageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        // No -appLanguageOverride: it would outrank what the picker writes.
        app.launchArguments = ["-subscribed", "1", "-hasCompletedOnboarding", "1", "-openScreen", "settings"]
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

    /// The nightly card carries the hour, which must read in the viewer's clock
    /// convention rather than as a fixed "21H30".
    func testNightlyCardShowsALocalizedHour() {
        let app = launch()
        choose("English", in: app)

        let card = button("label CONTAINS[c] 'TONIGHT'", in: app)
        XCTAssertTrue(card.waitForExistence(timeout: 10), "o card noturno não seguiu o idioma")
        XCTAssertTrue(card.label.contains("9:30"), "a hora não foi formatada em inglês: \(card.label)")
    }

    /// Inside the flow: the step counter is chrome and must follow the language.
    func testStepCounterFollowsTheLanguage() {
        let app = launch()
        choose("English", in: app)

        let card = button("label CONTAINS[c] 'TONIGHT'", in: app)
        XCTAssertTrue(card.waitForExistence(timeout: 10))
        // The card sits at the bottom of the scroll, and at the initial offset
        // its centre falls under the floating tab bar — which swallows the tap.
        // A person scrolls to it first; so does this.
        app.swipeUp()
        XCTAssertTrue(card.waitForExistence(timeout: 5), "o card noturno saiu de vista ao rolar")
        tapMiddle(card)

        let start = button("label CONTAINS[c] 'Start the Examen' OR label CONTAINS[c] 'Begin'", in: app)
        XCTAssertTrue(start.waitForExistence(timeout: 5), "a intro do Exame não abriu")
        tapMiddle(start)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'STEP 1 OF'")).firstMatch.waitForExistence(timeout: 5),
            "o contador de passos continuou em português"
        )
    }

    func testNightlyCardBackInPortuguese() {
        let app = launch()
        choose("Português", in: app)

        let card = button("label CONTAINS[c] 'À NOITE'", in: app)
        XCTAssertTrue(card.waitForExistence(timeout: 10), "o card noturno não voltou ao português")
        XCTAssertTrue(card.label.contains("21:30"), "a hora não saiu no formato de 24h: \(card.label)")
    }
}
