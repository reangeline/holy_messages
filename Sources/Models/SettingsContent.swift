import Foundation

struct SettingsItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let value: String?
    let destination: SettingsDestination
}

struct SettingsGroup: Identifiable {
    let id: String
    let label: String
    let items: [SettingsItem]
}

enum SettingsDestination: Hashable {
    case subscription
    case editName
    case regionalCalendar
    case language
    case data
    case support
    case faq
    case termsPlaceholder(String) // Termos / Privacidade — mocked as a label-only placeholder
}

struct RegionOption: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let isSelected: Bool
}

struct ContentReviewer: Identifiable {
    let id: String
    let name: String
    let role: String
    let bio: String
}

struct FAQItem: Identifiable {
    let id: String
    let question: String
    let answer: String
}
