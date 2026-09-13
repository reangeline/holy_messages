import SwiftUI

/// Screen 1 (eIs1) — Today home. Greeting, mood entry, formation/word/saint/rosary
/// teaser cards, and the nightly Examen/Compline card.
struct TodayRootView: View {
    @State private var showMoodSheet = false
    @State private var showDebugMenu = false
    @State private var navigateToExamen = false

    private let day = MockLiturgical.today

    var body: some View {
        NavigationStack {
            ZStack {
                day.color.pageBackground

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        header
                        moodCard
                        formationTeaserCard
                        wordOfDayTeaserCard
                        saintTeaserCard
                        rosaryTeaserCard
                        complineCard
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 110) // room for the floating glass tab bar
                }
            }
            .navigationDestination(isPresented: $navigateToExamen) {
                ExamenIntroView()
            }
            .sheet(isPresented: $showMoodSheet) {
                MoodCheckInSheet()
            }
            .sheet(isPresented: $showDebugMenu) {
                DebugMenuView()
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Circle().fill(day.color.accent).frame(width: 9, height: 9)
                    Text("\(day.feastName) · \(day.color.name) · \(day.dayMonthLabel)")
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(day.color.accent)
                }
                Text("Bom dia, Tiago")
                    .font(MissaleFont.display(28))
                    .foregroundStyle(Palette.ink)
            }
            Spacer()
            Button {
                showDebugMenu = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(day.color.accent)
                    .frame(width: 34, height: 34)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
            }
            // Debug-only entry point: screens 6, 7, 29 and 30 have no organic trigger in
            // this mocked-data pass (they're meant to fire from longitudinal pattern
            // detection, a repeated-question detector, and a schedule — none of which
            // exist yet), so they're only reachable from here for QA.
        }
    }

    private var moodCard: some View {
        Button {
            showMoodSheet = true
        } label: {
            GlassCard {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Eyebrow(text: "Hoje eu estou…")
                        Text("Toque para registrar")
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.ink)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Palette.wine)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var formationTeaserCard: some View {
        // Hooks into Sources/Features/Formation once that work stream lands; visual only for now.
        LiturgicalGradientCard(color: day.color) {
            VStack(alignment: .leading, spacing: 6) {
                Text("SUA TRILHA · PARTE 3 DE 14")
                    .font(MissaleFont.body(11, weight: .semibold))
                    .tracking(1.4)
                    .foregroundStyle(Palette.goldBright)
                Text("O Ato Penitencial")
                    .font(MissaleFont.display(21, weight: .medium))
                    .foregroundStyle(.white)
                Text("A Missa, parte por parte · 4 min")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.88))
                ProgressView(value: 3.0 / 14.0)
                    .tint(Palette.goldBright)
                    .padding(.top, 4)
            }
        }
        .opacity(0.85)
    }

    private var wordOfDayTeaserCard: some View {
        // Hooks into Sources/Features/WordOfDay once that work stream lands; visual only for now.
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Eyebrow(text: "Palavra de hoje")
                Text("“Como Moisés levantou a serpente no deserto, assim deve ser levantado o Filho do Homem.”")
                    .font(MissaleFont.display(21, italic: true))
                    .foregroundStyle(Palette.ink)
                Text("João 3, 14")
                    .font(MissaleFont.body(14))
                    .foregroundStyle(Palette.ink.opacity(0.65))
            }
        }
    }

    private var saintTeaserCard: some View {
        // Hooks into Sources/Features/Saints once that work stream lands; visual only for now.
        GlassCard {
            HStack(spacing: 13) {
                SaintPortraitPlaceholder()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 2) {
                    Eyebrow(text: "Santo do dia")
                    Text(MockSaints.notburga.name)
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(Palette.ink)
                    Text("\(MockSaints.notburga.role) · 3 min")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.65))
                }
            }
        }
    }

    private var rosaryTeaserCard: some View {
        // Hooks into Sources/Features/Prayers once that work stream lands; visual only for now.
        let todays = MockRosary.todays
        return GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Eyebrow(text: "Terço de hoje")
                    Text("Mistérios \(todays.mysterySet.rawValue)")
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(Palette.ink)
                    Text("\(todays.dayLabel) · 18 min")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.65))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Palette.wine)
            }
        }
    }

    private var complineCard: some View {
        Button {
            navigateToExamen = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("À NOITE, ÀS 21H30")
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(Palette.goldBright)
                    Text("Exame do dia e Completas")
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(16)
            .background(Palette.night, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

/// Debug-only menu surfacing the screens that this mocked-data pass has no organic
/// trigger for: pastoral nudge (6), scrupulosity redirect (7), Angelus nudge (29),
/// subscription cancellation (30). Not part of the design itself.
private struct DebugMenuView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Sem gatilho automático ainda") {
                    NavigationLink("Nota pastoral (tela 6)") { PastoralCareNudgeView() }
                    NavigationLink("Redirecionamento de escrúpulo (tela 7)") { ScrupulosityRedirectView() }
                    NavigationLink("Lembrete do Angelus (tela 29)") { AngelusNudgeView() }
                    NavigationLink("Cancelar assinatura (tela 30)") { SubscriptionCancellationView() }
                }
            }
            .navigationTitle("Debug")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    TodayRootView()
}
