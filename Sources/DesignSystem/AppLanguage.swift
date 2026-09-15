import Foundation
import SwiftUI

/// The 3 languages this pass supports for interface chrome. Religious content
/// (prayers, psalms, saint bios, formation lessons, FAQ answers) stays in
/// Portuguese for now regardless of the selected interface language — that's a
/// separate, larger translation effort tracked apart from this.
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
}
