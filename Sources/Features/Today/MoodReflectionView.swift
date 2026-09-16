import SwiftUI

/// Sits between picking a state and seeing the Psalm/saint/step response — a
/// moment to write about what's actually going on before anything else appears,
/// rather than an optional one-line field squeezed onto the picker screen. The
/// response is picked (see MockMood.relief) only after this screen continues,
/// not before, so writing genuinely comes first.
struct MoodReflectionView: View {
    let state: MoodStateOption
    let onBack: () -> Void
    let onContinue: (String) -> Void

    @State private var note: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(L.string("‹ Voltar", table: "Today"), action: onBack)
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.wine)
                    Spacer()
                }
                .padding(.top, 8)

                Eyebrow(text: L.string("Hoje você está {state}", table: "Today")
                    .replacingOccurrences(of: "{state}", with: L.string(state.label, table: "Today").lowercased()))
                Text("O que está acontecendo?", tableName: "Today")
                    .font(MissaleFont.display(27, weight: .semibold))
                    .foregroundStyle(Palette.ink)
                Text("Opcional. Escreva antes de ver qualquer resposta — o que vem depois é para o que você escreveu, não um texto pronto.", tableName: "Today")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.65))

                TextEditor(text: $note)
                    .focused($isFocused)
                    .font(MissaleFont.body(17))
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .frame(minHeight: 160)
                    .background(Color.white.opacity(0.5), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.7), lineWidth: 1))

                Text("Fica só neste aparelho. Ninguém além de você vê isto.", tableName: "Today")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.5))

                Spacer()

                Button {
                    onContinue(note.trimmingCharacters(in: .whitespacesAndNewlines))
                } label: {
                    Text("Continuar", tableName: "Today")
                        .font(MissaleFont.body(17))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Palette.wine, in: Capsule())
                        .foregroundStyle(.white)
                }
                Button {
                    onContinue("")
                } label: {
                    Text("Pular, sem escrever nada", tableName: "Today")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .onAppear {
            // Let the slide-in transition finish before the keyboard pops up —
            // focusing immediately made the keyboard slam in at the same instant
            // as the screen, which read as just as abrupt as no transition at all.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isFocused = true
            }
        }
    }
}

#Preview {
    MoodReflectionView(state: MoodStateOption(id: "anxious", label: "Ansioso"), onBack: {}, onContinue: { _ in })
}
