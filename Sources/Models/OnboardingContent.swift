import Foundation

struct OnboardingOption: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let subtitle: String?
    let isCrisisTrigger: Bool

    init(id: String, text: String, subtitle: String? = nil, isCrisisTrigger: Bool = false) {
        self.id = id
        self.text = text
        self.subtitle = subtitle
        self.isCrisisTrigger = isCrisisTrigger
    }
}

/// One of the 4 "state of life" onboarding questions (practical, not spiritual).
struct LifeQuestion: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let options: [OnboardingOption]
    let multiSelect: Bool
    let skippable: Bool
}

/// One of the 4 spiritual check-in ("consolation/desolation") onboarding questions.
struct SpiritualQuestion: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let options: [OnboardingOption]
}

/// Sample content shown on the pre-login "navigable sample" screen, switchable by tab.
struct SampleTab: Identifiable, Codable {
    let id: String
    let label: String
    let kicker: String
    let title: String
    let body: String
    let quote: String
}
