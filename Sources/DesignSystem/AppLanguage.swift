import Foundation
import SwiftUI

/// The three languages supported by the interface. Content collections declare
/// their own coverage through `LocalizedCatalog`; a collection must never
/// manufacture a translation at render time.
enum AppLanguage: String, CaseIterable, Identifiable {
    case en, pt, es

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: "English"
        case .pt: "Português"
        case .es: "Español"
        }
    }

    var locale: Locale { Locale(identifier: rawValue) }

    /// Maps a device's preferred-language list to one of our 3 supported
    /// languages, defaulting to English when none match.
    static func closestSupported(to preferred: [String]) -> AppLanguage {
        for code in preferred {
            let base = Locale(identifier: code).language.languageCode?.identifier ?? code
            if let match = AppLanguage(rawValue: base) { return match }
        }
        return .en
    }
}

enum AppLanguagePreference {
    /// "system" (follow the device), or one of AppLanguage's raw values as an
    /// explicit override. Stored via @AppStorage at the call site.
    static let storageKey = "appLanguageOverride"
    static let systemValue = "system"

    static func resolve(override: String) -> AppLanguage {
        if let explicit = AppLanguage(rawValue: override) { return explicit }
        return AppLanguage.closestSupported(to: Locale.preferredLanguages)
    }

    /// Reads the current override straight from UserDefaults (the same storage
    /// @AppStorage(storageKey) uses) and resolves it. For use outside SwiftUI
    /// view bodies — see `L.string`.
    static func resolveCurrent() -> AppLanguage {
        resolve(override: UserDefaults.standard.string(forKey: storageKey) ?? systemValue)
    }
}

/// A sheet or full-screen cover is hosted outside the presenting view's tree, so
/// it does NOT inherit `\.locale`: localized `Text` inside it falls back to the
/// device language, which is how the Settings sheet came out showing "Close" in
/// an app set to Portuguese. Apply this to every presented content view.
private struct AppLanguageLocale: ViewModifier {
    @AppStorage(AppLanguagePreference.storageKey) private var override = AppLanguagePreference.systemValue

    func body(content: Content) -> some View {
        content.environment(\.locale, AppLanguagePreference.resolve(override: override).locale)
    }
}

extension View {
    func appLanguageLocale() -> some View { modifier(AppLanguageLocale()) }
}

/// `L.string()` does NOT read SwiftUI's `\.locale` environment value —
/// only `Text` does. Every plain-`String` localized lookup in this app (nav
/// titles, format strings, anything that isn't a literal `Text(...)`) must go
/// through this instead, or it silently ignores the in-app language override
/// and just follows the device's system language.
///
/// Deliberately uses the classic Bundle(path:)-for-the-.lproj technique rather
/// than `String(localized:locale:)` — the explicit `locale:` parameter on that
/// initializer did not actually pick up the requested language in testing
/// (always fell back to the key itself), while this approach mirrors exactly
/// how SwiftUI's own `Text(_:tableName:)` resolves strings, which does work.
enum L {
    static func string(_ key: String, table: String? = nil) -> String {
        let language = AppLanguagePreference.resolveCurrent()
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, tableName: table, bundle: .main, value: key, comment: "")
        }
        return NSLocalizedString(key, tableName: table, bundle: bundle, value: key, comment: "")
    }
}
