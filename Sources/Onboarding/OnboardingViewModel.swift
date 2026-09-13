import Foundation
import UserNotifications

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var path: [OnboardingStep] = [.feed]
    @Published var lifeAnswers: [String: Set<String>] = [:]
    @Published var spiritualAnswers: [String: String] = [:]
    @Published var selectedNotificationTimeID: String = MockOnboarding.notificationTimes.first?.id ?? ""
    @Published var notificationPermissionRequested = false

    var current: OnboardingStep { path.last ?? .feed }

    var reliefContent: ReliefContent {
        OnboardingRelief.content(spirit2: spiritualAnswers["spirit-2"])
    }

    // MARK: - Navigation

    func push(_ step: OnboardingStep) {
        path.append(step)
    }

    func back() {
        guard path.count > 1 else { return }
        path.removeLast()
    }

    func advanceFromFeed() { push(.sample) }

    func advanceFromSample() { push(.life(0)) }

    func advanceFromLife(index: Int) {
        if index < MockOnboarding.lifeQuestions.count - 1 {
            push(.life(index + 1))
        } else {
            push(.spiritualIntro)
        }
    }

    func advanceFromSpiritualIntro() { push(.spiritual(0)) }

    func skipAllSpiritual() { push(.relief) }

    func advanceFromSpiritual(index: Int) {
        if index < MockOnboarding.spiritualQuestions.count - 1 {
            push(.spiritual(index + 1))
        } else {
            push(.relief)
        }
    }

    func advanceFromRelief() { push(.loader) }

    func advanceFromLoader() { push(.synthesis) }

    func advanceFromSynthesis() { push(.notificationTime) }

    func advanceFromNotificationTime() { push(.notificationPreview) }

    func skipNotifications() { push(.paywall) }

    func requestNotificationsThenAdvance() {
        notificationPermissionRequested = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] _, _ in
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

    func selectSpiritual(questionID: String, optionID: String) {
        spiritualAnswers[questionID] = optionID
    }
}
