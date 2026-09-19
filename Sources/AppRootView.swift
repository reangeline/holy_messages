import SwiftUI

struct AppRootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage(AppLanguagePreference.storageKey) private var languageOverride = AppLanguagePreference.systemValue
    @Environment(\.scenePhase) private var scenePhase

    private var resolvedLanguage: AppLanguage {
        AppLanguagePreference.resolve(override: languageOverride)
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingFlow(onFinished: { hasCompletedOnboarding = true })
            }
        }
        // Unifies onboarding and the main app under one language, detected from
        // the device by default with a manual override in Settings.
        .environment(\.locale, resolvedLanguage.locale)
        // The environment alone only updates `Text(_:tableName:)`, which resolves
        // its key against the locale at render time. Roughly half of the app's
        // strings instead go through `L.string`, which reads the override from
        // UserDefaults while a body is being evaluated — so on a live switch
        // those kept the previous language until the next cold launch, and the
        // interface came out half-translated. Same for content, which resolves
        // through `LocalizedCatalog.current`. Re-identifying the tree on the
        // language rebuilds every view, so both kinds resolve again at once.
        // It costs the navigation stack and the selected tab, which is the right
        // trade for a setting that changes once in the life of an install.
        .id(resolvedLanguage)
        // Rolling-window notifications need refreshing on every foreground, not just
        // cold launch — that's the only way a liturgical-season wording change
        // (Angelus → Regina Caeli) or the 64-pending cap stay honored over time.
        .onChange(of: scenePhase, initial: true) { _, newPhase in
            if newPhase == .active {
                AngelusScheduler.refresh()
            }
        }
    }
}

struct MainTabView: View {
    @State private var selection: MainTab = .today

    var body: some View {
        Group {
            switch selection {
            case .today: TodayRootView()
            case .calendar: CalendarRootView()
            case .formation: FormationRootView()
            case .prayers: PrayersRootView()
            }
        }
        .environment(\.mainTabSelection, $selection)
    }
}
