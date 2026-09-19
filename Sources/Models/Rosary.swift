import Foundation

enum MysterySet: String, Codable, CaseIterable, Hashable {
    case joyful = "Gozosos"
    case sorrowful = "Dolorosos"
    case glorious = "Gloriosos"
    case luminous = "Luminosos"

    /// `rawValue` stays Portuguese on purpose — it's the id persisted in
    /// RosaryHistoryEntry, so it must not shift when the language does. This
    /// is what the interface shows instead.
    var displayName: String {
        switch AppLanguagePreference.resolveCurrent() {
        case .en:
            switch self {
            case .joyful: "Joyful"
            case .sorrowful: "Sorrowful"
            case .glorious: "Glorious"
            case .luminous: "Luminous"
            }
        case .pt, .es:
            rawValue
        }
    }

    /// The whole phrase, because word order differs: "Mistérios Gozosos" but
    /// "Joyful Mysteries". Composing a noun + `displayName` at the call site
    /// only works in Portuguese.
    var displayTitle: String {
        switch AppLanguagePreference.resolveCurrent() {
        case .en: "\(displayName) Mysteries"
        case .pt, .es: "Mistérios \(rawValue)"
        }
    }
}

/// The fixed prayers of the Rosary. One instance per language: each has an
/// official approved wording, not a translation of another's — see
/// LocalizedCatalog.
struct RosaryPrayerTexts {
    let signOfCross: String
    let apostlesCreed: String
    let ourFather: String
    let hailMary: String
    let gloryBe: String
    let fatimaPrayer: String
    let hailHolyQueen: String
    let offeringPrayer: String
}

/// The labels around each bead ("Conta maior", "Anúncio do mistério", the
/// ordinals). These live in the per-language catalog rather than in the app's
/// string catalogs because they name parts of the Rosary itself: a language
/// with no Rosary catalog should show the whole thing in Portuguese, not
/// translated labels wrapped around Portuguese prayers.
struct RosaryStepLabels {
    let signOfCross: String
    let crucifixKicker: String
    let tapHint: String
    let intentions: String
    let intentionsKicker: String
    let intentionsText: String
    let intentionsHint: String
    let offering: String
    let offeringKicker: String
    let offeringHint: String
    let creed: String
    let creedKicker: String
    let creedHint: String
    let announcementKicker: String
    let announcementHint: String
    let mysteryWord: String
    let ourFatherKicker: String
    let ourFatherHint: String
    let hailMaryKicker: String
    let hailMaryHint: String
    let gloryKicker: String
    let gloryHint: String
    let hailHolyQueen: String
    let hailHolyQueenKicker: String
    let hailHolyQueenHint: String
    let ordinals: [String]

    func ordinal(_ n: Int) -> String {
        (1...ordinals.count).contains(n) ? ordinals[n - 1] : "\(n)"
    }
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
    // Set only for .announcement steps: "Primeiro Mistério — A Anunciação",
    // shown as the card's headline above the meditative description.
    var mysteryTitleLine: String? = nil
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
