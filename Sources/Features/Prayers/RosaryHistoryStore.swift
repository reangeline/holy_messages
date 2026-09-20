import Foundation

/// Local-only, persistent log of completed rosaries — backs "Terços rezados"
/// with the real mystery, mode and intention actually prayed, not a fixed demo list.
@MainActor
final class RosaryHistoryStore {
    static let shared = RosaryHistoryStore()

    let list = PersistedList<RosaryHistoryEntry>(storageKey: "rosary_history_entries")

    private init() {}

    func record(mysterySet: MysterySet, modeLabel: String, intention: String?) {
        let trimmed = intention?.trimmingCharacters(in: .whitespacesAndNewlines)
        list.append(RosaryHistoryEntry(mysterySet: mysterySet, modeLabel: modeLabel, intention: (trimmed?.isEmpty ?? true) ? nil : trimmed))
    }

    /// Newest first, for display.
    var recent: [RosaryHistoryEntry] {
        list.items.sorted { $0.date > $1.date }
    }
}

extension RosaryHistoryEntry {
    var title: String { mysterySet.displayTitle }

    var subtitle: String {
        guard let intention, !intention.isEmpty else { return modeLabel }
        // modeLabel is recorded at prayer time and kept as recorded — like the
        // mystery's rawValue, it is stored data, not chrome.
        return L.string("{mode} · intention: {intention}", table: "Prayers")
            .replacingOccurrences(of: "{mode}", with: modeLabel)
            .replacingOccurrences(of: "{intention}", with: intention)
    }

    var dateLabel: String { date.relativeLabel(format: "EEEE") }
}
