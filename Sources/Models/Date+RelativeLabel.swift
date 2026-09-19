import Foundation

extension Date {
    /// "Hoje", "Ontem", or a formatted label — the relative-day phrasing every
    /// local history screen uses (mood, rosary, Examen) instead of a raw date.
    func relativeLabel(format: String) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return L.string("Hoje") }
        if calendar.isDateInYesterday(self) { return L.string("Ontem") }
        let formatter = DateFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        formatter.dateFormat = format
        return formatter.string(from: self).localizedCapitalized
    }
}
