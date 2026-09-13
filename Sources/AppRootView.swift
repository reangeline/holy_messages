import SwiftUI

struct AppRootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingFlow(onFinished: { hasCompletedOnboarding = true })
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
