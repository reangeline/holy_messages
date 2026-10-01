import XCTest
@testable import Missale

/// The passage printed on a relief finds its chapter in the bundled Bible, and
/// marks the verses quoted — in Vulgate numbering for the psalms, though the
/// reference prints the Hebrew one.
final class ReliefPassageTests: XCTestCase {

    private func bible(_ language: AppLanguage) throws -> Bible {
        try XCTUnwrap(BibleCatalog.bible(for: language))
    }

    func testPsalmReferenceMapsHebrewNumberToVulgateChapter() throws {
        let found = try XCTUnwrap(ReliefPassage.resolve("Salmo 23, 1-3", in: bible(.pt)))
        XCTAssertEqual(found.book.id, "PSA")
        XCTAssertEqual(found.chapter, 22)
        XCTAssertEqual(found.verses, 1...3)
    }

    func testSingleVerseAndWholeChapter() throws {
        let one = try XCTUnwrap(ReliefPassage.resolve("Salmo 51, 3", in: bible(.es)))
        XCTAssertEqual(one.chapter, 50)
        XCTAssertEqual(one.verses, 3...3)
        let whole = try XCTUnwrap(ReliefPassage.resolve("Salmo 34", in: bible(.pt)))
        XCTAssertEqual(whole.chapter, 33)
        XCTAssertNil(whole.verses)
    }

    func testEnglishColonStyle() throws {
        let found = try XCTUnwrap(ReliefPassage.resolve("Psalm 69:4", in: bible(.en)))
        XCTAssertEqual(found.chapter, 68)
        XCTAssertEqual(found.verses, 4...4)
    }

    func testOtherBooksKeepTheirNumbers() throws {
        let found = try XCTUnwrap(ReliefPassage.resolve("João 11, 35", in: bible(.pt)))
        XCTAssertEqual(found.book.id, "JHN")
        XCTAssertEqual(found.chapter, 11)
        XCTAssertEqual(found.verses, 35...35)
        let numbered = try XCTUnwrap(ReliefPassage.resolve("1 João 4, 19", in: bible(.pt)))
        XCTAssertEqual(numbered.book.id, "1JN")
        XCTAssertEqual(numbered.chapter, 4)
    }

    /// Where the numberings split psalms there is no safe chapter: no passage.
    func testSplitPsalmAndGarbageResolveToNothing() throws {
        XCTAssertNil(ReliefPassage.resolve("Salmo 10, 1", in: try bible(.pt)))
        XCTAssertNil(ReliefPassage.resolve("Salmo 151", in: try bible(.pt)))
        XCTAssertNil(ReliefPassage.resolve("", in: try bible(.pt)))
        XCTAssertNil(ReliefPassage.resolve("Sem referência", in: try bible(.pt)))
    }

    /// Every psalm the reliefs quote either opens its chapter or is one of the
    /// split ones — never a wrong chapter.
    func testEveryReliefPsalmQuotedResolvesOrIsASplitPsalm() throws {
        let pt = try bible(.pt)
        for n in 1...150 {
            let found = ReliefPassage.resolve("Salmo \(n)", in: pt)
            if let found { XCTAssertEqual(found.book.id, "PSA"); XCTAssertEqual(PsalmNumbering.vulgateToHebrew[found.chapter], ["\(n)"]) }
        }
    }
}
