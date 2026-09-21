import SwiftUI

/// t5 screen 8 (fIs8) — human support contact, the explicit no-questions-asked
/// hardship policy, parish/catechesis licensing, and links (FAQ, Terms, Privacy).
struct SupportView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Support", tableName: "SettingsDetail")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("People respond, not a form.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Write to us", tableName: "SettingsDetail").font(MissaleFont.body(18, weight: .medium))
                            Text("We respond within two business days, in Portuguese or English. One of the three people who make the app answers.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.74))
                            Text(MockSettings.supportEmail)
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.wine)
                        }
                    }

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("FREE ACCESS", tableName: "SettingsDetail")
                                .font(MissaleFont.body(11, weight: .semibold))
                                .tracking(1.4)
                                .foregroundStyle(Palette.goldBright)
                            Text("If price is the problem, it stops being one", tableName: "SettingsDetail")
                                .font(MissaleFont.body(19, weight: .medium))
                                .foregroundStyle(.white)
                            Text("Write in and we'll unlock full access. No proof of income, no explanation, no deadline. This isn't an exception, it's policy — no one is left out of formation because of money.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(.white.opacity(0.92))
                            Text(MockSettings.accessEmail)
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.goldBright)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Parishes and catechesis", tableName: "SettingsDetail").font(MissaleFont.body(18, weight: .medium))
                            Text("Bulk licenses for groups, OCIA catechumens, and pastoral teams, also free. Talk to us.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.74))
                        }
                    }

                    VStack(spacing: 0) {
                        linkRow(L.string( "Frequently asked questions", table: "SettingsDetail"), destination: .faq)
                        Divider().opacity(0.5)
                        linkRow(L.string( "Terms of Use", table: "SettingsDetail"), destination: .legal(.terms))
                        Divider().opacity(0.5)
                        linkRow(L.string( "Privacy Policy", table: "SettingsDetail"), destination: .legal(.privacy))
                    }
                    .background(Color.white.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.58), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func linkRow(_ title: String, destination: SettingsDestination) -> some View {
        NavigationLink(value: destination) {
            HStack {
                Text(title).font(MissaleFont.body(17)).foregroundStyle(Palette.ink)
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13)).foregroundStyle(Palette.ink.opacity(0.35))
            }
            .padding(14)
        }
        .buttonStyle(.plain)
    }
}
