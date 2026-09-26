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

    @ObservedObject private var notes = BibleNotesStore.shared
    @State private var query = ""
    @State private var hits: [BibleSearch.Hit] = []
    @State private var searching = false
    private static let hitLimit = 200

    private var reference: BibleSearch.Reference? {
        BibleSearch.reference(query, in: bible)
    }

    private var oldTestament: [BibleBook] {
        Array(bible.books.prefix { $0.id != BibleBook.firstNewTestamentBook })
    }

    private var newTestament: [BibleBook] {
        Array(bible.books.drop { $0.id != BibleBook.firstNewTestamentBook })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Holy Bible", tableName: "Bible")
                    .font(MissaleFont.display(28))

                searchField

                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    bookmarkCard
                    highlightsRow
                    section(L.string("Old Testament", table: "Bible"), books: oldTestament)
                    section(L.string("New Testament", table: "Bible"), books: newTestament)
                } else {
                    results
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Search

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(Palette.ink.opacity(0.5))
            TextField(L.string("Search a word or a reference", table: "Bible"), text: $query)
                .font(MissaleFont.body(17))
                .autocorrectionDisabled()
                .submitLabel(.search)
            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Palette.ink.opacity(0.35))
                }
                .accessibilityLabel(L.string("Clear", table: "Bible"))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.white.opacity(0.8)))
        .task(id: query) {
            // A short pause so a word isn't searched letter by letter.
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            let text = query.trimmingCharacters(in: .whitespaces)
            guard text.count >= 3 else { hits = []; return }
            searching = true
            let bible = self.bible
            let found = await Task.detached(priority: .userInitiated) {
                BibleSearch.verses(matching: text, in: bible, limit: Self.hitLimit)
            }.value
            guard !Task.isCancelled else { return }
            hits = found
            searching = false
        }
    }

    @ViewBuilder
    private var results: some View {
        if let reference {
            NavigationLink {
                BibleChapterView(bible: bible, book: reference.book, chapter: reference.chapter, focusVerse: reference.verse)
            } label: {
                GlassCard(padding: 14) {
                    HStack {
                        Image(systemName: "arrow.right.circle").foregroundStyle(Palette.wine)
                        Text(L.string("Go to {reference}", table: "Bible")
                            .replacingOccurrences(of: "{reference}", with: label(reference.book, reference.chapter, reference.verse)))
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.ink)
                        Spacer()
                    }
                }
            }
            .buttonStyle(.plain)
        }

        if searching && hits.isEmpty {
            ProgressView().frame(maxWidth: .infinity).padding(.top, 12)
        } else if query.trimmingCharacters(in: .whitespaces).count >= 3, !(hits.isEmpty && reference != nil) {
            // A reference that matched already answers "Jo 3,16"; "no results"
            // under it would read as a contradiction.
            Text(hits.isEmpty
                 ? L.string("No results", table: "Bible")
                 : (hits.count == Self.hitLimit
                    ? L.string("Showing the first {n}.", table: "Bible")
                    : L.string("{n} results", table: "Bible"))
                    .replacingOccurrences(of: "{n}", with: "\(hits.count)"))
                .font(MissaleFont.body(13, weight: .semibold))
                .foregroundStyle(Palette.ink.opacity(0.5))
                .padding(.top, 4)
            ForEach(hits) { hit in
                NavigationLink {
                    BibleChapterView(bible: bible, book: hit.book, chapter: hit.chapter, focusVerse: hit.verse.n)
                } label: {
                    verseCard(label(hit.book, hit.chapter, hit.verse.n), hit.verse.t)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Bookmark and highlights

    @ViewBuilder
    private var bookmarkCard: some View {
        if let mark = notes.bookmark(in: bible), let book = bible.books.first(where: { $0.id == mark.bookID }) {
            NavigationLink {
                BibleChapterView(bible: bible, book: book, chapter: mark.chapter)
            } label: {
                LiturgicalGradientCard(color: .red) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Eyebrow(text: L.string("Continue where you left off", table: "Bible"), color: Palette.goldBright)
                            Text(label(book, mark.chapter, nil))
                                .font(MissaleFont.display(22, weight: .medium))
                                .foregroundStyle(.white)
                            Text(L.string("Marked {date}", table: "Bible")
                                .replacingOccurrences(of: "{date}", with: mark.date.formatted(
                                    Date.FormatStyle(date: .abbreviated, time: .omitted)
                                        .locale(AppLanguagePreference.resolveCurrent().locale))))
                                .font(MissaleFont.body(13))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "bookmark.fill").foregroundStyle(Palette.goldBright)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var highlightsRow: some View {
        NavigationLink {
            BibleHighlightsView(bible: bible)
        } label: {
            GlassCard(padding: 14) {
                HStack {
                    Image(systemName: "highlighter").foregroundStyle(Palette.wine)
                    Text(L.string("Highlighted verses", table: "Bible"))
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(Palette.ink)
                    Spacer()
                    Text("\(notes.highlights(in: bible).count)")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                    Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func label(_ book: BibleBook, _ chapter: Int, _ verse: Int?) -> String {
        let chapterLabel = book.id == "PSA" && bible.usesVulgatePsalms ? PsalmNumbering.label(vulgate: chapter) : "\(chapter)"
        return verse.map { "\(book.name) \(chapterLabel), \($0)" } ?? "\(book.name) \(chapterLabel)"
    }

    private func verseCard(_ title: String, _ text: String) -> some View {
        GlassCard(padding: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(MissaleFont.body(13, weight: .semibold))
                    .foregroundStyle(Palette.wine)
                Text(text)
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.85))
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

/// Every verse the reader highlighted in this Bible, newest first. Swipe to
/// remove; tap to open the chapter at that verse.
struct BibleHighlightsView: View {
    let bible: Bible
    @ObservedObject private var notes = BibleNotesStore.shared

    var body: some View {
        let items = notes.highlights(in: bible)
        return ZStack {
            LiturgicalColor.red.pageBackground
            if items.isEmpty {
                Text(L.string("No highlighted verses yet. Tap a verse while reading to mark it.", table: "Bible"))
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .padding(32)
            } else {
                List {
                    ForEach(items) { item in
                        if let book = bible.books.first(where: { $0.id == item.bookID }),
                           let verse = book.chapters.first(where: { $0.n == item.chapter })?.verses.first(where: { $0.n == item.verse }) {
                            NavigationLink {
                                BibleChapterView(bible: bible, book: book, chapter: item.chapter, focusVerse: item.verse)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(book.name) \(item.chapter), \(item.verse)")
                                        .font(MissaleFont.body(13, weight: .semibold))
                                        .foregroundStyle(Palette.wine)
                                    Text(verse.t)
                                        .font(MissaleFont.body(16))
                                        .foregroundStyle(Palette.ink.opacity(0.85))
                                        .lineLimit(4)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color.white.opacity(0.55))
                            .swipeActions {
                                Button(L.string("Remove", table: "Bible"), role: .destructive) { notes.remove(item) }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(L.string("Highlighted verses", table: "Bible"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
