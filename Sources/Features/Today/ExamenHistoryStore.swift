import Foundation

/// Local-only, persistent log of completed nightly Examens — what was actually
/// written at each of the four steps, not discarded once the flow closes.
@MainActor
final class ExamenHistoryStore {
    static let shared = ExamenHistoryStore()

    let list = PersistedList<ExamenEntry>(storageKey: "examen_entries")

    private init() {}

    func record(gratitude: String, lightRequest: String, review: String, response: String) {
        list.append(ExamenEntry(gratitude: gratitude, lightRequest: lightRequest, review: review, response: response))
    }

}
