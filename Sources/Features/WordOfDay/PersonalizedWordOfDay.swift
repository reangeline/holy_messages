import Combine
import SwiftUI
import WidgetKit

/// The Word of the Day, chosen for the reader from what they wrote — for
/// subscribers with "Personalizar com o que escrevo" on. Everyone else, and
/// anyone who wrote nothing in the last 24 hours, keeps the date draw.
///
/// - Input: the newest of the latest mood check-in note and today's morning
///   intention, from the last 24 hours.
/// - Jev picks one verse from the current language's reviewed pool, minus
///   the words shown in the last 30 days (JevPicker chunks it in two calls).
/// - At most once a day: once Jev was asked, the day's word is fixed. The
///   only change a reader can see is the date draw giving way to the chosen
///   word, once, in place, with a crossfade and the label.
/// - The choice lives in `WordOfDayLog` (app group), so Today, the word
///   screen, the share card, the reading notice and the widget show the
///   same verse; the widget's timeline is reloaded after a pick.
@MainActor
final class PersonalizedWordOfDay: ObservableObject {
    static let shared = PersonalizedWordOfDay()

    static let pickName = "word"
    static let recentTextWindow: TimeInterval = 24 * 60 * 60
    /// Several dozen options spread the probability thin.
    static let minimumConfidence = 0.15

    /// Today's word was chosen for the reader: the views show the label.
    @Published private(set) var isChosen = false
    /// What the reader wrote carried a sign of risk: the crisis card goes
    /// beside the word.
    @Published private(set) var showCrisisFirst = false

    private var inFlight = false
    private var observers: [AnyCancellable] = []

    private init() {
        sync()
        // Writing a check-in note or the morning intention is what makes a
        // pick possible, so each is a chance to ask — still once a day.
        MoodHistoryStore.shared.$entries.dropFirst()
            .sink { [weak self] _ in Task { await self?.refresh() } }
            .store(in: &observers)
        DailyRoutineStore.shared.$intentions.dropFirst()
            .sink { [weak self] _ in Task { await self?.refresh() } }
            .store(in: &observers)
        for name in [UIApplication.didBecomeActiveNotification, .NSCalendarDayChanged] {
            NotificationCenter.default.publisher(for: name)
                .sink { [weak self] _ in Task { await self?.refresh() } }
                .store(in: &observers)
        }
    }

    /// Reads today's entry into the published flags.
    func sync() {
        let entry = WordOfDayLog.entries()[MockLiturgical.today.dateKey]
        let language = AppLanguagePreference.resolveCurrent().rawValue
        let chosen = entry?.chosen == true && entry?.language == language
            && MockWordOfDay.today.id == entry?.id
        if chosen != isChosen { isChosen = chosen }
        let crisis = entry?.showCrisisFirst ?? false
        if crisis != showCrisisFirst { showCrisisFirst = crisis }
    }

    /// Asks Jev when today's word hasn't been asked about yet and there is
    /// something recent to read. Never blocks: the date draw is on screen
    /// meanwhile, and stays when anything is missing.
    func refresh() async {
#if DEBUG
        Self.resetForUITestsOnce()
#endif
        guard !inFlight else { return }
        inFlight = true
        defer { inFlight = false }

        let day = MockLiturgical.today.dateKey
        let text = Self.inputText(moods: MoodHistoryStore.shared.entries,
                                  intentions: DailyRoutineStore.shared.intentions, now: Date())
        let before = WordOfDayLog.entries()
        let after = await Self.resolve(log: before, day: day,
                                       language: AppLanguagePreference.resolveCurrent().rawValue,
                                       pool: MockWordOfDay.pool, drawn: MockWordOfDay.wordOfDay(for: day),
                                       text: text, enabled: JevPicker.isEnabled,
                                       excludingVerseID: DailyRoutineStore.shared.intentionVerseID()) { text, picks in
            await JevPicker.pick(from: text, picks)
        }
        // The day may have turned while Jev was thinking; an old answer is dropped.
        guard day == MockLiturgical.today.dateKey else { return }
        if after != before {
            WordOfDayLog.save(after)
            if after[day]?.chosen != before[day]?.chosen || after[day]?.id != before[day]?.id {
                WidgetCenter.shared.reloadTimelines(ofKind: "WordOfDayWidget")
                ReadingReminderScheduler.refresh()
            }
        }
        withAnimation(.easeInOut(duration: 0.6)) {
            objectWillChange.send()
            sync()
        }
    }

    // MARK: - The decision, without the stores (what the tests drive)

    typealias Ask = (_ text: String, _ picks: [JevPicker.Pick]) async -> JevPicker.Result?

