import Foundation

/// Local-only, persistent log of completed nightly Examens — what was actually
/// written at each of the four steps, not discarded once the flow closes.
@MainActor
final class ExamenHistoryStore: ObservableObject {
    static let shared = ExamenHistoryStore()

    private static let storageKey = "examen_entries"

    @Published private(set) var entries: [ExamenEntry] = []

    private init() {
        load()
    }

    func record(gratitude: String, lightRequest: String, review: String, response: String) {
        entries.append(ExamenEntry(gratitude: gratitude, lightRequest: lightRequest, review: review, response: response))
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([ExamenEntry].self, from: data) else { return }
        entries = decoded
    }
}
