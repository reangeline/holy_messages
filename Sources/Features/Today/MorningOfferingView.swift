import SwiftUI

/// The routine's morning: the traditional Morning Offering, prayed phrase by
/// phrase, then a line on what the reader hopes for the day — kept on the
/// device and shown back on the Today row.
struct MorningOfferingView: View {
    private enum Phase { case intro, praying, intention, done }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var routine = DailyRoutineStore.shared
    @State private var phase = Phase.intro
    @State private var text = ""
    @State private var checkVisible = false
    @FocusState private var writing: Bool

    private var phrases: [String] {
        Self.offering[AppLanguagePreference.resolveCurrent()] ?? Self.offering[.en]!
    }

    var body: some View {
        ZStack {
            Palette.night.ignoresSafeArea()
            switch phase {
            case .intro: intro
            case .praying:
                GuidedPrayerSequence(phrases: phrases) {
                    routine.markDone(.morning)
                    text = routine.intention() ?? ""
                    phase = .intention
                }
            case .intention: intention
            case .done: done
            }
        }
        .animation(.easeInOut(duration: 0.8), value: phase)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar(phase == .praying ? .hidden : .visible, for: .navigationBar)
#if DEBUG
        // `-openScreen morning-intention` skips the minute-long prayer, so a UI
        // test can reach the intention box.
        .onAppear {
            if phase == .intro, UserDefaults.standard.string(forKey: "openScreen") == "morning-intention" {
                text = routine.intention() ?? ""
                phase = .intention
            }
        }
#endif
    }

    private var intro: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                Eyebrow(text: L.string("MANHÃ", table: "Today"), color: Palette.goldBright)
                Text(L.string("Oferecimento do dia", table: "Today"))
                    .font(MissaleFont.display(34))
                    .foregroundStyle(.white)
                Text(L.string("Ofereça o dia a Deus antes de começar. Depois, escreva o que você espera dele.", table: "Today"))
                    .font(MissaleFont.body(17))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            Spacer()
            lightButton(L.string("Rezar agora", table: "Today")) { phase = .praying }
                .padding(.bottom, 24)
        }
        .transition(.opacity)
    }

    private var intention: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer().frame(height: 40)
            Text(L.string("O que você espera do seu dia?", table: "Today"))
                .font(MissaleFont.display(30))
                .foregroundStyle(.white)
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(L.string("Em poucas palavras, para você e para Deus.", table: "Today"))
                        .font(MissaleFont.body(18))
                        .foregroundStyle(.white.opacity(0.35))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                TextEditor(text: $text)
                    .font(MissaleFont.body(18))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .focused($writing)
            }
            .frame(height: 160)
            .padding(12)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            Spacer()
            lightButton(L.string("Guardar", table: "Today")) {
                // Only on save, never per keystroke. Jev picks the day's verse
                // in the background; Today shows it when it arrives.
                if routine.saveIntention(text) || routine.intentionVerseID() == nil,
                   let saved = routine.intention() {
                    IntentionVerse.request(for: saved)
                }
                finish()
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            Button(L.string("Pular", table: "Today"), action: finish)
                .font(MissaleFont.body(15))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .transition(.opacity)
        .onAppear { writing = true }
    }

    private var done: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Circle().strokeBorder(Palette.goldBright.opacity(0.35), lineWidth: 1).frame(width: 120, height: 120)
                Image(systemName: "sun.max")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(Palette.goldBright)
            }
            .scaleEffect(checkVisible ? 1 : 0.6)
            .opacity(checkVisible ? 1 : 0)
            .padding(.bottom, 28)
            Text(L.string("Seu dia está oferecido.", table: "Today"))
                .font(MissaleFont.display(32))
                .foregroundStyle(.white)
            Spacer()
            lightButton(L.string("Concluir", table: "Today")) { dismiss() }
                .padding(.bottom, 24)
        }
        .transition(.opacity)
        .sensoryFeedback(.success, trigger: checkVisible)
    }

    private func finish() {
        writing = false
        phase = .done
        withAnimation(.spring(duration: 0.8, bounce: 0.3).delay(0.4)) { checkVisible = true }
    }

    private func lightButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(MissaleFont.body(17, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(Palette.night)
                .background(.white, in: Capsule())
        }
        .padding(.horizontal, 24)
    }

    /// The Morning Offering of the Apostleship of Prayer, in its traditional form.
    static let offering: [AppLanguage: [String]] = [
        .pt: [
            "Ó Jesus, pelo Coração Imaculado de Maria,",
            "eu vos ofereço as orações, obras, alegrias e sofrimentos deste dia,",
            "por todas as intenções do vosso Sagrado Coração,",
            "em união com o Santo Sacrifício da Missa em todo o mundo,",
            "em reparação dos meus pecados, pelas intenções de todos os meus parentes e amigos,",
            "e em particular pelas intenções do Santo Padre. Amém.",
        ],
        .en: [
            "O Jesus, through the Immaculate Heart of Mary,",
            "I offer You my prayers, works, joys and sufferings of this day",
            "for all the intentions of Your Sacred Heart,",
            "in union with the Holy Sacrifice of the Mass throughout the world,",
            "in reparation for my sins, for the intentions of all my relatives and friends,",
            "and in particular for the intentions of the Holy Father. Amen.",
        ],
        .es: [
            "Oh Jesús, por medio del Corazón Inmaculado de María,",
            "te ofrezco mis oraciones, obras, alegrías y sufrimientos de este día,",
            "por todas las intenciones de tu Sagrado Corazón,",
            "en unión con el Santo Sacrificio de la Misa en todo el mundo,",
            "en reparación de mis pecados, por las intenciones de todos mis familiares y amigos,",
            "y en particular por las intenciones del Santo Padre. Amén.",
        ],
    ]
}
