import XCTest

/// The orientação from the reader's side: write, receive a reviewed reply;
/// crisis guidance first when the text carries a risk; the chips when the
/// answer isn't clear; the plans when there is no subscription.
///
/// `-fakeOrientation` answers without the network (see
/// `OrientationService.debugFakeResult`) — the simulator has no subscription
/// for the Missale API to verify, and the tests must not depend on Jev.
final class OrientationUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func abrirCheckIn(fake: String?, subscribed: Bool = true) -> XCUIApplication {
        let app = XCUIApplication()
        var args = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "1", "-appLanguageOverride", "pt"]
        if subscribed { args += ["-subscribed", "1"] }
        if let fake { args += ["-fakeOrientation", fake] }
        app.launchArguments = args
        app.launch()

        let checkIn = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Como está sendo meu dia'")).firstMatch
        XCTAssertTrue(checkIn.waitForExistence(timeout: 15), "o check-in de humor não apareceu")
        checkIn.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        return app
    }

    private func escrever(_ app: XCUIApplication, _ texto: String) {
        let campo = app.textFields["orientationText"].exists ? app.textFields["orientationText"] : app.textViews["orientationText"]
        XCTAssertTrue(campo.waitForExistence(timeout: 5), "a caixa da orientação não apareceu")
        campo.tap()
        campo.typeText(texto)
        let enviar = app.buttons["orientationSend"]
        XCTAssertTrue(enviar.waitForExistence(timeout: 5))
        enviar.tap()
    }

    private func respostaApareceu(_ app: XCUIApplication) -> Bool {
        app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH[c] 'Registrado'")).firstMatch.waitForExistence(timeout: 10)
    }

    func testWritingLeadsToAReviewedReply() {
        let app = abrirCheckIn(fake: "grief")
        escrever(app, "Meu pai faleceu semana passada")
        XCTAssertTrue(respostaApareceu(app), "a resposta da orientação não apareceu")
    }

    func testARiskSignShowsTheCrisisGuidanceFirst() {
        let app = abrirCheckIn(fake: "crisis")
        escrever(app, "Nao vejo saida")
        XCTAssertTrue(app.otherElements["orientationCrisis"].waitForExistence(timeout: 10)
                      || app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'pede cuidado'")).firstMatch.exists,
                      "a orientação de crise não veio primeiro")
        app.buttons["orientationContinue"].tap()
        XCTAssertTrue(respostaApareceu(app), "depois da crise, a palavra não veio")
    }

    /// A reviewed phrase opens the crisis guidance even when the server said nothing.
    func testACrisisPhraseIsCaughtOnTheDevice() {
        let app = abrirCheckIn(fake: "tired")
        escrever(app, "Pensei em me matar")
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'pede cuidado'")).firstMatch.waitForExistence(timeout: 10),
                      "a frase de risco não abriu a orientação de crise")
    }

    func testWhenUnsureTheReaderChoosesAndTheTextGoesAlong() {
        let app = abrirCheckIn(fake: "unsure")
        escrever(app, "Sei la, um dia estranho")
        XCTAssertTrue(app.staticTexts["orientationMessage"].waitForExistence(timeout: 10), "não pediu para escolher o estado")
        // The keyboard must not come back and cover the chips.
        XCTAssertFalse(app.keyboards.firstMatch.exists, "o teclado voltou e cobre os estados")
        let chip = app.buttons.matching(NSPredicate(format: "label == 'Cansado'")).firstMatch
        for _ in 0..<4 where !chip.isHittable { app.swipeUp() }
        XCTAssertTrue(chip.waitForExistence(timeout: 5))
        chip.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        // Straight to the reply: the note was already written.
        XCTAssertTrue(respostaApareceu(app), "o estado escolhido não levou à resposta")
    }

    func testWithoutASubscriptionTheBoxOpensThePlans() {
        let app = abrirCheckIn(fake: "grief", subscribed: false)
        escrever(app, "Meu pai faleceu")
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Restaurar'")).firstMatch.waitForExistence(timeout: 10),
                      "sem assinatura, a orientação não levou aos planos")
    }
}

/// The onboarding's orientação is free: no subscription, no lock, a reply.
final class OnboardingOrientationUITests: XCTestCase {

    func testTheOnboardingOrientationNeedsNoSubscription() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-hasCompletedOnboarding", "0",
                               "-appLanguageOverride", "pt", "-fakeOrientation", "grief", "-openScreen", "onboarding-orientation"]
        app.launch()

        let campo = app.textFields["orientationText"].exists ? app.textFields["orientationText"] : app.textViews["orientationText"]
        XCTAssertTrue(campo.waitForExistence(timeout: 15), "o passo da orientação não abriu")
        XCTAssertFalse(app.images["lock.fill"].exists, "a orientação do onboarding apareceu com cadeado")
        campo.tap()
        campo.typeText("Meu pai faleceu")
        app.buttons["orientationSend"].tap()
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH[c] 'Registrado'")).firstMatch.waitForExistence(timeout: 10),
                      "a orientação grátis não trouxe a resposta")
        XCTAssertTrue(app.buttons["Continuar"].exists, "a resposta no onboarding não leva adiante")
    }
}
