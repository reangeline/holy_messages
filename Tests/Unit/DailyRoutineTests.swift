import XCTest
@testable import Missale

@MainActor
final class DailyRoutineTests: XCTestCase {
    private var defaults: UserDefaults!

    override func setUp() {
        defaults = UserDefaults(suiteName: "DailyRoutineTests")
        defaults.removePersistentDomain(forName: "DailyRoutineTests")
    }

    private func day(_ n: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: n, hour: 9))!
    }

    /// The card keeps today's chapter after it's checked, and moves on the next day.
    func testReadingAdvancesOneChapterPerDay() {
        let store = DailyRoutineStore(defaults: defaults)
        XCTAssertEqual(store.chapterIndex(on: day(1), total: 260), 0)

        store.markDone(.reading, on: day(1))
        store.markDone(.reading, on: day(1))
        XCTAssertEqual(store.chapterIndex(on: day(1), total: 260), 0, "o capítulo de hoje pulou ao ser marcado")
        XCTAssertEqual(store.chapterIndex(on: day(2), total: 260), 1)
        XCTAssertTrue(store.isDone(.reading, on: day(1)))
        XCTAssertFalse(store.isDone(.reading, on: day(2)))

        let reopened = DailyRoutineStore(defaults: defaults)
        XCTAssertEqual(reopened.chapterIndex(on: day(2), total: 260), 1, "a posição não foi salva")
    }

    func testPrayerDoesNotMoveTheReading() {
        let store = DailyRoutineStore(defaults: defaults)
        store.markDone(.prayer, on: day(3))
        XCTAssertTrue(store.isDone(.prayer, on: day(3)))
        XCTAssertEqual(store.chapterIndex(on: day(4), total: 260), 0)
    }

    /// The Portuguese Bible's New Testament: Matthew to Revelation, 260 chapters.
    func testNewTestamentPlanCoversMatthewToRevelation() throws {
        let bible = try XCTUnwrap(BibleCatalog.all.first { $0.language == "pt" })
        let plan = NewTestamentPlan(bible: bible)
        XCTAssertEqual(plan.chapters.first?.book.id, "MAT")
        XCTAssertEqual(plan.chapters.last?.book.id, "REV")
        XCTAssertEqual(plan.chapters.count, 260)
    }

    func testPrayerPhrasesSplitAtPausesWithoutOrphans() {
        let phrases = GuidedPrayerSequence.phrases(from: "Glória ao Pai e ao Filho e ao Espírito Santo. Como era no princípio, agora e sempre. Ámen.")
        XCTAssertEqual(phrases, ["Glória ao Pai e ao Filho e ao Espírito Santo.", "Como era no princípio, agora e sempre. Ámen."])
    }

    func testThereIsADailyPrayer() {
        XCTAssertNotNil(DailyPrayer.today(on: day(1)))
    }

    /// The morning's line is kept per day and doesn't carry into the next.
    func testMorningIntentionIsKeptPerDay() {
        let store = DailyRoutineStore(defaults: defaults)
        store.saveIntention("  Ter paciência no trabalho  ", on: day(5))
        store.saveIntention("   ", on: day(6))
        XCTAssertEqual(store.intention(on: day(5)), "Ter paciência no trabalho")
        XCTAssertNil(store.intention(on: day(6)), "um texto vazio foi guardado")
        XCTAssertEqual(DailyRoutineStore(defaults: defaults).intention(on: day(5)), "Ter paciência no trabalho")
    }

    /// Days without a record get a saint too, and not yesterday's again.
    func testEveryDayHasASaintThatChanges() {
        let without = ["09-24", "09-25"].filter { MockSaints.saint(on: $0) == nil }
        guard without.count == 2 else { return }
        let first = MockSaints.saintOfDay(on: without[0])
        let second = MockSaints.saintOfDay(on: without[1])
        XCTAssertFalse(first.isTodaysFeast)
        XCTAssertNotEqual(first.saint.id, second.saint.id, "o santo se repetiu em dias seguidos")
    }
}
