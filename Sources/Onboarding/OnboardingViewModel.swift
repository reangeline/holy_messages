import Foundation
import UserNotifications

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var path: [OnboardingStep] = OnboardingViewModel.initialPath

    /// `-openScreen onboarding-orientation` starts on the free orientação, which
    /// is otherwise a dozen screens deep — the same reason the other
    /// `openScreen` values exist (see `AppRootView.debugOpenScreen`).
    private static var initialPath: [OnboardingStep] {
#if DEBUG
        if UserDefaults.standard.string(forKey: "openScreen") == "onboarding-orientation" {
            return [.verseIntro, .orientation]
        }
#endif
        return [.verseIntro]
    }
    @Published var lifeAnswers: [String: Set<String>] = [:]
    @Published var spiritualAnswers: [String: String] = [:]
    /// Chosen notice times, by option id, each with its (adjustable) minutes.
    @Published var notificationTimes: [String: Int] = ["morning": 7 * 60]
    @Published var notificationPermissionRequested = false

    /// The questionnaire answers as text for the AI, used by the orientação
    /// and its reflection (see `OnboardingContext`).
    var context: OnboardingContext {
        OnboardingContext(life: lifeAnswers, spiritual: spiritualAnswers, language: AppLanguagePreference.resolveCurrent())
    }

    var current: OnboardingStep { path.last ?? .verseIntro }

    // MARK: - Navigation

    func push(_ step: OnboardingStep) {
        path.append(step)
    }

    func back() {
        guard path.count > 1 else { return }
        path.removeLast()
    }

    func advanceFromVerseIntro() { push(.promise) }

    func advanceFromPromise() { push(.life(0)) }

    func advanceFromLife(index: Int) {
        if index < MockOnboarding.lifeQuestions(for: .en).count - 1 {
            push(.life(index + 1))
        } else {
            push(.spiritualIntro)
        }
    }

    func advanceFromSpiritualIntro() { push(.spiritual(0)) }

    /// The account comes right after the questions: the orientação, next, goes
    /// to the server. Already signed in, the step is skipped.
    func skipAllSpiritual() { pushAccountOrOrientation() }

    func advanceFromSpiritual(index: Int) {
        if index < MockOnboarding.spiritualQuestions(for: .en).count - 1 {
            push(.spiritual(index + 1))
        } else {
            pushAccountOrOrientation()
        }
    }

    private func pushAccountOrOrientation() {
        push(AccountStore.shared.isSignedIn ? .orientation : .signIn)
    }

    /// The free orientação (written, or skipped) leads to the guided prayer.
    func advanceFromOrientation() { push(.prayer) }

    func advanceFromPrayer() { push(.loader) }

    func advanceFromLoader() { push(.synthesis) }

    /// The synthesis leads straight to the notice times.
    func advanceFromSynthesis() { push(.notificationTime) }

    /// Replaces the sign-in step rather than stacking on it, so "back" from
    /// the orientação returns to the spiritual questions, not to a sign-in
    /// that already happened.
    func advanceFromSignIn() {
        if current == .signIn { path.removeLast() }
        push(.orientation)
    }

    func advanceFromNotificationTime() { push(.notificationPreview) }

    func toggleNotificationTime(id: String, defaultMinutes: Int) {
        if notificationTimes[id] == nil {
            notificationTimes[id] = defaultMinutes
        } else {
            notificationTimes[id] = nil
        }
    }

    func skipNotifications() {
        // Kept even without permission: turning notices on later in the
        // system settings finds the times already chosen.
        ReadingReminderScheduler.times = Array(notificationTimes.values)
        push(.paywall)
    }

    func requestNotificationsThenAdvance() {
        notificationPermissionRequested = true
        ReadingReminderScheduler.times = Array(notificationTimes.values)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] _, _ in
            ReadingReminderScheduler.refresh()
            DispatchQueue.main.async {
                self?.push(.paywall)
            }
        }
    }

    // MARK: - Answer recording

    func selectLife(questionID: String, optionID: String, multiSelect: Bool) {
        var set = lifeAnswers[questionID] ?? []
        if multiSelect {
            if set.contains(optionID) { set.remove(optionID) } else { set.insert(optionID) }
        } else {
            set = [optionID]
        }
        lifeAnswers[questionID] = set
    }

    func isLifeSelected(questionID: String, optionID: String) -> Bool {
        lifeAnswers[questionID]?.contains(optionID) ?? false
    }

    func hasAnyLifeAnswer(questionID: String) -> Bool {
        !(lifeAnswers[questionID]?.isEmpty ?? true)
    }

    /// A short answer to the reader's choice on a single-choice question, when
    /// the story has one for it.
    func reflection(questionID: String) -> String? {
        guard let optionID = lifeAnswers[questionID]?.first,
              let byLanguage = OnboardingStory.reflections[optionID] else { return nil }
        return OnboardingStory.text(byLanguage)
    }

    var commitment: String {
        let optionID = lifeAnswers["life-1"]?.first ?? ""
        return OnboardingStory.text(OnboardingStory.commitments[optionID] ?? OnboardingStory.commitmentFallback)
    }

    func selectSpiritual(questionID: String, optionID: String) {
        spiritualAnswers[questionID] = optionID
    }
}
