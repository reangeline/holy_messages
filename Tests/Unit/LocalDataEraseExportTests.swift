import XCTest
@testable import Missale

/// Export and erase work over LocalData's lists, so what the privacy policy
/// names, what the file carries and what the button removes stay the same.
@MainActor
final class LocalDataEraseExportTests: XCTestCase {
    private let defaults = UserDefaults.standard
    private var savedPreference: Any?

    override func setUp() {
        savedPreference = defaults.object(forKey: "examenMinutesOfDay")
    }

    override func tearDown() {
        defaults.set(savedPreference, forKey: "examenMinutesOfDay")
    }

    private func seed() throws {
        let entry = ExamenEntry(date: Date(timeIntervalSinceReferenceDate: 0),
                                gratitude: "o café", lightRequest: "", review: "", response: "")
        defaults.set(try JSONEncoder().encode([entry]), forKey: "examen_entries")
        defaults.set(["2026-09-24": "Ter paciência"], forKey: "routine_intentions")
        defaults.set(1290, forKey: "examenMinutesOfDay")
        ExamenHistoryStore.shared.list.reload()
        DailyRoutineStore.shared.reload()
    }

    /// The file is readable JSON: stored values unpacked, dates as ISO text.
    func testExportCarriesPersonalRecordsWithReadableDates() throws {
        try seed()
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: LocalData.exportJSON()) as? [String: Any])
        let records = try XCTUnwrap(json["records"] as? [String: Any])
        let examens = try XCTUnwrap(records["examen_entries"] as? [[String: Any]])
        XCTAssertEqual(examens.first?["gratitude"] as? String, "o café")
        XCTAssertEqual(examens.first?["date"] as? String, "2001-01-01T00:00:00Z", "a data saiu como número, não como texto")
        XCTAssertEqual((records["routine_intentions"] as? [String: String])?["2026-09-24"], "Ter paciência")
        XCTAssertNil(records["examenMinutesOfDay"], "uma preferência entrou no arquivo de dados pessoais")
    }

    /// Erasing removes what the reader wrote, keeps preferences, and the
    /// stores show the empty state without relaunching the app.
    func testEraseRemovesPersonalDataAndKeepsPreferences() throws {
        try seed()
        XCTAssertFalse(ExamenHistoryStore.shared.list.items.isEmpty)

        LocalData.erasePersonalData()

        for key in LocalData.personalKeys {
            XCTAssertNil(defaults.object(forKey: key), "\(key) sobreviveu ao apagar")
        }
        XCTAssertEqual(defaults.integer(forKey: "examenMinutesOfDay"), 1290, "o apagar levou uma preferência junto")
        XCTAssertTrue(ExamenHistoryStore.shared.list.items.isEmpty, "a tela continuaria mostrando o Exame apagado")
        XCTAssertNil(DailyRoutineStore.shared.intention(on: Date()))
    }
}
