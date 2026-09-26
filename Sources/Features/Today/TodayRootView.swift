import StoreKit
import SwiftUI

/// Screen 1 (eIs1) — Today home. Greeting, the daily routine (mood, New
/// Testament chapter, prayer, Examen), and formation/word/saint/rosary teasers.
struct TodayRootView: View {
    @State private var showMoodSheet = false
    @State private var navigateToExamen = false
    @ObservedObject private var progressStore = FormationProgressStore.shared
    @ObservedObject private var routine = DailyRoutineStore.shared
    @ObservedObject private var moodHistory = MoodHistoryStore.shared
    @ObservedObject private var examenHistory = ExamenHistoryStore.shared.list
    /// Redraws the saint and the word of the day once published content lands.
    @ObservedObject private var content = RemoteContentUpdater.Revision.shared
    /// Today's word chosen from what the reader wrote, when it is.
    @ObservedObject private var personalWord = PersonalizedWordOfDay.shared
    /// The reader's Bible, decoded off the main thread; nil until loaded, and
    /// nil after it when the app has no Bible in this language.
    @State private var bible: Bible?
    @State private var bibleLoaded = false
    @Environment(\.requestReview) private var requestReview
    @Environment(\.mainTabSelection) private var mainTabSelection
    @Environment(\.settingsPresented) private var settingsPresented
    @AppStorage(UserProfile.nameStorageKey) private var userDisplayName = ""
    /// Observed so the Examen row shows the new time as soon as it is changed
    /// on the Examen screen.
    @AppStorage(ExamenSchedule.storageKey) private var examenMinutes = ExamenSchedule.defaultMinutes

    /// Read on every render, not kept from init: open overnight, the header
    /// stayed on yesterday while the routine had already moved on.
    private var day: LiturgicalDay { MockLiturgical.today }

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
    // Goes through the region-keyed sanctoral calendar — see SaintCalendarRegion.
    // On a day with no record yet, a different saint from the catalog each day.
    private var saintEntry: (saint: Saint, isTodaysFeast: Bool) { MockSaints.saintOfDay(on: String(day.dateKey.suffix(5))) }
    private var saintOfDay: Saint { saintEntry.saint }

