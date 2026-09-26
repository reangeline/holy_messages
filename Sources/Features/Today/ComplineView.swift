import SwiftUI

/// Screen 5 (eIs5) — Compline / night prayer. Full-text reading with a dark-mode
/// toggle; "Terminar e apagar a tela" is this flow's literal end-of-session action.
struct ComplineView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var darkScreen = true
    @ObservedObject private var routine = DailyRoutineStore.shared

    /// Read at body time, not stored: the language can change under the screen.
    private var texts: ComplineText { MockCompline.today }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x181315).opacity(0.94), Color(hex: 0x28181C).opacity(0.94)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(L.string("‹ Voltar", table: "Today")) { dismiss() }
                        .foregroundStyle(Palette.goldBright)
                    Spacer()
                    HStack(spacing: 8) {
                        Text("Tela escura", tableName: "Today").font(MissaleFont.body(13)).foregroundStyle(.white.opacity(0.55))
                        Toggle("", isOn: $darkScreen)
                            .labelsHidden()
                            .tint(Palette.goldBright)
                    }
                }
                .padding(.top, 8)

                Eyebrow(text: L.string("Completas · oração da noite", table: "Today"), color: Palette.goldBright)
                    .padding(.top, 18)
                Text("\(MockLiturgical.today.weekdayLabel), \(MockLiturgical.today.feastName)")
                    .font(MissaleFont.display(28, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 6)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(texts.opening)
                            .font(MissaleFont.display(21, italic: true))
                            .foregroundStyle(Palette.goldBright)
                        Text("\(texts.invitatory) \(texts.gloryBe)")
                            .font(MissaleFont.body(18))
                            .foregroundStyle(.white.opacity(0.88))
                        Text(texts.psalmLabel)
                            .font(MissaleFont.body(12, weight: .semibold))
                            .tracking(1.4)
                            .foregroundStyle(.white.opacity(0.5))
                        Text(texts.psalmText)
                            .font(MissaleFont.body(18))
                            .foregroundStyle(.white.opacity(0.88))
                        Text(texts.note)
                            .font(MissaleFont.body(15))
                            .foregroundStyle(.white.opacity(0.55))
                        morningRecall
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Terminar e apagar a tela", tableName: "Today")
                        .font(MissaleFont.body(17))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.clear)
                        .overlay(Capsule().strokeBorder(.white.opacity(0.4), lineWidth: 1))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .brightness(darkScreen ? 0 : 0.15)
        }
        .navigationBarBackButtonHidden(true)
    }

    /// Before closing the day, what the reader asked for this morning — in
    /// their own words, exactly. The verse Jev chose for it joins in when
    /// there is one; personalization off, or Jev not having answered yet,
    /// still shows the intention on its own.
    @ViewBuilder
    private var morningRecall: some View {
        if let intention = routine.intention() {
            VStack(alignment: .leading, spacing: 10) {
                if routine.showsCrisisForIntention() {
                    CrisisSupportCard()
                        .padding(16)
                        .background(Palette.parchment, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                Text(L.string("Hoje de manhã você pediu por:", table: "Today"))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.6))
                Text("\u{201C}\(intention)\u{201D}")
                    .font(MissaleFont.display(19, italic: true))
                    .foregroundStyle(.white.opacity(0.9))
                if let id = routine.intentionVerseID(), let verse = IntentionVerse.verse(id: id) {
                    IntentionVerseText(verse: verse, ink: .white.opacity(0.88), accent: Palette.goldBright)
                        .padding(.top, 4)
                }
                Text(L.string("Entregue a Deus o que o dia trouxe.", table: "Today"))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.55))
            }
            .padding(.top, 10)
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("complineMorningRecall")
        }
    }
}

#Preview {
    NavigationStack { ComplineView() }
}
