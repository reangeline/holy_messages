import SwiftUI

struct BooksListView: View {
    @EnvironmentObject private var verseStore: VerseStore

    var body: some View {
        NavigationStack {
            List(verseStore.books, id: \.number) { book in
                NavigationLink(book.name) {
                    ChapterListView(bookNumber: book.number, bookName: book.name)
                }
            }
            .navigationTitle("Livros")
            .onAppear { verseStore.loadIfNeeded() }
        }
    }
}

struct ChapterListView: View {
    @EnvironmentObject private var verseStore: VerseStore
    let bookNumber: Int
    let bookName: String

    private let columns = [GridItem(.adaptive(minimum: 50))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(verseStore.chapters(inBook: bookNumber), id: \.self) { chapter in
                    NavigationLink {
                        ChapterView(bookNumber: bookNumber, bookName: bookName, chapter: chapter)
                    } label: {
                        Text("\(chapter)")
                            .frame(width: 44, height: 44)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
        }
        .navigationTitle(bookName)
    }
}

struct ChapterView: View {
    @EnvironmentObject private var verseStore: VerseStore
    let bookNumber: Int
    let bookName: String
    let chapter: Int

    var body: some View {
        List(verseStore.verses(inBook: bookNumber, chapter: chapter)) { verse in
            VerseRow(verse: verse)
        }
        .navigationTitle("\(bookName) \(chapter)")
    }
}
