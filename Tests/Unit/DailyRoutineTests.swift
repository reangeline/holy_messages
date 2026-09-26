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

    /// A day without reading keeps the same chapter; it moves on only after
    /// it's read, once, whatever day that is.
    func testUnreadChapterWaitsForTheReader() {
        let store = DailyRoutineStore(defaults: defaults)
        store.markDone(.reading, on: day(1))
        XCTAssertEqual(store.chapterIndex(on: day(2), total: 260), 1)
        XCTAssertEqual(store.chapterIndex(on: day(3), total: 260), 1, "avançou sem ter lido")
        XCTAssertEqual(store.chapterIndex(on: day(9), total: 260), 1)

        store.markDone(.reading, on: day(9))
        XCTAssertEqual(store.chapterIndex(on: day(9), total: 260), 1)
        XCTAssertEqual(store.chapterIndex(on: day(10), total: 260), 2)
    }

    /// After Revelation's last chapter the plan starts over at Matthew 1.
    func testReadingWrapsFromRevelationToMatthew() throws {
        let bible = try XCTUnwrap(BibleCatalog.all.first { $0.language == "pt" })
        let plan = NewTestamentPlan(bible: bible)
        let total = plan.chapters.count
        defaults.set(total - 1, forKey: DailyRoutineStore.positionKey)
        let store = DailyRoutineStore(defaults: defaults)

        let last = plan.chapters[store.chapterIndex(on: day(1), total: total)]
        XCTAssertEqual(last.book.id, "REV")
        XCTAssertEqual(last.chapter, 22)

        store.markDone(.reading, on: day(1))
        XCTAssertEqual(plan.chapters[store.chapterIndex(on: day(1), total: total)].book.id, "REV")
        let next = plan.chapters[store.chapterIndex(on: day(2), total: total)]
        XCTAssertEqual(next.book.id, "MAT")
        XCTAssertEqual(next.chapter, 1)
    }

    /// The Bible reader recognises today's chapter by its place in the plan.
    func testPlanFindsAChapterAcrossBooks() throws {
        let bible = try XCTUnwrap(BibleCatalog.all.first { $0.language == "pt" })
        let plan = NewTestamentPlan(bible: bible)
        XCTAssertEqual(plan.index(of: "MAT", chapter: 1), 0)
        XCTAssertEqual(plan.index(of: "MRK", chapter: 1), 28, "Marcos 1 vem depois dos 28 capítulos de Mateus")
        XCTAssertEqual(plan.index(of: "REV", chapter: 22), plan.chapters.count - 1)
        XCTAssertNil(plan.index(of: "GEN", chapter: 1), "o Antigo Testamento não está no plano")
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
