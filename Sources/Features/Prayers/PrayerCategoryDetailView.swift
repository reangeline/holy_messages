import SwiftUI

/// List of prayers within one devotional category (e.g. "Orações de Paz e Entrega").
struct PrayerCategoryDetailView: View {
    let category: PrayerCategory

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(category.title)
                        .font(MissaleFont.display(26))
                        .padding(.bottom, 6)

                    ForEach(category.prayers) { prayer in
                        NavigationLink {
                            DevotionalPrayerDetailView(prayer: prayer)
                        } label: {
                            GlassCard {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(prayer.title)
                                        .font(MissaleFont.body(17, weight: .medium))
                                        .foregroundStyle(Palette.ink)
                                    if let attribution = prayer.attribution {
                                        Text(attribution)
                                            .font(MissaleFont.body(13))
                                            .foregroundStyle(Palette.wine)
                                    }
                                    Text(prayer.focus)
                                        .font(MissaleFont.body(14))
                                        .foregroundStyle(Palette.ink.opacity(0.65))
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
    NavigationStack { PrayerCategoryDetailView(category: MockDevotionalPrayers.categories[0]) }
}
