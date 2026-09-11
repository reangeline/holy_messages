import SwiftUI

struct VerseRow: View {
    @EnvironmentObject private var favorites: FavoritesStore
    let verse: Verse

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(verse.verse). \(verse.verseText)")
                    .font(.body)
            }
            Spacer()
            Button {
                favorites.toggle(verse)
            } label: {
                Image(systemName: favorites.isFavorite(verse) ? "heart.fill" : "heart")
                    .foregroundStyle(favorites.isFavorite(verse) ? .red : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
