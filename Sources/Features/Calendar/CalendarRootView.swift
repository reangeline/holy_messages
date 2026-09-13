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
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: CalendarDestination.self) { destination in
                switch destination {
                case .day(let mark):
                    CalendarDayDetailView(mark: mark)
                case .journey:
                    JourneyListView()
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Eyebrow(text: MockLiturgical.today.seasonName)
                Text("Setembro")
                    .font(MissaleFont.display(28))
            }
            Spacer()
            NavigationLink(value: CalendarDestination.journey) {
                Text("A jornada ›")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.wine)
            }
        }
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
                legendSwatch(color: Palette.green, label: "Tempo Comum")
                legendSwatch(color: Palette.wine, label: "Festa, vermelho")
                legendSwatch(color: .white, bordered: true, label: "Branco")
            }
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2).fill(Palette.ink.opacity(0.45)).frame(width: 16, height: 3)
                Text("marca discreta = você registrou algo naquele dia")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.7))
            }
            Text("Sem mapa de calor e sem cores de bom e mau dia: a cor é da liturgia, a marca é sua.")
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
}

extension CalendarDayMark: Hashable {
    static func == (lhs: CalendarDayMark, rhs: CalendarDayMark) -> Bool { lhs.dateKey == rhs.dateKey }
    func hash(into hasher: inout Hasher) { hasher.combine(dateKey) }
}
