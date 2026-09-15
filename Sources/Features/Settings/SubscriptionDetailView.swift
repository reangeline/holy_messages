import SwiftUI

/// t5 screen 2 (fIs2) — active subscription detail, explicit restore button,
/// what's included vs. free-forever, and the path to cancellation (fIs9).
struct SubscriptionDetailView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Subscription", tableName: "SettingsDetail")
                        .font(MissaleFont.display(29, weight: .semibold))

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("ACTIVE", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.4)
                                    .foregroundStyle(Palette.goldBright)
                                Spacer()
                                Text("US$ 39.99/year", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                            Text("Missale Premium · yearly", tableName: "SettingsDetail")
                                .font(MissaleFont.display(21, weight: .medium))
                                .foregroundStyle(.white)
                            Text("Automatically renews on October 14, 2026. Billed through the App Store.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(.white.opacity(0.88))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 9) {
                            Eyebrow(text: L.string( "What's included", table: "SettingsDetail"))
                            VStack(alignment: .leading, spacing: 8) {
                                Text("All formation tracks, and new ones as they launch", tableName: "SettingsDetail")
                                Text("The complete liturgical calendar, with every feast explained", tableName: "SettingsDetail")
                                Text("Traditional prayers and devotions, offline", tableName: "SettingsDetail")
                                Text("Guided rosary with voice, beginner mode, and dark screen", tableName: "SettingsDetail")
                            }
                            .font(MissaleFont.body(16))

                            Divider().padding(.vertical, 4)

                            Eyebrow(text: L.string( "Free forever, with or without a subscription", table: "SettingsDetail"))
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Word of the day and saint of the day", tableName: "SettingsDetail")
                                Text("The complete Rosary", tableName: "SettingsDetail")
                                Text("Your calendar and everything you've logged", tableName: "SettingsDetail")
                                Text("The pastoral referral network", tableName: "SettingsDetail")
                            }
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.78))
                        }
                    }

                    Button {
                        // UI-only for this pass — no real StoreKit transaction to restore.
                    } label: {
                        Text("Restore Purchases", tableName: "SettingsDetail")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                            .foregroundStyle(Palette.ink)
                    }

                    NavigationLink {
                        SubscriptionCancellationView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Cancel renewal", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(17))
                                    .foregroundStyle(Palette.ink)
                                Text("No questions, no discount offer", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.64))
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(16)
                    .background(Color.white.opacity(0.36))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 4])).foregroundStyle(Palette.ink.opacity(0.22)))

                    HStack(spacing: 16) {
                        NavigationLink(value: SettingsDestination.termsPlaceholder(L.string( "Terms of Use", table: "SettingsDetail"))) {
                            Text("Terms of Use", tableName: "SettingsDetail")
                        }
                        NavigationLink(value: SettingsDestination.termsPlaceholder(L.string( "Privacy Policy", table: "SettingsDetail"))) {
                            Text("Privacy Policy", tableName: "SettingsDetail")
                        }
                    }
                    .font(MissaleFont.body(15))
                    .tint(Palette.wine)

                    Text("The subscription renews automatically until canceled. Cancellation happens in your App Store account settings, at least 24 hours before the period ends.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
