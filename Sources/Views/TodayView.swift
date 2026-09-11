import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var verseStore: VerseStore
    @EnvironmentObject private var favorites: FavoritesStore
    @State private var shareItem: ShareItem?

    private var verse: Verse? {
        verseStore.verseOfTheDay()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.99, green: 0.95, blue: 0.78),
                        Color(uiColor: .systemBackground),
                        Color(red: 0.99, green: 0.84, blue: 0.66)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if let verse {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(verse.verseText)
                            .font(.title3)
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        Text(verse.reference)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        HStack(spacing: 32) {
                            Button {
                                favorites.toggle(verse)
                            } label: {
                                Label(
                                    favorites.isFavorite(verse) ? "Favorito" : "Favoritar",
                                    systemImage: favorites.isFavorite(verse) ? "heart.fill" : "heart"
                                )
                            }
                            Button {
                                shareItem = ShareItem(text: "\(verse.verseText) — \(verse.reference)")
                            } label: {
                                Label("Compartilhar", systemImage: "square.and.arrow.up")
                            }
                        }
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .padding(.bottom, 32)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Hoje")
            .onAppear {
                verseStore.loadIfNeeded()
                if let verse {
                    WidgetBridge.publish(verse)
                }
            }
            .onChange(of: verseStore.isLoaded) { _, _ in
                if let verse {
                    WidgetBridge.publish(verse)
                }
            }
            .sheet(item: $shareItem) { item in
                ActivityView(activityItems: [item.text])
            }
        }
    }
}

struct ShareItem: Identifiable {
    let id = UUID()
    let text: String
}
