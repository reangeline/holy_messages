import Foundation

enum MysterySet: String, Codable, CaseIterable, Hashable {
    case joyful = "Gozosos"
    case sorrowful = "Dolorosos"
    case glorious = "Gloriosos"
    case luminous = "Luminosos"
}

struct RosaryMystery: Identifiable, Codable, Hashable {
    var id: String { mysterySet.rawValue }
    let mysterySet: MysterySet
    let dayLabel: String // e.g. "Segunda e sábado"
    let decades: [String] // the 5 mystery titles, e.g. "A Visitação"
}

struct RosaryBead: Identifiable, Codable {
    var id: Int { index }
    let index: Int
    let kind: BeadKind
    let mysteryIndex: Int? // which of the 5 decades this bead belongs to, if any

    enum BeadKind: String, Codable {
        case crucifix, creed, ourFather, hailMary, glory, announcement, hailHolyQueen
    }
}

/// A real, local-only record of a completed rosary — backs "Terços rezados"
/// with what was actually prayed, not a fixed demo history.
struct RosaryHistoryEntry: Identifiable, Codable {
    let id: UUID
    let mysterySet: MysterySet
    let modeLabel: String // "Guiado", "Modo iniciante" or "Tela apagada"
    let intention: String?
    let date: Date

    init(id: UUID = UUID(), mysterySet: MysterySet, modeLabel: String, intention: String? = nil, date: Date = Date()) {
        self.id = id
        self.mysterySet = mysterySet
        self.modeLabel = modeLabel
        self.intention = intention
        self.date = date
    }
}

struct RosaryPrayerStep: Codable {
    let beadLabel: String // "Segundo mistério gozoso · a Visitação"
    let kicker: String
    let text: String
    let hint: String
}

struct Novena: Codable {
    let title: String
    let currentDay: Int
    let totalDays: Int
}

struct PrayerHowTo: Identifiable, Codable {
    let id: String
    let title: String
    let body: String
}
