import SwiftUI

/// t4 screen 9 — detail for a specific past day. Push/detail screen, no tab bar.
struct CalendarDayDetailView: View {
    let mark: CalendarDayMark
    /// This pass only has real detail content authored for one example day (Sept 8);
    /// other days reuse it so the drill-down never dead-ends.
    private var detail: DayDetail { MockLiturgical.sampleDayDetail }

    var body: some View {
        ZStack {
            detail.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text(detail.color.name)
                            .font(MissaleFont.body(12, weight: .semibold))
                            .tracking(1.2)
                            .foregroundStyle(detail.color.accent)
                        Spacer()
                    }
                    Eyebrow(text: detail.dateLabel)
                    Text(detail.feastName)
                        .font(MissaleFont.display(29))

                    if let title = detail.loggedStateTitle {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: "Você registrou")
                                Text(title).font(MissaleFont.body(19, weight: .medium))
                                if let note = detail.loggedNote {
                                    Text("\u{201C}\(note)\u{201D}")
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.72))
                                }
                            }
                        }
                    }

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: "A passagem daquele dia", color: Palette.goldBright)
                            Text(detail.psalmText)
                                .font(MissaleFont.display(21, italic: true))
                                .foregroundStyle(.white)
                            Text(detail.psalmRef)
                                .font(MissaleFont.body(14))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "Naquele dia na liturgia")
                            Text(detail.liturgyNote).font(MissaleFont.body(17))
                        }
                    }

                    if let other = detail.otherActivity {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: "Também naquele dia")
                                Text(other).font(MissaleFont.body(17))
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Setembro").font(MissaleFont.body(15, weight: .medium))
            }
        }
    }
}
