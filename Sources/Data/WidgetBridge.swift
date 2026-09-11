import Foundation
import WidgetKit

/// Shares today's verse with the HolyMessagesWidget extension via an App Group,
/// mirroring the shared UserDefaults contract the widget already reads from.
enum WidgetBridge {
    static let appGroupID = "group.com.holymessages.app"

    private static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    static func publish(_ verse: Verse) {
        guard let defaults = sharedDefaults else { return }
        defaults.set(verse.verseText, forKey: "daily_verse")
        defaults.set(verse.reference, forKey: "daily_verse_ref")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
