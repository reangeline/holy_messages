import SwiftUI

/// The orientação's writing box, at the top of "Hoje eu estou…".
///
/// Its own file on purpose: the orientação is a paid feature, and
/// `SubscriptionGateTests` allows the mood sheet a single mention of the
/// subscription (the relief step). Keeping this check here leaves that count —
/// and the guarantee behind it, that logging, the note and the crisis path
/// never ask for money — intact.
struct OrientationWritingCard: View {
    @Binding var text: String
    var onSend: () -> Void
    var onLocked: () -> Void
    /// The onboarding's orientação is free (a lifetime allowance per account,
    /// enforced by the server): no lock, no plans.
    var isFree = false

    @ObservedObject private var store = SubscriptionStore.shared
    /// Released on send: otherwise the keyboard comes back with the picker
    /// (no connection, Jev unsure) and hides the very chips the reader is asked
    /// to choose from.
    @FocusState private var editing: Bool

    /// Subscribers send; everyone else sees what it does and the way to the plans.
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Eyebrow(text: L.string("Orientação", table: "Today"))
                Text("Escreva o que você está sentindo", tableName: "Today")
                    .font(MissaleFont.body(18, weight: .medium))
                    .foregroundStyle(Palette.ink)
                TextField(L.string("Com as suas palavras, do jeito que vier.", table: "Today"),
                          text: $text, axis: .vertical)
                    .lineLimit(3...6)
                    .font(MissaleFont.body(16))
                    .textInputAutocapitalization(.sentences)
                    .onChange(of: text) { _, novo in
                        if novo.count > 1000 { text = String(novo.prefix(1000)) }
                    }
                    .focused($editing)
                    .accessibilityIdentifier("orientationText")

                Button {
                    editing = false
                    if isFree || store.isSubscribed { onSend() } else { onLocked() }
                } label: {
                    HStack(spacing: 8) {
                        if !isFree && !store.isSubscribed { Image(systemName: "lock.fill").font(.system(size: 13)) }
                        Text("Receber orientação", tableName: "Today")
                    }
                    .font(MissaleFont.body(16))
                    .frame(maxWidth: .infinity)
                    .padding(13)
                    .background(Palette.wine, in: Capsule())
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                .accessibilityIdentifier("orientationSend")

                // O consentimento, no ponto de uso: é a única coisa escrita
                // que sai do aparelho, e só neste toque.
                Text("Ao tocar, o que você escreveu vai para o servidor do Missale e para a IA que escolhe a resposta no nosso acervo. Não guardamos o texto.", tableName: "Today")
                    .font(MissaleFont.body(12))
                    .foregroundStyle(Palette.ink.opacity(0.55))
            }
        }
    }
}
