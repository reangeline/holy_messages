import XCTest
@testable import Missale

/// `POST /v1/decisions` carries `free`, so the server knows whether this call
/// is allowed to spend the account's lifetime free allowance (only the
/// onboarding's orientação) — see TASKS.md, "Só o onboarding gasta o
/// gratuito".
final class DecideRequestTests: XCTestCase {

    func testTheBodyCarriesFreeTrueForTheOnboardingOrientation() {
        let body = MissaleAPI.decideBody(state: "texto", questions: [:], free: true)
        XCTAssertEqual(body["free"] as? Bool, true)
        XCTAssertEqual(body["state"] as? String, "texto")
    }

    func testTheBodyCarriesFreeFalseForEverythingElse() {
        let body = MissaleAPI.decideBody(state: "texto", questions: [:], free: false)
        XCTAssertEqual(body["free"] as? Bool, false)
    }
}
