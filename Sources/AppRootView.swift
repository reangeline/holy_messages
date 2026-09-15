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
        // the device by default with a manual override in Settings. Applying it
        // here (not per-screen) means every Text/L.string() below updates
        // live the moment the override changes — no restart needed.
        .environment(\.locale, resolvedLanguage.locale)
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
