import Foundation

struct DevotionalPrayer: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let attribution: String?
    let focus: String // short description of the prayer's theme
    let fullText: String
    /// The saint record this prayer can open, when both are present in the
    /// curated catalog. It is an id rather than a display name so the record
    /// follows the app's selected content language.
    let saintID: String?

    init(
        id: String,
        title: String,
        attribution: String?,
        focus: String,
        saintID: String? = nil,
        fullText: String
    ) {
        self.id = id
        self.title = title
        self.attribution = attribution
        self.focus = focus
        self.saintID = saintID
        self.fullText = fullText
    }
}

struct PrayerCategory: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let prayers: [DevotionalPrayer]
}
