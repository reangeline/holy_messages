import Foundation

enum LiturgicalRank: String, Codable {
    case memorial = "Memória"
    case optionalMemorial = "Memória facultativa"
    case feast = "Festa"
    case solemnity = "Solenidade"
    case weekday = "Feria"
}

struct LiturgicalDay: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String // "yyyy-MM-dd"
    let weekdayLabel: String
    let dayMonthLabel: String
    let seasonName: String
    let feastName: String
    let rank: LiturgicalRank
    let color: LiturgicalColor
    let explanation: String
}
