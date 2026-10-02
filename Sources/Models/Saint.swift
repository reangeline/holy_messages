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
    /// The wide image for the top of the saint's page, when one was uploaded
    /// in the admin page; `heroArtworkName` falls back to `artworkName`.
    var wideArtworkName: String? = nil
    /// Miracles and well-known episodes — Francis and the wolf of Gubbio, Rita
    /// and the rose in winter — each with its source. Empty until the research
    /// batch carries a `stories` list for the record; the screen hides the
    /// section when there is none.
    var stories: [SaintStory] = []
}

extension Saint {
    /// What the top of the saint's page shows.
    var heroArtworkName: String? { wideArtworkName ?? artworkName }
}

/// Which image goes where, for saints and apparitions alike. Each record can
/// carry two uploads from the admin page — a wide one for the top of its page
/// and a square one for thumbnails — besides the art that ships in the app.
/// Each place prefers its own shape, then the other upload, then the bundled
/// art. An upload that hasn't been downloaded yet is nil here, so the next one
/// in line shows meanwhile.
enum ArtworkChoice {
    static func thumbnail(square: String?, wide: String?, bundled: String?) -> String? {
        square ?? wide ?? bundled.flatMap { $0.isEmpty ? nil : $0 }
    }

    static func hero(square: String?, wide: String?, bundled: String?) -> String? {
        wide ?? square ?? bundled.flatMap { $0.isEmpty ? nil : $0 }
    }
}

struct SaintStory: Codable, Hashable {
    let title: String
    let body: String
    /// Where the account comes from, shown under it: a Vatican page, a
    /// shrine, a hagiography with its edition.
    let source: String
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
    /// The saint's id is part of it: several saints share a date (four on
    /// 19 October in the published sanctoral), and a list keyed on the date
    /// alone drew the first of them once per row.
    var id: String { "\(region.rawValue)-\(dateKey)-\(saint.id)" }
    let dateKey: String
    let region: SaintCalendarRegion
    let saint: Saint
}

extension Saint {
    /// The rank as the reader's language says it. The first research batches
    /// wrote it in Portuguese for every language, so an English or Spanish
    /// page showed "Memória"; known values are translated here, anything else
    /// is shown as written.
    var displayRank: String {
        let byLanguage: [String: [AppLanguage: String]] = [
            "Solenidade": [.en: "Solemnity", .es: "Solemnidad"],
            "Festa": [.en: "Feast", .es: "Fiesta"],
            "Memória": [.en: "Memorial", .es: "Memoria"],
            "Memória facultativa": [.en: "Optional memorial", .es: "Memoria libre"],
        ]
        return byLanguage[rank]?[AppLanguagePreference.resolveCurrent()] ?? rank
    }
}

/// A saint as the admin page publishes it: the record and its date, flat, so
/// the page edits one form per saint. Decodes into the app's `SaintOfDay`.
struct PublishedSaint: Codable, Hashable {
    let id: String
    /// "MM-dd": the fixed civil date of the memorial.
    let dateKey: String
    let name: String
    let lifespan: String
    let role: String
    let rank: String
    let calendarNote: String
    let bioParagraphs: [String]
    let whyItMattersToday: String
    let prayer: String
    var artworkName: String? = nil
    /// The square image uploaded in the admin page (thumbnails); wins over
    /// `artworkName` once the app has downloaded it.
    var artworkURL: String? = nil
    /// The wide image uploaded in the admin page (the top of the page).
    var wideArtworkURL: String? = nil
    var stories: [SaintStory]? = nil

    init(_ entry: SaintOfDay) {
        let s = entry.saint
        id = s.id
        dateKey = entry.dateKey
        name = s.name
        lifespan = s.lifespan
        role = s.role
        rank = s.rank
        calendarNote = s.calendarNote
        bioParagraphs = s.bioParagraphs
        whyItMattersToday = s.whyItMattersToday
        prayer = s.prayer
        artworkName = s.artworkName
        stories = s.stories.isEmpty ? nil : s.stories
    }

    var saintOfDay: SaintOfDay {
        let square = RemoteContent.artworkName(forURL: artworkURL)
        let wide = RemoteContent.artworkName(forURL: wideArtworkURL)
        return SaintOfDay(dateKey: dateKey, region: .general, saint: Saint(
            id: id, name: name, lifespan: lifespan, role: role, rank: rank, calendarNote: calendarNote,
            bioParagraphs: bioParagraphs, whyItMattersToday: whyItMattersToday, prayer: prayer,
            artworkName: ArtworkChoice.thumbnail(square: square, wide: wide, bundled: artworkName),
            // Only an upload goes here: without one, `heroArtworkName` already
            // falls back to `artworkName`, and a bundled saint round-trips intact.
            wideArtworkName: ArtworkChoice.hero(square: square, wide: wide, bundled: nil),
            stories: stories ?? []))
    }
}
