import XCTest
@testable import Missale

/// The Sunday lectionary cycle, which decides WHICH readings a Sunday gets.
///
/// A liturgical year opens in Advent and runs into the next civil year, so for
/// any date from January to the Saturday before Advent the cycle comes from the
/// PREVIOUS year's Advent. `ordinaryDay` applied that to the first block of
/// Ordinary Time (January to Ash Wednesday) but not to the second (after
/// Pentecost to Advent), which pushed June–November onto the next cycle and
/// served the wrong readings for roughly half of every year.
final class LiturgicalEngineCycleTests: XCTestCase {

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.gregorianUTC.date(from: DateComponents(year: year, month: month, day: day))!
    }

    private func cycle(_ year: Int, _ month: Int, _ day: Int) -> String {
        LiturgicalEngine.day(for: date(year, month, day)).sundayCycle
    }

    /// Advent 2025 opened Year A, so every Sunday from then until Advent 2026
    /// is Year A — whichever season it falls in.
    func testTheWholeLiturgicalYearKeepsOneCycle() {
        XCTAssertEqual(cycle(2025, 11, 30), "A", "1º Domingo do Advento de 2025 abre o ano A")
        XCTAssertEqual(cycle(2026, 1, 25), "A", "Tempo Comum, primeiro bloco")
        XCTAssertEqual(cycle(2026, 3, 8), "A", "Quaresma")
        XCTAssertEqual(cycle(2026, 4, 12), "A", "Tempo Pascal")
        XCTAssertEqual(cycle(2026, 9, 20), "A", "Tempo Comum, segundo bloco — era aqui que virava B")
        XCTAssertEqual(cycle(2026, 11, 22), "A", "Cristo Rei fecha o ano A")
    }

    /// And the next Advent does move it on.
    func testAdventStartsTheNextCycle() {
        XCTAssertEqual(cycle(2026, 11, 29), "B", "1º Domingo do Advento de 2026 abre o ano B")
        XCTAssertEqual(cycle(2027, 9, 19), "B", "e setembro seguinte continua em B")
    }

    /// Three consecutive years must give three different letters, in order.
    func testTheCycleRotatesEveryThreeYears() {
        XCTAssertEqual(cycle(2024, 9, 22), "B")
        XCTAssertEqual(cycle(2025, 9, 21), "C")
        XCTAssertEqual(cycle(2026, 9, 20), "A")
        XCTAssertEqual(cycle(2027, 9, 19), "B")
    }

    /// The readings the corrected cycle actually reaches, for one Sunday whose
    /// references are registered in all three languages. Year A's 25th Sunday
    /// is the parable of the workers in the vineyard, not Mark's passion
    /// prediction, which is Year B's.
    func testTheTwentyFifthSundayOf2026ServesYearAReadings() {
        let day = LiturgicalEngine.day(for: date(2026, 9, 20))
        XCTAssertEqual(day.lectionaryKey, "ordinary-25-A")

        guard let readings = MockLectionary.sundayReadings[day.lectionaryKey ?? ""] else {
            return XCTFail("o domingo 25 do ano A não está cadastrado")
        }
        XCTAssertTrue(
            readings.gospel.contains("20"),
            "o Evangelho do ano A é Mateus 20, e veio: \(readings.gospel)"
        )
    }

    /// Weekday cycle is keyed to the civil year, a different rule — pinned so a
    /// later fix to one doesn't quietly change the other.
    func testWeekdayCycleFollowsTheCivilYear() {
        XCTAssertEqual(LiturgicalEngine.weekdayCycleLabel(for: 2026), "II")
        XCTAssertEqual(LiturgicalEngine.weekdayCycleLabel(for: 2027), "I")
    }
}
