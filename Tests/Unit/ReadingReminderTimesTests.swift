import XCTest
@testable import Missale

final class ReadingReminderTimesTests: XCTestCase {
    func testAddStopsAtThree() {
        var t = ReadingReminderTimes([7 * 60])
        t.add(); t.add(); t.add()
        XCTAssertEqual(t.minutes.count, 3)
        XCTAssertFalse(t.canAdd)
    }

    func testAddPicksFreeTimeAndKeepsSorted() {
        var t = ReadingReminderTimes([12 * 60])
        t.add()
        XCTAssertEqual(t.minutes, [12 * 60, 13 * 60])
    }

    func testRemoveKeepsAtLeastOne() {
        var t = ReadingReminderTimes([420, 1260])
        t.remove(420)
        t.remove(1260)
        XCTAssertEqual(t.minutes, [1260])
        XCTAssertFalse(t.canRemove)
    }

    func testReplaceMergesDuplicatesAndSorts() {
        var t = ReadingReminderTimes([420, 720, 1260])
        t.replace(1260, with: 420)
        XCTAssertEqual(t.minutes, [420, 720])
        t.replace(720, with: 300)
        XCTAssertEqual(t.minutes, [300, 420])
    }

    func testInitDedupesAndFallsBackToDefault() {
        XCTAssertEqual(ReadingReminderTimes([600, 600, 300]).minutes, [300, 600])
        XCTAssertEqual(ReadingReminderTimes([]).minutes, ReadingReminderScheduler.defaultMinutes)
    }
}
