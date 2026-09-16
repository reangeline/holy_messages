import SwiftUI
import Foundation

/// t4 screen 19 — Formation lesson detail ("O Ato Penitencial"). Body paragraphs
/// support tappable, dotted-underlined inline glossary terms (e.g. "mea culpa").
struct FormationLessonView: View {
    let lesson: FormationLesson
    @ObservedObject private var progressStore = FormationProgressStore.shared
    @State private var activeTerm: LocalGlossaryTerm?
    @State private var showEndOfSession = false

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(L.string("part {n} of {total}", table: "FormationWordOfDay")
                            .replacingOccurrences(of: "{n}", with: "\(lesson.partNumber)")
                            .replacingOccurrences(of: "{total}", with: "\(lesson.partsTotal)"))
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.5))
                        Spacer()
                    }
                    Eyebrow(text: lesson.kicker)
                    Text(lesson.title)
                        .font(MissaleFont.display(29, weight: .semibold))
                        .foregroundStyle(Palette.ink)

                    ForEach(Array(lesson.bodyParagraphs.enumerated()), id: \.offset) { _, paragraph in
                        Text(attributedParagraph(paragraph))
                            .font(MissaleFont.body(17))
                            .foregroundStyle(Palette.ink.opacity(0.88))
                            .lineSpacing(4)
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
                    }

                    if let quote = lesson.quoteText {
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(Palette.goldMuted)
                                .frame(width: 2)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(quote)
                                    .font(MissaleFont.display(19, italic: true))
                                    .foregroundStyle(Palette.ink.opacity(0.85))
                                if let attribution = lesson.quoteAttribution {
                                    Text(attribution)
                                        .font(MissaleFont.body(13))
                                        .foregroundStyle(Palette.ink.opacity(0.5))
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Button {
                        progressStore.markCompleted(lesson.id)
                        showEndOfSession = true
                    } label: {
                        Text("I finished this part", tableName: "FormationWordOfDay")
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Palette.wine, in: Capsule())
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("A Missa, parte por parte")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showEndOfSession) {
            EndOfSessionView(lesson: lesson)
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
    NavigationStack { FormationLessonView(lesson: MockFormation.atoPenitencial) }
}
