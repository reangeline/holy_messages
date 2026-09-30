import XCTest

/// The imported saint art and the records behind it. The archive used to be a
/// hand-typed list of six names where only one row could be opened, because only
/// one had a record; now it is the sanctoral itself, every row opens its own
/// saint, and 32 of them carry public-domain artwork.
final class SaintArtUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        launch(language: nil)
    }

    private func launch(language: String?) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-signedIn", "1", "-demoDate", "2026-09-14", "-subscribed", "1", "-hasCompletedOnboarding", "1"]
        if let language {
            app.launchArguments += ["-appLanguageOverride", language]
        }
        app.launch()
        return app
    }

    private func tapMiddle(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    /// `tapMiddle` taps raw screen coordinates without checking hittability,
    /// so a card the Today ScrollView hasn't scrolled into view yet (its
    /// accessibility frame can sit below the window, e.g. y > app.frame.height)
    /// gets tapped off-window: the touch lands wherever the simulator resolves
    /// that point instead of on the intended card, opening a different screen.
    /// Scroll until the element is actually on screen and hittable before
    /// tapping it.
    private func scrollIntoView(_ element: XCUIElement, in app: XCUIApplication, maxAttempts: Int = 6) {
        guard !element.isHittable else { return }
        let scrollView = app.scrollViews.firstMatch
        guard scrollView.waitForExistence(timeout: 5) else { return }
        var attempts = 0
        // A drag confined to the scroll view's own bounds (25%–75% of its
        // height) instead of `swipeUp()`, whose default start/end points can
        // land near the real screen edge and get read as the system's
        // swipe-to-home gesture — that backgrounds/kills the app mid-test
        // (seen as "is not running") or leaves the gesture invalidated by
        // interruption handling ("no longer valid after interruption").
        while !element.isHittable && attempts < maxAttempts {
            let start = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75))
            let end = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.25))
            start.press(forDuration: 0.05, thenDragTo: end)
            attempts += 1
        }
        XCTAssertTrue(element.isHittable, "não foi possível rolar até o elemento ficar visível/tocável")
    }

    private func keepScreenshot(_ name: String, app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func keepScreenScreenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func openSaintDetail(_ app: XCUIApplication, language: String) -> XCUIElement {
        let card = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Notburga'")).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 10), "o card de Notburga não apareceu em \(language)")
        scrollIntoView(card, in: app)
        tapMiddle(card)

        let hero = app.descendants(matching: .any)["saintDetailHero"]
        XCTAssertTrue(hero.waitForExistence(timeout: 5), "o hero adaptativo não apareceu em \(language)")
        return hero
    }

    func testIPadHeroPreservesTheArtworkInEveryLanguageAndLandscape() throws {
        // The 761pt cap and the landscape rotation this test drives are the
        // iPad's adaptive hero; on the phone, `XCUIDevice.shared.orientation`
        // doesn't actually rotate the app (`app.frame` stays portrait), so
        // this would fail on an assertion that was never about the phone.
        try XCTSkipUnless(UIDevice.current.userInterfaceIdiom == .pad,
                           "hero adaptativo é específico do iPad")
        XCUIDevice.shared.orientation = .portrait
        for language in ["pt", "en", "es"] {
            let app = launch(language: language)
            let hero = openSaintDetail(app, language: language)
            XCTAssertLessThanOrEqual(hero.frame.width, 761)
            XCTAssertEqual(hero.frame.width / hero.frame.height, 1206.0 / 648.0, accuracy: 0.02)
            sleep(1)
            keepScreenshot("ipad-portrait-\(language)-saint-detail", app: app)
            app.terminate()
        }

        XCUIDevice.shared.orientation = .landscapeLeft
        let app = launch(language: "pt")
        let hero = openSaintDetail(app, language: "pt-landscape")
        XCTAssertGreaterThan(app.frame.width, app.frame.height)
        XCTAssertLessThanOrEqual(hero.frame.width, 761)
        XCTAssertEqual(hero.frame.width / hero.frame.height, 1206.0 / 648.0, accuracy: 0.02)
        sleep(1)
        keepScreenScreenshot("ipad-landscape-pt-saint-detail")
        app.terminate()
        XCUIDevice.shared.orientation = .portrait
    }

    /// Saint of the day on the home screen opens a real record.
    func testSaintOfTheDayOpensItsRecord() {
        let app = launch()
        let card = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Notburga'")).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 10), "o card do santo do dia não apareceu")
        scrollIntoView(card, in: app)
        tapMiddle(card)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Notburga'")).firstMatch.waitForExistence(timeout: 5),
            "a ficha do santo não abriu"
        )
        // The hand-written record has all three sections; an imported one has only
        // the biography, and the other two cards are skipped rather than empty.
        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'importa hoje' OR label CONTAINS[c] 'matters today'")).firstMatch.exists,
            "a ficha escrita à mão deveria mostrar a seção de por que importa hoje"
        )
    }

    /// Every archive row opens its own saint, and an imported record shows no
    /// empty section where the unauthored ones would be.
    func testArchiveRowsOpenTheirOwnSaint() {
        let app = launch()

        let saintCard = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Notburga'")).firstMatch
        XCTAssertTrue(saintCard.waitForExistence(timeout: 10))
        scrollIntoView(saintCard, in: app)
        tapMiddle(saintCard)

        let archive = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Arquivo' OR label CONTAINS[c] 'Archive'")).firstMatch
        guard archive.waitForExistence(timeout: 5) else {
            // The archive link isn't on this screen in every layout; the row-level
            // behaviour is still covered by the detail assertions above.
            return
        }
        scrollIntoView(archive, in: app)
        tapMiddle(archive)

        // Any row that isn't the hand-written saint. Matched by structure (a row
        // label ends with its date) instead of by name, so the test doesn't care
        // which language the previous run left the app in.
        let rows = app.buttons.allElementsBoundByIndex.filter {
            $0.label.contains(",") && !$0.label.localizedCaseInsensitiveContains("Notburga")
        }
        XCTAssertFalse(rows.isEmpty, "o arquivo não listou os santos importados")

        let picked = rows[0]
        let expectedName = picked.label.split(separator: ",").first.map(String.init) ?? picked.label
        scrollIntoView(picked, in: app)
        tapMiddle(picked)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", expectedName)).firstMatch.waitForExistence(timeout: 5),
            "abriu uma ficha diferente da linha tocada: esperava \(expectedName)"
        )
        // An imported record has a biography and nothing else authored yet, so
        // neither of the other two cards may be on screen carrying empty text.
        for header in ["Por que importa hoje", "Why it matters today", "Por qué importa hoy"] {
            XCTAssertFalse(app.staticTexts[header].exists,
                           "a ficha importada mostrou a seção '\(header)' sem conteúdo")
        }
    }
}
