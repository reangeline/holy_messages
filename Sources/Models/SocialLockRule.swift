import Foundation

/// One configurable trigger for the (not yet built) screen-time lock — spec §8.
/// This model and its screens are UI-only: there is no real ManagedSettings /
/// DeviceActivity integration behind these toggles yet. That requires the
/// `com.apple.developer.family-controls` entitlement (weeks-to-months approval
/// lead time — request it early, per the spec) plus native app extensions that
/// can't be built in a mocked SwiftUI pass. See SocialLockSetupView.
struct SocialLockRule: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let detail: String
    var isEnabled: Bool
}
