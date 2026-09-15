import SwiftUI

enum MainTab: CaseIterable, Identifiable {
    case today, calendar, formation, prayers

    var id: Self { self }

    var title: String {
        switch self {
        case .today: L.string( "Today")
        case .calendar: L.string( "Calendar")
        case .formation: L.string( "Formation")
        case .prayers: L.string( "Prayers")
        }
    }

    var icon: String {
        switch self {
        case .today: "sun.max"
        case .calendar: "calendar"
        case .formation: "book.closed"
        case .prayers: "hands.sparkles"
        }
    }
}

/// The floating pill-shaped glass tab bar from the design, replacing the plain
/// system tab bar chrome. Hosted over content by `MainTabContainer`.
struct GlassTabBar: View {
    @Binding var selection: MainTab
    var accent: Color = Palette.wine

    var body: some View {
        HStack {
            ForEach(MainTab.allCases) { tab in
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 19, weight: .medium))
                        Text(tab.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selection == tab ? accent : Palette.ink.opacity(0.45))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial, in: Capsule())
        .background(Color.white.opacity(0.18), in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white.opacity(0.55), lineWidth: 1))
        .shadow(color: accent.opacity(0.18), radius: 20, x: 0, y: 12)
        .padding(.horizontal, 20)
    }
}

private struct MainTabSelectionKey: EnvironmentKey {
    static let defaultValue: Binding<MainTab>? = nil
}

extension EnvironmentValues {
    /// Set once by MainTabView. Hub-screen roots (Today, Calendar, Formation,
    /// Prayers) read this to draw their own floating tab bar via
    /// `.hubTabBarOverlay()`. Deliberately NOT applied by wrapping each tab's
    /// whole NavigationStack from the outside — that would keep the bar floating
    /// over every pushed detail screen too, which the design never shows it on.
    var mainTabSelection: Binding<MainTab>? {
        get { self[MainTabSelectionKey.self] }
        set { self[MainTabSelectionKey.self] = newValue }
    }
}

private struct HubTabBarOverlay: ViewModifier {
    @Environment(\.mainTabSelection) private var selection

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if let selection {
                GlassTabBar(selection: selection)
                    .padding(.bottom, 8)
            }
        }
    }
}

extension View {
    /// Apply inside a hub screen's own root ZStack (alongside its background and
    /// ScrollView) — never around a NavigationStack — so the floating tab bar
    /// disappears correctly on push and reappears on pop.
    func hubTabBarOverlay() -> some View {
        modifier(HubTabBarOverlay())
    }
}
