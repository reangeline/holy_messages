import Foundation

/// How much of the app's *content* exists in a given language. Interface
/// strings are complete in all three languages; content catalogs are authored
/// one at a time via the Acervo, so switching to English today still shows
/// Portuguese saints and formation lessons. LanguageSettingsView reports this
/// instead of letting the fallback look like a bug.
///
/// Every catalog in the app is listed here — adding one means adding a line.
enum ContentLanguageCoverage {
    private static func catalogFlags(for language: AppLanguage) -> [Bool] {
        [
            LiturgicalSanctoral.catalog.hasOwnCatalog(for: language),
            MockLiturgical.currentWeekCatalog.hasOwnCatalog(for: language),
            MockLiturgical.glossaryCatalog.hasOwnCatalog(for: language),
            MockLiturgical.ranksExplainerCatalog.hasOwnCatalog(for: language),
            MockLiturgical.seasonsCatalog.hasOwnCatalog(for: language),
            MockLiturgical.todayCatalog.hasOwnCatalog(for: language),
            MockLiturgical.tomorrowCatalog.hasOwnCatalog(for: language),
            MockDevotionalPrayers.catalog.hasOwnCatalog(for: language),
            MockFormation.otherTracksCatalog.hasOwnCatalog(for: language),
            MockFormation.trackCatalog.hasOwnCatalog(for: language),
            MockMood.reliefCatalog.hasOwnCatalog(for: language),
            MockMood.stateGroupsCatalog.hasOwnCatalog(for: language),
            MockRosary.examenStepsCatalog.hasOwnCatalog(for: language),
            MockRosary.howToCatalog.hasOwnCatalog(for: language),
            MockRosary.intentionCatalog.hasOwnCatalog(for: language),
            MockRosary.labelCatalog.hasOwnCatalog(for: language),
            MockRosary.mysteryCatalog.hasOwnCatalog(for: language),
            MockRosary.prayerCatalog.hasOwnCatalog(for: language),
            MockSaints.catalog.hasOwnCatalog(for: language),
            MockWordOfDay.catalog.hasOwnCatalog(for: language),
        ]
    }

    /// (how many catalogs exist in `language`, how many there are in total).
    static func counts(for language: AppLanguage) -> (authored: Int, total: Int) {
        let flags = catalogFlags(for: language)
        return (flags.filter { $0 }.count, flags.count)
    }

    static func isComplete(for language: AppLanguage) -> Bool {
        let counts = counts(for: language)
        return counts.authored == counts.total
    }
}
