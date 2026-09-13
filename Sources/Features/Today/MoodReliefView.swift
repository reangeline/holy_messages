import SwiftUI

/// Screen 3 (eIs3) — tailored relief content shown right after logging a state:
/// a psalm, a saint who carried something similar, and one concrete step.
struct MoodReliefView: View {
    let state: MoodStateOption
    var onDone: () -> Void

    private var relief: ReliefContent { MockMood.relief(for: state.id) }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Button("‹ Voltar", action: onDone)
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.wine)
                        Spacer()
                        Text("Registrado · \(MockLiturgical.today.dayMonthLabel)")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                    }
                    .padding(.top, 8)

                    Eyebrow(text: "Hoje você está \(state.label.lowercased())")
                    Text(relief.title)
                        .font(MissaleFont.display(28, weight: .semibold))
                        .foregroundStyle(Palette.ink)

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: relief.psalmRef, color: Palette.goldBright)
                            Text(relief.psalmText)
                                .font(MissaleFont.display(21, italic: true))
                                .foregroundStyle(.white)
                            Text(relief.psalmWhy)
                                .font(MissaleFont.body(14))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }

                    GlassCard {
                        HStack(alignment: .top, spacing: 13) {
                            SaintPortraitPlaceholder().frame(width: 50, height: 50)
                            VStack(alignment: .leading, spacing: 3) {
                                Eyebrow(text: "Alguém que passou por isso")
                                Text(relief.saintName)
                                    .font(MissaleFont.body(17, weight: .medium))
                                Text(relief.saintWhy)
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "Um passo concreto")
                            Text(relief.stepTitle)
                                .font(MissaleFont.body(17, weight: .medium))
                            Text(relief.stepBody)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.75))
                        }
                    }

                    Text("Este registro entra no seu calendário. Ninguém além de você o vê — ele não sai deste aparelho.")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    MoodReliefView(state: MoodStateOption(id: "dryness", label: "Árido na oração")) {}
}
