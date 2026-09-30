import XCTest

/// Walks the story beats wrapped around the questionnaire — verse, promise,
/// reflection, guided prayer, commitment — in Portuguese, up to the
/// notification screen. Leaves `hasCompletedOnboarding` false, like the other
/// onboarding tests.
final class OnboardingStoryUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func snapshot(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testStoryBeatsInPortuguese() {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1",
            "-demoDate", "2026-09-14",
            "-hasCompletedOnboarding", "0",
            "-appLanguageOverride", "pt",
        ]
        app.launch()

        // Verse plays on its own, then the promise offers "Começar".
        let begin = app.buttons["Começar"]
        XCTAssertTrue(begin.waitForExistence(timeout: 30), "a tela-ponte não apareceu depois do versículo")
        sleep(1)
        snapshot(app, "1-promessa")
        begin.tap()

        // Choosing an answer on the first question shows its reflection.
        let returning = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Voltando depois'")).firstMatch
        XCTAssertTrue(returning.waitForExistence(timeout: 10))
        returning.tap()
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'O pai correu'")).firstMatch.waitForExistence(timeout: 5),
            "a reflexão da resposta não apareceu"
        )
        snapshot(app, "2-reflexao")
        app.buttons["Continuar"].tap()

        for option in ["Algumas vezes por mês", "Constância", "Prefiro não dizer"] {
            if option == "Prefiro não dizer" {
                XCTAssertTrue(app.buttons["Casamento civil"].waitForExistence(timeout: 5), "falta casamento civil")
                XCTAssertTrue(app.buttons["Casamento religioso"].exists, "falta casamento religioso")
                XCTAssertFalse(app.buttons["Vida consagrada / religiosa"].exists, "vida consagrada ainda aparece no estado de vida")
                snapshot(app, "2a-estado-de-vida")
            }
            let chip = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", option)).firstMatch
            XCTAssertTrue(chip.waitForExistence(timeout: 5), "não achei a opção \(option)")
            chip.tap()
            app.buttons["Continuar"].tap()
        }

        let skipSpiritual = app.buttons["Pular as quatro"]
        XCTAssertTrue(skipSpiritual.waitForExistence(timeout: 5))
        snapshot(app, "2b-intro-espiritual")
        app.buttons["Vou responder"].tap()
        XCTAssertTrue(app.buttons["Eu oro com o coração"].waitForExistence(timeout: 5), "a nova opção de oração não apareceu")
        snapshot(app, "2b-oracao-com-o-coracao")
        app.buttons["Pular as quatro"].tap()

        // Relief, then the guided prayer.
        let reliefContinue = app.buttons["Continuar"]
        XCTAssertTrue(reliefContinue.waitForExistence(timeout: 5))
        snapshot(app, "2c-alivio")
        reliefContinue.tap()

        let pray = app.buttons["Vamos rezar juntos"]
        XCTAssertTrue(pray.waitForExistence(timeout: 10), "o momento de oração não apareceu")
        sleep(2) // Aguarda o curtain terminar o fade para a captura não sair escura.
        snapshot(app, "3-oracao-intro")
        let emphasis = app.staticTexts["onboardingPrayerEmphasis"]
        XCTAssertTrue(emphasis.exists, "o corpo do convite ao Pai-Nosso precisa estar na tela antes do zoom")
        XCTAssertEqual(
            emphasis.label,
            "Vamos rezar o Pai-Nosso devagar, com atenção, meditando cada palavra.",
            "o destaque precisa usar o convite completo"
        )
        let emphasisStartedAt = Date()
        pray.tap()
        usleep(200_000)
        snapshot(app, "3a-pai-nosso-zoom-inicio")
        usleep(700_000)
        snapshot(app, "3b-pai-nosso-zoom-meio")
        usleep(900_000)
        snapshot(app, "3c-pai-nosso-zoom-fim")
        XCTAssertTrue(emphasis.waitForNonExistence(timeout: 2.5), "o zoom no Pai-Nosso não terminou após os 2 segundos")
        XCTAssertGreaterThanOrEqual(
            Date().timeIntervalSince(emphasisStartedAt), 1.8,
            "o zoom permaneceu na tela por menos de 2 segundos"
        )

        sleep(6)
        snapshot(app, "4-respiracao")
        sleep(9)
        snapshot(app, "5-pai-nosso")

        let prayed = app.staticTexts["Sua primeira oração no Missale"]
        XCTAssertTrue(prayed.waitForExistence(timeout: 90), "a tela de marco não apareceu")
        sleep(3)
        snapshot(app, "6-marco")

        app.buttons["Continuar"].tap()

        // Synthesis ends with the commitment sentence built from life-1.
        let commitment = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'um dia de cada vez'")).firstMatch
        XCTAssertTrue(commitment.waitForExistence(timeout: 20), "a frase de compromisso não veio da resposta")
        snapshot(app, "7-compromisso")
        app.buttons["Segure para se comprometer"].press(forDuration: 2)

        // The free orientação comes right after the account (-signedIn skips
        // the sign-in step); this story skips it.
        let pular = app.buttons["onboardingOrientationSkip"]
        XCTAssertTrue(pular.waitForExistence(timeout: 10), "a orientação grátis não apareceu depois do compromisso")
        snapshot(app, "8a-orientacao")
        pular.tap()

        XCTAssertTrue(
            app.buttons["Ver como fica"].waitForExistence(timeout: 10),
            "segurar o botão não levou para a tela de notificação"
        )
        snapshot(app, "8-depois-do-compromisso")
        app.buttons["Ver como fica"].tap()
        XCTAssertTrue(
            app.staticTexts["Palavra de hoje"].waitForExistence(timeout: 5),
            "a prévia não mostra o aviso que o app envia de verdade"
        )
        snapshot(app, "9-previa-aviso")
    }
}
