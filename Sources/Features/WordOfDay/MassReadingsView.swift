import SwiftUI

/// t4 screen 16 — Mass readings of the day.
struct MassReadingsView: View {
    private let day = MockLiturgical.today

    var body: some View {
        ZStack {
            day.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Na Missa de hoje")
                            .font(MissaleFont.display(27))
                        Text("\(day.feastName) · \(day.rank.rawValue.lowercased()) · \(day.color.name.lowercased())")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.65))
                    }

                    ForEach(MockWordOfDay.massReadings) { reading in
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: reading.kicker)
                                Text(reading.title)
                                    .font(MissaleFont.display(19, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                Text(reading.summary)
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.78))
                            }
                        }
                    }

                    Text(MockWordOfDay.massReadingsFootnote)
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.5))
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Leituras")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { MassReadingsView() }
}
