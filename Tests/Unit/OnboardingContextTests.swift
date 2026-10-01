import XCTest
@testable import Missale

/// The questionnaire answers as context for the AI: only answered questions,
/// English for Jev, the app's language for the reflection, the reader's text
/// first and the context cut first when the server's limits press.
final class OnboardingContextTests: XCTestCase {

    private let life: [String: Set<String>] = [
        "life-1": ["returning"],
        "life-3": ["peace", "consistency"],   // multiple choice; "life-2" and "life-4" skipped
        "life-4": [],                          // emptied selection counts as skipped
    ]
    private let spiritual = ["spirit-2": "fear"]

    func testOnlyAnsweredQuestionsMultiSelectJoinedByComma() {
        let lines = OnboardingContext.lines(life: life, spiritual: spiritual, language: .en)
        XCTAssertEqual(lines, [
            "Where are you in your walk of faith?: Coming back after time away",
            "What's missing most right now?: Consistency, Peace of mind",   // catalog order, not Set order
            "What's weighing on you most right now?: Fear about the future",
        ])
    }

    func testNothingAnsweredMeansNoContext() {
        let context = OnboardingContext(life: [:], spiritual: [:], language: .pt)
        XCTAssertEqual(context, .empty)
        XCTAssertNil(context.reflectionContext)
        XCTAssertEqual(context.jevState(for: "Estou cansado"), "Estou cansado")
    }

    func testJevGetsEnglishAndReflectionGetsTheCurrentLanguage() {
        let context = OnboardingContext(life: life, spiritual: spiritual, language: .pt)
        let state = context.jevState(for: "Estou ansioso")
        XCTAssertTrue(state.hasPrefix("Estou ansioso\n\nContext from their onboarding answers:\n"))
        XCTAssertTrue(state.hasSuffix("What's weighing on you most right now?: Fear about the future"))
        XCTAssertFalse(state.contains("Onde você está"))
        let reflection = context.reflectionContext
        XCTAssertTrue(reflection?.hasPrefix("Onde você está na sua caminhada de fé?: Voltando depois de um tempo afastado") ?? false)
        XCTAssertEqual(reflection?.components(separatedBy: "\n").count, 3)
    }

    func testStateIsCutAt2000WithTheTextFirstAndWholeLines() {
        let lines = (0..<10).map { "Q\($0): " + String(repeating: "a", count: 200) }
        let context = OnboardingContext(englishLines: lines, localLines: lines)
        let text = String(repeating: "t", count: 1000)
        let state = context.jevState(for: text)
        XCTAssertLessThanOrEqual(state.unicodeScalars.count, 2000)
        XCTAssertTrue(state.hasPrefix(text + "\n\n" + OnboardingContext.jevHeader))
        let kept = state.components(separatedBy: "\n").filter { $0.hasPrefix("Q") }
        XCTAssertFalse(kept.isEmpty)
        XCTAssertLessThan(kept.count, 10)
        XCTAssertEqual(kept, Array(lines.prefix(kept.count)))   // whole lines, in order
    }

    func testLongTextWinsAndTheContextIsDropped() {
        let context = OnboardingContext(englishLines: ["Q: A"], localLines: ["Q: A"])
        let almost = String(repeating: "é", count: 1990)   // no room left for header + one line
        XCTAssertEqual(context.jevState(for: almost), almost)
        let full = String(repeating: "é", count: 2000)
        XCTAssertEqual(context.jevState(for: full), full)
    }

    func testReflectionContextIsCutAt1500ByWholeLines() {
        let lines = (0..<10).map { "Q\($0): " + String(repeating: "b", count: 300) }
        let context = OnboardingContext(englishLines: lines, localLines: lines)
        let text = context.reflectionContext ?? ""
        XCTAssertLessThanOrEqual(text.unicodeScalars.count, 1500)
        XCTAssertEqual(text.components(separatedBy: "\n").count, 4)   // 4 x 304 + 3 breaks = 1219; a fifth would pass 1500
    }

    func testReflectionBodyWithAndWithoutContext() {
        let without = MissaleAPI.reflectionBody(state: "a", reference: "r", passage: "p", saint: "s", summary: "x",
                                                language: "pt", free: true)
        XCTAssertNil(without["context"])
        let empty = MissaleAPI.reflectionBody(state: "a", reference: "r", passage: "p", saint: "s", summary: "x",
                                              language: "pt", free: true, context: "")
        XCTAssertNil(empty["context"])
        let with = MissaleAPI.reflectionBody(state: "a", reference: "r", passage: "p", saint: "s", summary: "x",
                                             language: "pt", free: true, context: "Q: A")
        XCTAssertEqual(with["context"] as? String, "Q: A")
        XCTAssertEqual(with["state"] as? String, "a")   // the state stays the reader's text
        let long = MissaleAPI.reflectionBody(state: "a", reference: "r", passage: "p", saint: "s", summary: "x",
                                             language: "pt", free: true, context: String(repeating: "c", count: 1800))
        XCTAssertEqual((long["context"] as? String)?.unicodeScalars.count, 1500)
    }

    func testReflectSendsTheContextButKeepsStateAsTheReadersText() async {
        var sent: [[String: Any]] = []
        let relief = ReliefContent(title: "t", psalmRef: "Salmo 139", psalmText: "x", psalmWhy: "w",
                                   saintName: "Santa Teresa", saintWhy: "y", stepTitle: "s", stepBody: "b")
        _ = await OrientationService.reflect(on: "Estou ansioso", relief: relief, showCrisisFirst: false, free: true,
                                             context: "Q: A", language: .pt) { body in
            sent.append(body)
            return "ok"
        }
        XCTAssertEqual(sent.first?["state"] as? String, "Estou ansioso")
        XCTAssertEqual(sent.first?["context"] as? String, "Q: A")
    }

    func testLocalCrisisCheckStaysOnTheReadersTextOnly() {
        // `orient` runs CrisisPhrases on the text it is given, never on the
        // state built with the context: a benign text with every answer in
        // the context stays benign, and a risky text stays risky.
        let context = OnboardingContext(life: life, spiritual: spiritual, language: .en)
        XCTAssertFalse(CrisisPhrases.matches("Estou cansado"))
        XCTAssertTrue(CrisisPhrases.matches("quero morrer"))
        XCTAssertNotEqual(context.jevState(for: "Estou cansado"), "Estou cansado")
    }
}
