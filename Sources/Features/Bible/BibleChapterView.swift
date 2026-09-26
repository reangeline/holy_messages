import SwiftUI

/// Reads one chapter, with previous/next that carry across book boundaries
/// without pushing a new screen for every chapter turned.
struct BibleChapterView: View {
    let bible: Bible
    /// Set when opened from the daily routine: the chapter ends with a button
    /// that checks the reading off, instead of stepping to the next chapter.
    var onFinished: (() -> Void)? = nil
    /// Scrolled to on open — from a search hit or a highlighted verse.
    var focusVerse: Int? = nil
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var notes = BibleNotesStore.shared
    @ObservedObject private var routine = DailyRoutineStore.shared
    @AppStorage(ReadingTextSize.storageKey) private var textSize = ReadingTextSize.defaultStep
    @State private var book: BibleBook
    @State private var chapter: Int

    init(bible: Bible, book: BibleBook, chapter: Int, focusVerse: Int? = nil, onFinished: (() -> Void)? = nil) {
        self.bible = bible
        self.focusVerse = focusVerse
        self.onFinished = onFinished
        _book = State(initialValue: book)
        _chapter = State(initialValue: chapter)
    }

    /// "John 3", or "Psalm 22 (23)" in a Vulgate-numbered Bible.
    private static func title(bible: Bible, book: BibleBook, chapter: Int) -> String {
        if book.id == "PSA" {
            let number = bible.usesVulgatePsalms ? PsalmNumbering.label(vulgate: chapter) : "\(chapter)"
            return L.string("Psalm {n}", table: "Bible").replacingOccurrences(of: "{n}", with: number)
        }
        return "\(book.name) \(chapter)"
    }

    private var verses: [BibleVerse] {
        book.chapters.first { $0.n == chapter }?.verses ?? []
    }

    /// Today's New Testament chapter, opened from the Bible rather than from
    /// Today, still gets its button to check the reading off.
    private var isTodaysReading: Bool {
        guard onFinished == nil, !routine.isDone(.reading) else { return false }
        let plan = NewTestamentPlan(bible: bible)
        guard !plan.chapters.isEmpty else { return false }
        return plan.index(of: book.id, chapter: chapter) == routine.chapterIndex(total: plan.chapters.count)
    }

    /// Every (book, chapter) in reading order, to step through.
    private var position: (all: [(BibleBook, Int)], index: Int) {
        let all = bible.books.flatMap { b in b.chapters.map { (b, $0.n) } }
        let index = all.firstIndex { $0.0.id == book.id && $0.1 == chapter } ?? 0
        return (all, index)
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Eyebrow(text: book.id == "PSA" ? book.name : L.string("Holy Bible", table: "Bible"))
                            .id("top")
                        Text(Self.title(bible: bible, book: book, chapter: chapter))
                            .font(MissaleFont.display(28))
                        Text(L.string("Tap a verse to highlight it.", table: "Bible"))
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.5))
                            .padding(.bottom, 6)

                        ForEach(verses, id: \.n) { verse in
                            let marked = notes.isHighlighted(bible, book.id, chapter, verse.n)
                            (Text(verse.s == nil ? "\(verse.n)  " : "\(verse.n)† ")
                                .font(MissaleFont.body(12 * ReadingTextSize.scale(textSize), weight: .semibold))
                                .foregroundColor(Palette.wine)
                             + Text(verse.t)
                                .font(MissaleFont.body(18 * ReadingTextSize.scale(textSize))))
                                .foregroundStyle(Palette.ink)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(marked ? Palette.goldBright.opacity(0.45) : .clear,
                                            in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .padding(.horizontal, -6)
                                .contentShape(Rectangle())
                                .onTapGesture { notes.toggleHighlight(bible, book.id, chapter, verse.n) }
                                .sensoryFeedback(.selection, trigger: marked)
                                .accessibilityAddTraits(marked ? [.isSelected, .isButton] : .isButton)
                                .id("v\(verse.n)")
                        }

                        supplementNote

                        if let onFinished {
                            finishButton {
                                onFinished()
                                dismiss()
                            }
                        } else {
                            if isTodaysReading {
                                finishButton { routine.markDone(.reading) }
                            }
                            stepper { proxy.scrollTo("top", anchor: .top) }
                                .padding(.top, 20)
                        }
                    }
                    .textSelection(.enabled)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .onAppear {
                    if let focusVerse { proxy.scrollTo("v\(focusVerse)", anchor: .center) }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ReadingTextSizeButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                let here = notes.isBookmarked(bible, book.id, chapter)
                Button {
                    notes.toggleBookmark(bible, book.id, chapter)
                } label: {
                    Image(systemName: here ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(Palette.wine)
                }
                .accessibilityLabel(L.string("Mark where I stopped", table: "Bible"))
                .sensoryFeedback(.success, trigger: here)
            }
        }
    }

    /// Names the other Bible behind any † verse in this chapter, so a filled
    /// gap is never read as this edition's own text.
    @ViewBuilder
    private var supplementNote: some View {
        let codes = Set(verses.compactMap(\.s))
        if !codes.isEmpty {
            let names = codes.sorted().map { bible.supplements?[$0] ?? $0 }.joined(separator: ", ")
            Text(L.string("† Verses marked come from the {source}, where this edition's text is missing or damaged.", table: "Bible")
                .replacingOccurrences(of: "{source}", with: names))
                .font(MissaleFont.body(13, italic: true))
                .foregroundStyle(Palette.ink.opacity(0.6))
                .padding(.top, 12)
        }
    }

    private func finishButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.string("Concluir leitura", table: "Today"))
                .font(MissaleFont.body(17, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(Palette.wine, in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.top, 24)
    }

    private func stepper(scrollToTop: @escaping () -> Void) -> some View {
        let (all, index) = position
        return HStack {
            if index > 0 {
                button(L.string("Previous chapter", table: "Bible"), icon: "chevron.left") {
                    (book, chapter) = all[index - 1]
                    scrollToTop()
                }
            }
            Spacer()
            if index < all.count - 1 {
                button(L.string("Next chapter", table: "Bible"), icon: "chevron.right", trailing: true) {
                    (book, chapter) = all[index + 1]
                    scrollToTop()
                }
            }
        }
    }

    private func button(_ title: String, icon: String, trailing: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if !trailing { Image(systemName: icon) }
                Text(title)
                if trailing { Image(systemName: icon) }
            }
            .font(MissaleFont.body(15, weight: .medium))
            .foregroundStyle(Palette.wine)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.45), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}
