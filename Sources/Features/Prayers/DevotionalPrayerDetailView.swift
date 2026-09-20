import SwiftUI

/// Full text of one devotional prayer — same "ORAÇÃO" gradient-card treatment
/// used on the saint detail screen, for a consistent reading moment.
struct DevotionalPrayerDetailView: View {
    let prayer: DevotionalPrayer

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        if let attribution = prayer.attribution {
                            Eyebrow(text: attribution)
                        }
                        Text(prayer.title)
                            .font(MissaleFont.display(28))
                    }
                    Text(prayer.focus)
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string("Prayer", table: "Prayers"), color: Palette.goldBright)
                            Text(prayer.fullText)
                                .font(MissaleFont.display(19, italic: true))
                                .foregroundStyle(.white)
                        }
                    }

                    if let saintID = prayer.saintID,
                       let saint = MockSaints.saint(withID: saintID) {
                        NavigationLink {
                            SaintDetailView(saint: saint)
                        } label: {
                            GlassCard {
                                HStack(spacing: 12) {
                                    SaintPortrait(artworkName: saint.artworkName, cornerRadius: 8)
                                        .frame(width: 44, height: 44)
                                    Text(L.string("View {name}'s record", table: "Prayers")
                                        .replacingOccurrences(of: "{name}", with: saint.name))
                                        .font(MissaleFont.body(16, weight: .medium))
                                        .foregroundStyle(Palette.ink)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Palette.wine)
                                }
                            }
                        }
                        .buttonStyle(.plain)
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

#Preview {
    NavigationStack { DevotionalPrayerDetailView(prayer: MockDevotionalPrayers.categories[0].prayers[0]) }
}
