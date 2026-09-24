import Foundation

/// A verse the reader marked while reading.
struct BibleHighlight: Codable, Hashable, Identifiable {
    let bibleID: String
    let bookID: String
    let chapter: Int
    let verse: Int
    var date = Date()

    var id: String { "\(bibleID)/\(bookID)/\(chapter)/\(verse)" }
}

/// "Where I stopped": one per Bible, set by hand from the chapter screen. It
/// is separate from the New Testament plan on Today, which moves on its own.
struct BibleBookmark: Codable, Hashable {
    let bibleID: String
    let bookID: String
    let chapter: Int
    var date = Date()
}

/// Highlights and the bookmark, kept on the device only — see LocalData.
@MainActor
final class BibleNotesStore: ObservableObject {
    static let shared = BibleNotesStore()

    static let highlightsKey = "bible_highlights"
    static let bookmarksKey = "bible_bookmarks"

    @Published private(set) var highlights: [BibleHighlight]
    @Published private(set) var bookmarks: [String: BibleBookmark]

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
#if DEBUG
        // `-resetBibleNotes 1` gives the UI tests a clean slate: a highlight
        // left by an earlier run would make the next tap remove it.
        if UserDefaults.standard.volatileDomain(forName: UserDefaults.argumentDomain)["resetBibleNotes"] as? String == "1" {
            defaults.removeObject(forKey: Self.highlightsKey)
            defaults.removeObject(forKey: Self.bookmarksKey)
        }
#endif
        highlights = Self.decode([BibleHighlight].self, defaults.data(forKey: Self.highlightsKey)) ?? []
        bookmarks = Self.decode([String: BibleBookmark].self, defaults.data(forKey: Self.bookmarksKey)) ?? [:]
    }

    /// Re-reads what is stored — after LocalData erases it, for instance.
    func reload() {
        highlights = Self.decode([BibleHighlight].self, defaults.data(forKey: Self.highlightsKey)) ?? []
        bookmarks = Self.decode([String: BibleBookmark].self, defaults.data(forKey: Self.bookmarksKey)) ?? [:]
    }

    // MARK: Highlights

    func highlights(in bible: Bible) -> [BibleHighlight] {
        highlights.filter { $0.bibleID == bible.id }.sorted { $0.date > $1.date }
    }

    func isHighlighted(_ bible: Bible, _ bookID: String, _ chapter: Int, _ verse: Int) -> Bool {
        highlights.contains { $0.id == BibleHighlight(bibleID: bible.id, bookID: bookID, chapter: chapter, verse: verse).id }
    }

    func toggleHighlight(_ bible: Bible, _ bookID: String, _ chapter: Int, _ verse: Int) {
        let new = BibleHighlight(bibleID: bible.id, bookID: bookID, chapter: chapter, verse: verse)
        if let index = highlights.firstIndex(where: { $0.id == new.id }) {
            highlights.remove(at: index)
        } else {
            highlights.append(new)
        }
        save()
    }

    func remove(_ highlight: BibleHighlight) {
        highlights.removeAll { $0.id == highlight.id }
        save()
    }

    // MARK: Bookmark

    func bookmark(in bible: Bible) -> BibleBookmark? { bookmarks[bible.id] }

    func isBookmarked(_ bible: Bible, _ bookID: String, _ chapter: Int) -> Bool {
        guard let mark = bookmarks[bible.id] else { return false }
        return mark.bookID == bookID && mark.chapter == chapter
    }

    /// Marks this chapter as where the reader stopped, or clears the mark when
    /// it is already here.
    func toggleBookmark(_ bible: Bible, _ bookID: String, _ chapter: Int) {
        if isBookmarked(bible, bookID, chapter) {
            bookmarks[bible.id] = nil
        } else {
            bookmarks[bible.id] = BibleBookmark(bibleID: bible.id, bookID: bookID, chapter: chapter)
        }
        save()
    }

    private func save() {
        defaults.set(try? JSONEncoder().encode(highlights), forKey: Self.highlightsKey)
        defaults.set(try? JSONEncoder().encode(bookmarks), forKey: Self.bookmarksKey)
    }

    private static func decode<T: Decodable>(_ type: T.Type, _ data: Data?) -> T? {
        data.flatMap { try? JSONDecoder().decode(type, from: $0) }
    }
}

/// Finding a passage: by reference ("Jo 3,16", "1 Coríntios 13", "Psalm 23")
/// or by words in the text.
enum BibleSearch {
    struct Reference: Equatable {
        let book: BibleBook
        let chapter: Int
        let verse: Int?
    }

    struct Hit: Identifiable {
        let book: BibleBook
        let chapter: Int
        let verse: BibleVerse
        var id: String { "\(book.id)/\(chapter)/\(verse.n)" }
    }

