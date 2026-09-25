import SwiftUI

/// Screen 2 (eIs2) — bottom sheet: "Hoje eu estou…" grouped chip picker. Tapping a
/// chip goes to a reflection screen (write about it, optional) before anything
/// else — the Psalm/saint/step response is only picked once that continues, so
/// nothing repetitive shows before the person has had a chance to write.
struct MoodCheckInSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step: Step = Self.passoInicial
    /// Which way the last step change went, so the slide transition can match:
    /// forward slides in from the trailing edge, back slides in from the leading
    /// edge — a plain conditional swap with no transition at all is what read as
    /// "seco" (abrupt) here.
    @State private var goingForward = true
    @State private var showPastoralCare = false
    @State private var showPaywall = false

    /// O único ponto deste fluxo que olha para a assinatura, e olha para um
    /// passo só: o Salmo, o santo e o passo do dia. Registrar como se está,
    /// escrever sobre isso e o caminho do apoio não passam por aqui — por isso
    /// o `MoodReliefView` continua sem uma linha sequer sobre assinatura.
    @ObservedObject private var store = SubscriptionStore.shared

    private enum Step: Equatable {
        case picker
        case reflection(MoodStateOption)
        /// `Int?`: the reply the orientação chose, when it chose one.
        case relief(MoodStateOption, Int?)
        case scrupulosity
        case guiding
        /// Crisis guidance first; the state and reply wait behind "continue".
        case crisis(MoodStateOption?, Int?)
    }

    /// What the reader wrote for the orientação.
    @State private var writtenText = ""
    /// Text that already went through the orientação but still needs a state
    /// from the reader (no connection, Jev unsure, the daily limit): the next
    /// chip tap logs it as that state's note, skipping the writing screen.
    @State private var pendingNote: String?
    /// Why the chips are being asked for after the reader wrote.
    @State private var orientationMessage: String?

    /// Normally the picker. `-openScreen mood-write` starts on the writing
    /// screen instead, which is otherwise two taps deep and so unreachable for
    /// a screenshot — the same reason `-openScreen examen` and `paywall` exist
    /// (see `AppRootView.debugOpenScreen`). The App Store listing shots are of
    /// these screens, and the Simulator cannot be tapped from a shell.
    private static var passoInicial: Step {
#if DEBUG
        if UserDefaults.standard.string(forKey: "openScreen") == "mood-write",
           let primeiro = MockMood.stateGroups.first?.items.first {
            return .reflection(primeiro)
        }
#endif
        return .picker
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.parchment.ignoresSafeArea()
                switch step {
                case .picker:
                    pickerBody
                        .transition(transition)
                case .reflection(let option):
                    MoodReflectionView(
                        state: option,
                        onBack: { retreat(to: .picker) },
                        onContinue: { note in finalize(option, note: note) }
                    )
                    .transition(transition)
                case .relief(let option, let chosenIndex):
                    if store.isSubscribed {
                        MoodReliefView(state: option, chosenIndex: chosenIndex) { dismiss() }
                            .transition(transition)
                    } else {
                        reliefBloqueado
                            .transition(transition)
                    }
                case .scrupulosity:
                    // Replaces relief outright once the pattern is established —
                    // the point is to interrupt the cycle, not add another
                    // reassurance on top.
                    ScrupulosityRedirectView()
                        .transition(transition)
                case .guiding:
                    guidingBody
                        .transition(transition)
                case .crisis(let option, let chosenIndex):
                    OrientationCrisisView {
                        if let option, let note = pendingNote {
                            complete(option, note: note, chosenIndex: chosenIndex)
                        } else {
                            retreat(to: .picker)
                        }
                    }
                    .transition(transition)
                }
            }
        }
    }

    /// O muro que substitui o alívio para quem não assina — e que carrega o
    /// caminho do apoio junto. Quem acabou de escrever "luto" e esbarra numa
    /// tela de venda não pode ficar sem saída: o link para o padre, a diocese
    /// ou a crise está aqui igual ao da primeira tela.
    private var reliefBloqueado: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 14) {
                CrossGlyph(size: 30, color: Palette.wine)
                Text("Um Salmo, um santo, e um passo", tableName: "Today")
                    .font(MissaleFont.display(27))
                    .foregroundStyle(Palette.ink)
                    .multilineTextAlignment(.center)
                Text("Escolhidos para o que você acabou de registrar. Vêm com o Missale Premium.", tableName: "Today")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.72))
                    .multilineTextAlignment(.center)

                Button {
                    showPaywall = true
                } label: {
                    Text("See the plans", tableName: "Onboarding")
                        .font(MissaleFont.body(17))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Palette.wine, in: Capsule())
                        .foregroundStyle(.white)
                }
                .padding(.top, 6)

                Text("O que você escreveu ficou salvo neste aparelho, com ou sem assinatura.", tableName: "Today")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.55))
                    .multilineTextAlignment(.center)

                Button {
                    showPastoralCare = true
                } label: {
                    Text("Precisa de mais do que isto? Padre, diocese, ou uma crise", tableName: "Today")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.wine)
                        .underline()
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)

                Button(L.string("‹ Voltar", table: "Today")) { dismiss() }
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                    .padding(.top, 2)
            }
            .padding(.horizontal, 32)
        }
    }

    private var transition: AnyTransition { directionalTransition(forward: goingForward) }

    private func advance(to next: Step) {
        goingForward = true
        withAnimation(.easeInOut(duration: 0.3)) { step = next }
    }

    private func retreat(to next: Step) {
        goingForward = false
        withAnimation(.easeInOut(duration: 0.3)) { step = next }
    }

    private func finalize(_ option: MoodStateOption, note: String) {
        complete(option, note: note, chosenIndex: nil)
    }

    private func complete(_ option: MoodStateOption, note: String, chosenIndex: Int?) {
        pendingNote = nil
        orientationMessage = nil
        let count = MoodHistoryStore.shared.record(state: option, note: note.isEmpty ? nil : note)
        let next: Step = (option.isScrupulosityTrigger && count >= 3) ? .scrupulosity : .relief(option, chosenIndex)
        advance(to: next)
    }

    // MARK: - Orientação

    private func requestOrientation() {
        let text = writtenText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        pendingNote = text
        orientationMessage = nil
        advance(to: .guiding)
        Task {
            do {
                let result = try await OrientationService.orient(text)
                let option = result.stateID.flatMap(Self.option(forID:))
                if result.showCrisisFirst {
                    advance(to: .crisis(option, result.reliefIndex))
                } else if let option {
                    complete(option, note: text, chosenIndex: result.reliefIndex)
                } else {
                    askForState(L.string("Não consegui entender bem como você está. Escolha abaixo — o que você escreveu vai junto.", table: "Today"))
                }
            } catch MissaleAPI.Failure.subscriptionRequired {
                askForState(nil)
                showPaywall = true
            } catch MissaleAPI.Failure.dailyLimit {
                askForState(L.string("Você já recebeu muitas orientações hoje. Escolha abaixo como você está — o que você escreveu vai junto.", table: "Today"))
            } catch {
                // Offline, the server, or a session that ended (the account
                // store signs out, and the app shows the sign-in screen).
                let crisis = CrisisPhrases.matches(text)
                askForState(L.string("Não consegui buscar a orientação agora. Escolha abaixo como você está — o que você escreveu vai junto.", table: "Today"))
                if crisis { advance(to: .crisis(nil, nil)) }
            }
        }
    }

    private func askForState(_ message: String?) {
        orientationMessage = message
        retreat(to: .picker)
    }

    private static func option(forID id: String) -> MoodStateOption? {
        MockMood.stateGroups.flatMap(\.items).first { $0.id == id }
    }

    private var guidingBody: some View {
        VStack(spacing: 18) {
            CrossGlyph(size: 30, color: Palette.wine)
            ProgressView().tint(Palette.wine)
            Text("Buscando nas Escrituras e nos santos uma palavra para você…", tableName: "Today")
                .font(MissaleFont.display(22))
                .foregroundStyle(Palette.ink)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 36)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("orientationGuiding")
    }

    private var pickerBody: some View {
        VStack(alignment: .leading, spacing: 4) {
            Capsule().fill(Palette.ink.opacity(0.2)).frame(width: 38, height: 4).frame(maxWidth: .infinity)
                .padding(.top, 10)
            Text("Hoje eu estou…", tableName: "Today")
                .font(MissaleFont.display(27, weight: .semibold))
                .foregroundStyle(Palette.ink)
                .padding(.top, 14)
            Text("Um toque. Fica no aparelho, e pode ficar em branco.", tableName: "Today")
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.ink.opacity(0.65))
                .padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Static, always here — not gated behind detecting a pattern.
                    Button {
                        showPastoralCare = true
                    } label: {
                        HStack {
                            Text("Precisa de mais do que isto? Padre, diocese, ou uma crise", tableName: "Today")
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.6))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundStyle(Palette.ink.opacity(0.4))
                        }
                    }
                    .buttonStyle(.plain)

                    OrientationWritingCard(text: $writtenText,
                                           onSend: requestOrientation,
                                           onLocked: { showPaywall = true })

                    if let orientationMessage {
                        Text(orientationMessage)
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.wine)
                            .accessibilityIdentifier("orientationMessage")
                    }

                    ForEach(MockMood.stateGroups) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: group.label)
                            FlowChips(items: group.items) { option in
                                if let note = pendingNote {
                                    finalize(option, note: note)
                                } else {
                                    advance(to: .reflection(option))
                                }
                            }
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 24)
        .sheet(isPresented: $showPaywall) {
            OnboardingPaywallView(onFinish: { showPaywall = false })
                .appLanguageLocale()
        }
        .sheet(isPresented: $showPastoralCare) {
            PastoralCareNudgeView()
                .appLanguageLocale()
        }
    }
}

/// Simple wrapping chip layout for the mood options within a group.
private struct FlowChips: View {
    let items: [MoodStateOption]
    let onTap: (MoodStateOption) -> Void

    var body: some View {
        // A basic flow layout via a lazy wrapping HStack-in-VStack approximation.
        let rows = chunk(items, perRow: 3)
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 8) {
                    ForEach(row) { item in
                        Button {
                            onTap(item)
                        } label: {
                            Text(item.label)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(item.isCrisisTrigger ? Palette.wine : Palette.ink)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 9)
                                .background(.ultraThinMaterial, in: Capsule())
                                .overlay(Capsule().strokeBorder(item.isCrisisTrigger ? Palette.wine.opacity(0.35) : Color.white.opacity(0.6), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func chunk(_ items: [MoodStateOption], perRow: Int) -> [[MoodStateOption]] {
        stride(from: 0, to: items.count, by: perRow).map { start in
            Array(items[start..<min(start + perRow, items.count)])
        }
    }
}

#Preview {
    MoodCheckInSheet()
}
