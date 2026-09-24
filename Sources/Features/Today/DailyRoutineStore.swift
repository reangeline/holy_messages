import Foundation

/// "Seu dia com Deus": four things a day — the mood check-in, a New Testament
/// chapter, a short prayer, and the Examen at night.
///
/// The mood and the Examen already keep dated records, so they count as done
/// from those. Only the reading and the prayer need a record of their own,
/// plus where the reader is in the New Testament.
@MainActor
final class DailyRoutineStore: ObservableObject {
    static let shared = DailyRoutineStore()

    static let completionsKey = "routine_completions"
    static let positionKey = "routine_nt_position"
    /// Older days are dropped: the list only ever answers "done today?".
    private static let keptDays = 60

    enum Item: String { case reading, prayer }

    /// Day key -> items done that day.
    @Published private(set) var completions: [String: [String]]
    /// New Testament chapters finished so far, in canonical order.
    @Published private(set) var position: Int

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completions = defaults.dictionary(forKey: Self.completionsKey) as? [String: [String]] ?? [:]
        position = defaults.integer(forKey: Self.positionKey)
    }

    nonisolated static func dayKey(_ date: Date) -> String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year!, parts.month!, parts.day!)
    }

    func isDone(_ item: Item, on date: Date = Date()) -> Bool {
        completions[Self.dayKey(date)]?.contains(item.rawValue) ?? false
    }

    /// Today's chapter: the next one, or the one already read today — so the
    /// card doesn't jump ahead the moment it's checked.
    func chapterIndex(on date: Date = Date(), total: Int) -> Int {
        guard total > 0 else { return 0 }
        let index = isDone(.reading, on: date) ? position - 1 : position
        return max(0, index) % total
    }

    func markDone(_ item: Item, on date: Date = Date()) {
        guard !isDone(item, on: date) else { return }
        let key = Self.dayKey(date)
        completions[key, default: []].append(item.rawValue)
        if item == .reading {
            position += 1
            defaults.set(position, forKey: Self.positionKey)
        }
        let cutoff = Self.dayKey(Calendar.current.date(byAdding: .day, value: -Self.keptDays, to: date) ?? date)
        completions = completions.filter { $0.key >= cutoff }
        defaults.set(completions, forKey: Self.completionsKey)
    }
}

/// The New Testament as a reading plan: every chapter from Matthew to the end
/// of the Bible, in the reader's own translation.
struct NewTestamentPlan {
    let chapters: [(book: BibleBook, chapter: Int)]

    init(bible: Bible) {
        let start = bible.books.firstIndex { $0.id == BibleBook.firstNewTestamentBook } ?? bible.books.endIndex
        chapters = bible.books[start...].flatMap { book in book.chapters.map { (book, $0.n) } }
    }

    /// Reading time at an unhurried ~180 words a minute.
    static func minutes(_ book: BibleBook, chapter: Int) -> Int {
        let words = book.chapters.first { $0.n == chapter }?.verses
            .reduce(0) { $0 + $1.t.split(separator: " ").count } ?? 0
        return max(1, Int((Double(words) / 180).rounded()))
    }
}
