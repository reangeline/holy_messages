import SwiftUI
import Foundation

/// t4 screen 19 — Formation lesson detail ("O Ato Penitencial"). Body paragraphs
/// support tappable, dotted-underlined inline glossary terms (e.g. "mea culpa").
struct FormationLessonView: View {
    let lesson: FormationLesson
    let onBackToTracks: () -> Void
    @ObservedObject private var progressStore = FormationProgressStore.shared
    @State private var activeTerm: LocalGlossaryTerm?
    @State private var showEndOfSession = false
    @AppStorage(ReadingTextSize.storageKey) private var textSize = ReadingTextSize.defaultStep

    /// Where the reader is in the lesson's pages — see `pages`.
    @State private var page = 0

    /// One idea per screen, the way onboarding reads: the opening, each
    /// paragraph, the quote, and the close. The lesson used to be one long
    /// scroll of text, which the testers found heavy for a daily part.
    private enum Page: Hashable {
        case opening
        case paragraph(Int)
        case quote
    }

    private var pages: [Page] {
        [.opening] + lesson.bodyParagraphs.indices.map(Page.paragraph) + (lesson.quoteText == nil ? [] : [.quote])
    }

    private var isLastPage: Bool { page >= pages.count - 1 }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                progressSegments
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { indice, item in
                        ScrollView {
                            pageContent(item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 24)
                                .padding(.top, 28)
                                .padding(.bottom, 24)
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        .tag(indice)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: page)

                footer
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
        .navigationTitle(MockFormation.track(withID: lesson.trackID)?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ReadingTextSizeButton()
            }
        }
        .navigationDestination(isPresented: $showEndOfSession) {
            EndOfSessionView(lesson: lesson, onBackToTracks: onBackToTracks)
        }
        .sheet(item: $activeTerm) { term in
            VStack(alignment: .leading, spacing: 10) {
                Text(term.term)
                    .font(MissaleFont.display(24, weight: .medium))
                Text(term.definition)
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.8))
                Spacer()
            }
            .padding(24)
            .presentationDetents([.fraction(0.3)])
        }
    }

    /// One capsule per page, filled up to the current one.
    private var progressSegments: some View {
        HStack(spacing: 4) {
            ForEach(pages.indices, id: \.self) { indice in
                Capsule()
                    .fill(indice <= page ? Palette.wine : Palette.wine.opacity(0.15))
                    .frame(height: 4)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: page)
    }

    @ViewBuilder
    private func pageContent(_ item: Page) -> some View {
        switch item {
        case .opening:
            VStack(alignment: .leading, spacing: 14) {
                Text(L.string("part {n} of {total}", table: "FormationWordOfDay")
                    .replacingOccurrences(of: "{n}", with: "\(lesson.partNumber)")
                    .replacingOccurrences(of: "{total}", with: "\(lesson.partsTotal)"))
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                Eyebrow(text: lesson.kicker)
                Text(lesson.title)
                    .font(MissaleFont.display(34, weight: .semibold))
                    .foregroundStyle(Palette.ink)
                CrossGlyph(size: 26, color: Palette.goldMuted)
                    .padding(.top, 10)
            }
            .padding(.top, 40)
        case .paragraph(let indice):
            Text(attributedParagraph(lesson.bodyParagraphs[indice]))
                .font(MissaleFont.body(20 * ReadingTextSize.scale(textSize)))
                .foregroundStyle(Palette.ink.opacity(0.9))
                .lineSpacing(6)
                .environment(\.openURL, OpenURLAction { url in
                    if url.scheme == "glossary" {
                        let requested = url.path.removingPercentEncoding?
                            .trimmingCharacters(in: CharacterSet(charactersIn: "/")) ?? ""
                        if let match = lesson.glossaryTerms.first(where: { $0.term == requested }) {
                            activeTerm = LocalGlossaryTerm(term: match.term, definition: match.definition)
                            return .handled
                        }
                    }
                    return .discarded
                })
        case .quote:
            if let quote = lesson.quoteText {
                LiturgicalGradientCard(color: .red) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(quote)
                            .font(MissaleFont.display(23 * ReadingTextSize.scale(textSize), italic: true))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.top, 40)
            }
        }
    }

    private var footer: some View {
        HStack(spacing: 12) {
            if page > 0 {
                Button {
                    page -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 52, height: 52)
                        .background(.ultraThinMaterial, in: Circle())
                        .foregroundStyle(Palette.wine)
                }
                .accessibilityLabel(Text("Previous page", tableName: "FormationWordOfDay"))
            }
            Button {
                if isLastPage {
                    progressStore.markCompleted(lesson.id)
                    showEndOfSession = true
                } else {
                    page += 1
                }
            } label: {
                Text(isLastPage
                     ? L.string("I finished this part", table: "FormationWordOfDay")
                     : L.string("Continue", table: "FormationWordOfDay"))
                    .font(MissaleFont.body(17, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Palette.wine, in: Capsule())
            }
        }
    }

    private func attributedParagraph(_ text: String) -> AttributedString {
        var attributed = AttributedString(text)
        for term in lesson.glossaryTerms {
            if let range = attributed.range(of: term.term, options: .caseInsensitive) {
                attributed[range].underlineStyle = Text.LineStyle(pattern: .dot, color: Palette.wine)
                attributed[range].foregroundColor = Palette.wine
                let encoded = term.term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? term.term
                attributed[range].link = URL(string: "glossary:///\(encoded)")
            }
        }
        return attributed
    }
}

private struct LocalGlossaryTerm: Identifiable {
    let term: String
    let definition: String
    var id: String { term }
}

#Preview {
    NavigationStack { FormationLessonView(lesson: MockFormation.atoPenitencial, onBackToTracks: {}) }
}
