import SwiftUI

/// t4 screen 13 — saints curated from whatever the user recently logged.
struct SaintsForYouView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Santos para o que você carrega")
                        .font(MissaleFont.display(29))
                    Text("A partir do que você registrou: aridez na oração.")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.7))

                    ForEach(MockSaints.saintsForYou) { recommendation in
                        GlassCard {
                            HStack(alignment: .top, spacing: 13) {
                                SaintPortraitPlaceholder()
                                    .frame(width: 48, height: 48)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(recommendation.name)
                                        .font(MissaleFont.body(17, weight: .medium))
                                    Text(recommendation.reason)
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.74))
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
