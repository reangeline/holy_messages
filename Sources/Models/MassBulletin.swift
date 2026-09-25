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

/// One Sunday's readings as the admin page publishes them: the lectionary
/// key ("ordinary-12-B": season, week, cycle) and the references only — the
/// reading texts themselves are licensed and never ship.
struct PublishedSundayReadings: Codable, Hashable {
    let id: String
    let key: String
    let firstReading: String
    let psalm: String
    var secondReading: String? = nil
    let gospel: String

    init(key: String, _ r: MassReadings) {
        id = key.lowercased()
        self.key = key
        firstReading = r.firstReading
        psalm = r.psalm
        secondReading = r.secondReading
        gospel = r.gospel
    }

    var readings: MassReadings {
        MassReadings(firstReading: firstReading, psalm: psalm,
                     secondReading: (secondReading?.isEmpty ?? true) ? nil : secondReading, gospel: gospel)
    }
}
