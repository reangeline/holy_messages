import SwiftUI

/// Spec §4.1 — the liturgical week, Sunday to Saturday, named for its Sunday
/// rather than by civil date range. Seven columns make the week's rhythm visible
/// before any word is read (a wall of green with one red day in the middle, or
/// Holy Week's purple-purple-purple-white-red-and-the-emptiness-of-Holy-Saturday).
struct LiturgicalWeekView: View {
    let week: LiturgicalWeek
    @State private var selectedDayID: String

    init(week: LiturgicalWeek) {
        self.week = week
        _selectedDayID = State(initialValue: week.days.first { $0.dateKey == MockLiturgical.today.dateKey }?.id ?? week.days.first?.id ?? "")
    }

    private var selectedDay: LiturgicalWeekDay {
        week.days.first { $0.id == selectedDayID } ?? week.days[0]
    }

    var body: some View {
        ZStack {
            LiturgicalColor.green.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    weekStrip
                    dayDetail
                    gospelThread
                    if let note = week.whatChangesNote {
                        whatChanges(note)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(week.name).font(MissaleFont.body(15, weight: .medium))
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Eyebrow(text: week.name)
            Text(week.dateRangeLabel)
                .font(MissaleFont.display(26))
            HStack(spacing: 10) {
                Text(week.sundayCycle)
                Text("·").foregroundStyle(Palette.ink.opacity(0.4))
                Text(week.weekdayCycle)
            }
            .font(MissaleFont.body(14))
            .foregroundStyle(Palette.ink.opacity(0.6))
        }
    }

    private var weekStrip: some View {
        HStack(spacing: 6) {
            ForEach(week.days) { day in
                Button {
                    selectedDayID = day.id
                } label: {
                    dayColumn(day)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func dayColumn(_ day: LiturgicalWeekDay) -> some View {
        let isSelected = day.id == selectedDayID
        return VStack(spacing: 6) {
            Text(String(day.weekdayLabel.prefix(1)))
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Palette.ink.opacity(0.5))
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(day.color == .white ? Color.white.opacity(0.9) : day.color.accent.opacity(isSelected ? 0.95 : 0.55))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(isSelected ? Palette.wine : (day.color == .white ? Palette.ink.opacity(0.2) : .clear), lineWidth: isSelected ? 2 : 1)
                    )
                VStack(spacing: 2) {
                    Text("\(day.dayNumber)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(day.color == .white ? Palette.ink : .white)
                    if day.celebrationName != nil {
                        Circle().fill(day.color == .white ? Palette.ink.opacity(0.5) : .white.opacity(0.85)).frame(width: 4, height: 4)
                    }
                }
            }
            .frame(height: 52)
        }
        .frame(maxWidth: .infinity)
    }

    private var dayDetail: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle().fill(selectedDay.color.accent).frame(width: 9, height: 9)
                    Text("\(selectedDay.weekdayLabel), \(selectedDay.dayNumber)")
                        .font(MissaleFont.body(15, weight: .semibold))
                    Spacer()
                    Text(selectedDay.rank.displayName)
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                Text(selectedDay.celebrationName ?? "Feria do Tempo Comum")
                    .font(MissaleFont.display(21))
                    .foregroundStyle(Palette.ink)

                HStack(spacing: 14) {
                    if selectedDay.isHolyDayOfObligation {
                        tag(L.string("Holy day of obligation", table: "CalendarSaints"))
                    }
                    if selectedDay.isAbstinenceDay {
                        tag(L.string("Abstinence", table: "CalendarSaints"))
                    }
                    tag(L.string("Rosary · {mysteries}", table: "CalendarSaints").replacingOccurrences(of: "{mysteries}", with: selectedDay.mysterySet.displayName))
                }
            }
        }
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(MissaleFont.body(12, weight: .medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Palette.wine.opacity(0.1), in: Capsule())
            .foregroundStyle(Palette.wine)
    }

    private var gospelThread: some View {
        DashedUtilityCard {
            VStack(alignment: .leading, spacing: 6) {
                Eyebrow(text: L.string("The Gospel thread", table: "CalendarSaints"))
                Text(week.gospelThreadBody)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.82))
            }
        }
    }

    private func whatChanges(_ note: String) -> some View {
        LiturgicalGradientCard(color: .purple) {
            VStack(alignment: .leading, spacing: 6) {
                Eyebrow(text: L.string("What changes this week", table: "CalendarSaints"), color: Palette.goldBright)
                Text(note)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.92))
            }
        }
    }
}

#Preview {
    NavigationStack { LiturgicalWeekView(week: MockLiturgical.currentWeek) }
}
