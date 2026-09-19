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
