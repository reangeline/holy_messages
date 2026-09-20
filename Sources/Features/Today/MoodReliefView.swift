import SwiftUI

/// Screen 3 (eIs3) — tailored relief content shown right after logging a state:
/// a psalm, a saint who carried something similar, and one concrete step.
struct MoodReliefView: View {
    let state: MoodStateOption
    var onDone: () -> Void
    private let relief: ReliefContent

    // Picked once, at init, rather than as a computed property — a computed
    // property would re-roll a new (possibly different) variation on every
    // body re-render, which would both look buggy and record the wrong "last
    // shown" index for the anti-repetition check.
    init(state: MoodStateOption, onDone: @escaping () -> Void) {
        self.state = state
        self.onDone = onDone
        let lastIndex = MoodHistoryStore.shared.lastReliefIndex(for: state.id)
        let (content, index) = MockMood.relief(for: state.id, excluding: lastIndex)
        self.relief = content
        MoodHistoryStore.shared.recordReliefShown(stateID: state.id, index: index)
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Button(L.string("‹ Voltar", table: "Today"), action: onDone)
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.wine)
                        Spacer()
                        Text(L.string("Registrado · {date}", table: "Today")
                            .replacingOccurrences(of: "{date}", with: MockLiturgical.today.dayMonthLabel))
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                    }
                    .padding(.top, 8)

                    Eyebrow(text: L.string("Hoje você está {state}", table: "Today")
                        .replacingOccurrences(of: "{state}", with: L.string(state.label, table: "Today").lowercased()))
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

                    saintCard

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: L.string("Um passo concreto", table: "Today"))
                            Text(relief.stepTitle)
                                .font(MissaleFont.body(17, weight: .medium))
                            Text(relief.stepBody)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.75))
                        }
                    }

                    if state.isScrupulosityTrigger {
                        DashedUtilityCard {
                            Text(L.string(MockMood.confessorNudgeLine, table: "Today"))
                                .font(MissaleFont.body(14))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }

                    Text("Este registro entra no seu calendário. Ninguém além de você o vê — ele não sai deste aparelho.", tableName: "Today")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
    }

    private var linkedSaint: Saint? {
        if let saintID = relief.saintID, let saint = MockSaints.saint(withID: saintID) {
            return saint
        }
        return MockSaints.saint(referencedBy: relief.saintName)
    }

    @ViewBuilder
    private var saintCard: some View {
        if let saint = linkedSaint {
            NavigationLink {
                SaintDetailView(saint: saint)
            } label: {
                saintCardContent(saint: saint, showsChevron: true)
            }
            .buttonStyle(.plain)
        } else {
            saintCardContent(saint: nil, showsChevron: false)
        }
    }

    private func saintCardContent(saint: Saint?, showsChevron: Bool) -> some View {
        GlassCard {
            HStack(alignment: .top, spacing: 13) {
                if let saint {
                    SaintPortrait(artworkName: saint.artworkName, cornerRadius: 10)
                        .frame(width: 50, height: 50)
                } else {
                    SaintPortraitPlaceholder().frame(width: 50, height: 50)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Eyebrow(text: L.string("Alguém que passou por isso", table: "Today"))
                    Text(relief.saintName)
                        .font(MissaleFont.body(17, weight: .medium))
                    Text(relief.saintWhy)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.72))
                }
                if showsChevron {
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Palette.wine)
                        .padding(.top, 4)
                }
            }
        }
    }
}

#Preview {
    MoodReliefView(state: MoodStateOption(id: "dryness", label: "Árido na oração")) {}
}
