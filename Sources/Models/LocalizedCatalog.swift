import Foundation

/// Content that exists as a separate catalog per language rather than as
/// translations of one another: liturgical and devotional texts have an
/// official approved wording in each language (the English Our Father is not
/// a translation of the Portuguese one, it's its own fixed text), so each
/// language gets its own authored catalog.
///
/// Portuguese is the base. A language with no catalog of its own falls back to
/// it, so switching language never empties a screen — LanguageSettingsView
/// says so out loud rather than letting it look like a bug.
struct LocalizedCatalog<Content> {
    private let pt: Content
    private let en: Content?
    private let es: Content?

    init(pt: Content, en: Content? = nil, es: Content? = nil) {
        self.pt = pt
        self.en = en
        self.es = es
    }

    /// The catalog for the language the app is currently set to.
    var current: Content { self[AppLanguagePreference.resolveCurrent()] }

    subscript(language: AppLanguage) -> Content {
        switch language {
        case .pt: pt
        case .en: en ?? pt
        case .es: es ?? pt
        }
    }

    /// False when `language` has no catalog of its own and is therefore being
    /// served Portuguese.
    func hasOwnCatalog(for language: AppLanguage) -> Bool {
        switch language {
        case .pt: true
        case .en: en != nil
        case .es: es != nil
        }
    }
}
