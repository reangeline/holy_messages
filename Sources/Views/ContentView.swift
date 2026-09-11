import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Hoje", systemImage: "sun.max") }
            BooksListView()
                .tabItem { Label("Livros", systemImage: "book") }
            FavoritesView()
                .tabItem { Label("Favoritos", systemImage: "heart") }
        }
    }
}
