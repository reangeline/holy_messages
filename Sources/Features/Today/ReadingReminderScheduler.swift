import Foundation
import UserNotifications

/// The daily-reading notice, at the times the reader chose in the onboarding —
/// one or several a day. Each notice carries that day's word, so the schedule
/// is a rolling window, refreshed whenever the app becomes active, like the
/// Angelus beside it.
enum ReadingReminderScheduler {
    static let storageKey = "reading_reminder_minutes"
    static let defaultMinutes = [7 * 60]
    /// 7 days × up to 3 times = 21, beside the Angelus' 30: under the 64 cap.
    private static let windowDays = 7
    private static let identifierPrefix = "reading."

    /// Minutes after midnight, sorted.
    static var times: [Int] {
        get { (UserDefaults.standard.array(forKey: storageKey) as? [Int]) ?? defaultMinutes }
        set { UserDefaults.standard.set(Array(Set(newValue)).sorted(), forKey: storageKey) }
    }

    static func refresh() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            center.getPendingNotificationRequests { pending in
                center.removePendingNotificationRequests(
                    withIdentifiers: pending.map(\.identifier).filter { $0.hasPrefix(identifierPrefix) })
                Task { @MainActor in schedule(center: center) }
            }
        }
    }

    @MainActor
    private static func schedule(center: UNUserNotificationCenter) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for dayOffset in 0..<windowDays {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            // Days ahead get the date draw; today, the word already chosen for
            // the reader, if any, so the notice matches the app.
            let word = MockWordOfDay.word(for: DailyRoutineStore.dayKey(day))
            for minutes in times {
                guard let fireDate = calendar.date(bySettingHour: minutes / 60, minute: minutes % 60, second: 0, of: day),
                      fireDate > Date() else { continue }
                let content = UNMutableNotificationContent()
                content.title = L.string("Palavra de hoje", table: "Today")
                content.body = "\u{201C}\(word.quote)\u{201D} \(word.reference)"
                content.sound = .default

                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let identifier = "\(identifierPrefix)\(DailyRoutineStore.dayKey(day))-\(minutes)"
                center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
            }
        }
    }

    /// "7:00" / "7:00 AM", in the app's language.
    static func label(_ minutes: Int) -> String {
        let date = Calendar.current.date(bySettingHour: minutes / 60, minute: minutes % 60, second: 0, of: Date()) ?? Date()
        return date.formatted(Date.FormatStyle(date: .omitted, time: .shortened)
            .locale(AppLanguagePreference.resolveCurrent().locale))
    }

    /// "7:00 e 20:30", joined the way the app's language joins a list.
    static func label(_ times: [Int]) -> String {
        let formatter = ListFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        return formatter.string(from: times.sorted().map { label($0) }) ?? ""
    }
}
