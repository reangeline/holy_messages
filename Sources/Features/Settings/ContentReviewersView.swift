import SwiftUI

/// t5 screen 7 (fIs7) — named content reviewers, so claims are checkable.
struct ContentReviewersView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Quem revisou o conteúdo")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("Com nome, para você poder verificar.")
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
                            Eyebrow(text: "Como o conteúdo é feito")
                            Text(MockSettings.contentProcessNote)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                            Text(MockSettings.errorsEmail)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.wine)
                        }
                    }

                    Text(MockSettings.licensingNote)
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
