import Foundation

/// One day within a liturgical week — see LiturgicalWeek.
struct LiturgicalWeekDay: Identifiable, Codable, Hashable {
    var id: String { dateKey }
    let dateKey: String // "yyyy-MM-dd"
    let dayNumber: Int
    let color: LiturgicalColor
    let rank: LiturgicalRank
    let celebrationName: String? // saint/feast name; nil on a plain weekday
    let isHolyDayOfObligation: Bool
    let isAbstinenceDay: Bool
    let mysterySet: MysterySet

    /// Derived from dateKey — see DateKeyLabel.
    var weekdayLabel: String { DateKeyLabel.weekday(fromKey: dateKey) }
}

/// A liturgical week runs Sunday to Saturday and takes its name and identity from
/// that Sunday — "3ª Semana do Advento", not "15 a 21 de dezembro". Weekday
/// readings are semicontinuous (the same book, in sequence, Monday to Saturday),
/// which is what `gospelThreadBody` surfaces. See product spec §4.1.
struct LiturgicalWeek: Identifiable, Codable, Hashable {
    let id: String
    let name: String // "23ª Semana do Tempo Comum"
    let sundayCycle: String // "Domingo · Ciclo B"
    let weekdayCycle: String // "Semana II do saltério"
    let gospelThreadBody: String // "Lucas 9 a 11, em sequência"
    let whatChangesNote: String?
    let days: [LiturgicalWeekDay]

    /// Derived from the week's own first and last day — see DateKeyLabel.
    var dateRangeLabel: String {
        guard let first = days.first?.dateKey, let last = days.last?.dateKey else { return "" }
        return DateKeyLabel.dayMonthRange(fromKey: first, toKey: last)
    }
}

extension MysterySet {
    /// The traditional weekly rotation (Joyful/Sorrowful/Glorious/Luminous schema
    /// in force since 2002). Doesn't yet account for the Lent/Advent-Christmas
    /// exceptions some calendars apply to Sunday — a fixed Sunday = Glorious for now.
    static func forWeekday(_ weekdayIndex: Int) -> MysterySet {
        // weekdayIndex: 1 = Sunday ... 7 = Saturday (Calendar.component(.weekday)).
        switch weekdayIndex {
        case 1: .glorious
        case 2: .joyful
        case 3: .sorrowful
        case 4: .glorious
        case 5: .luminous
        case 6: .sorrowful
        default: .joyful // 7 = Saturday
        }
    }
}
