import Foundation

struct DevotionalPrayer: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let attribution: String?
    let focus: String // short description of the prayer's theme
    let fullText: String
}

struct PrayerCategory: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let prayers: [DevotionalPrayer]
}
