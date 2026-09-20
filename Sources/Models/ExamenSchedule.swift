import Foundation

/// When the Examen is offered. The hour lives here instead of inside a
/// translated string: the home card read "TONIGHT, AT 9:30 PM" in English while
/// the Examen's own screen showed a hardcoded "21H30", and the Spanish
/// translation carried the Portuguese "21H30" spelling too. Foundation writes
/// each locale's own clock convention.
enum ExamenSchedule {
    static let hour = 21
    static let minute = 30

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
