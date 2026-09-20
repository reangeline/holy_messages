import Foundation

struct Saint: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let lifespan: String
    let role: String
    let rank: String // e.g. "Memória", shown as a pill
    let calendarNote: String // e.g. "Calendário próprio · Áustria e Alemanha"
    let bioParagraphs: [String]
    let whyItMattersToday: String
    let prayer: String
    /// Name of an image in the asset catalog, when there is public-domain art
    /// for this saint. Nil falls back to SaintPortraitPlaceholder — most saints
    /// have no art yet, and a striped placeholder is honest about that.
    var artworkName: String? = nil
}

/// A curated recommendation of saints tied to whatever mood/state the user logged.
struct SaintRecommendation: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let reason: String
}

/// The sanctoral cycle differs by calendar region: the General Roman Calendar plus
/// national/regional propers on top of it (a date can carry a different saint, or an
/// additional one, in the US vs. Poland vs. Portugal). `.general` is the only region
/// populated in this pass, but every lookup already goes through a region so adding
/// a country later is additive — it doesn't reshape this model or its call sites.
/// See product spec §2.
enum SaintCalendarRegion: String, CaseIterable, Identifiable, Codable {
    case general

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .general: "Calendário Romano Geral"
        }
    }
}

/// One region's commemoration on one fixed calendar date. `dateKey` is "MM-dd" —
/// year-independent, since the sanctoral cycle (unlike movable feasts) repeats on
/// the same civil date every year.
struct SaintOfDay: Identifiable, Codable, Hashable {
    var id: String { "\(region.rawValue)-\(dateKey)" }
    let dateKey: String
    let region: SaintCalendarRegion
    let saint: Saint
}
