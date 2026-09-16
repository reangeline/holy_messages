import Foundation

enum MysterySet: String, Codable, CaseIterable, Hashable {
    case joyful = "Gozosos"
    case sorrowful = "Dolorosos"
    case glorious = "Gloriosos"
    case luminous = "Luminosos"
}

struct RosaryMysteryDetail: Codable, Hashable {
    let title: String // short label, e.g. "A Visitação"
    let description: String // what's being contemplated, meditated during the decade
    let fruit: String // the traditional "fruit of the mystery"
    let scriptureRef: String
}

struct RosaryMystery: Identifiable, Codable, Hashable {
    var id: String { mysterySet.rawValue }
    let mysterySet: MysterySet
    let dayLabel: String // e.g. "Segunda e sábado"
    let decades: [RosaryMysteryDetail] // the 5 mysteries of this set, in order
}

struct RosaryBead: Identifiable, Codable {
    var id: Int { index }
    let index: Int
    let kind: BeadKind
    let mysteryIndex: Int? // which of the 5 decades this bead belongs to, if any

    enum BeadKind: String, Codable {
        case crucifix, intentions, offering, creed, ourFather, hailMary, glory, announcement, hailHolyQueen
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

struct RosaryPromptItem: Codable, Hashable {
    let label: String
    let detail: String
}

struct RosaryPrayerStep: Codable {
    let beadLabel: String // "Segundo mistério gozoso · a Visitação"
    let kicker: String
    let text: String
    let hint: String
    // Set only for .announcement steps — shown unconditionally (not gated
    // behind beginner mode, unlike `hint`), since the fruit and citation are
    // core content, not just a UI tip.
    var fruit: String? = nil
    var scriptureRef: String? = nil
    // Set only for the .intentions step — when present, the view renders this
    // instead of `text` as a plain, non-italic list, so it reads as guidance
    // to think about, not as a prayer to recite.
    var promptItems: [RosaryPromptItem]? = nil
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
