import Foundation

/// What the reader did and wrote on one civil day, gathered from the stores
/// that keep it — the calendar used to read only the mood check-in, and only
/// for today, so the routine, the morning's intention, the Examen and the
/// Rosary never showed on any day.
///
/// Days are keyed like the routine (`DailyRoutineStore.dayKey`, the device's
/// own calendar), which is also how the calendar names its days.
struct DayRecord {
    let moods: [MoodEntry]
    let examens: [ExamenEntry]
    let rosaries: [RosaryHistoryEntry]
    /// The routine's own items done that day (morning offering, prayer, reading).
    let routineDone: [DailyRoutineStore.Item]
    let intention: String?

    var isEmpty: Bool {
        moods.isEmpty && examens.isEmpty && rosaries.isEmpty && routineDone.isEmpty && intention == nil
    }

    @MainActor
    init(dateKey: String, moods: [MoodEntry], examens: [ExamenEntry], rosaries: [RosaryHistoryEntry],
         routine: DailyRoutineStore) {
        let onDay: (Date) -> Bool = { DailyRoutineStore.dayKey($0) == dateKey }
        self.moods = moods.filter { onDay($0.date) }
        self.examens = examens.filter { onDay($0.date) }
        self.rosaries = rosaries.filter { onDay($0.date) }
        let done = routine.completions[dateKey] ?? []
        routineDone = [.morning, .prayer, .reading].filter { done.contains($0.rawValue) }
        intention = routine.intentions[dateKey]
    }
}
