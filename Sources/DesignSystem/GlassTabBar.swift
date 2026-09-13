import SwiftUI

enum MainTab: CaseIterable, Identifiable {
    case today, calendar, formation, prayers

    var id: Self { self }

    var title: String {
        switch self {
        case .today: "Hoje"
        case .calendar: "Calendário"
        case .formation: "Formação"
        case .prayers: "Orações"
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

/// Wraps a tab's root content with the floating glass bar pinned to the bottom,
/// matching the design's overlay placement rather than a system TabView chrome.
struct MainTabContainer<Content: View>: View {
    @Binding var selection: MainTab
    var accent: Color = Palette.wine
    @ViewBuilder var content: Content

    var body: some View {
        ZStack(alignment: .bottom) {
            content
            GlassTabBar(selection: $selection, accent: accent)
                .padding(.bottom, 8)
        }
    }
}
