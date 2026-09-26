import Combine
import XCTest
@testable import Missale

/// The calendar's day screen: what the reader did and wrote shows on the day it
/// happened. It used to read only the mood, and only for today.
@MainActor
final class CalendarDayRecordTests: XCTestCase {
    private var defaults: UserDefaults!

    override func setUp() {
        defaults = UserDefaults(suiteName: "CalendarDayRecordTests")
        defaults.removePersistentDomain(forName: "CalendarDayRecordTests")
    }

    private func day(_ n: Int, hour: Int = 9, minute: Int = 0) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: n, hour: hour, minute: minute))!
    }

    private func mood(_ note: String, on date: Date) -> MoodEntry {
        MoodEntry(stateID: "peace", stateLabel: "em paz", note: note, date: date)
    }

    private func examen(on date: Date) -> ExamenEntry {
        ExamenEntry(date: date, gratitude: "a", lightRequest: "b", review: "c", response: "d")
    }

    /// A check-in from a past day shows on that day, not only today's.
    func testPastCheckInShowsOnItsOwnDay() {
        let moods = [mood("primeiro", on: day(1)), mood("segundo", on: day(2))]
        let record = DayRecord(dateKey: "2026-09-01", moods: moods, examens: [], rosaries: [],
                               routine: DailyRoutineStore(defaults: defaults))
        XCTAssertEqual(record.moods.map(\.note), ["primeiro"])
    }

    /// The routine's checks and the morning's line show on the day they were done.
    func testRoutineAndIntentionShowOnTheirDay() {
        let routine = DailyRoutineStore(defaults: defaults)
        routine.markDone(.morning, on: day(3))
        routine.markDone(.reading, on: day(3))
        routine.saveIntention("paciência", on: day(3))

        let record = DayRecord(dateKey: "2026-09-03", moods: [], examens: [], rosaries: [], routine: routine)
        XCTAssertEqual(record.routineDone, [.morning, .reading])
        XCTAssertEqual(record.intention, "paciência")
        XCTAssertFalse(record.isEmpty)

        let nextDay = DayRecord(dateKey: "2026-09-04", moods: [], examens: [], rosaries: [], routine: routine)
        XCTAssertTrue(nextDay.isEmpty)
    }

    /// An Examen written late at night belongs to the reader's own day, not to
    /// the UTC one (in Brazil, 23:30 is already tomorrow in UTC).
    func testLateExamenStaysOnTheLocalDay() {
        let late = examen(on: day(5, hour: 23, minute: 30))
        let record = DayRecord(dateKey: "2026-09-05", moods: [], examens: [late], rosaries: [],
                               routine: DailyRoutineStore(defaults: defaults))
        XCTAssertEqual(record.examens.count, 1)
    }

    /// Today's checks are "done today?" questions asked of the clock: when the
    /// day turns, Today has to redraw instead of showing yesterday's checks
    /// until something unrelated makes them all vanish at once.
    func testRoutineRedrawsWhenTheDayTurns() {
        let routine = DailyRoutineStore(defaults: defaults)
        var redraws = 0
        let subscription = routine.objectWillChange.sink { redraws += 1 }
        NotificationCenter.default.post(name: .NSCalendarDayChanged, object: nil)
        XCTAssertEqual(redraws, 1)
        subscription.cancel()
    }
}
