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

    /// `word_of_day_shown` lives in the app group (WordOfDayLog), not in
    /// `UserDefaults.standard` — the one key in `personalKeys` that isn't
    /// where the others are.
    private func seedWordOfDayLog() -> [String: ShownWord] {
        let saved = WordOfDayLog.entries()
        WordOfDayLog.save(["2026-09-24": ShownWord(id: "w7", language: "pt", chosen: true, asked: true)])
        return saved
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

    /// `word_of_day_shown` fica no grupo do app, não em `.standard`: o export
    /// tinha que ir buscá-lo lá, ou o arquivo saía sem essa chave.
    func testExportCarriesWordOfDayShownFromTheAppGroup() throws {
        let saved = seedWordOfDayLog()
        defer { WordOfDayLog.save(saved) }

        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: LocalData.exportJSON()) as? [String: Any])
        let records = try XCTUnwrap(json["records"] as? [String: Any])
        let shown = try XCTUnwrap(records["word_of_day_shown"] as? [String: Any])
        let day = try XCTUnwrap(shown["2026-09-24"] as? [String: Any])
        XCTAssertEqual(day["id"] as? String, "w7")
        XCTAssertEqual(day["chosen"] as? Bool, true)
    }

    /// Erasing removes what the reader wrote, keeps preferences, and the
    /// stores show the empty state without relaunching the app.
    func testEraseRemovesPersonalDataAndKeepsPreferences() throws {
        try seed()
        XCTAssertFalse(ExamenHistoryStore.shared.list.items.isEmpty)

        LocalData.erasePersonalData()

        for key in LocalData.personalKeys where key != WordOfDayLog.storageKey {
            XCTAssertNil(defaults.object(forKey: key), "\(key) sobreviveu ao apagar")
        }
        XCTAssertEqual(defaults.integer(forKey: "examenMinutesOfDay"), 1290, "o apagar levou uma preferência junto")
        XCTAssertTrue(ExamenHistoryStore.shared.list.items.isEmpty, "a tela continuaria mostrando o Exame apagado")
        XCTAssertNil(DailyRoutineStore.shared.intention(on: Date()))
    }

    /// The app-group key erase already clears (`LocalData.erasePersonalData`
    /// removes it explicitly), checked from where it actually lives — the
    /// loop above reads `.standard`, where this key was never stored.
    func testEraseRemovesWordOfDayShownFromTheAppGroup() {
        let saved = seedWordOfDayLog()
        defer { WordOfDayLog.save(saved) }

        LocalData.erasePersonalData()

        XCTAssertNil(WordOfDayLog.defaults.object(forKey: WordOfDayLog.storageKey), "a palavra do dia escolhida sobreviveu ao apagar")
    }
}
