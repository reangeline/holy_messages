import Foundation

/// Sunday Mass reading references, keyed by `LiturgicalEngine.ComputedDay.
/// lectionaryKey` ("season-week-cycle") — the same key recurs every time that
/// exact Sunday comes around again, every 3 years, matching how the Lectionary
/// itself is organized.
///
/// Deliberately empty to start: filling in ~170 citations (3 cycles × ~55
/// Sundays and major feasts) from memory risks a wrong chapter or verse in a
/// religious app, which is worse than showing nothing. Grows one validated
/// Sunday at a time — see the "Liturgia" tab in the Acervo tool, which can add
/// entries here directly. `MassBulletinView` shows an honest "ainda não
/// cadastrado" state for any key not yet present.
enum MockLectionary {
    /// One catalog per language: the book names and the psalm numbering differ,
    /// so this is not a translation of one list. Filled from the research
    /// deliveries — see Sources/MockData/Generated.
    /// What the admin page published wins; the catalog is what ships.
    static var sundayReadings: [String: MassReadings] {
        let language = AppLanguagePreference.resolveCurrent()
        if let published = RemoteContent.items("sunday_readings", language: language, as: PublishedSundayReadings.self) {
            return Dictionary(published.map { ($0.key, $0.readings) }, uniquingKeysWith: { first, _ in first })
        }
        return catalog[language]
    }

    static let catalog = LocalizedCatalog(pt: ptSundays, en: enSundays, es: esSundays)

    static func readings(for day: LiturgicalEngine.ComputedDay) -> MassReadings? {
        guard let key = day.lectionaryKey else { return nil }
        return sundayReadings[key]
    }
}
