import SwiftUI

/// t4 screen 8 — monthly liturgical calendar grid. Hub screen (shows the floating tab bar).
struct CalendarRootView: View {
    private let weekdaySymbols = ["D", "S", "T", "Q", "Q", "S", "S"]
    /// September 1, 2026 lands in this column (0 = Sunday) — purely for grid layout of the mock month.
    private let leadingEmptyDays = 2

    var body: some View {
        NavigationStack {
            ZStack {
                LiturgicalColor.green.pageBackground
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header
                        GlassCard(cornerRadius: 20) {
                            VStack(spacing: 10) {
                                weekdayRow
                                dayGrid
                            }
                        }
                        legend
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 110) // room for the floating glass tab bar
                }
            }
            .hubTabBarOverlay()
            .navigationBarHidden(true)
            .navigationDestination(for: CalendarDestination.self) { destination in
                switch destination {
                case .day(let mark):
                    CalendarDayDetailView(mark: mark)
                case .journey:
                    JourneyListView()
                case .week:
                    LiturgicalWeekView(week: MockLiturgical.currentWeek)
                case .year:
                    LiturgicalYearRibbonView()
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Eyebrow(text: MockLiturgical.today.seasonName)
                    Text("September", tableName: "CalendarSaints")
                        .font(MissaleFont.display(28))
                }
                Spacer()
                NavigationLink(value: CalendarDestination.journey) {
                    Text("The journey ›", tableName: "CalendarSaints")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.wine)
                }
            }
            HStack(spacing: 10) {
                NavigationLink(value: CalendarDestination.week) {
                    zoomLink(title: MockLiturgical.currentWeek.name, subtitle: "A semana em 7 dias")
                }
                .buttonStyle(.plain)
                NavigationLink(value: CalendarDestination.year) {
                    zoomLink(title: "O ano litúrgico", subtitle: "Uma faixa, o ano inteiro")
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func zoomLink(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(MissaleFont.body(14, weight: .medium))
                .foregroundStyle(Palette.ink)
                .lineLimit(1)
            Text(subtitle)
                .font(MissaleFont.body(12))
                .foregroundStyle(Palette.ink.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
    }

    private var weekdayRow: some View {
        HStack {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.system(size: 11))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var dayGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(0..<leadingEmptyDays, id: \.self) { _ in
                Color.clear.frame(height: 40)
            }
            ForEach(MockLiturgical.septemberDays) { mark in
                NavigationLink(value: CalendarDestination.day(mark)) {
                    dayCell(mark)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func dayCell(_ mark: CalendarDayMark) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(mark.color == .white ? Color.white.opacity(0.85) : mark.color.accent.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(mark.color == .white ? Palette.ink.opacity(0.2) : .clear, lineWidth: 1)
                )
            Text("\(mark.dayNumber)")
                .font(.system(size: 14))
                .foregroundStyle(mark.color == .white ? Palette.ink : Color.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 6)
            if mark.hasLoggedEntry {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Palette.ink.opacity(0.45))
                    .frame(width: 16, height: 3)
                    .padding(.bottom, 4)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 14) {
                legendSwatch(color: Palette.green, label: L.string( "Ordinary Time", table: "CalendarSaints"))
                legendSwatch(color: Palette.wine, label: L.string( "Feast, red", table: "CalendarSaints"))
                legendSwatch(color: .white, bordered: true, label: L.string( "White", table: "CalendarSaints"))
            }
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2).fill(Palette.ink.opacity(0.45)).frame(width: 16, height: 3)
                Text("discreet mark = you logged something that day", tableName: "CalendarSaints")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.7))
            }
            Text("No heat map and no good-day/bad-day colors: the color is the liturgy's, the mark is yours.", tableName: "CalendarSaints")
                .font(MissaleFont.body(13))
                .foregroundStyle(Palette.ink.opacity(0.55))
        }
    }

    private func legendSwatch(color: Color, bordered: Bool = false, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(bordered ? 0.85 : 0.5))
                .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(Palette.ink.opacity(bordered ? 0.2 : 0), lineWidth: 1))
                .frame(width: 12, height: 12)
            Text(label).font(MissaleFont.body(14)).foregroundStyle(Palette.ink.opacity(0.7))
        }
    }
}

enum CalendarDestination: Hashable {
    case day(CalendarDayMark)
    case journey
    case week
    case year
}

extension CalendarDayMark: Hashable {
    static func == (lhs: CalendarDayMark, rhs: CalendarDayMark) -> Bool { lhs.dateKey == rhs.dateKey }
    func hash(into hasher: inout Hasher) { hasher.combine(dateKey) }
}
