import XCTest
@testable import Missale

final class ReviewMilestoneTests: XCTestCase {
    private var defaults: UserDefaults!

    override func setUp() {
        defaults = UserDefaults(suiteName: "ReviewMilestoneTests")
        defaults.removePersistentDomain(forName: "ReviewMilestoneTests")
    }

    private func day(_ n: Int, hour: Int = 9) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: n, hour: hour))!
    }

    /// Asks on the third distinct day with the routine complete, and never again.
    func testAsksOnceOnTheThirdDistinctDay() {
        XCTAssertFalse(ReviewMilestone.recordCompleteRoutine(on: day(1), defaults: defaults))
        XCTAssertFalse(ReviewMilestone.recordCompleteRoutine(on: day(1, hour: 20), defaults: defaults), "o mesmo dia não conta duas vezes")
        XCTAssertFalse(ReviewMilestone.recordCompleteRoutine(on: day(2), defaults: defaults))
        XCTAssertTrue(ReviewMilestone.recordCompleteRoutine(on: day(5), defaults: defaults))
        XCTAssertFalse(ReviewMilestone.recordCompleteRoutine(on: day(6), defaults: defaults), "pediu a avaliação mais de uma vez")
    }
}
