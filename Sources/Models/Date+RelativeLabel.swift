import Foundation

extension Date {
    /// "Hoje", "Ontem", or a formatted label — the relative-day phrasing every
    /// local history screen uses (mood, rosary, Examen) instead of a raw date.
    ///
    /// Takes a *template* ("EEEEdMMMM"), not a fixed pattern: the Examen history
    /// used to pass "EEEE, d 'de' MMMM", with the Portuguese connector baked in,
    /// which in English produced "Monday, 14 de September". Foundation supplies
    /// each locale's own field order and connectors.
    func relativeLabel(template: String) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return L.string("Hoje") }
        if calendar.isDateInYesterday(self) { return L.string("Ontem") }
        let formatter = DateFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        formatter.setLocalizedDateFormatFromTemplate(template)
        let name = formatter.string(from: self)
        // Only the first character is raised: localizedCapitalized would also
        // raise the second half of a compound weekday name ("Segunda-Feira").
        return name.prefix(1).localizedUppercase + name.dropFirst()
    }
}
