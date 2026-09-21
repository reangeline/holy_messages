import Foundation

/// Local-only, persistent record of which Formation lessons have been marked
/// "Concluí esta parte" — backs the track's progress bar and "next up" label so
/// both reflect what was actually completed, not a fixed demo value.
@MainActor
final class FormationProgressStore: ObservableObject {
    static let shared = FormationProgressStore()

    private static let storageKey = "formation_completed_lesson_ids"
    private static let orderKey = "formation_completed_lesson_order"

    @Published private(set) var completedLessonIDs: Set<String> = []
    /// Lesson ids in the order they were most recently marked complete — the
    /// last element is the most recent. Backs "resume where you stopped":
    /// since the track detail screen lets you open any part directly, "next up"
    /// has to follow whatever you actually did last, not the first numeric gap.
    private var completionOrder: [String] = []

    private init() {
        load()
    }

    func isCompleted(_ lessonID: String) -> Bool {
        completedLessonIDs.contains(lessonID)
    }

    func markCompleted(_ lessonID: String) {
        completedLessonIDs.insert(lessonID)
        completionOrder.removeAll { $0 == lessonID }
        completionOrder.append(lessonID)
        save()
    }

    /// The most recently completed id among `lessonIDs`, or nil if none of them
    /// have been completed yet.
    func mostRecentlyCompletedID(in lessonIDs: Set<String>) -> String? {
        completionOrder.last { lessonIDs.contains($0) }
    }

    private func save() {
        UserDefaults.standard.set(Array(completedLessonIDs), forKey: Self.storageKey)
        UserDefaults.standard.set(completionOrder, forKey: Self.orderKey)
    }

    private func load() {
        completedLessonIDs = Set(UserDefaults.standard.stringArray(forKey: Self.storageKey) ?? [])
        completionOrder = UserDefaults.standard.stringArray(forKey: Self.orderKey) ?? []
    }
    /// Backs Settings' "Delete everything" — see LocalData.
    func deleteAll() {
        completedLessonIDs = []
        completionOrder = []
        UserDefaults.standard.removeObject(forKey: Self.storageKey)
        UserDefaults.standard.removeObject(forKey: Self.orderKey)
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
    /// in the track is marked complete. Used only as `resumeLesson`'s fallback.
    func nextLesson(_ store: FormationProgressStore) -> FormationLesson? {
        lessons.first { !store.isCompleted($0.id) }
    }

    /// Where "Continuar" should take you: the lesson right after whichever one
    /// in this track was most recently marked complete. This is what makes
    /// resuming honor jumping around to review a part instead of snapping back
    /// to the first numeric gap. Falls back to the first incomplete lesson (for
    /// someone who hasn't started yet), then the first lesson overall.
    func resumeLesson(_ store: FormationProgressStore) -> FormationLesson? {
        guard !lessons.isEmpty else { return nil }
        let idsInTrack = Set(lessons.map(\.id))
        if let lastID = store.mostRecentlyCompletedID(in: idsInTrack),
           let idx = lessons.firstIndex(where: { $0.id == lastID }),
           idx + 1 < lessons.count {
            return lessons[idx + 1]
        }
        return nextLesson(store) ?? lessons.first
    }

    /// What the "next up" line should say. Falls back to the seeded `nextUp`
    /// string for tracks with no lessons written yet.
    func liveNextUpLabel(_ store: FormationProgressStore) -> String {
        guard !lessons.isEmpty else { return nextUp }
        if completedCount(in: store) == lessons.count { return "Trilha concluída — toque para revisar" }
        guard let next = resumeLesson(store) else { return nextUp }
        return "Parte \(next.partNumber): \(next.title)"
    }

}
