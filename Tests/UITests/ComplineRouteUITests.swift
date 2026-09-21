import XCTest

/// Compline had no way in. The rewritten Examen flow (`f268d70`) dropped the
/// link, so `ComplineView` was reachable only from its own `#Preview`, while
/// the Today card kept promising "Daily Examen and Compline" and the paywall
/// kept listing it as a feature. The Examen intro now carries the link the
/// orphaned "Ir direto às Completas" string was written for.
final class ComplineRouteUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func openCompline(_ language: String, _ app: XCUIApplication) {
        app.launchArguments = ["-hasCompletedOnboarding", "1", "-appLanguageOverride", language]
        app.launch()

        let nightly = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'À NOITE' OR label CONTAINS[c] 'TONIGHT' OR label CONTAINS[c] 'NOCHE'")
        ).firstMatch
        XCTAssertTrue(nightly.waitForExistence(timeout: 15), "não achei o cartão noturno")

        // O cartão fica no fim da rolagem, e no deslocamento inicial seu centro
        // cai sob a barra flutuante de abas, que engole o toque. Rola até ele
        // ficar de fato tocável, em vez de deslizar uma vez e esperar dar certo.
        for _ in 0..<4 where !nightly.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(nightly.isHittable, "o cartão noturno não ficou tocável")
        nightly.tap()

        let link = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'direto às Completas' OR label CONTAINS[c] 'straight to Compline' OR label CONTAINS[c] 'directo a Completas'")
        ).firstMatch
        XCTAssertTrue(link.waitForExistence(timeout: 5), "a intro do Exame não oferece as Completas")
        link.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    /// The psalm label is the same in all three languages, so it marks arrival.
    func testTheExamenIntroReachesCompline() {
        let app = XCUIApplication()
        openCompline("pt", app)
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'SALMO 91'")).firstMatch.waitForExistence(timeout: 5),
            "as Completas não abriram"
        )
    }

    /// Each language must show its own edition, not Portuguese.
    func testComplineShowsTheSpanishEdition() {
        let app = XCUIApplication()
        openCompline("es", app)
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Conviértenos'")).firstMatch.waitForExistence(timeout: 5),
            "a abertura não saiu na edição espanhola"
        )
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Torres Amat'")).firstMatch.exists,
            "a tela não declara a edição citada"
        )
    }

    func testComplineShowsTheEnglishEdition() {
        let app = XCUIApplication()
        openCompline("en", app)
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Convert us, O God'")).firstMatch.waitForExistence(timeout: 5),
            "a abertura não saiu na edição inglesa"
        )
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Douay-Rheims'")).firstMatch.exists,
            "a tela não declara a edição citada"
        )
    }
}
