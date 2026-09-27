import XCTest
@testable import Missale

/// Guideline 5.1.1(v): `DELETE /v1/account` carries a fresh Sign in with
/// Apple authorization code when one is available, so the server can revoke
/// it, and keeps working with no body for app versions that send none.
final class DeleteAccountRequestTests: XCTestCase {

    func testTheBodyCarriesTheAuthorizationCode() {
        let body = MissaleAPI.deleteAccountBody(authorizationCode: "the-code")
        XCTAssertEqual(body, ["authorizationCode": "the-code"])
    }

    func testWithoutACodeTheBodyIsNil() {
        // Old app versions, and "delete anyway" after Apple itself failed:
        // no body at all, exactly today's request.
        XCTAssertNil(MissaleAPI.deleteAccountBody(authorizationCode: nil))
    }
}
