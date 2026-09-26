import Foundation

/// The word shown on each of the last 30 days, and whether the day's was
/// chosen for this reader from what they wrote (see PersonalizedWordOfDay).
///
/// Kept in the app group, like the language, so the widget shows the very
/// verse the app shows. This file is compiled into the widget too — see the
/// MissaleWidgetsExtension sources in project.yml.
struct ShownWord: Codable, Equatable {
    let id: String
    /// The pool the id belongs to: ids differ between languages.
    let language: String
    /// Chosen by Jev from what the reader wrote, instead of drawn by date.
    var chosen: Bool = false
    /// Jev already answered today (confident or not): never asked again until
    /// tomorrow, so the word can't change twice. Left false when every call
    /// so far failed (offline, the server, the daily limit), so the next
    /// chance — the app becomes active, Today appears, a note or intention is
    /// saved — tries again.
    var asked: Bool = false
    /// What the reader wrote carried a sign of risk: the crisis card stays
    /// beside the word for the rest of the day.
    var showCrisisFirst: Bool = false
}

enum WordOfDayLog {
    static let storageKey = "word_of_day_shown"
    static let keptDays = 30

    static var defaults: UserDefaults { UserDefaults(suiteName: RemoteContent.appGroup) ?? .standard }

    /// Day key ("yyyy-MM-dd") → the word shown that day.
    static func entries(in defaults: UserDefaults = defaults) -> [String: ShownWord] {
        guard let data = defaults.data(forKey: storageKey),
              let entries = try? JSONDecoder().decode([String: ShownWord].self, from: data) else { return [:] }
        return entries
    }

    static func save(_ entries: [String: ShownWord], in defaults: UserDefaults = defaults) {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: storageKey)
    }
}

extension MockWordOfDay {
    /// The word the reader sees on `dayKey`: the one chosen for them that day,
    /// while it is in the current language's pool; otherwise the date draw.
    /// The app (Today, the word screen, the share card) and the widget all
    /// come through here, so they can't disagree.
    static func word(for dayKey: String, log: [String: ShownWord] = WordOfDayLog.entries()) -> WordOfDay {
        if let entry = log[dayKey], entry.chosen,
           entry.language == AppLanguagePreference.resolveCurrent().rawValue,
           let chosen = pool.first(where: { $0.id == entry.id }) {
            return chosen
        }
        return wordOfDay(for: dayKey)
    }
}
