import SwiftUI

struct AppRootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingFlow(onFinished: { hasCompletedOnboarding = true })
            }
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
        MainTabContainer(selection: $selection) {
            switch selection {
            case .today: TodayRootView()
            case .calendar: CalendarRootView()
            case .formation: FormationRootView()
            case .prayers: PrayersRootView()
            }
        }
    }
}
