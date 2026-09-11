import Foundation

@MainActor
final class VerseStore: ObservableObject {
    static let shared = VerseStore()

    @Published private(set) var verses: [Verse] = []
    @Published private(set) var isLoaded = false

    /// Book numbers in canonical order, each paired with its display name.
    private(set) var books: [(number: Int, name: String)] = []
    private var versesByBook: [Int: [Verse]] = [:]

    private init() {}

    func loadIfNeeded() {
        guard !isLoaded else { return }
        guard let url = Bundle.main.url(forResource: "verses", withExtension: "json") else {
            assertionFailure("verses.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Verse].self, from: data)
            verses = decoded
            indexByBook(decoded)
            isLoaded = true
        } catch {
            assertionFailure("Failed to load verses.json: \(error)")
        }
    }

    private func indexByBook(_ verses: [Verse]) {
        var seenBooks: [Int: String] = [:]
        var order: [Int] = []
        for verse in verses {
            if seenBooks[verse.book] == nil {
                seenBooks[verse.book] = verse.bookName
                order.append(verse.book)
            }
            versesByBook[verse.book, default: []].append(verse)
        }
        books = order.map { (number: $0, name: seenBooks[$0] ?? "") }
    }

    func chapters(inBook book: Int) -> [Int] {
        let numbers = versesByBook[book]?.map(\.chapter) ?? []
        return Array(Set(numbers)).sorted()
    }

    func verses(inBook book: Int, chapter: Int) -> [Verse] {
        (versesByBook[book] ?? [])
            .filter { $0.chapter == chapter }
            .sorted { $0.verse < $1.verse }
    }

    /// Stable "verse of the day": same result all day, changes daily, no persistence needed.
    /// Uses a deterministic day count (not String.hashValue, which is randomized per process launch).
    func verseOfTheDay(for date: Date = Date()) -> Verse? {
        guard !verses.isEmpty else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let referenceDate = DateComponents(calendar: calendar, year: 2000, month: 1, day: 1).date!
        let daysSinceReference = calendar.dateComponents([.day], from: referenceDate, to: date).day ?? 0
        let index = ((daysSinceReference % verses.count) + verses.count) % verses.count
        return verses[index]
    }

    func verse(withKey key: String) -> Verse? {
        verses.first { $0.key == key }
    }
}
