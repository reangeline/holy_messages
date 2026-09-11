import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()

    private static let storageKey = "favorite_verse_keys"

    @Published private(set) var favoriteKeys: Set<String>

    private init() {
        let stored = UserDefaults.standard.stringArray(forKey: Self.storageKey) ?? []
        favoriteKeys = Set(stored)
    }

    func isFavorite(_ verse: Verse) -> Bool {
        favoriteKeys.contains(verse.key)
    }

    func toggle(_ verse: Verse) {
        if favoriteKeys.contains(verse.key) {
            favoriteKeys.remove(verse.key)
        } else {
            favoriteKeys.insert(verse.key)
        }
        UserDefaults.standard.set(Array(favoriteKeys), forKey: Self.storageKey)
    }
}
