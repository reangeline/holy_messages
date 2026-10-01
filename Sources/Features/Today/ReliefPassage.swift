import Foundation

/// The passage printed on a relief ("Salmo 23, 1-3", "Psalm 69:4", "Salmo 34")
/// found again in the Bible the app already ships, so the reader can open the
/// whole chapter around the few verses quoted.
struct ReliefPassage: Equatable {
    let book: BibleBook
    /// In the Bible's own numbering: a Vulgate psalm for the three editions
    /// the app carries, though the reference prints the Hebrew number.
    let chapter: Int
    /// The verses quoted; nil when the reference names the whole chapter.
    let verses: ClosedRange<Int>?

    /// Nil whenever the reference can't be placed with confidence (unknown
    /// book, chapter missing, a psalm whose numbering splits): the relief then
    /// stays as it always was, with no tap.
    static func resolve(_ reference: String, in bible: Bible) -> ReliefPassage? {
        let pattern = #"^\s*(.+?)\s+(\d+)(?:\s*[,:.]\s*(\d+)(?:\s*[-–]\s*(\d+))?)?\s*$"#
        guard let match = try? NSRegularExpression(pattern: pattern)
            .firstMatch(in: reference, range: NSRange(reference.startIndex..., in: reference)),
            let bookRange = Range(match.range(at: 1), in: reference),
            let chapterRange = Range(match.range(at: 2), in: reference),
            let found = BibleSearch.reference("\(reference[bookRange]) \(reference[chapterRange])", in: bible)
        else { return nil }

        var chapter = found.chapter
        if found.book.id == "PSA", bible.usesVulgatePsalms {
            guard let vulgate = PsalmNumbering.vulgate(forHebrew: chapter) else { return nil }
            chapter = vulgate
        }
        guard found.book.chapters.contains(where: { $0.n == chapter }) else { return nil }

        func number(_ group: Int) -> Int? {
            Range(match.range(at: group), in: reference).flatMap { Int(reference[$0]) }
        }
        var verses: ClosedRange<Int>?
        if let first = number(3) {
            let last = number(4) ?? first
            verses = first <= last ? first...last : first...first
        }
        return ReliefPassage(book: found.book, chapter: chapter, verses: verses)
    }
}
