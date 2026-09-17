import Foundation

struct SubscriptionPlan: Identifiable, Codable {
    let id: String
    let title: String
    let rate: String
    let subtitle: String
    let total: String
    let badge: String?
}

struct WordOfDay: Identifiable, Codable, Hashable {
    let id: String
    let quote: String
    let reference: String
    let translationNote: String // e.g. "Douay-Rheims, domínio público"
    let context: String
}

struct MassReading: Identifiable, Codable {
    let id: String
    let kicker: String
    let title: String
    let summary: String
}
