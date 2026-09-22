import Foundation

/// Local-only, persistent log of "Hoje eu estou…" selections. Backs the
/// scrupulosity rule: the app counts how many times a given state was logged in
/// a rolling 14-day window and changes behavior on the 3rd occurrence.
@MainActor
final class MoodHistoryStore: ObservableObject {
    static let shared = MoodHistoryStore()

    private static let storageKey = "mood_history_entries"
    private static let lastReliefIndexKey = "mood_last_relief_index"
    private static let scrupulosityWindowDays = 14
    private static let scrupulosityThreshold = 3

    @Published private(set) var entries: [MoodEntry] = []
    private var lastReliefIndexByState: [String: Int] = [:]

    private init() {
        load()
        loadReliefIndex()
    }

    /// The variation index shown last time this state's relief content was
    /// displayed, so MockMood.relief(for:excluding:) can avoid repeating it.
    func lastReliefIndex(for stateID: String) -> Int? {
        lastReliefIndexByState[stateID]
    }

    func recordReliefShown(stateID: String, index: Int) {
        lastReliefIndexByState[stateID] = index
        UserDefaults.standard.set(lastReliefIndexByState, forKey: Self.lastReliefIndexKey)
    }

    private func loadReliefIndex() {
        lastReliefIndexByState = UserDefaults.standard.dictionary(forKey: Self.lastReliefIndexKey) as? [String: Int] ?? [:]
    }

    /// Records a selection and returns the resulting count for that state within
    /// the scrupulosity window (including the entry just recorded), so the caller
    /// can decide relief vs. redirect in one step.
    @discardableResult
    func record(state: MoodStateOption, note: String?) -> Int {
        entries.append(MoodEntry(stateID: state.id, stateLabel: state.label, note: note))
        save()
        return count(ofState: state.id, withinDays: Self.scrupulosityWindowDays)
    }

    func count(ofState stateID: String, withinDays days: Int) -> Int {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? .distantPast
        return entries.filter { $0.stateID == stateID && $0.date >= cutoff }.count
    }

    /// True from the 3rd time a scrupulosity-trigger state is logged within 14 days.
    /// The redirect screen REPLACES relief content from that point on — it doesn't
    /// stack alongside it — so the app stops manufacturing new reassurance about
    /// that specific state once the pattern is established.
    func scrupulosityShouldRedirect(for state: MoodStateOption) -> Bool {
        guard state.isScrupulosityTrigger else { return false }
        return count(ofState: state.id, withinDays: Self.scrupulosityWindowDays) >= Self.scrupulosityThreshold
    }


    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) else { return }
        entries = decoded
    }
}
