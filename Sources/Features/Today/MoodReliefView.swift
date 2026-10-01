import SwiftUI

/// Screen 3 (eIs3) — tailored relief content shown right after logging a state:
/// a passage (a psalm or a Word of the Day verse), a saint who carried something similar, and one concrete step.
struct MoodReliefView: View {
    let state: MoodStateOption
    var onDone: () -> Void
    /// In the onboarding the reply is a step forward, not a sheet to close:
    /// the "‹ Voltar" at the top gives way to this button at the bottom.
    var continueTitle: String? = nil
    private let relief: ReliefContent
    /// The red block: the passage the orientação chose, else the relief's psalm.
    private let shown: OrientationPassage
    /// What the reader wrote, when a reflection may be asked for it: only
    /// after Jev chose this reply and the orientação did not open the crisis
    /// flow. Nil asks nothing. The reflection stays in memory, never saved.
    private let reflectionText: String?
    private let reflectionFree: Bool
    /// The onboarding's questionnaire answers, sent along with the reflection.
    private let reflectionContext: String?
    @State private var reflection: String?
    @State private var isReflecting = false
    /// The Bible and the chapter behind `shown.reference`, once found. While
    /// nil (or when the reference can't be placed) the block is just text.
    @State private var passage: (bible: Bible, passage: ReliefPassage)?
    @State private var showPassage = false

    // Picked once, at init, rather than as a computed property — a computed
    // property would re-roll a new (possibly different) variation on every
    // body re-render, which would both look buggy and record the wrong "last
    // shown" index for the anti-repetition check.
    /// `chosenIndex` is the variation the orientação picked for what the
    /// reader wrote; without it, one is drawn avoiding the last shown.
    init(state: MoodStateOption, chosenIndex: Int? = nil, chosenPassage: OrientationPassage? = nil, continueTitle: String? = nil,
         reflectionText: String? = nil, reflectionFree: Bool = false,
         reflectionContext: String? = nil, onDone: @escaping () -> Void) {
        self.state = state
        self.onDone = onDone
        self.continueTitle = continueTitle
        self.reflectionFree = reflectionFree
        self.reflectionContext = reflectionContext
        if let chosenIndex, let variants = MockMood.reliefVariants(for: state.id),
           variants.indices.contains(chosenIndex) {
            self.relief = variants[chosenIndex]
            self.shown = chosenPassage ?? OrientationPassage(psalmOf: variants[chosenIndex])
            self.reflectionText = reflectionText
            MoodHistoryStore.shared.recordReliefShown(stateID: state.id, index: chosenIndex)
            return
        }
        self.reflectionText = nil   // Jev made no choice: nothing to reflect on
        let lastIndex = MoodHistoryStore.shared.lastReliefIndex(for: state.id)
        let (content, index) = MockMood.relief(for: state.id, excluding: lastIndex)
        self.relief = content
        self.shown = OrientationPassage(psalmOf: content)
        MoodHistoryStore.shared.recordReliefShown(stateID: state.id, index: index)
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        if continueTitle == nil {
                            Button(L.string("‹ Voltar", table: "Today"), action: onDone)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.wine)
                        }
                        Spacer()
                        Text(L.string("Registrado · {date}", table: "Today")
                            .replacingOccurrences(of: "{date}", with: MockLiturgical.today.dayMonthLabel))
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                    }
                    .padding(.top, 8)

                    Eyebrow(text: L.string("Hoje você está {state}", table: "Today")
                        .replacingOccurrences(of: "{state}", with: state.label.lowercased()))
                    // The title quotes the reply's own psalm: over another
                    // passage it would read as a non sequitur, so it steps aside.
                    if shown.reference == relief.psalmRef {
                        Text(relief.title)
                            .font(MissaleFont.display(28, weight: .semibold))
                            .foregroundStyle(Palette.ink)
                    }

                    passageBlock

                    saintCard

                    reflectionCard

                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            // O próprio registro já traz o rótulo no idioma do
                            // acervo, como no onboarding; uma tarja fixa aqui
                            // repetia a mesma frase duas vezes na tela.
                            Eyebrow(text: relief.stepTitle)
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

                    // Same exception as MoodReflectionView's note: with
                    // personalization on, this entry's note may go to Jev for
                    // the Word of the Day.
                    Text(JevPicker.isActive
                         ? L.string("Este registro entra no seu calendário. Pode ir ao Jev para escolher a palavra do dia, sem ser guardado. Dá para desligar em Ajustes.", table: "Today")
                         : L.string("Este registro entra no seu calendário. Ninguém além de você o vê — ele não sai deste aparelho.", table: "Today"))
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))

                    if let continueTitle {
                        OnboardingPrimaryButton(title: continueTitle, isEnabled: true, action: onDone)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .task {
            // Runs again on the way back from the saint's page: ask once, and
            // never let a later failure wipe a reflection already shown.
            guard let reflectionText, reflection == nil, !isReflecting else { return }
            isReflecting = true
            let result = await OrientationService.reflect(on: reflectionText, relief: relief, passage: shown, free: reflectionFree,
                                                          context: reflectionContext)
            if let result { withAnimation(.easeInOut(duration: 0.25)) { reflection = result } }
            isReflecting = false
        }
        // Off the main thread: the first touch decodes the whole Bible.
        .task {
            let reference = shown.reference
            let language = AppLanguagePreference.resolveCurrent()
            passage = await Task.detached(priority: .userInitiated) {
                guard let bible = BibleCatalog.bible(for: language),
                      let found = ReliefPassage.resolve(reference, in: bible) else { return nil }
                return (bible, found)
            }.value
        }
    }

    /// Absent until the reflection arrives, and for good if it never does.
    @ViewBuilder
    private var reflectionCard: some View {
        if let reflection {
            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(text: L.string("Uma palavra para você", table: "Today"))
                    Text(reflection)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.75))
                    Text("Escrita por IA a partir da passagem e do santo.", tableName: "Today")
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.45))
                }
            }
            .transition(.opacity)
            .accessibilityIdentifier("orientationReflection")
        } else if isReflecting {
            ProgressView().tint(Palette.wine)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier("orientationReflectionLoading")
        }
    }

    private var passageCard: some View {
        LiturgicalGradientCard(color: .red) {
            VStack(alignment: .leading, spacing: 8) {
                Eyebrow(text: shown.reference, color: Palette.goldBright)
                Text(shown.text)
                    .font(MissaleFont.display(21, italic: true))
                    .foregroundStyle(.white)
                Text(shown.why)
                    .font(MissaleFont.body(14))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
    }

    /// Tap opens the whole chapter, with the quoted verses marked. Without a
    /// chapter to open it stays the plain card it was.
    @ViewBuilder
    private var passageBlock: some View {
        if let passage {
            Button { showPassage = true } label: { passageCard }
                .buttonStyle(.plain)
                .accessibilityHint(L.string("Toque para ler o capítulo inteiro", table: "Today"))
                .sheet(isPresented: $showPassage) {
                    NavigationStack {
                        BibleChapterView(bible: passage.bible, book: passage.passage.book,
                                         chapter: passage.passage.chapter,
                                         focusVerse: passage.passage.verses?.lowerBound,
                                         passage: passage.passage.verses)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(L.string("Fechar", table: "Today")) { showPassage = false }
                                        .foregroundStyle(Palette.wine)
                                }
                            }
                    }
                }
        } else {
            passageCard
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
