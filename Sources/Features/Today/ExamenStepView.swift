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

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
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
                .padding(.top, 8)

                Eyebrow(text: step.title, color: Palette.goldBright)
                Text(step.subtitle)
                    .font(MissaleFont.display(26, weight: .semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(MissaleFont.body(17))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .frame(minHeight: 160)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.16), lineWidth: 1))

                Text("Fica só neste aparelho. Ninguém além de você vê isto.", tableName: "Today")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.5))

                Spacer()

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
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
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
