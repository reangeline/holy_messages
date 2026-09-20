import SwiftUI

/// Not part of the original 10-screen Ajustes design — added because the app now
/// unifies onboarding and the main app under one interface language, detected
/// from the device by default with this manual override.
struct LanguageSettingsView: View {
    @AppStorage(AppLanguagePreference.storageKey) private var languageOverride = AppLanguagePreference.systemValue

    var body: some View {
        List {
            Section {
                row(title: L.string( "Automatic (device language)"), isSelected: languageOverride == AppLanguagePreference.systemValue) {
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
            } footer: {
                Text(contentFooter)
            }
        }
        .navigationTitle(L.string( "Language"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var currentlyResolvedFooter: String {
        let resolved = AppLanguagePreference.resolve(override: languageOverride)
        return "\u{2192} \(resolved.displayName)"
    }

    /// Says out loud that the interface and the content are translated at
    /// different speeds: chrome is complete in all 3 languages, content is
    /// authored catalog by catalog and falls back to Portuguese until then.
    private var contentFooter: String {
        let resolved = AppLanguagePreference.resolve(override: languageOverride)
        guard !ContentLanguageCoverage.isComplete(for: resolved) else {
            return L.string("The interface and all content are available in this language.")
        }
        let counts = ContentLanguageCoverage.counts(for: resolved)
        return L.string("The interface is fully translated. Content is available in {done} of {total} sections; the rest is shown in Portuguese until it is added.")
            .replacingOccurrences(of: "{done}", with: "\(counts.authored)")
            .replacingOccurrences(of: "{total}", with: "\(counts.total)")
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
            // A linha inteira tem de aceitar o toque. Sem isto, só a palavra
            // responde, e tocar no resto da linha não seleciona nada.
            .contentShape(Rectangle())
        }
    }
}
