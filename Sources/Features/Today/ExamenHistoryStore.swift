import Foundation

/// Local-only, persistent log of completed nightly Examens — what was actually
/// written at each of the four steps, not discarded once the flow closes.
@MainActor
final class ExamenHistoryStore {
    static let shared = ExamenHistoryStore()

    let list = PersistedList<ExamenEntry>(storageKey: "examen_entries")

    private init() {}

    @discardableResult
    func record(gratitude: String, lightRequest: String, review: String, response: String) -> ExamenEntry {
        let entry = ExamenEntry(gratitude: gratitude, lightRequest: lightRequest, review: review, response: response)
        list.append(entry)
        return entry
    }

    /// Keeps Jev's saint and prayer with the entry they were chosen from.
    func attach(_ suggestion: ExamenSuggestion, to entryID: UUID) {
        list.update(where: { $0.id == entryID }) { entry in
            entry.saintID = suggestion.saintID
            entry.prayerID = suggestion.prayerID
        }
    }

}
