import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var verseStore: VerseStore
    @EnvironmentObject private var favorites: FavoritesStore

    private var favoriteVerses: [Verse] {
        verseStore.verses
            .filter { favorites.favoriteKeys.contains($0.key) }
            .sorted { $0.book == $1.book ? ($0.chapter, $0.verse) < ($1.chapter, $1.verse) : $0.book < $1.book }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteVerses.isEmpty {
                    ContentUnavailableView(
                        "Nenhum favorito ainda",
                        systemImage: "heart",
                        description: Text("Toque no coração de um versículo para salvá-lo aqui.")
                    )
                } else {
                    List(favoriteVerses) { verse in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(verse.verseText)
                            Text(verse.reference)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Favoritos")
        }
    }
}
