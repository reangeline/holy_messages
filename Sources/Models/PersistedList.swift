import Foundation

/// A Codable array persisted to UserDefaults as JSON — the save/load shape
/// shared by every local-only history store (Examen, rosary, mood entries).
@MainActor
final class PersistedList<Element: Codable>: ObservableObject {
    @Published private(set) var items: [Element] = []
    private let storageKey: String

    init(storageKey: String) {
        self.storageKey = storageKey
        load()
    }

    func append(_ item: Element) {
        items.append(item)
        save()
    }

    /// Clears the list and the stored copy. Backs "Delete everything": the
    /// in-memory array has to go too, or the screen keeps showing entries that
    /// were deleted and saves them back on the next append.
    func removeAll() {
        items = []
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Element].self, from: data) else { return }
        items = decoded
    }
}
