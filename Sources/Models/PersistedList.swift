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

    /// Changes the first item that `matches`, if any, and saves.
    func update(where matches: (Element) -> Bool, _ change: (inout Element) -> Void) {
        guard let index = items.firstIndex(where: matches) else { return }
        change(&items[index])
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    /// Re-reads the stored list — after LocalData erases it, for instance.
    func reload() {
        items = []
        load()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Element].self, from: data) else { return }
        items = decoded
    }
}
