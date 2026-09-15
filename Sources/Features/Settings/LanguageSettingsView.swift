import SwiftUI

/// Not part of the original 10-screen Ajustes design — added because the app now
/// unifies onboarding and the main app under one interface language, detected
/// from the device by default with this manual override.
struct LanguageSettingsView: View {
    @AppStorage(AppLanguagePreference.storageKey) private var languageOverride = AppLanguagePreference.systemValue

    var body: some View {
        List {
            Section {
                row(title: String(localized: "Automatic (device language)"), isSelected: languageOverride == AppLanguagePreference.systemValue) {
                    languageOverride = AppLanguagePreference.systemValue
                }
            } footer: {
                Text(currentlyResolvedFooter)
            }
            Section {
                ForEach(AppLanguage.allCases) { language in
                    row(title: language.displayName, isSelected: languageOverride == language.rawValue) {
                        languageOverride = language.rawValue
                    }
                }
            }
        }
        .navigationTitle(String(localized: "Language"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var currentlyResolvedFooter: String {
        let resolved = AppLanguagePreference.resolve(override: languageOverride)
        return "\u{2192} \(resolved.displayName)"
    }

    private func row(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title).foregroundStyle(Palette.ink)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark").foregroundStyle(Palette.wine)
                }
            }
        }
    }
}
