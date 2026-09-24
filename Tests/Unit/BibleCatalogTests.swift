import XCTest
@testable import Missale

final class BibleCatalogTests: XCTestCase {

    /// The English Bible ships; if the bundle stops carrying it the Bible
    /// screen silently turns into "no Bible in this language".
    func testDouayRheimsIsBundledAndComplete() throws {
        let bible = try XCTUnwrap(BibleCatalog.all.first { $0.id == "douay-rheims-challoner" })
        XCTAssertEqual(bible.language, "en")
        XCTAssertEqual(bible.books.count, 73)
        XCTAssertEqual(BibleCatalog.bible(for: .en)?.id, bible.id)
    }

    /// Portuguese: Matos Soares, public domain confirmed by the project owner.
    func testMatosSoaresIsBundled() throws {
        let bible = try XCTUnwrap(BibleCatalog.bible(for: .pt))
        XCTAssertEqual(bible.id, "matos-soares")
        XCTAssertEqual(bible.license, "public-domain")
        XCTAssertEqual(bible.books.count, 73)
        XCTAssertTrue(bible.usesVulgatePsalms)
        XCTAssertEqual(bible.books.first { $0.id == "LUK" }?.chapters.first { $0.n == 2 }?.verses.count, 52)
    }

    /// Spanish: Torres Amat rebuilt from OCR, with verses still missing —
    /// TestFlight only, which the release gate below enforces.
    func testTorresAmatIsBundled() throws {
        let bible = try XCTUnwrap(BibleCatalog.bible(for: .es))
        XCTAssertEqual(bible.id, "torres-amat")
        XCTAssertEqual(bible.books.count, 73)
        XCTAssertTrue(bible.usesVulgatePsalms)
    }

    /// Every verse taken from another Bible names a source the reader can see.
    func testEverySupplementedVerseHasANamedSource() {
        for bible in BibleCatalog.all {
            let codes = Set(bible.books.flatMap { $0.chapters.flatMap { $0.verses.compactMap(\.s) } })
            for code in codes {
                XCTAssertNotNil(bible.supplements?[code], "\(bible.id): versículos de \(code) sem nome de fonte")
            }
        }
    }

    /// Reference chapters checked against the printed text (see biblias/README.md).
    func testReferenceChapterLengths() throws {
        let bible = try XCTUnwrap(BibleCatalog.bible(for: .en))
        func count(_ book: String, _ chapter: Int) -> Int? {
            bible.books.first { $0.id == book }?.chapters.first { $0.n == chapter }?.verses.count
        }
        XCTAssertEqual(count("LUK", 2), 52)
        XCTAssertEqual(count("MAT", 13), 58)
        XCTAssertEqual(count("JHN", 3), 36)
    }

    func testEveryBibleSplitsIntoBothTestaments() throws {
        for bible in BibleCatalog.all {
            XCTAssertTrue(bible.books.contains { $0.id == BibleBook.firstNewTestamentBook },
                          "\(bible.id): sem \(BibleBook.firstNewTestamentBook), o Novo Testamento some da lista")
            let empty = bible.books.flatMap { b in b.chapters.flatMap { c in c.verses.filter { $0.t.isEmpty }.map { "\(b.id) \(c.n):\($0.n)" } } }
            XCTAssertTrue(empty.isEmpty, "\(bible.id): versículos vazios \(empty.prefix(5))")
        }
    }

    /// Never another language standing in for the reader's own.
    func testNoBibleIsServedInAnotherLanguage() {
        for language in AppLanguage.allCases {
            if let bible = BibleCatalog.bible(for: language) {
                XCTAssertEqual(bible.language, language.rawValue)
            }
        }
    }

    func testPsalmLabelsShowTheHebrewNumber() {
        XCTAssertEqual(PsalmNumbering.label(vulgate: 1), "1")
        XCTAssertEqual(PsalmNumbering.label(vulgate: 22), "22 (23)")
        XCTAssertEqual(PsalmNumbering.label(vulgate: 9), "9 (9–10)")
        XCTAssertEqual(PsalmNumbering.label(vulgate: 114), "114 (116:1–9)")
    }

    /// Release gate: a Bible whose rights are unconfirmed, or with verses
    /// still missing, may go to TestFlight but never to the store.
    func testBiblesReadyForRelease() throws {
        #if !DEBUG
        for bible in try BibleCatalog.loadAll() {
            XCTAssertNotEqual(bible.license, "unverified", "\(bible.id): direitos não confirmados")
            XCTAssertEqual(bible.missingVerses ?? 0, 0, "\(bible.id): versículos faltando")
        }
        #endif
    }
}
