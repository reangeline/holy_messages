import Foundation
import UserNotifications

/// Schedules the Angelus (Regina Caeli in Eastertide) as real local notifications.
///
/// Two constraints shape this, both easy to miss:
/// 1. A single `repeats: true` trigger bakes its content in at scheduling time, so
///    it can't switch wording when the liturgical season turns (Angelus → Regina
///    Caeli at Easter, back at Pentecost). Each occurrence is scheduled individually
///    instead, with content resolved per-date via `MockLiturgical.marianAntiphonPeriod`.
/// 2. iOS caps pending local notifications at 64 per app, shared across every
///    notification-producing feature (this, the daily-reading reminder from
///    onboarding, Divine Mercy, etc.). A rolling window refreshed on every launch —
///    not a long-dated schedule — is required, not an optimization. This scheduler
///    only owns its own slice of that budget (`windowDays` × `hours.count`); it does
///    not coordinate with other features that also schedule notifications, which a
///    real cross-feature notification budget would need to do.
enum AngelusScheduler {
    /// 6h/12h/18h is the traditional triple Angelus. Change here, not at call sites.
    private static let hours = [6, 12, 18]
    /// 10 days × 3 times/day = 30 pending notifications — well under the 64 cap,
    /// leaving room for whatever else schedules notifications.
    private static let windowDays = 10
    private static let identifierPrefix = "angelus."

    /// Removes any previously-scheduled Angelus notifications and schedules a fresh
    /// rolling window. Safe to call every time the app becomes active — idempotent,
    /// and the only way the Eastertide/Ordinary Time wording switch actually reaches
    /// already-pending notifications is by re-running this after the season turns.
    static func refresh() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            center.getPendingNotificationRequests { pending in
                let ours = pending
                    .filter { $0.identifier.hasPrefix(identifierPrefix) }
                    .map(\.identifier)
                center.removePendingNotificationRequests(withIdentifiers: ours)
                scheduleWindow(center: center)
            }
        }
    }

    private static func scheduleWindow(center: UNUserNotificationCenter) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for dayOffset in 0..<windowDays {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let period = MockLiturgical.marianAntiphonPeriod(on: day)

            for hour in hours {
                guard let fireDate = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day),
                      fireDate > Date() else { continue }

                let content = UNMutableNotificationContent()
                switch period {
                case .angelus:
                    content.title = "Hora do Angelus"
                    content.body = "Três minutos, quando você puder. \u{201C}O Anjo do Senhor anunciou a Maria.\u{201D}"
                case .reginaCaeli:
                    content.title = "Hora do Regina Caeli"
                    content.body = "Tempo Pascal: \u{201C}Rainha do Céu, alegrai-vos, aleluia.\u{201D}"
                }
                content.sound = .default

                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let identifier = "\(identifierPrefix)\(components.year!)-\(components.month!)-\(components.day!)-\(hour)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
}
