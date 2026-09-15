import SwiftUI

/// t5 screen 7 (fIs7) — named content reviewers, so claims are checkable.
struct ContentReviewersView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Who reviewed the content", tableName: "SettingsDetail")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("By name, so you can verify.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    ForEach(MockSettings.reviewers) { reviewer in
                        GlassCard {
                            HStack(alignment: .top, spacing: 14) {
                                SaintPortraitPlaceholder().frame(width: 50, height: 50)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(reviewer.name).font(MissaleFont.body(18, weight: .medium))
                                    Text(reviewer.role.uppercased())
                                        .font(MissaleFont.body(12, weight: .semibold))
                                        .tracking(1)
                                        .foregroundStyle(Palette.goldDim)
                                    Text(reviewer.bio)
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.75))
                                        .padding(.top, 2)
                                }
                            }
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string( "How the content is made", table: "SettingsDetail"))
                            // MockSettings.contentProcessNote is not mine to edit; translated
                            // under a new key with matching meaning (policy text, not scripture).
                            Text("The explanatory texts are original and go through review before publishing. Liturgical quotes appear as support, with the source. Found a doctrinal error? Write to us — we correct it and log the correction.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                            Text(MockSettings.errorsEmail)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.wine)
                        }
                    }

                    // MockSettings.licensingNote is not mine to edit; translated under a
                    // new key with matching meaning, same reasoning as above.
                    Text("The liturgical translations used in this app are licensed with the corresponding episcopal conference. The biblical ones are public domain, with the version noted on each text.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.58))
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
