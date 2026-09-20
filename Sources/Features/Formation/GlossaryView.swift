import SwiftUI

/// t4 screen 21 — "Why is today red?" liturgical color explainer + glossary.
struct GlossaryView: View {
    private let day = MockLiturgical.today

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Why is today red?", tableName: "FormationWordOfDay")
                        .font(MissaleFont.display(28, weight: .semibold))
                    Text("\(day.dayMonthLabel) · \(day.rank.displayName.lowercased()) · \(day.feastName)")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.65))

                    Text(day.explanation)
                        .font(MissaleFont.body(17))
                        .foregroundStyle(Palette.ink.opacity(0.85))
                        .lineSpacing(3)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: L.string( "Degrees of celebration", table: "FormationWordOfDay"))
                            Text(MockLiturgical.ranksExplainer)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.8))
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("The liturgical colors", tableName: "FormationWordOfDay")
                            .font(MissaleFont.body(13, weight: .semibold))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                        ForEach(MockLiturgical.colorGuide) { info in
                            HStack(alignment: .top, spacing: 10) {
                                Circle().fill(info.color.accent).frame(width: 12, height: 12).padding(.top, 4)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(info.color.name).font(MissaleFont.body(16, weight: .medium))
                                    Text(info.color.meaning)
                                        .font(MissaleFont.body(14))
                                        .foregroundStyle(Palette.ink.opacity(0.65))
                                }
                            }
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(L.string("Tap any technical term in the content to open its definition.", table: "FormationWordOfDay"))
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.75))
                            ForEach(MockLiturgical.glossaryTerms, id: \.term) { term in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(term.term).font(MissaleFont.body(15, weight: .medium))
                                    Text(term.definition)
                                        .font(MissaleFont.body(14))
                                        .foregroundStyle(Palette.ink.opacity(0.65))
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(L.string( "Glossary", table: "FormationWordOfDay"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { GlossaryView() }
}
