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

    func testReflectionGetsTheShownPassageNotThePsalm() async {
        let api = FakeAPI()
        let verse = OrientationPassage(reference: "Mateus 5, 4", text: "Bem-aventurados os que choram.", why: "c")
        _ = await OrientationService.reflect(
            on: "texto", relief: relief(), passage: verse, showCrisisFirst: false, free: false, send: api.send)
        let sent = api.bodies[0]["passage"] as? [String: String]
        XCTAssertEqual(sent?["reference"], "Mateus 5, 4")
        XCTAssertEqual(sent?["text"], "Bem-aventurados os que choram.")
    }

    // MARK: - Crisis

    func testCrisisBodyOmitsPassageAndSaintWhenThereAreNone() {
        let body = MissaleAPI.reflectionBody(state: "x", reference: nil, passage: nil, saint: nil, summary: nil,
                                             language: "pt", free: true, context: "Q: A", crisis: true)
        XCTAssertEqual(body["crisis"] as? Bool, true)
        XCTAssertNil(body["passage"])
        XCTAssertNil(body["saint"])
        XCTAssertEqual(body["state"] as? String, "x")
        XCTAssertEqual(body["context"] as? String, "Q: A")
        XCTAssertEqual(body["free"] as? Bool, true)
    }

    func testCrisisBodyKeepsPassageAndSaintWhenThereAreSome() {
        let body = MissaleAPI.reflectionBody(state: "x", reference: "Salmo 139", passage: "p", saint: "Teresa", summary: "s",
                                             language: "pt", free: false, crisis: true)
        XCTAssertEqual(body["crisis"] as? Bool, true)
        XCTAssertEqual((body["passage"] as? [String: String])?["reference"], "Salmo 139")
        XCTAssertEqual((body["saint"] as? [String: String])?["name"], "Teresa")
    }

    func testOrdinaryBodyHasNoCrisisField() {
        let body = MissaleAPI.reflectionBody(state: "x", reference: "r", passage: "p", saint: "n", summary: "s",
                                             language: "pt", free: false)
        XCTAssertNil(body["crisis"])
    }

    func testCrisisReflectionIsAskedWithCrisisAndNoPassageWhenStateUnknown() async {
        let api = FakeAPI()
        let reflection = await OrientationService.reflectInCrisis(
            on: " quero morrer ", free: true, context: "Q: A", language: .pt, send: api.send)
        XCTAssertEqual(reflection, "Deus está perto de você.")
        XCTAssertEqual(api.bodies.count, 1)
        let body = api.bodies[0]
        XCTAssertEqual(body["crisis"] as? Bool, true)
        XCTAssertEqual(body["state"] as? String, "quero morrer")
        XCTAssertEqual(body["free"] as? Bool, true)
        XCTAssertEqual(body["context"] as? String, "Q: A")
        XCTAssertNil(body["passage"])
        XCTAssertNil(body["saint"])
    }

    func testCrisisReflectionSendsPassageAndSaintWhenTheStateIsKnown() async throws {
        let api = FakeAPI()
        let variants = try XCTUnwrap(MockMood.reliefVariants(for: "grief"))
        _ = await OrientationService.reflectInCrisis(
            on: "quero morrer", stateID: "grief", reliefIndex: 0, free: false, language: .pt, send: api.send)
        let body = api.bodies[0]
        XCTAssertEqual(body["crisis"] as? Bool, true)
        XCTAssertEqual((body["passage"] as? [String: String])?["reference"], variants[0].psalmRef)
        XCTAssertEqual((body["saint"] as? [String: String])?["name"], variants[0].saintName)
    }

    func testCrisisReflectionFailureOrEmptyTextLeavesItEmpty() async {
        let api = FakeAPI()
        api.result = .failure(MissaleAPI.Failure.unavailable)
        let failed = await OrientationService.reflectInCrisis(on: "quero morrer", free: false, send: api.send)
        XCTAssertNil(failed)
        let empty = await OrientationService.reflectInCrisis(on: "  ", free: false, send: api.send)
        XCTAssertNil(empty)
        XCTAssertEqual(api.bodies.count, 1, "texto vazio não pede nada")
    }

    func testThePassageScreenAfterTheCrisisAsksNothingAgain() async {
        // MoodReliefView asks through `reflect(... showCrisisFirst:)`; the
        // crisis flow continues with showCrisisFirst true and no text.
        let api = FakeAPI()
        let again = await OrientationService.reflect(
            on: "quero morrer", relief: relief(), showCrisisFirst: true, free: true, send: api.send)
        XCTAssertNil(again)
        XCTAssertTrue(api.bodies.isEmpty)
    }
}
