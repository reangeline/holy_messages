import SwiftUI

@main
struct HolyMessagesApp: App {
    @StateObject private var verseStore = VerseStore.shared
    @StateObject private var favorites = FavoritesStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(verseStore)
                .environmentObject(favorites)
        }
    }
}
