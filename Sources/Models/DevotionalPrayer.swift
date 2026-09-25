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

/// A prayer category as the admin page publishes it (its prayers are their
/// own collection).
struct PublishedPrayerCategory: Codable, Hashable {
    let id: String
    let title: String
}

/// A devotional prayer as the admin page publishes it, with its category.
struct PublishedPrayer: Codable, Hashable {
    let id: String
    let categoryID: String
    let title: String
    var attribution: String? = nil
    let focus: String
    var saintID: String? = nil
    let fullText: String

    init(_ prayer: DevotionalPrayer, categoryID: String) {
        id = prayer.id
        self.categoryID = categoryID
        title = prayer.title
        attribution = prayer.attribution
        focus = prayer.focus
        saintID = prayer.saintID
        fullText = prayer.fullText
    }

    var prayer: DevotionalPrayer {
        DevotionalPrayer(id: id, title: title,
                         attribution: (attribution?.isEmpty ?? true) ? nil : attribution,
                         focus: focus,
                         saintID: (saintID?.isEmpty ?? true) ? nil : saintID,
                         fullText: fullText)
    }

    /// The categories in the published order, each with its prayers in the
    /// published order. An empty category is left out.
    static func assemble(categories: [PublishedPrayerCategory], prayers: [PublishedPrayer]) -> [PrayerCategory] {
        categories.compactMap { category in
            let own = prayers.filter { $0.categoryID == category.id }.map(\.prayer)
            return own.isEmpty ? nil : PrayerCategory(id: category.id, title: category.title, prayers: own)
        }
    }
}
