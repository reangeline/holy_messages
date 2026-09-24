import Foundation

/// The App Store review is asked once, on the third distinct day the reader
/// completes the whole of "Seu dia com Deus": three full days say habit, not
/// curiosity. The system shows at most three prompts a year, so it isn't spent
/// on the onboarding, before the app has been used.
enum ReviewMilestone {
    static let completeDaysKey = "review_routine_days"
    static let askedKey = "review_prompt_asked"
    static let threshold = 3

    /// Records a day with the routine complete and returns true exactly once:
    /// the first time the count of distinct days reaches the threshold.
    static func recordCompleteRoutine(on date: Date = Date(), defaults: UserDefaults = .standard) -> Bool {
        guard !defaults.bool(forKey: askedKey) else { return false }

        var days = Set(defaults.stringArray(forKey: completeDaysKey) ?? [])
        days.insert(DailyRoutineStore.dayKey(date))
        defaults.set(Array(days), forKey: completeDaysKey)

        guard days.count >= threshold else { return false }
        defaults.set(true, forKey: askedKey)
        return true
    }
}
