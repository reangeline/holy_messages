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

    /// Asset name of the shrine's image, when the art catalog has one. Nil for
    /// a record whose art hasn't been produced — `SaintPortrait` then draws the
    /// striped placeholder rather than borrowing another shrine's picture.
    ///
    /// Derived from the id rather than stored per language: the artwork is the
    /// same in all three, and `apparitionArtwork` keeps the mapping in one place.
    var artworkName: String? { MarianApparitionArt.artwork(forID: id) }
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
        // aparecida, lourdes e gracas já têm arte no catálogo, mas ainda não
        // têm ficha com fonte; assim que a ficha entrar, basta a linha aqui.
    ]

    static func artwork(forID id: String) -> String? { porID[id] }

    /// Art present in the catalog with no record to attach it to. Surfaced by
    /// a test so the gap stays visible instead of sitting unused in the bundle.
    static let semFicha = ["aparecida", "lourdes", "gracas"]
}
