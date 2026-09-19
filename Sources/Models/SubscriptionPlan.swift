import Foundation

struct SubscriptionPlan: Identifiable, Codable {
    let id: String
    let title: String
    let rate: String
    let subtitle: String
    let total: String
    let badge: String?
}

struct MassReading: Identifiable, Codable {
    let id: String
    let kicker: String
    let title: String
    let summary: String
}
