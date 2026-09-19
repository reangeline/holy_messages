import Foundation

enum UserProfile {
    static let nameStorageKey = "userDisplayName"

    /// Preferences someone sets and expects to find again. These were all
    /// view-local `@State` until now, which meant the screen showed the choice
    /// and then threw it away on the way back out — the picker looked like it
    /// worked and never did.
    static let calendarRegionKey = "liturgicalCalendarRegionID"
    static let rosaryBeginnerModeKey = "rosaryBeginnerMode"
    static let syncEnabledKey = "syncAcrossDevices"
    static let analyticsEnabledKey = "anonymousAnalytics"
}
