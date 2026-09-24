import SwiftUI

/// The Bible's front page: the books by testament.
struct BibleHomeView: View {
    @State private var loaded = false
    @State private var bible: Bible?
    @State private var others: [Bible] = []

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            if !loaded {
                ProgressView(L.string("Loading…", table: "Bible"))
                    .font(MissaleFont.body(15))
            } else if let bible {
                BibleBookList(bible: bible)
            } else {
                missingLanguage
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Several megabytes of JSON: decoded off the main thread, once.
            let language = AppLanguagePreference.resolveCurrent()
            let all = await Task.detached(priority: .userInitiated) { BibleCatalog.all }.value
            bible = all.first { $0.language == language.rawValue }
            others = all.filter { $0.language != language.rawValue }
            loaded = true
        }
    }

    /// No Bible in the reader's language yet. Said plainly, and the other
    /// languages offered by name — never swapped in silently.
    private var missingLanguage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Holy Bible", tableName: "Bible")
                    .font(MissaleFont.display(28))
                Text("There is no Bible in this language in the app yet. It will come in an update, in a published Catholic translation.", tableName: "Bible")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.75))
                if !others.isEmpty {
                    Text("Meanwhile, in another language:", tableName: "Bible")
                        .font(MissaleFont.body(14, weight: .medium))
                        .foregroundStyle(Palette.goldDim)
                        .padding(.top, 8)
                    ForEach(others) { other in
                        NavigationLink {
                            ZStack {
                                LiturgicalColor.red.pageBackground
                                BibleBookList(bible: other)
                            }
                        } label: {
                            GlassCard {
                                HStack {
                                    Text(other.name)
                                        .font(MissaleFont.body(17, weight: .medium))
                                        .foregroundStyle(Palette.ink)
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}

struct BibleBookList: View {
    let bible: Bible

    private var oldTestament: [BibleBook] {
        Array(bible.books.prefix { $0.id != BibleBook.firstNewTestamentBook })
    }

    private var newTestament: [BibleBook] {
        Array(bible.books.drop { $0.id != BibleBook.firstNewTestamentBook })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 5) {
                    Eyebrow(text: bible.abbreviation)
                    Text("Holy Bible", tableName: "Bible")
                        .font(MissaleFont.display(28))
                    Text(bible.name)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.65))
                }

                section(L.string("Old Testament", table: "Bible"), books: oldTestament)
                section(L.string("New Testament", table: "Bible"), books: newTestament)

                Text(bible.source)
                    .font(MissaleFont.body(12))
                    .foregroundStyle(Palette.ink.opacity(0.45))
                    .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
    }

    private func section(_ title: String, books: [BibleBook]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(MissaleFont.display(21))
                .padding(.top, 8)
            ForEach(books) { book in
                NavigationLink {
                    BibleChapterPicker(bible: bible, book: book)
                } label: {
                    GlassCard(padding: 14) {
                        HStack {
                            Text(book.name)
                                .font(MissaleFont.body(17, weight: .medium))
                                .foregroundStyle(Palette.ink)
                            Spacer()
                            Text(book.chapters.count == 1
                                 ? L.string("one chapter", table: "Bible")
                                 : L.string("{n} chapters", table: "Bible")
                                     .replacingOccurrences(of: "{n}", with: "\(book.chapters.count)"))
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.55))
                            Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// The chapters of one book as a grid of numbers.
struct BibleChapterPicker: View {
    let bible: Bible
    let book: BibleBook

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text(book.name)
                        .font(MissaleFont.display(28))
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 56), spacing: 10)], spacing: 10) {
                        ForEach(book.chapters, id: \.n) { chapter in
                            NavigationLink {
                                BibleChapterView(bible: bible, book: book, chapter: chapter.n)
                            } label: {
                                Text("\(chapter.n)")
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .background(Color.white.opacity(0.45), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
