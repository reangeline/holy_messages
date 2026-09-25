import Foundation

enum LiturgicalRank: String, Codable {
    case memorial = "Memória"
    case optionalMemorial = "Memória facultativa"
    case feast = "Festa"
    case solemnity = "Solenidade"
    case weekday = "Feria"

    /// `rawValue` stays Portuguese because it is the coded value; this is what
    /// the interface shows. Same split as MysterySet.displayName.
    var displayName: String { L.string(rawValue) }
}

struct LiturgicalDay: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String // "yyyy-MM-dd"

    /// Derived, never stored — a stored label freezes the language it was
    /// authored in. See DateKeyLabel.
    var weekdayLabel: String { DateKeyLabel.weekday(fromKey: dateKey) }
    var dayMonthLabel: String { DateKeyLabel.dayMonth(fromKey: dateKey) }

    let seasonName: String
    let feastName: String
    let rank: LiturgicalRank
    let color: LiturgicalColor
    let explanation: String
}

/// A fixed-date celebration as the admin page publishes it. Rank and colour
/// are the app's own coded values ("Memória", "white"); an entry with a value
/// the app doesn't know is dropped rather than shown wrong.
struct PublishedFeast: Codable, Hashable {
    let id: String
    let monthDay: String
    let name: String
    let rank: String
    let color: String

    init(_ feast: LiturgicalSanctoral.FixedFeast) {
        id = feast.monthDay
        monthDay = feast.monthDay
        name = feast.name
        rank = feast.rank.rawValue
        color = feast.color.rawValue
    }

    var feast: LiturgicalSanctoral.FixedFeast? {
        guard let rank = LiturgicalRank(rawValue: rank), let color = LiturgicalColor(rawValue: color) else { return nil }
        return .init(monthDay: monthDay, name: name, rank: rank, color: color)
    }
}
