import XCTest
@testable import Missale

/// The one-time consent Apple's guideline 5.1.2(i) calls for before what the
/// reader writes reaches Jev: the persisted state (`JevConsent`) and the
/// prompt's async handshake (`JevConsentCoordinator`). The network-boundary
/// guarantee itself — nothing sent while not asked or declined — is
/// `JevPickerTests.testNotAskedOrDeclinedConsentMakesNoCall`; this file is
/// about the state machine behind the prompt.
final class JevConsentTests: XCTestCase {

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: JevConsent.storageKey)
    }

    func testDefaultsToNotAsked() {
        UserDefaults.standard.removeObject(forKey: JevConsent.storageKey)
        XCTAssertEqual(JevConsent.state, .notAsked)
    }

    func testStateRoundTrips() {
        JevConsent.state = .granted
        XCTAssertEqual(JevConsent.state, .granted)
        JevConsent.state = .declined
        XCTAssertEqual(JevConsent.state, .declined)
    }

    /// Existing TestFlight readers have the toggle on but never saw the
    /// prompt: nothing migrates them to granted, so they read as not asked,
    /// same as a fresh install.
    func testAnAbsentKeyIsNotAskedNotGranted() {
        UserDefaults.standard.removeObject(forKey: JevConsent.storageKey)
        XCTAssertNotEqual(JevConsent.state, .granted)
        XCTAssertEqual(JevConsent.state, .notAsked)
    }

    /// Erasing personal data resets consent, so the reader is asked again.
    @MainActor
    func testErasingPersonalDataResetsConsent() {
        JevConsent.state = .granted
        LocalData.erasePersonalData()
        XCTAssertEqual(JevConsent.state, .notAsked)
    }

    @MainActor
    func testGrantedEnsureGrantedReturnsTrueWithoutShowingThePrompt() async {
        JevConsent.state = .granted
        let coordinator = JevConsentCoordinator.shared
        let granted = await JevConsent.ensureGranted()
        XCTAssertTrue(granted)
        XCTAssertFalse(coordinator.isPending)
    }

    @MainActor
    func testDeclinedEnsureGrantedReturnsFalseWithoutShowingThePrompt() async {
        JevConsent.state = .declined
        let coordinator = JevConsentCoordinator.shared
        let granted = await JevConsent.ensureGranted()
        XCTAssertFalse(granted)
        XCTAssertFalse(coordinator.isPending)
    }

    /// Not asked: the coordinator shows the prompt (`isPending`) and only
    /// resolves once a screen calls `answer` — the "wait for the answer, don't
    /// block the flow" behaviour the prompt relies on.
    @MainActor
    func testNotAskedWaitsForAnAnswer() async {
        JevConsent.state = .notAsked
        let coordinator = JevConsentCoordinator.shared
        let task = Task { await JevConsent.ensureGranted() }
        while !coordinator.isPending { await Task.yield() }
        XCTAssertTrue(coordinator.isPending)

        coordinator.answer(granted: true)
        let granted = await task.value
        XCTAssertTrue(granted)
        XCTAssertEqual(JevConsent.state, .granted)
        XCTAssertFalse(coordinator.isPending)
    }

    @MainActor
    func testDecliningPersistsAndDoesNotAskAgainAutomatically() async {
        JevConsent.state = .notAsked
        let coordinator = JevConsentCoordinator.shared
        let task = Task { await JevConsent.ensureGranted() }
        while !coordinator.isPending { await Task.yield() }
        coordinator.answer(granted: false)
        let granted = await task.value
        XCTAssertFalse(granted)
        XCTAssertEqual(JevConsent.state, .declined)

        // A later feature asking again gets the answer straight away, with no
        // new prompt.
        let askedAgain = await JevConsent.ensureGranted()
        XCTAssertFalse(askedAgain)
        XCTAssertFalse(coordinator.isPending)
    }

    /// Two features asking at once share the one prompt and the one answer.
    @MainActor
    func testConcurrentRequestsShareOneAnswer() async {
        JevConsent.state = .notAsked
        let coordinator = JevConsentCoordinator.shared
        let first = Task { await JevConsent.ensureGranted() }
        let second = Task { await JevConsent.ensureGranted() }
        while !coordinator.isPending { await Task.yield() }
        coordinator.answer(granted: true)
        let results = await (first.value, second.value)
        XCTAssertTrue(results.0)
        XCTAssertTrue(results.1)
    }

    /// A screen closing without a tap on either button counts as "Agora não",
    /// so nothing is left waiting forever.
    @MainActor
    func testAnUnansweredPromptThatClosesCountsAsDeclined() async {
        JevConsent.state = .notAsked
        let coordinator = JevConsentCoordinator.shared
        let task = Task { await JevConsent.ensureGranted() }
        while !coordinator.isPending { await Task.yield() }
        coordinator.answerIfStillPending()
        let granted = await task.value
        XCTAssertFalse(granted)
        XCTAssertEqual(JevConsent.state, .declined)
    }

    /// No-op when nothing is waiting — a sheet's `onDismiss` firing after an
    /// explicit answer must not double-resolve or overwrite the state.
    @MainActor
    func testAnswerIfStillPendingIsANoOpWhenNothingIsPending() {
        JevConsent.state = .granted
        JevConsentCoordinator.shared.answerIfStillPending()
        XCTAssertEqual(JevConsent.state, .granted)
    }
}
