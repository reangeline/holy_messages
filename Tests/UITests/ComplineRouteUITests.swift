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

    /// Opens the Examen intro straight from the DEBUG launch argument, then
    /// taps the link to Compline.
    ///
    /// It used to get there by tapping the nightly card on Today. That tap was
    /// the flakiest step in the suite: the card is the last item in the scroll,
    /// the floating tab bar covers part of it, and how much depends on the
    /// language of the card's own text — so a fixed offset passed in one
    /// language and missed in another, three fixes in a row. The card's own
    /// route is covered by ExamenLanguageUITests; this file is about Compline.
    private func openCompline(_ language: String, _ app: XCUIApplication) {
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1", "-hasCompletedOnboarding", "1", "-appLanguageOverride", language,
                               "-openScreen", "examen"]
        app.launch()

        // O link fica abaixo do botão principal e, em inglês e espanhol, os
        // subtítulos dos quatro passos são mais longos: ele nasce fora da
        // dobra. Uma ScrollView do SwiftUI não constrói o que está fora de
        // vista, então rola-se primeiro e só depois espera-se por ele.
        let link = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'direto às Completas' OR label CONTAINS[c] 'straight to Compline' OR label CONTAINS[c] 'directo a Completas'")
        ).firstMatch
        for _ in 0..<5 where !link.exists || !link.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(link.waitForExistence(timeout: 10), "a intro do Exame não oferece as Completas")
        XCTAssertTrue(link.isHittable, "o link das Completas não ficou tocável")
        link.tap()
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
