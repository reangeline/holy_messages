import SwiftUI

/// One step of the guided Examen — write about it before moving on. Mirrors
/// MoodReflectionView's "write first" shape, in the Examen's own dark theme.
struct ExamenStepView: View {
    let step: ExamenStep
    let totalSteps: Int
    let initialText: String
    let onBack: () -> Void
    let onContinue: (String) -> Void

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    /// The review step looks back at what the reader hoped for this morning,
    /// in the Morning Offering — the routine's day read end to end.
    private var morningIntention: String? {
        step.number == 3 ? DailyRoutineStore.shared.intention() : nil
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(L.string("‹ Voltar", table: "Today"), action: onBack)
                        .foregroundStyle(Palette.goldBright)
                    Spacer()
                    Text(L.string("PASSO {n} DE {total}", table: "Today")
                        .replacingOccurrences(of: "{n}", with: "\(step.number)")
                        .replacingOccurrences(of: "{total}", with: "\(totalSteps)"))
                        .font(MissaleFont.body(12, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Eyebrow(text: step.title, color: Palette.goldBright)
                        Text(step.subtitle)
                            .font(MissaleFont.display(26, weight: .semibold))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)

                        if let morningIntention {
                            VStack(alignment: .leading, spacing: 4) {
                                Eyebrow(text: L.string("DE MANHÃ VOCÊ ESCREVEU", table: "Today"), color: .white.opacity(0.5))
                                Text("\u{201C}\(morningIntention)\u{201D}")
                                    .font(MissaleFont.display(19, italic: true))
                                    .foregroundStyle(Palette.goldBright)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .overlay(alignment: .leading) {
                                Capsule().fill(Palette.goldBright.opacity(0.6)).frame(width: 2).padding(.vertical, 12)
                            }
                            .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }

                        TextEditor(text: $text)
                            .focused($isFocused)
                            .font(MissaleFont.body(17))
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)
                            .padding(12)
                            .frame(minHeight: 160)
                            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.16), lineWidth: 1))

                        // With "Personalizar com o que escrevo" on, the answers go to Jev
                        // when the Examen ends (ExamenSuggestion) — "only on this
                        // device" would no longer be true.
                        Text(JevPicker.isEnabled
                             ? L.string("Fica neste aparelho. Ao concluir, o texto vai ao Jev só para escolher um santo e uma oração, sem ser guardado. Dá para desligar em Ajustes.", table: "Today")
                             : L.string("Fica só neste aparelho. Ninguém além de você vê isto.", table: "Today"))
                            .font(MissaleFont.body(13))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }
        }
        // Pinned above the keyboard instead of at the end of the VStack: the
        // text field autofocuses shortly after the step appears, and the
        // keyboard used to cover Continuar/Pular (ExamenSuggestionUITests).
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    onContinue(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } label: {
                    Text("Continuar", tableName: "Today")
                        .font(MissaleFont.body(18))
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(Palette.goldBright, in: Capsule())
                        .foregroundStyle(Color(hex: 0x2A1A1C))
                }
                Button {
                    onContinue("")
                } label: {
                    Text("Pular, sem escrever nada", tableName: "Today")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.55))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            text = initialText
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isFocused = true
            }
        }
    }
}

#Preview {
    ExamenStepView(step: MockRosary.examenSteps[0], totalSteps: 4, initialText: "", onBack: {}, onContinue: { _ in })
}
