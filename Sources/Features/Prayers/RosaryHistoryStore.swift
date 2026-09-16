import Foundation

/// Local-only, persistent log of completed rosaries — backs "Terços rezados"
/// with the real mystery, mode and intention actually prayed, not a fixed demo list.
@MainActor
final class RosaryHistoryStore: ObservableObject {
    static let shared = RosaryHistoryStore()

    private static let storageKey = "rosary_history_entries"

    @Published private(set) var entries: [RosaryHistoryEntry] = []

    private init() {
        load()
    }

    func record(mysterySet: MysterySet, modeLabel: String, intention: String?) {
        let trimmed = intention?.trimmingCharacters(in: .whitespacesAndNewlines)
        entries.append(RosaryHistoryEntry(mysterySet: mysterySet, modeLabel: modeLabel, intention: (trimmed?.isEmpty ?? true) ? nil : trimmed))
        save()
    }

    /// Newest first, for display.
    var recent: [RosaryHistoryEntry] {
        entries.sorted { $0.date > $1.date }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([RosaryHistoryEntry].self, from: data) else { return }
        entries = decoded
    }
}

extension RosaryHistoryEntry {
    var title: String { "Mistérios \(mysterySet.rawValue)" }

    var subtitle: String {
        guard let intention, !intention.isEmpty else { return modeLabel }
        return "\(modeLabel) · intenção: \(intention)"
    }

    /// "Hoje", "Ontem", or the weekday name — matches the app's existing
    /// relative-day phrasing elsewhere rather than a raw calendar date.
    var dateLabel: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Hoje" }
        if calendar.isDateInYesterday(date) { return "Ontem" }
        let formatter = DateFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).localizedCapitalized
    }
}
