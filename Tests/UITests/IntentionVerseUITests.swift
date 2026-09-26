import XCTest

/// The morning intention's verse, with Jev faked offline (`-fakeJevPick`, see
/// JevPicker.debugFakeResult): after the intention is saved, Today shows the
/// chosen verse under it, and Compline recalls the intention in the reader's
/// own words with the verse. `-openScreen morning-intention` skips the
/// minute-long guided prayer before the intention box.
final class IntentionVerseUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private let base = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1",
                        "-hasCompletedOnboarding", "1", "-appLanguageOverride", "en"]

    private func text(_ fragment: String, in app: XCUIApplication) -> XCUIElement {
        app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", fragment)).firstMatch
    }

    func testTodayShowsTheVerseAndComplineRecallsIt() {
        // A different text each run, so saving always counts as an edit.
        let intention = "For my father's surgery \(Int(Date().timeIntervalSince1970) % 100_000)"

        let app = XCUIApplication()
        app.launchArguments = base + ["-openScreen", "morning-intention", "-fakeJevPick", "mateus-5-4-en"]
        app.launch()

        let morning = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Morning Offering'")).firstMatch
        XCTAssertTrue(morning.waitForExistence(timeout: 10), "a linha da manhã não apareceu")
        morning.tap()

        let box = app.textViews.firstMatch
        XCTAssertTrue(box.waitForExistence(timeout: 5), "a caixa da intenção não apareceu")
        box.tap()
        box.press(forDuration: 1.0)
        if app.menuItems["Select All"].waitForExistence(timeout: 1) {
            app.menuItems["Select All"].tap()
            box.typeText(XCUIKeyboardKey.delete.rawValue)
        }
        box.typeText(intention)
        app.buttons["Save"].tap()
        let done = app.buttons["Done"]
        XCTAssertTrue(done.waitForExistence(timeout: 5))
        done.tap()

        XCTAssertTrue(text("Chosen from your intention", in: app).waitForExistence(timeout: 5),
                      "o cartão do versículo não apareceu no Hoje")
        XCTAssertTrue(text("For your intention today", in: app).exists)
        XCTAssertTrue(text("Blessed are they that mourn", in: app).exists, "o texto do acervo não apareceu")
        XCTAssertTrue(text("Matthew 5:4", in: app).exists)

        // Compline, through the Examen intro as ComplineRouteUITests does.
        app.terminate()
        app.launchArguments = base + ["-openScreen", "examen"]
        app.launch()
        let link = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'straight to Compline'")).firstMatch
        for _ in 0..<5 where !link.exists || !link.isHittable { app.swipeUp() }
        XCTAssertTrue(link.waitForExistence(timeout: 10), "a intro do Exame não oferece as Completas")
        link.tap()

        let recall = text("This morning you asked for:", in: app)
        for _ in 0..<6 where !recall.exists { app.swipeUp() }
        XCTAssertTrue(recall.waitForExistence(timeout: 5), "as Completas não lembraram a intenção")
        XCTAssertTrue(text(intention, in: app).exists, "a intenção não saiu com as palavras da pessoa")
        XCTAssertTrue(text("Blessed are they that mourn", in: app).exists, "o versículo não saiu nas Completas")
    }

    func testPersonalizationOffShowsNoVerse() {
        let app = XCUIApplication()
        app.launchArguments = base + ["-openScreen", "morning-intention", "-fakeJevPick", "off"]
        app.launch()

        let morning = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Morning Offering'")).firstMatch
        XCTAssertTrue(morning.waitForExistence(timeout: 10))
        morning.tap()
        let box = app.textViews.firstMatch
        XCTAssertTrue(box.waitForExistence(timeout: 5))
        box.tap()
        box.typeText(" again")
        app.buttons["Save"].tap()
        let done = app.buttons["Done"]
        XCTAssertTrue(done.waitForExistence(timeout: 5))
        done.tap()

        XCTAssertTrue(morning.waitForExistence(timeout: 5), "o Hoje não voltou")
        XCTAssertFalse(text("Chosen from your intention", in: app).waitForExistence(timeout: 3),
                       "sem Jev, nenhum versículo deveria aparecer")
    }
}
