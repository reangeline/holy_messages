import SwiftUI

/// t4 screen 8 — monthly liturgical calendar grid. Hub screen (shows the floating tab bar).
struct CalendarRootView: View {
    private let weekdaySymbols = ["D", "S", "T", "Q", "Q", "S", "S"]
    @ObservedObject private var moodHistory = MoodHistoryStore.shared
    @State private var displayedYear = Calendar.gregorianUTC.component(.year, from: MockLiturgical.currentDate)
    @State private var displayedMonth = Calendar.gregorianUTC.component(.month, from: MockLiturgical.currentDate)

    private var days: [CalendarDayMark] { MockLiturgical.days(year: displayedYear, month: displayedMonth) }
    private var leadingEmptyDays: Int { MockLiturgical.leadingEmptyDays(year: displayedYear, month: displayedMonth) }
    private var isViewingCurrentMonth: Bool {
        displayedYear == Calendar.gregorianUTC.component(.year, from: MockLiturgical.currentDate)
            && displayedMonth == Calendar.gregorianUTC.component(.month, from: MockLiturgical.currentDate)
    }

    private func isToday(_ mark: CalendarDayMark) -> Bool { mark.dateKey == MockLiturgical.today.dateKey }

    private func changeMonth(by delta: Int) {
        var newMonth = displayedMonth + delta
        var newYear = displayedYear
        if newMonth < 1 { newMonth = 12; newYear -= 1 }
        if newMonth > 12 { newMonth = 1; newYear += 1 }
        displayedMonth = newMonth
        displayedYear = newYear
    }

    /// "consolation", "desolation", or nil (nothing logged). Only "today" can
    /// ever return non-nil: this calendar's other dates are a fixed/fictional
    /// range with no real per-day history, so they never show a registro mark
    /// that didn't actually happen — see spec §1.5.
    private func loggedGroup(for mark: CalendarDayMark) -> String? {
        guard mark.dateKey == MockLiturgical.today.dateKey, let latest = moodHistory.entries.last else { return nil }
        return MockMood.group(forStateID: latest.stateID)
    }

    private func markColor(for group: String) -> Color {
        group == "consolation" ? Palette.goldMuted : Palette.ink.opacity(0.45)
    }

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
                        // As aparições passaram para o Rezar, onde o leitor as
                        // procura: o que se faz com um santuário é rezar nele.
                        // Ver PrayersRootView.apparitionsSection.
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
                    Eyebrow(text: isViewingCurrentMonth ? MockLiturgical.today.seasonName : L.string("Ordinary Time", table: "CalendarSaints"))
                    Text("\(MockLiturgical.monthName(year: displayedYear, month: displayedMonth)) \(String(displayedYear))")
                        .font(MissaleFont.display(28))
                }
                Spacer()
                NavigationLink(value: CalendarDestination.journey) {
                    Text("The journey ›", tableName: "CalendarSaints")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.wine)
                }
            }
            HStack(spacing: 16) {
                Button { changeMonth(by: -1) } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial, in: Circle())
                }
                if !isViewingCurrentMonth {
                    Button {
                        displayedYear = 2026
                        displayedMonth = 9
                    } label: {
                        Text("Today", tableName: "CalendarSaints")
                            .font(MissaleFont.body(14, weight: .medium))
                            .foregroundStyle(Palette.wine)
                    }
                }
                Spacer()
                Button { changeMonth(by: 1) } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .foregroundStyle(Palette.ink)
            HStack(spacing: 10) {
                NavigationLink(value: CalendarDestination.week) {
                    zoomLink(title: MockLiturgical.currentWeek.name, subtitle: L.string("The week in 7 days", table: "CalendarSaints"))
                }
                .buttonStyle(.plain)
                NavigationLink(value: CalendarDestination.year) {
                    zoomLink(title: L.string("The liturgical year", table: "CalendarSaints"), subtitle: L.string("One strip, the whole year", table: "CalendarSaints"))
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
            ForEach(days) { mark in
                NavigationLink(value: CalendarDestination.day(mark)) {
                    dayCell(mark)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func dayCell(_ mark: CalendarDayMark) -> some View {
        let today = isToday(mark)
        return ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(mark.color == .white ? Color.white.opacity(0.85) : mark.color.accent.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(mark.color == .white ? Palette.ink.opacity(0.2) : .clear, lineWidth: 1)
                )
                // "Today" gets its own ring, independent of the liturgical color —
                // a red feast day and "today" being red are two different facts,
                // and this makes sure they don't get confused for one another. Gold
                // rather than wine specifically so it doesn't compete with a red
                // feast day's own fill color.
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(today ? Palette.goldBright : .clear, lineWidth: 2.5)
                )
            Text("\(mark.dayNumber)")
                .font(.system(size: 14, weight: today ? .bold : .regular))
                .foregroundStyle(mark.color == .white ? Palette.ink : Color.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 6)
            if let group = loggedGroup(for: mark) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(markColor(for: group))
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
            HStack(spacing: 14) {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2).fill(Palette.goldMuted).frame(width: 16, height: 3)
                    Text("Consolation", tableName: "CalendarSaints")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.7))
                }
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2).fill(Palette.ink.opacity(0.45)).frame(width: 16, height: 3)
                    Text("Desolation", tableName: "CalendarSaints")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.7))
                }
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
