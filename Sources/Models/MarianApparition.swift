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
}
