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
        case relief(MoodStateOption)
        case scrupulosity
    }

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
                case .relief(let option):
                    if store.isSubscribed {
                        MoodReliefView(state: option) { dismiss() }
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
        let count = MoodHistoryStore.shared.record(state: option, note: note.isEmpty ? nil : note)
        let next: Step = (option.isScrupulosityTrigger && count >= 3) ? .scrupulosity : .relief(option)
        advance(to: next)
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

                    ForEach(MockMood.stateGroups) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: group.label)
                            FlowChips(items: group.items) { option in
                                advance(to: .reflection(option))
                            }
                        }
                    }
                }
            }
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
