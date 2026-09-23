import Foundation

/// Liturgical dates are stored as "yyyy-MM-dd" keys, and every human-readable
/// label is derived from the key through here.
///
/// The calendar data used to carry the labels as authored strings
/// (`weekdayLabel: "Segunda-feira"`, `dayMonthLabel: "14 de setembro"`), which
/// froze them in the language they were written in: the calendar stayed
/// Portuguese in English and Spanish, and a relaunch didn't help. A weekday name
/// is chrome, not content — Foundation already has it in every locale, correctly
/// declined, so nothing here is hand-translated.
enum DateKeyLabel {
    private static let keyParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.gregorianUTC
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func date(fromKey key: String) -> Date? { keyParser.date(from: key) }

    private static func formatter(template: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.gregorianUTC
        formatter.timeZone = TimeZone(identifier: "UTC")
        let locale = AppLanguagePreference.resolveCurrent().locale
        formatter.locale = locale
        // Templates, not fixed patterns: each locale gets its own field order and
        // connectors ("14 de setembro", "September 14", "14 de septiembre").
        formatter.setLocalizedDateFormatFromTemplate(template)
        return formatter
    }

    /// "Segunda-feira" · "Monday" · "Lunes". Only the first character is raised:
    /// `localizedCapitalized` would also raise the second half of a compound
    /// weekday name ("Segunda-Feira").
    static func weekday(fromKey key: String) -> String {
        guard let date = date(fromKey: key) else { return "" }
        let name = formatter(template: "EEEE").string(from: date)
        return name.prefix(1).localizedUppercase + name.dropFirst()
    }

    /// "14 de setembro" · "September 14" · "14 de septiembre"
    /// "Setembro" · "December" — the month of the key, for a screen's title.
    static func month(fromKey key: String) -> String {
        guard let date = date(fromKey: key) else { return "" }
        let nome = formatter(template: "LLLL").string(from: date)
        return nome.prefix(1).localizedUppercase + nome.dropFirst()
    }

    static func dayMonth(fromKey key: String) -> String {
        guard let date = date(fromKey: key) else { return "" }
        return formatter(template: "dMMMM").string(from: date)
    }

    /// "13 – 19 de setembro" · "September 13 – 19" — one interval, formatted by
    /// Foundation rather than assembled with a hardcoded "a".
    static func dayMonthRange(fromKey start: String, toKey end: String) -> String {
        guard let from = date(fromKey: start), let to = date(fromKey: end) else { return "" }
        let formatter = DateIntervalFormatter()
        formatter.calendar = Calendar.gregorianUTC
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        formatter.dateTemplate = "dMMMM"
        return formatter.string(from: from, to: to)
    }
}
