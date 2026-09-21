import XCTest

/// Settings used to open a screen that said "This text hasn't been written
/// yet" where the terms and the privacy policy belong — which is also a screen
/// the App Store requires next to a subscription. Both documents now ship with
/// the app and open in the reader's language.
final class LegalDocumentUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func openSettings(_ language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-hasCompletedOnboarding", "1", "-appLanguageOverride", language,
                               "-openScreen", "settings"]
        app.launch()
        return app
    }

    /// Scrolls until the row exists and can be tapped: the legal rows sit at
    /// the bottom of a long list, and a SwiftUI ScrollView doesn't build what
    /// is off screen.
    private func row(_ app: XCUIApplication, matching predicate: String) -> XCUIElement {
        let alvo = app.buttons.matching(NSPredicate(format: predicate)).firstMatch
        for _ in 0..<10 where !alvo.exists || !alvo.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(alvo.waitForExistence(timeout: 5), "não achei a linha (\(predicate))")
        return alvo
    }

    func testThePrivacyPolicyOpensInPortuguese() {
        let app = openSettings("pt")
        row(app, matching: "label CONTAINS[c] 'privacidade'").tap()

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'não faz nenhuma requisição de rede'")).firstMatch.waitForExistence(timeout: 5),
            "a política não abriu, ou não afirma o que o app cumpre"
        )
        XCTAssertFalse(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'ainda não foi escrito'")).firstMatch.exists,
            "o placeholder voltou"
        )
    }

    func testTheTermsOpenInSpanish() {
        let app = openSettings("es")
        row(app, matching: "label CONTAINS[c] 'érminos' OR label CONTAINS[c] 'terminos'").tap()

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'se renueva automáticamente'")).firstMatch.waitForExistence(timeout: 5),
            "os termos não abriram em espanhol, ou não falam da renovação"
        )
    }

    /// The data screen must no longer offer what the app doesn't do.
    func testTheDataScreenOffersNothingItCannotDo() {
        let app = openSettings("pt")
        row(app, matching: "label CONTAINS[c] 'Seus dados' OR label CONTAINS[c] 'dados'").tap()

        // A oferta é o interruptor, não a palavra: a tela agora *menciona*
        // analytics para dizer que não tem, e isso deve continuar aparecendo.
        XCTAssertEqual(app.switches.count, 0,
                       "a tela de dados ainda tem interruptor — sincronização ou analytics voltaram")
        for ausente in ["Sincronizar", "PDF", "JSON"] {
            XCTAssertFalse(
                app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", ausente)).firstMatch.exists,
                "a tela de dados ainda oferece \(ausente), que o app não faz"
            )
        }
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'não tem analytics'")).firstMatch.exists,
            "a tela deixou de declarar que não há analytics"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Apagar tudo'")).firstMatch.exists,
            "o botão de apagar desapareceu"
        )
    }
}
