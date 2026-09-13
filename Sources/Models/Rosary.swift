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
    let isTodays: Bool
    let decades: [String] // the 5 mystery titles, e.g. "A Visitação"
}

struct RosaryBead: Identifiable, Codable {
    var id: Int { index }
    let index: Int
    let kind: BeadKind
    let mysteryIndex: Int? // which of the 5 decades this bead belongs to, if any

    enum BeadKind: String, Codable {
        case crucifix, ourFather, hailMary, glory, announcement
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

struct RosaryLogEntry: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let dateLabel: String
}

struct PrayerHowTo: Identifiable, Codable {
    let id: String
    let title: String
    let body: String
}
