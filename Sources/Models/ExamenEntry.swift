import Foundation

/// One night's answers to the four Ignatian Examen steps.
struct ExamenEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let gratitude: String
    let lightRequest: String
    let review: String
    let response: String

    init(id: UUID = UUID(), date: Date = Date(), gratitude: String, lightRequest: String, review: String, response: String) {
        self.id = id
        self.date = date
        self.gratitude = gratitude
        self.lightRequest = lightRequest
        self.review = review
        self.response = response
    }
}

extension ExamenEntry {
    /// "Hoje", "Ontem", or the weekday name — same relative phrasing as
    /// RosaryHistoryEntry.dateLabel, for a consistent feel across history screens.
    var dateLabel: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Hoje" }
        if calendar.isDateInYesterday(date) { return "Ontem" }
        let formatter = DateFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        return formatter.string(from: date).localizedCapitalized
    }
}
