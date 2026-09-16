import Foundation

/// Local-only, persistent record of which Formation lessons have been marked
/// "Concluí esta parte" — backs the track's progress bar and "next up" label so
/// both reflect what was actually completed, not a fixed demo value.
@MainActor
final class FormationProgressStore: ObservableObject {
    static let shared = FormationProgressStore()

    private static let storageKey = "formation_completed_lesson_ids"

    @Published private(set) var completedLessonIDs: Set<String> = []

    private init() {
        load()
    }

    func isCompleted(_ lessonID: String) -> Bool {
        completedLessonIDs.contains(lessonID)
    }

    func markCompleted(_ lessonID: String) {
        guard !completedLessonIDs.contains(lessonID) else { return }
        completedLessonIDs.insert(lessonID)
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(completedLessonIDs), forKey: Self.storageKey)
    }

    private func load() {
        let stored = UserDefaults.standard.stringArray(forKey: Self.storageKey) ?? []
        completedLessonIDs = Set(stored)
    }
}

@MainActor
extension FormationTrack {
    /// How many of this track's lessons are marked complete. A track whose
    /// lessons haven't been written yet (an empty `lessons` array) always reads 0.
    func completedCount(in store: FormationProgressStore) -> Int {
        lessons.filter { store.isCompleted($0.id) }.count
    }

    /// The real progress fraction, computed from completed lessons. Falls back to
    /// the seeded `progress` value only for tracks with no lessons written yet.
    func liveProgress(_ store: FormationProgressStore) -> Double {
        guard let total = lessons.first?.partsTotal, total > 0 else { return progress }
        return Double(completedCount(in: store)) / Double(total)
    }

    /// The first not-yet-completed lesson, in part order — nil once every lesson
    /// in the track is marked complete.
    func nextLesson(_ store: FormationProgressStore) -> FormationLesson? {
        lessons.first { !store.isCompleted($0.id) }
    }

    /// What the "next up" line should say. Falls back to the seeded `nextUp`
    /// string for tracks with no lessons written yet.
    func liveNextUpLabel(_ store: FormationProgressStore) -> String {
        guard !lessons.isEmpty else { return nextUp }
        guard let next = nextLesson(store) else { return "Trilha concluída — toque para revisar" }
        return "Parte \(next.partNumber): \(next.title)"
    }
}
