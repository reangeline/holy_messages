import XCTest

/// The subscription screen, in the state the test environment can actually
/// reproduce: no App Store.
///
/// A UI test cannot give the app under test a local StoreKit configuration —
/// the configuration attaches to Xcode's Run action, and `SKTestSession`
/// configures the test process, not the separate app process. So what is
/// covered here is the branch that matters most for honesty: with no products,
/// the screen must say so and offer to carry on free. It must never fall back
/// to a price of its own, which is exactly what it used to do — three plans
/// with prices written into the source, one of them a "Lifetime" with no
/// product behind it.
///
/// The loaded state is verified by running from Xcode with
/// Tests/Support/Missale.storekit, which is also how the App Store review
/// screenshot is taken — see capturas-appstore/LEIA.md.
final class PaywallUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func abrir(_ language: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-hasCompletedOnboarding", "1", "-appLanguageOverride", language,
                               "-openScreen", "paywall"]
        app.launch()
        return app
    }

    func testWithNoStoreItSaysSoInsteadOfShowingAPrice() {
        let app = abrir("pt")
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Não foi possível consultar a App Store'")).firstMatch.waitForExistence(timeout: 15),
            "o paywall não declarou que não conseguiu carregar os planos"
        )
        // Nenhum dos preços que estavam cravados pode aparecer.
        for preco in ["34,90", "199,90", "649,90", "39.99", "129.99"] {
            XCTAssertFalse(
                app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", preco)).firstMatch.exists,
                "o paywall voltou a mostrar o preço cravado \(preco)"
            )
        }
    }

    /// And the fabricated rating must not come back.
    func testTheInventedRatingIsGone() {
        let app = abrir("pt")
        _ = app.staticTexts.firstMatch.waitForExistence(timeout: 15)
        for inventado in ["4.8", "12,4 mil", "12.4K", "★★★★★"] {
            XCTAssertFalse(
                app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", inventado)).firstMatch.exists,
                "a avaliação inventada (\(inventado)) voltou ao paywall"
            )
        }
    }

    /// Without a product there is nothing to buy, so the button offers the
    /// truth: carry on free. It used to promise thirty free days and close.
    func testTheButtonOffersToCarryOnFreeWhenThereIsNothingToBuy() {
        let app = abrir("pt")
        let botao = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Continuar de graça'")).firstMatch
        XCTAssertTrue(botao.waitForExistence(timeout: 15), "o botão não oferece continuar de graça")
        XCTAssertFalse(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '30 dias'")).firstMatch.exists,
            "o botão voltou a prometer 30 dias sem saber se o produto os oferece"
        )
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Restaurar compras'")).firstMatch.exists,
            "restaurar compras desapareceu (diretriz 3.1.1)"
        )
    }

    /// Settings must not claim a subscription nobody bought.
    func testSettingsReportsNoSubscription() {
        let app = XCUIApplication()
        app.launchArguments = ["-hasCompletedOnboarding", "1", "-appLanguageOverride", "pt",
                               "-openScreen", "settings"]
        app.launch()

        let linha = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Assinatura'")).firstMatch
        for _ in 0..<8 where !linha.exists || !linha.isHittable { app.swipeUp() }
        XCTAssertTrue(linha.waitForExistence(timeout: 10), "não achei a linha de assinatura")
        linha.tap()

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Nenhuma assinatura neste aparelho'")).firstMatch.waitForExistence(timeout: 5),
            "a tela não declara que não há assinatura"
        )
        for falso in ["ACTIVE", "ATIVA", "39.99", "14 de outubro"] {
            XCTAssertFalse(
                app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", falso)).firstMatch.exists,
                "a assinatura falsa voltou: \(falso)"
            )
        }
    }
}
