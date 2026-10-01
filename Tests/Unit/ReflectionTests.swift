import XCTest
@testable import Missale

/// The reflection the orientação asks for after Jev chose a passage and a
/// saint: shown when it arrives, absent on any failure, never asked in the
/// crisis flow, and cut to the server's limits. The API is a fake.
final class ReflectionTests: XCTestCase {

    private func relief(passage: String = "Senhor, tu me sondas.", summary: String = "Confiou em Deus.") -> ReliefContent {
        ReliefContent(title: "t", psalmRef: "Salmo 139", psalmText: passage, psalmWhy: "w",
                      saintName: "Santa Teresa", saintWhy: summary, stepTitle: "s", stepBody: "b")
    }

    private final class FakeAPI {
        var bodies: [[String: Any]] = []
        var result: Result<String, Error> = .success("Deus está perto de você.")
        func send(_ body: [String: Any]) async throws -> String {
            bodies.append(body)
            return try result.get()
        }
    }

    func testSuccessFillsTheReflectionAndSendsWhatJevChose() async {
        let api = FakeAPI()
        let reflection = await OrientationService.reflect(
            on: " Estou ansioso ", relief: relief(), showCrisisFirst: false, free: true, language: .es, send: api.send)
        XCTAssertEqual(reflection, "Deus está perto de você.")
        let body = api.bodies.first
        XCTAssertEqual(body?["state"] as? String, "Estou ansioso")
        XCTAssertEqual(body?["language"] as? String, "es")
        XCTAssertEqual(body?["free"] as? Bool, true)
        XCTAssertEqual((body?["passage"] as? [String: String])?["reference"], "Salmo 139")
        XCTAssertEqual((body?["saint"] as? [String: String])?["name"], "Santa Teresa")
    }

    func testAnyFailureLeavesItEmpty() async {
        for failure in [MissaleAPI.Failure.unavailable, .subscriptionRequired, .dailyLimit, .unauthorized] {
            let api = FakeAPI()
            api.result = .failure(failure)
            let reflection = await OrientationService.reflect(
                on: "texto", relief: relief(), showCrisisFirst: false, free: false, send: api.send)
            XCTAssertNil(reflection, "\(failure)")
        }
    }

    func testAnEmptyAnswerLeavesItEmpty() async {
        let api = FakeAPI()
        api.result = .success("  \n")
        let reflection = await OrientationService.reflect(
            on: "texto", relief: relief(), showCrisisFirst: false, free: false, send: api.send)
        XCTAssertNil(reflection)
    }

    func testCrisisAsksNothing() async {
        let api = FakeAPI()
        let reflection = await OrientationService.reflect(
            on: "texto", relief: relief(), showCrisisFirst: true, free: false, send: api.send)
        XCTAssertNil(reflection)
        XCTAssertTrue(api.bodies.isEmpty)
    }

    func testLongTextIsCutToTheServersLimits() async {
        let api = FakeAPI()
        let long = relief(passage: String(repeating: "p", count: 5000), summary: String(repeating: "s", count: 3000))
        _ = await OrientationService.reflect(
            on: String(repeating: "é", count: 2500), relief: long, showCrisisFirst: false, free: false, send: api.send)
        let body = api.bodies[0]
        XCTAssertEqual((body["state"] as? String)?.unicodeScalars.count, 2000)
        XCTAssertEqual(((body["passage"] as? [String: String])?["text"])?.unicodeScalars.count, 4000)
        XCTAssertEqual(((body["saint"] as? [String: String])?["summary"])?.unicodeScalars.count, 2000)
        let body2 = MissaleAPI.reflectionBody(state: "a", reference: String(repeating: "r", count: 300), passage: "p",
                                              saint: String(repeating: "n", count: 300), summary: "s", language: "pt", free: false)
        XCTAssertEqual(((body2["passage"] as? [String: String])?["reference"])?.count, 200)
        XCTAssertEqual(((body2["saint"] as? [String: String])?["name"])?.count, 200)
    }
}
