import XCTest
@testable import Missale

/// The glossary explains the colour of the day, so each colour needs its own
/// title and explanation, in all three languages (the keys are built at
/// runtime, so `LocalizationKeyTests` cannot see them).
final class GlossaryColorExplainerTests: XCTestCase {
    private let allColors: [LiturgicalColor] = [.red, .purple, .green, .white, .rose, .black]

    func testTitleNamesTheColorOfTheDay() {
        XCTAssertEqual(GlossaryColorExplainer.titleKey(for: .green), "Why is today green?")
        XCTAssertEqual(GlossaryColorExplainer.titleKey(for: .purple), "Why is today purple?")
        XCTAssertEqual(GlossaryColorExplainer.titleKey(for: .red), "Why is today red?")
    }

    func testEveryColorHasItsOwnTitleAndExplanation() {
        XCTAssertEqual(Set(allColors.map(GlossaryColorExplainer.titleKey(for:))).count, allColors.count)
        XCTAssertEqual(Set(allColors.map(GlossaryColorExplainer.explanationKey(for:))).count, allColors.count)
    }

    func testEveryKeyIsTranslatedInThreeLanguages() throws {
        let path = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("Sources/Features/Formation/FormationWordOfDay.xcstrings")
        let json = try JSONSerialization.jsonObject(with: Data(contentsOf: path)) as? [String: Any]
        let strings = try XCTUnwrap(json?["strings"] as? [String: [String: Any]])
        for color in allColors {
            for key in [GlossaryColorExplainer.titleKey(for: color), GlossaryColorExplainer.explanationKey(for: color)] {
                let localizations = try XCTUnwrap(strings[key]?["localizations"] as? [String: Any], "sem entrada: \(key)")
                for language in ["pt", "en", "es"] {
                    XCTAssertNotNil(localizations[language], "\(key) sem \(language)")
                }
            }
        }
    }
}
