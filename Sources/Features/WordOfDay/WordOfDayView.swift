import SwiftUI

/// t4 screen 15 — Word of the day. Standalone/independently navigable: push it with
/// `NavigationLink { WordOfDayView() }` from within an existing `NavigationStack`
/// (e.g. from Today), or wrap it in your own `NavigationStack` to present as a sheet.
struct WordOfDayView: View {
    private let word = MockWordOfDay.today
    private let day = MockLiturgical.today

    var body: some View {
        ZStack {
            day.color.pageBackground
            ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink {
                            ShareCardView()
                        } label: {
                            Text("Compartilhar ›")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.wine)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        LiturgicalGradientCard(color: day.color) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("PALAVRA DE HOJE")
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.6)
                                    .foregroundStyle(Palette.goldBright)
                                Text(word.quote)
                                    .font(MissaleFont.display(24, italic: true))
                                    .foregroundStyle(.white)
                                Text("\(word.reference) · \(word.translationNote)")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: "O contexto")
                                Text(word.context)
                                    .font(MissaleFont.body(16))
                                    .foregroundStyle(Palette.ink.opacity(0.85))
                                    .lineSpacing(3)
                            }
                        }

                        NavigationLink {
                            MassReadingsView()
                        } label: {
                            GlassCard {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("O que se lê hoje na Missa")
                                            .font(MissaleFont.body(17, weight: .medium))
                                            .foregroundStyle(Palette.ink)
                                        Text("Primeira leitura, salmo e Evangelho")
                                            .font(MissaleFont.body(14))
                                            .foregroundStyle(Palette.ink.opacity(0.65))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
            }
        }
        .navigationTitle("Palavra do dia")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { WordOfDayView() }
}
