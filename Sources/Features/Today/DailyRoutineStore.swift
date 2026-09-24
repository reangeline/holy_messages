import Foundation

/// "Seu dia com Deus", as a day's tasks: the morning offering with what the
/// reader hopes for the day, a short prayer, "how is my day going" in the
/// afternoon (the mood check-in), a New Testament chapter, and the Examen.
///
/// The mood and the Examen already keep dated records, so they count as done
/// from those. The rest need a record of their own, plus where the reader is
/// in the New Testament and what they wrote in the morning.
@MainActor
final class DailyRoutineStore: ObservableObject {
    static let shared = DailyRoutineStore()

    static let completionsKey = "routine_completions"
    static let positionKey = "routine_nt_position"
    static let intentionsKey = "routine_intentions"
    /// Older days are dropped: the list only ever answers "done today?".
    private static let keptDays = 60

    enum Item: String { case morning, reading, prayer }

    /// Day key -> items done that day.
    @Published private(set) var completions: [String: [String]]
    /// New Testament chapters finished so far, in canonical order.
    @Published private(set) var position: Int
    /// Day key -> what the reader hopes for that day, written in the morning.
    @Published private(set) var intentions: [String: String]

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completions = defaults.dictionary(forKey: Self.completionsKey) as? [String: [String]] ?? [:]
        position = defaults.integer(forKey: Self.positionKey)
        intentions = defaults.dictionary(forKey: Self.intentionsKey) as? [String: String] ?? [:]
    }

    func intention(on date: Date = Date()) -> String? {
        intentions[Self.dayKey(date)]
    }

    func saveIntention(_ text: String, on date: Date = Date()) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        intentions[Self.dayKey(date)] = trimmed
        intentions = intentions.filter { $0.key >= Self.cutoff(from: date) }
        defaults.set(intentions, forKey: Self.intentionsKey)
    }

    private static func cutoff(from date: Date) -> String {
        dayKey(Calendar.current.date(byAdding: .day, value: -keptDays, to: date) ?? date)
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
        completions = completions.filter { $0.key >= Self.cutoff(from: date) }
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
