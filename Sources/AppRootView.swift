import SwiftUI

struct AppRootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSettings = false
#if DEBUG
    @State private var showExamen = false
    @State private var showPaywall = false
#endif
    @AppStorage(AppLanguagePreference.storageKey, store: AppLanguagePreference.store) private var languageOverride = AppLanguagePreference.systemValue
    @Environment(\.scenePhase) private var scenePhase

    private var resolvedLanguage: AppLanguage {
        AppLanguagePreference.resolve(override: languageOverride)
    }

#if DEBUG
    /// Opens a screen straight from a launch argument. The Simulator can't be
    /// driven from a shell, so screens behind a tap (everything under Settings)
    /// were impossible to check with a screenshot:
    ///
    ///     xcrun simctl launch <device> com.missale.app -openScreen settings
    ///
    /// Debug-only and off unless the argument is passed.
    private var debugOpensSettings: Bool {
        debugOpenScreen == "settings"
    }

    /// Which screen the launch argument asks for, if any.
    ///
    /// "examen" opens the Examen intro: reaching it by tapping the nightly card
    /// was the flakiest step in the UI suite — the card is the last item in the
    /// scroll and the floating tab bar covers part of it, by an amount that
    /// changes with the language of the card's own text.
    ///
    /// "paywall" opens the subscription screen. App Store Connect requires a
    /// screenshot of it for subscription review, and it is otherwise only
    /// reachable at the end of onboarding, after eighteen screens.
    private var debugOpenScreen: String? {
        UserDefaults.standard.string(forKey: "openScreen")
    }
#endif

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
        // Outside the .id() above on purpose: the sheet survives the rebuild, so
        // picking a language updates the app behind it without closing it.
        .environment(\.settingsPresented, $showSettings)
#if DEBUG
        .fullScreenCover(isPresented: $showPaywall) {
            OnboardingPaywallView(onFinish: { showPaywall = false })
                .appLanguageLocale()
        }
        .fullScreenCover(isPresented: $showExamen) {
            NavigationStack {
                ExamenIntroView(onFinished: { showExamen = false })
            }
            .appLanguageLocale()
        }
#endif
        .sheet(isPresented: $showSettings) {
            // The locale has to be applied to the sheet's own content: a sheet is
            // hosted outside the presenting view's tree, so `Text(_:tableName:)`
            // inside it was resolving against the device language instead of the
            // app's — the Settings sheet showed "Close" in an app set to Portuguese.
            SettingsView()
                .appLanguageLocale()
        }
        .task {
#if DEBUG
            if debugOpensSettings { showSettings = true }
            if debugOpenScreen == "examen" { showExamen = true }
            if debugOpenScreen == "paywall" { showPaywall = true }
#endif
        }
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
