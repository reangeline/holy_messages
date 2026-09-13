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
