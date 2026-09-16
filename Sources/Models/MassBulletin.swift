import Foundation

/// One Sunday's Mass readings — references only, never the licensed text
/// itself (CNBB/USCCB own the translation; only the citation — book, chapter,
/// verse — is free to publish). See spec's own licensing note and
/// `LiturgicalEngine.ComputedDay.lectionaryKey`.
struct MassReadings: Codable, Hashable {
    let firstReading: String   // e.g. "Isaías 2, 1-5"
    let psalm: String          // e.g. "Salmo 121"
    let secondReading: String? // nil only for the rare Mass that genuinely has none
    let gospel: String         // e.g. "Mateus 24, 37-44"
}