    /// Reads "book chapter[,:. verse]". The book can be the full name, the
    /// start of it (three letters or more) or a usual abbreviation.
    static func reference(_ query: String, in bible: Bible) -> Reference? {
        let pattern = #"^\s*(\d?\s*[^\d]+?)\s*(\d+)(?:\s*[,:.]\s*(\d+))?\s*$"#
        guard let match = try? NSRegularExpression(pattern: pattern)
            .firstMatch(in: query, range: NSRange(query.startIndex..., in: query)),
            let bookRange = Range(match.range(at: 1), in: query),
            let chapterRange = Range(match.range(at: 2), in: query),
            let chapter = Int(query[chapterRange]) else { return nil }
        let verse = Range(match.range(at: 3), in: query).flatMap { Int(query[$0]) }
        let typed = key(String(query[bookRange]))
        guard !typed.isEmpty else { return nil }

        let book = abbreviations[bible.language]?[typed].flatMap { id in bible.books.first { $0.id == id } }
            ?? bible.books.first { key($0.name) == typed }
            ?? (typed.count >= 3 ? bible.books.first { key($0.name).hasPrefix(typed) } : nil)
        guard let book, book.chapters.contains(where: { $0.n == chapter }) else { return nil }
        return Reference(book: book, chapter: chapter, verse: verse)
    }

    /// Verses containing every word of the query, ignoring case and accents,
    /// in canonical order. Stops at `limit`.
    nonisolated static func verses(matching query: String, in bible: Bible, limit: Int = 200) -> [Hit] {
        let words = query.split(separator: " ").map(String.init).filter { $0.count >= 2 }
        guard !words.isEmpty else { return [] }
        var hits: [Hit] = []
        for book in bible.books {
            for chapter in book.chapters {
                for verse in chapter.verses where words.allSatisfy({
                    verse.t.range(of: $0, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                }) {
                    hits.append(Hit(book: book, chapter: chapter.n, verse: verse))
                    if hits.count == limit { return hits }
                }
            }
        }
        return hits
    }

    /// Lowercased, without accents, spaces or dots: "1 Cor." -> "1cor".
    static func key(_ text: String) -> String {
        text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .filter { $0.isLetter || $0.isNumber }
    }

    /// The abbreviations readers actually type, per language, to USFM codes.
    /// Names and their beginnings are matched from the Bible itself.
    private static let abbreviations: [String: [String: String]] = [
        "pt": ["gn": "GEN", "ex": "EXO", "lv": "LEV", "nm": "NUM", "dt": "DEU", "sl": "PSA", "pr": "PRO",
               "is": "ISA", "jr": "JER", "ez": "EZK", "dn": "DAN", "mt": "MAT", "mc": "MRK", "lc": "LUK",
               "jo": "JHN", "at": "ACT", "rm": "ROM", "1cor": "1CO", "2cor": "2CO", "gl": "GAL", "ef": "EPH",
               "fl": "PHP", "cl": "COL", "1ts": "1TH", "2ts": "2TH", "1tm": "1TI", "2tm": "2TI", "hb": "HEB",
               "tg": "JAS", "1pd": "1PE", "2pd": "2PE", "1jo": "1JN", "2jo": "2JN", "3jo": "3JN", "ap": "REV"],
        "en": ["gen": "GEN", "ex": "EXO", "lev": "LEV", "num": "NUM", "deut": "DEU", "ps": "PSA", "prov": "PRO",
               "is": "ISA", "jer": "JER", "ezek": "EZK", "dan": "DAN", "mt": "MAT", "mk": "MRK", "lk": "LUK",
               "jn": "JHN", "rom": "ROM", "1cor": "1CO", "2cor": "2CO", "gal": "GAL", "eph": "EPH",
               "phil": "PHP", "col": "COL", "1thess": "1TH", "2thess": "2TH", "1tim": "1TI", "2tim": "2TI",
               "heb": "HEB", "jas": "JAS", "1pet": "1PE", "2pet": "2PE", "1jn": "1JN", "2jn": "2JN", "3jn": "3JN",
               "rev": "REV"],
        "es": ["gn": "GEN", "ex": "EXO", "lv": "LEV", "nm": "NUM", "dt": "DEU", "sal": "PSA", "prov": "PRO",
               "is": "ISA", "jer": "JER", "ez": "EZK", "dn": "DAN", "mt": "MAT", "mc": "MRK", "lc": "LUK",
               "jn": "JHN", "hch": "ACT", "rom": "ROM", "1cor": "1CO", "2cor": "2CO", "gal": "GAL", "ef": "EPH",
               "flp": "PHP", "col": "COL", "1ts": "1TH", "2ts": "2TH", "1tim": "1TI", "2tim": "2TI", "heb": "HEB",
               "sant": "JAS", "1pe": "1PE", "2pe": "2PE", "1jn": "1JN", "2jn": "2JN", "3jn": "3JN", "ap": "REV"],
    ]
}
