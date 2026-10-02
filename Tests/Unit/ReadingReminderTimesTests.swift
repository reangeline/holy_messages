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
        t.remove(t.slots[0].id)
        t.remove(t.slots[0].id)
        XCTAssertEqual(t.minutes, [1260])
        XCTAssertFalse(t.canRemove)
    }

    func testReplaceRefusesAnotherRowsTimeAndKeepsEveryRow() {
        var t = ReadingReminderTimes([420, 720, 1260])
        let last = t.slots[2].id
        t.replace(last, with: 420)
        XCTAssertEqual(t.minutes, [420, 720, 1260], "passar por um horário que já existe não pode fundir as linhas")
        t.replace(last, with: 300)
        XCTAssertEqual(t.minutes, [420, 720, 300], "a linha fica no lugar enquanto é editada")
        XCTAssertEqual(t.slots[2].id, last)
    }

    func testInitDedupesAndFallsBackToDefault() {
        XCTAssertEqual(ReadingReminderTimes([600, 600, 300]).minutes, [300, 600])
        XCTAssertEqual(ReadingReminderTimes([]).minutes, ReadingReminderScheduler.defaultMinutes)
    }
}
