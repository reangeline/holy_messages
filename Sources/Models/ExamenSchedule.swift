import Foundation

/// When the Examen is offered. The hour lives here instead of inside a
/// translated string: the home card read "TONIGHT, AT 9:30 PM" in English while
/// the Examen's own screen showed a hardcoded "21H30", and the Spanish
/// translation carried the Portuguese "21H30" spelling too. Foundation writes
/// each locale's own clock convention.
///
/// The time is the reader's to choose — it was fixed at 21:30 — and is kept as
/// minutes after midnight.
enum ExamenSchedule {
    static let storageKey = "examenMinutesOfDay"
    static let defaultMinutes = 21 * 60 + 30

    static var minutesOfDay: Int {
        get { UserDefaults.standard.object(forKey: storageKey) as? Int ?? defaultMinutes }
        set { UserDefaults.standard.set(newValue, forKey: storageKey) }
    }

    static var hour: Int { minutesOfDay / 60 }
    static var minute: Int { minutesOfDay % 60 }

    /// Today at the chosen time, for a DatePicker.
    static func date(forMinutes minutes: Int) -> Date {
        Calendar.current.date(bySettingHour: minutes / 60, minute: minutes % 60, second: 0, of: .now) ?? .now
    }

    static func minutes(from date: Date) -> Int {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (c.hour ?? 21) * 60 + (c.minute ?? 30)
    }

    static var timeLabel: String {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        guard let date = Calendar.current.date(from: components) else { return "" }
        let formatter = DateFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}
