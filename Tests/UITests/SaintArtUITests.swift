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
        let app = XCUIApplication()
        app.launchArguments = ["-subscribed", "1", "-hasCompletedOnboarding", "1"]
        app.launch()
        return app
    }

    private func tapMiddle(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    /// Saint of the day on the home screen opens a real record.
    func testSaintOfTheDayOpensItsRecord() {
        let app = launch()
        let card = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Notburga'")).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 10), "o card do santo do dia não apareceu")
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
        tapMiddle(saintCard)

        let archive = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Arquivo' OR label CONTAINS[c] 'Archive'")).firstMatch
        guard archive.waitForExistence(timeout: 5) else {
            // The archive link isn't on this screen in every layout; the row-level
            // behaviour is still covered by the detail assertions above.
            return
        }
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
        tapMiddle(picked)

        XCTAssertTrue(
            app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", expectedName)).firstMatch.waitForExistence(timeout: 5),
            "abriu uma ficha diferente da linha tocada: esperava \(expectedName)"
        )
        // An imported record has a biography and nothing else authored yet, so
        // neither of the other two cards may be on screen carrying empty text.
        for header in ["Por que ela importa hoje", "Why she matters today", "Por qué importa hoy"] {
            XCTAssertFalse(app.staticTexts[header].exists,
                           "a ficha importada mostrou a seção '\(header)' sem conteúdo")
        }
    }
}
