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
}

/// What the user logged on a specific day, for the day-detail drill-down. Real
/// per-day history doesn't exist yet (no per-day liturgical engine, and this
/// mock's calendar dates are fixed/fictional except "today") — `liturgyNote` is
/// nil except for the couple of days that have real authored liturgical content,
/// and `loggedStateTitle`/`loggedNote` are nil whenever nothing was actually
/// registered, rather than reusing a canned example. See CalendarDayDetailView.
struct DayDetail: Codable {
    let dateLabel: String
    let feastName: String
    let color: LiturgicalColor
    let loggedStateTitle: String?
    let loggedNote: String?
    let psalmRef: String?
    let psalmText: String?
    let liturgyNote: String?
}
