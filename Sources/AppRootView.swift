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
    ///     xcrun simctl launch <device> com.holymessages.app -openScreen settings
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
        // A paleta deste app é clara e cravada em hexadecimal — pergaminho,
        // tinta, vinho, ouro. Os materiais do sistema (`.ultraThinMaterial`
        // no GlassCard, nos chips do humor e na barra de abas), porém, seguem
        // a aparência do aparelho: com o modo escuro ligado o fundo continuava
        // pergaminho e cada cartão virava uma laje cinza-escura por cima dele.
        // Declarar a aparência é o conserto honesto enquanto não existir uma
        // paleta escura de verdade — e não existe: nenhuma cor do Palette tem
        // variante escura.
        .preferredColorScheme(.light)
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
                ReadingReminderScheduler.refresh()
                Task { await SubscriptionStore.shared.refreshOnForeground() }
            }
        }
    }
}

struct MainTabView: View {
    @State private var selection: MainTab = .today

    var body: some View {
        Group {
            switch selection {
            case .today:
                // Fica aberta: é onde está a palavra do dia e o caminho para o
                // apoio em momento de crise. Os cartões pagos do Hoje têm o
                // portão em cada um — ver TodayRootView.
                TodayRootView()
            case .calendar:
                GatedTab(content: { CalendarRootView() },
                         title: L.string("The liturgical calendar", table: "Onboarding"),
                         explanation: L.string("Every day of the year with its season, its colour and its feast, and the Sunday readings.", table: "Onboarding"))
            case .formation:
                GatedTab(content: { FormationRootView() },
                         title: L.string("Formation", table: "Onboarding"),
                         explanation: L.string("The Mass part by part, the liturgical year, confession, the Rosary — in short daily parts.", table: "Onboarding"))
            case .prayers:
                GatedTab(content: { PrayersRootView() },
                         title: L.string("Prayers and the Rosary", table: "Onboarding"),
                         explanation: L.string("The guided Rosary, the traditional prayers, and the Marian shrines with their sources.", table: "Onboarding"))
            }
        }
        .environment(\.mainTabSelection, $selection)
    }
}
