import Foundation

struct PrayerItem: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let timeLabel: String
    let reminderEnabled: Bool
}

struct ExamenStep: Identifiable, Codable {
    var id: Int { number }
    let number: Int
    let title: String
    let subtitle: String
}
