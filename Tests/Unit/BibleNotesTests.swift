import XCTest
@testable import Missale

@MainActor
final class BibleNotesTests: XCTestCase {
    private var defaults: UserDefaults!
    private var pt: Bible!

    override func setUpWithError() throws {
        defaults = UserDefaults(suiteName: "BibleNotesTests")
        defaults.removePersistentDomain(forName: "BibleNotesTests")
        pt = try XCTUnwrap(BibleCatalog.all.first { $0.language == "pt" })
    }

    /// Full names, their beginnings and the usual abbreviations all land on
    /// the right book, chapter and verse.
    func testReferencesReadTheWayReadersTypeThem() {
        let cases: [(String, String, Int, Int?)] = [
            ("Jo 3,16", "JHN", 3, 16),
            ("joão 3:16", "JHN", 3, 16),
            ("1 Cor 13", "1CO", 13, nil),
            ("1Cor 13.4", "1CO", 13, 4),
            ("Mateus 5", "MAT", 5, nil),
            ("mat 5, 3", "MAT", 5, 3),
            ("Sl 22", "PSA", 22, nil),
        ]
        for (query, book, chapter, verse) in cases {
            let reference = BibleSearch.reference(query, in: pt)
            XCTAssertEqual(reference?.book.id, book, query)
            XCTAssertEqual(reference?.chapter, chapter, query)
            XCTAssertEqual(reference?.verse, verse, query)
        }
        XCTAssertNil(BibleSearch.reference("misericórdia", in: pt), "uma palavra virou referência")
        XCTAssertNil(BibleSearch.reference("Jo 99", in: pt), "um capítulo que não existe virou referência")
    }

    /// Words match ignoring case and accents, and every word must be there.
    func testWordSearchIgnoresAccentsAndNeedsEveryWord() {
        let hits = BibleSearch.verses(matching: "MISERICORDIA pobres", in: pt, limit: 500)
        XCTAssertFalse(hits.isEmpty)
        for hit in hits {
            let text = hit.verse.t.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            XCTAssertTrue(text.contains("misericordia") && text.contains("pobres"), hit.id)
        }
    }

    func testHighlightAndBookmarkToggleAndPersist() {
        let store = BibleNotesStore(defaults: defaults)
        store.toggleHighlight(pt, "JHN", 3, 16)
        XCTAssertTrue(store.isHighlighted(pt, "JHN", 3, 16))
        store.toggleBookmark(pt, "MAT", 5)
        XCTAssertTrue(store.isBookmarked(pt, "MAT", 5))

        let reopened = BibleNotesStore(defaults: defaults)
        XCTAssertTrue(reopened.isHighlighted(pt, "JHN", 3, 16), "a marcação não foi salva")
        XCTAssertEqual(reopened.bookmark(in: pt)?.chapter, 5, "o marcador não foi salvo")

        reopened.toggleHighlight(pt, "JHN", 3, 16)
        reopened.toggleBookmark(pt, "MAT", 5)
        XCTAssertFalse(reopened.isHighlighted(pt, "JHN", 3, 16))
        XCTAssertNil(reopened.bookmark(in: pt))
    }
}
