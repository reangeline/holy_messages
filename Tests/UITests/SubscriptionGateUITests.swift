import XCTest

/// What the subscription gates, and — more important — what it must never
/// gate.
///
/// The decision for this version was that only the word of the day stays free.
/// Two carve-outs are not commercial and are asserted here so a later change
/// cannot quietly remove them:
///
/// - **The support path.** Logging a state like "culpado" or "sozinho" leads to
///   relief and, when the pattern repeats, to a pastoral screen that ends at
///   the crisis guidance. A paywall between someone in that state and that
///   guidance is the worst thing this app could do.
/// - **A way out of a locked tab.** The first version of the gate dropped the
///   floating tab bar, which left the reader stuck on the locked screen with no
///   route back to Today — and so no route to the support path either.
final class SubscriptionGateUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    /// No subscription: this is the state every one of these tests runs in,
    /// since the simulator has no App Store.
    private func launch(_ language: String = "pt") -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1", "-appLanguageOverride", language]
        app.launch()
        return app
    }

    private func abrirAba(_ app: XCUIApplication, _ rotulo: String) {
        let tab = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", rotulo)).firstMatch
        XCTAssertTrue(tab.waitForExistence(timeout: 15), "não achei a aba \(rotulo)")
        tab.tap()
    }

    // MARK: - O que o muro cobre

    func testTheThreePaidTabsAreLocked() {
        let app = launch()
        for (aba, titulo) in [("Calendário", "O calendário litúrgico"),
                              ("Formação", "Formação"),
                              ("Orações", "Orações e o Terço")] {
            abrirAba(app, aba)
            XCTAssertTrue(
                app.staticTexts[titulo].waitForExistence(timeout: 5),
                "a aba \(aba) não está atrás da assinatura"
            )
            XCTAssertTrue(
                app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Ver os planos'")).firstMatch.exists,
                "a aba \(aba) não oferece ver os planos"
            )
        }
    }

    /// The locked screen must keep the way out. This is the regression that
    /// shipped in the first version of the gate.
    func testALockedTabStillOffersTheWayBack() {
        let app = launch()
        abrirAba(app, "Formação")
        XCTAssertTrue(app.staticTexts["Formação"].waitForExistence(timeout: 5))

        let hoje = app.buttons.matching(NSPredicate(format: "label == 'Hoje'")).firstMatch
        XCTAssertTrue(hoje.exists, "a barra de abas desapareceu na tela bloqueada: a pessoa fica presa")
        hoje.tap()
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'PALAVRA DE HOJE'")).firstMatch.waitForExistence(timeout: 5),
            "não voltei para o Hoje"
        )
    }

    // MARK: - O que o muro não cobre

    func testTheWordOfTheDayIsFree() {
        let app = launch()
        let cartao = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Palavra de hoje'")).firstMatch
        XCTAssertTrue(cartao.waitForExistence(timeout: 15), "o cartão da palavra do dia desapareceu")
        cartao.tap()
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'PALAVRA DO DIA'")).firstMatch.waitForExistence(timeout: 5),
            "a palavra do dia ficou atrás da assinatura"
        )
        XCTAssertFalse(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Ver os planos'")).firstMatch.exists,
            "a palavra do dia abriu um paywall"
        )
    }

    /// The support path, as far as a UI test can drive it: the mood check-in
    /// and the note screen behind it, with no subscription and no paywall.
    ///
    /// It stops at the note screen because the text editor there takes focus
    /// and the keyboard pushes the two buttons out of the accessibility tree,
    /// which made this test brittle in a way that had nothing to do with the
    /// gate. What comes after — the relief, the pastoral screen and the crisis
    /// line — is asserted in `SubscriptionGateTests`, which reads the sources
    /// and fails if a gate ever appears in those files.
    func testTheMoodCheckInIsNeverBehindThePaywall() {
        let app = launch()

        // The afternoon row of "Seu dia com Deus" opens the mood check-in.
        let checkIn = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Como está sendo meu dia'")).firstMatch
        XCTAssertTrue(checkIn.waitForExistence(timeout: 15), "o check-in de humor desapareceu")
        checkIn.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        // Um estado de desolação, que é o caminho que leva ao apoio. Os estados
        // só existem dentro da folha, então achá-los prova que ela abriu.
        let chip = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Culpado' OR label CONTAINS[c] 'Sozinho' OR label CONTAINS[c] 'Luto'")).firstMatch
        XCTAssertTrue(chip.waitForExistence(timeout: 5), "o check-in de humor ficou atrás da assinatura")
        chip.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'O que está acontecendo'")).firstMatch.waitForExistence(timeout: 5),
            "a tela da nota ficou atrás da assinatura"
        )
        XCTAssertFalse(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Ver os planos'")).firstMatch.exists,
            "apareceu um paywall no caminho do apoio"
        )
    }

    /// Settings has to stay reachable: it is where cancelling, the language,
    /// and the two legal documents live.
    func testSettingsAndTheLegalDocumentsStayFree() {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1", "-appLanguageOverride", "pt",
                               "-openScreen", "settings"]
        app.launch()

        let privacidade = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'privacidade'")).firstMatch
        for _ in 0..<10 where !privacidade.exists || !privacidade.isHittable { app.swipeUp() }
        XCTAssertTrue(privacidade.waitForExistence(timeout: 5), "não achei a política de privacidade")
        privacidade.tap()
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'O que você escreve e registra fica no seu aparelho'")).firstMatch.waitForExistence(timeout: 5),
            "a política de privacidade ficou atrás da assinatura"
        )
    }
}
