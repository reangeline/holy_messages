import Foundation

/// A Marian apparition presented by its shrine or other ecclesial source.
/// This is intentionally separate from `Saint`: an apparition is an event and
/// its reception by the Church, not a biography of the Blessed Virgin or of a
/// visionary.
struct MarianApparition: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let place: String
    let year: String
    let visionaries: String
    let summary: String
    let ecclesialRecognition: String
    let source: String

    /// Square and wide images uploaded in the admin page, when there are any.
    var artworkURL: String? = nil
    var wideArtworkURL: String? = nil

    /// The thumbnail: the square upload, else the wide one, else the art that
    /// ships in the app for this id. Nil for a record with none of them —
    /// `SaintPortrait` then draws the striped placeholder rather than
    /// borrowing another shrine's picture.
    var artworkName: String? {
        ArtworkChoice.thumbnail(square: RemoteContent.artworkName(forURL: artworkURL),
                                wide: RemoteContent.artworkName(forURL: wideArtworkURL),
                                bundled: MarianApparitionArt.artwork(forID: id))
    }

    /// The top of the apparition's page: the wide upload first.
    var heroArtworkName: String? {
        ArtworkChoice.hero(square: RemoteContent.artworkName(forURL: artworkURL),
                           wide: RemoteContent.artworkName(forURL: wideArtworkURL),
                           bundled: MarianApparitionArt.artwork(forID: id))
    }
}

/// Which apparitions have art in `Assets.xcassets/Saints`.
///
/// The image files are named for the devotion, not for the record id, because
/// they came from the same art batch as the saints (one folder per title under
/// ~/Documents/Missale-pesquisa). This maps one to the other, and answers nil
/// for a record with no image yet.
enum MarianApparitionArt {
    /// Record id -> asset name. Only ids listed here have artwork.
    private static let porID = [
        "fatima-1917": "fatima",
        "guadalupe-1531": "guadalupe",
        "aparecida-1717": "aparecida",
        "lourdes-1858": "lourdes",
        "rue-du-bac-1830": "gracas",
    ]

    static func artwork(forID id: String) -> String? { porID[id] }

    /// Art present in the catalog with no record to attach it to. Surfaced by
    /// a test so the gap stays visible instead of sitting unused in the bundle.
    static let semFicha: [String] = []
}