    /// The newest text the reader wrote in the last 24 hours: the latest mood
    /// check-in note, or today's morning intention. The intention keeps only
    /// its day, so it counts as written at the start of today.
    nonisolated static func inputText(moods: [MoodEntry], intentions: [String: String], now: Date) -> String? {
        let since = now.addingTimeInterval(-recentTextWindow)
        var written: [(date: Date, text: String)] = moods.compactMap { entry in
            guard let note = entry.note?.trimmingCharacters(in: .whitespacesAndNewlines), !note.isEmpty,
                  entry.date >= since, entry.date <= now else { return nil }
            return (entry.date, note)
        }
        if let intention = intentions[DailyRoutineStore.dayKey(now)]?.trimmingCharacters(in: .whitespacesAndNewlines),
           !intention.isEmpty {
            let start = Calendar.current.startOfDay(for: now)
            if start >= since { written.append((start, intention)) }
        }
        // A tie goes to the check-in, whose time is exact.
        return written.max { $0.date < $1.date }?.text
    }

    /// Today's log after this visit:
    /// - personalization off: a word chosen today goes back to the date draw;
    /// - the day's word is recorded as shown, for the 30-day exclusion;
    /// - with recent text and Jev not yet asked today, Jev is asked once.
    ///   Nil from the picker (off, no subscription) leaves the day open, so a
    ///   later subscription can still pick; any answer, even an unsure one,
    ///   closes it.
    static func resolve(log: [String: ShownWord], day: String, language: String, pool: [WordOfDay],
                        drawn: WordOfDay, text: String?, enabled: Bool, excludingVerseID: String? = nil,
                        ask: Ask) async -> [String: ShownWord] {
        var log = pruned(log, today: day)
        var entry = log[day].flatMap { $0.language == language ? $0 : nil }
            ?? ShownWord(id: drawn.id, language: language)
        if !enabled, entry.chosen {
            entry = ShownWord(id: drawn.id, language: language, asked: entry.asked)
        }
        log[day] = entry
        guard enabled, !entry.asked, let text, pool.count >= 2 else { return log }

        let candidates = self.candidates(pool: pool, log: log, today: day, excluding: excludingVerseID)
        guard let result = await ask(text, [pick(candidates)]) else { return log }
        entry.asked = true
        entry.showCrisisFirst = result.showCrisisFirst
        if let id = result[pickName], candidates.contains(where: { $0.id == id }) {
            entry = ShownWord(id: id, language: language, chosen: true, asked: true,
                              showCrisisFirst: result.showCrisisFirst)
        }
        log[day] = entry
        return log
    }

    /// The pool minus what was shown in the last 30 days (today's word may
    /// stay) and minus today's intention verse (IntentionVerse), so the two
    /// cards on Today never show the same passage. If that leaves too little,
    /// the exclusions are relaxed in turn — the 30-day one first, since it's
    /// the one already allowed to give way to keeping today's own word.
    static func candidates(pool: [WordOfDay], log: [String: ShownWord], today: String,
                           excluding excludedID: String? = nil) -> [WordOfDay] {
        let recent = Set(log.filter { $0.key != today && $0.key < today }.map(\.value.id))
        let fresh = pool.filter { (!recent.contains($0.id) || log[today]?.id == $0.id) && $0.id != excludedID }
        if fresh.count >= 2 { return fresh }
        let withoutIntentionVerse = pool.filter { $0.id != excludedID }
        return withoutIntentionVerse.count >= 2 ? withoutIntentionVerse : pool
    }

    static func pick(_ candidates: [WordOfDay]) -> JevPicker.Pick {
        JevPicker.Pick(
            key: pickName,
            instructions: "Which of these Bible verses would best speak to what this person wrote — to console, encourage or guide them today?",
            candidates: candidates.map { .init(id: $0.id, description: "\($0.reference): \($0.quote) \($0.context)") },
            minimumConfidence: minimumConfidence)
    }

    /// Keeps the last `WordOfDayLog.keptDays` days, counted back from `today`.
    static func pruned(_ log: [String: ShownWord], today: String) -> [String: ShownWord] {
        guard let date = MockLiturgical.date(fromKey: today),
              let cutoff = Calendar.gregorianUTC.date(byAdding: .day, value: -WordOfDayLog.keptDays, to: date)
        else { return log }
        let parts = Calendar.gregorianUTC.dateComponents([.year, .month, .day], from: cutoff)
        let cutoffKey = String(format: "%04d-%02d-%02d", parts.year!, parts.month!, parts.day!)
        return log.filter { $0.key > cutoffKey && $0.key <= today }
    }

#if DEBUG
    private static var didReset = false
    /// `-resetWordOfDay 1` starts the UI tests from a day nobody picked yet.
    private static func resetForUITestsOnce() {
        guard !didReset else { return }
        didReset = true
        if UserDefaults.standard.volatileDomain(forName: UserDefaults.argumentDomain)["resetWordOfDay"] as? String == "1" {
            WordOfDayLog.defaults.removeObject(forKey: WordOfDayLog.storageKey)
        }
    }
#endif
}

/// "Escolhida a partir do que você escreveu": the label every personalized
/// word carries. Never "God chose".
struct WordChosenLabel: View {
    var color: Color = Palette.wine

    var body: some View {
        Text(L.string("Chosen from what you wrote", table: "FormationWordOfDay"))
            .font(MissaleFont.body(11, weight: .semibold))
            .tracking(1.2)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .accessibilityIdentifier("wordOfDayChosenLabel")
    }
}
