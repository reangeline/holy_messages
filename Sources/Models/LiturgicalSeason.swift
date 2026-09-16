import Foundation

struct LiturgicalSeason: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let dateRange: String
    let color: LiturgicalColor
    let summaryLine: String
}

struct SeasonRetrospective: Codable {
    let seasonID: String
    let seasonLabel: String // e.g. "Quaresma · 5 mar a 17 abr"
    let color: LiturgicalColor
    let title: String
    let narrative: String
    let accompaniments: [String]
    let milestoneTitle: String
    let milestoneBody: String
    let closingLine: String
}

struct CalendarDayMark: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String
    let dayNumber: Int
    let color: LiturgicalColor
    let hasLoggedEntry: Bool
    /// "consolation" or "desolation" — which Exame group was logged that day, so
    /// the calendar can show *which* kind of day it was, not just that something
    /// was logged. Still two neutral, non-judgmental marks, not a red/green
    /// heat map — see spec §1.5 and CalendarRootView.dayCell.
    let loggedGroup: String?

    init(dateKey: String, dayNumber: Int, color: LiturgicalColor, hasLoggedEntry: Bool, loggedGroup: String? = nil) {
        self.dateKey = dateKey
        self.dayNumber = dayNumber
        self.color = color
        self.hasLoggedEntry = hasLoggedEntry
        self.loggedGroup = loggedGroup
    }
}

/// What the user logged / experienced on a specific past day, for the day-detail drill-down.
struct DayDetail: Codable {
    let dateLabel: String
    let feastName: String
    let color: LiturgicalColor
    let loggedStateTitle: String?
    let loggedNote: String?
    let psalmRef: String
    let psalmText: String
    let liturgyNote: String
    let otherActivity: String?
}