    var body: some View {
        NavigationStack {
            ZStack {
                day.color.pageBackground

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        header
                        routineSection
                        formationTeaserCard
                        if personalWord.showCrisisFirst {
                            CrisisSupportCard()
                        }
                        wordOfDayTeaserCard
                            .task { await personalWord.refresh() }
                        saintTeaserCard
                        rosaryTeaserCard
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
            .task {
                // Several megabytes of JSON: decoded off the main thread, once.
                let language = AppLanguagePreference.resolveCurrent()
                let all = await Task.detached(priority: .utility) { BibleCatalog.all }.value
                bible = all.first { $0.language == language.rawValue }
                bibleLoaded = true
            }
            .task {
#if DEBUG
                // "mood" e "mood-write" abrem a folha do humor direto: ela só
                // abre por toque, e as capturas da App Store são destas telas.
                if let tela = UserDefaults.standard.string(forKey: "openScreen"),
                   tela == "mood" || tela == "mood-write" { showMoodSheet = true }
#endif
            }
            // The whole routine done: a third such day is when the App Store
            // review is asked, once — see ReviewMilestone.
            .onChange(of: routineComplete, initial: true) { _, complete in
                guard complete, ReviewMilestone.recordCompleteRoutine() else { return }
                Task {
                    // Let the last check mark land before the system sheet.
                    try? await Task.sleep(for: .seconds(2))
                    requestReview()
                }
            }
            .sheet(isPresented: $showMoodSheet) {
                MoodCheckInSheet()
                    .appLanguageLocale()
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

    private var formationTeaserCard: some View {
        let track = MockFormation.track
        let next = track.resumeLesson(progressStore) ?? track.lessons.last ?? MockFormation.atoPenitencial
        let trackFinished = track.completedCount(in: progressStore) == track.lessons.count
        return GatedLink {
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
    }

    private var wordOfDayTeaserCard: some View {
        let word = MockWordOfDay.today
        return NavigationLink {
            WordOfDayView()
        } label: {
            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(text: L.string("Palavra de hoje", table: "Today"))
                    // A pick that lands after the date draw was shown swaps
                    // in place, with a crossfade and the label: one word on
                    // screen, the same as the widget's.
                    VStack(alignment: .leading, spacing: 6) {
                        if personalWord.isChosen { WordChosenLabel() }
                        Text("\u{201C}\(word.quote)\u{201D}")
                            .font(MissaleFont.display(21, italic: true))
                            .foregroundStyle(Palette.ink)
                            .lineLimit(3)
                        Text(word.reference)
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.65))
                    }
                    .id(word.id)
                    .transition(.opacity)
                }
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("todayWordOfDayCard")
            }
        }
        .buttonStyle(.plain)
    }

    private var saintTeaserCard: some View {
        GatedLink {
            SaintDetailView(saint: saintOfDay)
        } label: {
            GlassCard {
                HStack(spacing: 13) {
                    SaintPortrait(artworkName: saintOfDay.artworkName)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 2) {
                        Eyebrow(text: saintEntry.isTodaysFeast
                                ? L.string("Santo do dia", table: "Today")
                                : L.string("Um santo para conhecer", table: "Today"))
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
    }

    private var rosaryTeaserCard: some View {
        let todays = MockRosary.todays
        return GatedLink {
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
    }

    // MARK: - Seu dia com Deus

    private var moodDone: Bool { moodHistory.entries.contains { Calendar.current.isDateInToday($0.date) } }
    private var examenDone: Bool { examenHistory.items.contains { Calendar.current.isDateInToday($0.date) } }

    /// Today's chapter, once the Bible has loaded. No Bible in this language
    /// means no reading row, rather than a row that can't open.
    private var reading: (plan: NewTestamentPlan, index: Int)? {
        guard let bible else { return nil }
        let plan = NewTestamentPlan(bible: bible)
        guard !plan.chapters.isEmpty else { return nil }
        return (plan, routine.chapterIndex(total: plan.chapters.count))
    }

    private var showsReading: Bool { !bibleLoaded || reading != nil }
    private var routineTotal: Int { showsReading ? 5 : 4 }
    private var routineDone: Int {
        [routine.isDone(.morning), routine.isDone(.prayer), moodDone,
         routine.isDone(.reading) && showsReading, examenDone].filter { $0 }.count
    }
    /// Only once the Bible has loaded, so a missing reading row can't make
    /// three items look like the whole routine.
    private var routineComplete: Bool { bibleLoaded && routineDone == routineTotal }

    private var routineSection: some View {
        let total = routineTotal
        let done = routineDone
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Eyebrow(text: L.string("SEU DIA COM DEUS", table: "Today"))
                Spacer()
                Text(L.string("{done} de {total}", table: "Today")
                    .replacingOccurrences(of: "{done}", with: "\(done)")
                    .replacingOccurrences(of: "{total}", with: "\(total)"))
                    .font(MissaleFont.body(13, weight: .semibold))
                    .foregroundStyle(Palette.ink.opacity(0.5))
            }
            .padding(.top, 6)

            NavigationLink {
                MorningOfferingView()
            } label: {
                routineRow(icon: "sunrise", period: L.string("MANHÃ", table: "Today"),
                           title: L.string("Oferecimento do dia", table: "Today"),
                           subtitle: routine.intention().map { "\u{201C}\($0)\u{201D}" }
                               ?? L.string("Oração e o que espero do dia", table: "Today"),
                           trailing: minutes(2), isDone: routine.isDone(.morning))
            }
            .buttonStyle(.plain)

            IntentionVerseSection()

            NavigationLink {
                DailyPrayerView()
            } label: {
                routineRow(icon: "hands.and.sparkles", title: L.string("Oração", table: "Today"),
                           subtitle: DailyPrayer.today()?.title,
                           trailing: minutes(DailyPrayer.today().map(DailyPrayer.minutes) ?? 1),
                           isDone: routine.isDone(.prayer))
            }
            .buttonStyle(.plain)

            Button {
                showMoodSheet = true
            } label: {
                routineRow(icon: "sun.max", period: L.string("TARDE", table: "Today"),
                           title: L.string("Como está sendo meu dia?", table: "Today"),
                           trailing: minutes(1), isDone: moodDone)
            }
            .buttonStyle(.plain)

            if showsReading { readingRow }

            // A navegação é do Hoje (ver navigationDestination no body), para o
            // "Encerrar" do fim do Exame conseguir voltar até aqui de uma vez.
            GatedLink(presented: $navigateToExamen) {
                EmptyView()
            } label: {
                routineRow(icon: "moon.stars",
                           period: L.string("À NOITE, ÀS {time}", table: "Today")
                               .replacingOccurrences(of: "{time}", with: ExamenSchedule.timeLabel),
                           title: L.string("Exame do dia", table: "Today"),
                           trailing: minutes(5), isDone: examenDone)
            }
        }
    }

    @ViewBuilder
    private var readingRow: some View {
        if let bible, let reading {
            let (book, chapter) = reading.plan.chapters[reading.index]
            NavigationLink {
                BibleChapterView(bible: bible, book: book, chapter: chapter,
                                 onFinished: routine.isDone(.reading) ? nil : { routine.markDone(.reading) })
            } label: {
                HStack(alignment: .center, spacing: 14) {
                    routineIcon("book")
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L.string("Novo Testamento · {n} de {total}", table: "Today")
                            .replacingOccurrences(of: "{n}", with: "\(reading.index + 1)")
                            .replacingOccurrences(of: "{total}", with: "\(reading.plan.chapters.count)")
                            .uppercased())
                            .font(MissaleFont.body(11, weight: .semibold))
                            .tracking(1.2)
                            .foregroundStyle(Palette.wine)
                        Text("\(book.name) \(chapter)")
                            .font(MissaleFont.display(24, weight: .medium))
                            .foregroundStyle(Palette.ink)
                        Text(minutes(NewTestamentPlan.minutes(book, chapter: chapter)))
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                    }
                    Spacer()
                    if routine.isDone(.reading) {
                        doneMark
                    } else {
                        Text(L.string("Ler", table: "Today"))
                            .font(MissaleFont.body(15, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(Palette.wine, in: Capsule())
                    }
                }
                .routineRowBackground()
            }
            .buttonStyle(.plain)
        } else {
            routineRow(icon: "book", title: L.string("Novo Testamento", table: "Today"), trailing: "", isDone: false)
                .redacted(reason: .placeholder)
        }
    }

    /// `period` is the time of day the task belongs to (MANHÃ, TARDE, À NOITE…);
    /// `subtitle`, what it holds today — the prayer's name, the morning's line.
    private func routineRow(icon: String, period: String? = nil, title: String, subtitle: String? = nil,
                            trailing: String, isDone: Bool) -> some View {
        HStack(spacing: 14) {
            routineIcon(icon)
            VStack(alignment: .leading, spacing: 2) {
                if let period {
                    Text(period)
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(Palette.wine)
                }
                Text(title)
                    .font(MissaleFont.body(17, weight: .medium))
                    .foregroundStyle(Palette.ink)
                if let subtitle {
                    Text(subtitle)
                        .font(MissaleFont.body(14, italic: true))
                        .foregroundStyle(Palette.ink.opacity(0.6))
                        .lineLimit(2)
                }
            }
            Spacer()
            if isDone {
                doneMark
            } else {
                Text(trailing)
                    .font(MissaleFont.body(14))
                    .foregroundStyle(Palette.ink.opacity(0.55))
            }
        }
        .routineRowBackground()
    }

    private func routineIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 19, weight: .light))
            .foregroundStyle(Palette.wine)
            .frame(width: 28)
    }

    private var doneMark: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 24))
            .foregroundStyle(.white, Palette.green)
            .accessibilityLabel(L.string("Feito", table: "Today"))
    }

    private func minutes(_ n: Int) -> String {
        L.string("{n} min", table: "Today").replacingOccurrences(of: "{n}", with: "\(n)")
    }
}

private extension View {
    func routineRowBackground() -> some View {
        padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Palette.wine.opacity(0.1)))
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    TodayRootView()
}
