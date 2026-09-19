import SwiftUI

/// Screen 1 (eIs1) — Today home. Greeting, mood entry, formation/word/saint/rosary
/// teaser cards, and the nightly Examen/Compline card.
struct TodayRootView: View {
    @State private var showMoodSheet = false
    @State private var navigateToExamen = false
    @ObservedObject private var progressStore = FormationProgressStore.shared
    @Environment(\.mainTabSelection) private var mainTabSelection
    @Environment(\.settingsPresented) private var settingsPresented
    @AppStorage(UserProfile.nameStorageKey) private var userDisplayName = ""

    private let day = MockLiturgical.today

    /// Real device time, not the app's fixed demo date — this is about the
    /// actual moment someone opens the app, so it should change through the day.
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let (withName, withoutName): (String, String) = switch hour {
        case 5..<12: ("Bom dia, {name}", "Bom dia!")
        case 12..<18: ("Boa tarde, {name}", "Boa tarde!")
        default: ("Boa noite, {name}", "Boa noite!")
        }
        let firstName = userDisplayName.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").first ?? ""
        guard !firstName.isEmpty else { return L.string(withoutName, table: "Today") }
        return L.string(withName, table: "Today").replacingOccurrences(of: "{name}", with: firstName)
    }
    // Goes through the region-keyed sanctoral calendar rather than a hardcoded
    // saint, even though only MockSaints.notburga is registered for today's date
    // right now — see SaintCalendarRegion.
    private var saintOfDay: Saint { MockSaints.saint(on: String(day.dateKey.suffix(5))) ?? MockSaints.notburga }

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
                    .padding(.top, 12)
                    .padding(.bottom, 110) // room for the floating glass tab bar
                }
            }
            .hubTabBarOverlay()
            .navigationDestination(isPresented: $navigateToExamen) {
                ExamenIntroView(onFinished: { navigateToExamen = false })
            }
            .sheet(isPresented: $showMoodSheet) {
                MoodCheckInSheet()
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink {
                    GlossaryView()
                } label: {
                    HStack(spacing: 8) {
                        Circle().fill(day.color.accent).frame(width: 9, height: 9)
                        Text("\(day.feastName) · \(day.color.name) · \(day.dayMonthLabel)")
                            .font(MissaleFont.body(11, weight: .semibold))
                            .tracking(1.2)
                            .foregroundStyle(day.color.accent)
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 10))
                            .foregroundStyle(day.color.accent.opacity(0.7))
                    }
                }
                .buttonStyle(.plain)
                Text(greeting)
                    .font(MissaleFont.display(28))
                    .foregroundStyle(Palette.ink)
            }
            Spacer()
            Button {
                settingsPresented?.wrappedValue = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(day.color.accent)
                    .frame(width: 34, height: 34)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
            }
        }
    }

    private var moodCard: some View {
        Button {
            showMoodSheet = true
        } label: {
            GlassCard {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Eyebrow(text: L.string("Hoje eu estou…", table: "Today"))
                        Text("Toque para registrar", tableName: "Today")
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
        let track = MockFormation.track
        let next = track.resumeLesson(progressStore) ?? track.lessons.last ?? MockFormation.atoPenitencial
        let trackFinished = track.completedCount(in: progressStore) == track.lessons.count
        return NavigationLink {
            FormationLessonView(lesson: next, onBackToTracks: {
                mainTabSelection?.wrappedValue = .formation
            })
        } label: {
            LiturgicalGradientCard(color: day.color) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(trackFinished
                         ? L.string("TRILHA CONCLUÍDA", table: "Today")
                         : L.string("SUA TRILHA · PARTE {n} DE {total}", table: "Today")
                             .replacingOccurrences(of: "{n}", with: "\(next.partNumber)")
                             .replacingOccurrences(of: "{total}", with: "\(next.partsTotal)"))
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(Palette.goldBright)
                    Text(next.title)
                        .font(MissaleFont.display(21, weight: .medium))
                        .foregroundStyle(.white)
                    // Track title comes from the content catalog, so it follows
                    // whichever language that track was authored in.
                    Text("\(track.title) · 4 min")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.88))
                    ProgressView(value: track.liveProgress(progressStore))
                        .tint(Palette.goldBright)
                        .padding(.top, 4)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var wordOfDayTeaserCard: some View {
        let word = MockWordOfDay.today
        return NavigationLink {
            WordOfDayView()
        } label: {
            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(text: L.string("Palavra de hoje", table: "Today"))
                    Text("\u{201C}\(word.quote)\u{201D}")
                        .font(MissaleFont.display(21, italic: true))
                        .foregroundStyle(Palette.ink)
                        .lineLimit(3)
                    Text(word.reference)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.65))
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var saintTeaserCard: some View {
        NavigationLink {
            SaintDetailView(saint: saintOfDay)
        } label: {
            GlassCard {
                HStack(spacing: 13) {
                    SaintPortraitPlaceholder()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 2) {
                        Eyebrow(text: L.string("Santo do dia", table: "Today"))
                        Text(saintOfDay.name)
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.ink)
                        Text("\(saintOfDay.role) · 3 min")
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.65))
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }

    private var rosaryTeaserCard: some View {
        let todays = MockRosary.todays
        return NavigationLink {
            RosaryMysteriesPickerView()
        } label: {
            GlassCard {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Eyebrow(text: L.string("Terço de hoje", table: "Today"))
                        Text(todays.mysterySet.displayTitle)
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
        .buttonStyle(.plain)
    }

    private var complineCard: some View {
        Button {
            navigateToExamen = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("À NOITE, ÀS 21H30", tableName: "Today")
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(Palette.goldBright)
                    Text("Exame do dia e Completas", tableName: "Today")
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

#Preview {
    TodayRootView()
}
