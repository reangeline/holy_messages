import SwiftUI

/// t5 screen 6 (fIs6) — "O que este app é, e o que ele não é": the three static
/// declarations (not confession, not spiritual direction, not therapy), what the
/// app actually offers, and where a grave question actually belongs.
struct PastoralNoteDetailView: View {
    @State private var showFullResources = false

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Eyebrow(text: L.string( "Pastoral note", table: "SettingsDetail"))
                        Text("What this app is, and what it isn't", tableName: "SettingsDetail")
                            .font(MissaleFont.display(28, weight: .semibold))
                    }

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("THREE STATEMENTS", tableName: "SettingsDetail")
                                .font(MissaleFont.body(11, weight: .semibold))
                                .tracking(1.4)
                                .foregroundStyle(Palette.goldBright)
                            declaration(
                                L.string( "It's not confession.", table: "SettingsDetail"),
                                L.string( "Nothing logged here is matter for absolution, and no text in this app forgives sin. Only the sacrament does that, and it happens with a priest.", table: "SettingsDetail")
                            )
                            declaration(
                                L.string( "It's not spiritual direction.", table: "SettingsDetail"),
                                L.string( "The answers are the same for everyone who picks the same state. Spiritual direction is someone who knows your story and answers you.", table: "SettingsDetail")
                            )
                            declaration(
                                L.string( "It's not therapy.", table: "SettingsDetail"),
                                L.string( "There's no clinical evaluation, diagnosis, or follow-up care. Psychological suffering calls for a professional, and the two paths don't compete.", table: "SettingsDetail")
                            )
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: L.string( "What it is", table: "SettingsDetail"))
                            Text("A place to receive the word of the day, get to know the saint of the day, understand the rites, and pray with the Church. When you log how you're doing, it offers what the tradition already has for that state: a psalm, someone who went through it, and one concrete step. Nothing beyond that.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.ink.opacity(0.86))
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string( "If the question is serious", table: "SettingsDetail"))
                            Text("Grave sin, a doubt of conscience, a life decision, a crisis: take it to a priest. This app shows you the nearest parish and confession hours, and that's the best it has to offer on this point.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                            Button {
                                showFullResources = true
                            } label: {
                                Text("Find a parish →", tableName: "SettingsDetail")
                            }
                            .font(MissaleFont.body(16, weight: .medium))
                            .foregroundStyle(Palette.wine)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showFullResources) {
            PastoralCareNudgeView()
        }
    }

    private func declaration(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(MissaleFont.body(17, weight: .semibold)).foregroundStyle(.white)
            Text(body).font(MissaleFont.body(15)).foregroundStyle(.white.opacity(0.88))
        }
    }
}
