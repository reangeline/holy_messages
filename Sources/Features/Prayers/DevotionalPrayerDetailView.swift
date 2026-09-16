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
                            Eyebrow(text: "Oração", color: Palette.goldBright)
                            Text(prayer.fullText)
                                .font(MissaleFont.display(19, italic: true))
                                .foregroundStyle(.white)
                        }
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
