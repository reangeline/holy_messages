import SwiftUI

/// t4 screen 21 — "Why is today red?" liturgical color explainer + glossary.
struct GlossaryView: View {
    private let day = MockLiturgical.today

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Por que hoje é vermelho?")
                        .font(MissaleFont.display(28, weight: .semibold))
                    Text("\(day.dayMonthLabel) · \(day.rank.rawValue.lowercased()) · \(day.feastName)")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.65))

                    Text(day.explanation)
                        .font(MissaleFont.body(17))
                        .foregroundStyle(Palette.ink.opacity(0.85))
                        .lineSpacing(3)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "Graus de celebração")
                            Text(MockLiturgical.ranksExplainer)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.8))
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("As cores litúrgicas")
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
                            Text("Toque em qualquer termo técnico no conteúdo para abrir a definição: mea culpa, Kyrie, lecionário, Completas.")
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
        .navigationTitle("Glossário")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { GlossaryView() }
}
