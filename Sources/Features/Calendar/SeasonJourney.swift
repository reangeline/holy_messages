import Foundation

/// The four seasons of the current liturgical year, with their real dates, and
/// a retrospective built only from what the reader actually logged in each.
///
/// The Journey used to list fixed date ranges and open a single hand-written
/// Lent — "40 consecutive days of the Rosary", "two confessions on 12 and 30
/// March" — for everyone, whether or not they had opened the app in Lent. Every
/// season that has begun now opens, and says only what the local history says.
@MainActor
enum SeasonJourney {
    enum Status { case past, current, upcoming }

    struct Entry: Identifiable {
        let season: LiturgicalSeason
        /// One interval for most seasons, two for Ordinary Time.
        let intervals: [ClosedRange<Date>]
        let status: Status
        var id: String { season.id }
        var start: Date { intervals[0].lowerBound }
        var end: Date { intervals[intervals.count - 1].upperBound }
    }

    /// Advent through Christ the King of the liturgical year in force today.
    static func currentYear(today: Date = .now) -> [Entry] {
        let hoje = utcDay(today)
        let civil = Calendar.gregorianUTC.component(.year, from: hoje)
        // O ano litúrgico começa no Advento: antes dele, ainda é o ano que
        // começou no Advento do ano civil anterior.
        let anoPrincipal = hoje >= LiturgicalEngine.movableFeasts(year: civil).adventStart ? civil + 1 : civil
        let anterior = LiturgicalEngine.movableFeasts(year: anoPrincipal - 1)
        let festas = LiturgicalEngine.movableFeasts(year: anoPrincipal)
        let natal = day(anoPrincipal - 1, 12, 25)

        let intervalos: [String: [ClosedRange<Date>]] = [
            "advent": [anterior.adventStart ... add(natal, -1)],
            "lent": [festas.ashWednesday ... festas.holyThursday],
            "easter": [festas.easter ... festas.pentecost],
            "ordinary": [add(festas.baptismOfTheLord, 1) ... add(festas.ashWednesday, -1),
                         add(festas.pentecost, 1) ... add(festas.adventStart, -1)],
        ]

        return MockLiturgical.seasons.compactMap { season in
            guard let faixas = intervalos[season.id] else { return nil }
            let status: Status
            if faixas.contains(where: { $0.contains(hoje) }) {
                status = .current
            } else if faixas[0].lowerBound > hoje {
                status = .upcoming
            } else {
                status = .past
            }
            let comDatas = LiturgicalSeason(id: season.id, name: season.name,
                                            dateRange: faixas.map(rangeLabel).joined(separator: " · "),
                                            color: season.color, summaryLine: season.summaryLine)
            return Entry(season: comDatas, intervals: faixas, status: status)
        }
    }

    /// What the reader logged while this season ran, up to today.
    static func retrospective(for entry: Entry, today: Date = .now) -> SeasonRetrospective {
        let hoje = utcDay(today)
        func dentro(_ data: Date) -> Bool {
            let dia = utcDay(data)
            return dia <= hoje && entry.intervals.contains { $0.contains(dia) }
        }

        let tercos = RosaryHistoryStore.shared.list.items.filter { dentro($0.date) }
        let exames = ExamenHistoryStore.shared.list.items.filter { dentro($0.date) }
        let humores = MoodHistoryStore.shared.entries.filter { dentro($0.date) }
        let dias = Set((tercos.map(\.date) + exames.map(\.date) + humores.map(\.date)).map(utcDay)).count

        var linhas: [String] = []
        if !tercos.isEmpty { linhas.append(count("{n} Rosaries prayed", tercos.count)) }
        if !exames.isEmpty { linhas.append(count("{n} Examens of the day", exames.count)) }
        if !humores.isEmpty { linhas.append(count("{n} check-ins of how you were", humores.count)) }
        let porEstado = Dictionary(grouping: humores, by: \.stateID)
        if let maisFrequente = porEstado.values.max(by: { $0.count < $1.count }),
           maisFrequente.count > 1, let rotulo = maisFrequente.last?.stateLabel {
            linhas.append(L.string("Most logged: {state}", table: "CalendarSaints")
                .replacingOccurrences(of: "{state}", with: rotulo))
        }

        let narrativa = dias == 0
            ? L.string("Nothing was logged in this season. It passed all the same — the liturgical year doesn't wait for a record.", table: "CalendarSaints")
            : count("{n} days with something logged in this season.", dias)

        let fecho: String
        switch entry.status {
        case .current:
            fecho = L.string("This season is still under way, until {date}.", table: "CalendarSaints")
                .replacingOccurrences(of: "{date}", with: dayLabel(entry.end))
        case .past, .upcoming:
            fecho = L.string("Counted only from what you logged on this device.", table: "CalendarSaints")
        }

        return SeasonRetrospective(
            seasonID: entry.season.id,
            seasonLabel: "\(entry.season.name) · \(entry.season.dateRange)",
            color: entry.season.color,
            title: entry.season.name,
            narrative: narrativa,
            accompaniments: linhas,
            milestoneTitle: "",
            milestoneBody: "",
            closingLine: fecho
        )
    }

    // MARK: - Datas

    private static func count(_ key: String, _ n: Int) -> String {
        L.string(key, table: "CalendarSaints").replacingOccurrences(of: "{n}", with: "\(n)")
    }

    /// The reader's civil day, as the UTC midnight the engine works in.
    static func utcDay(_ date: Date) -> Date {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return day(c.year!, c.month!, c.day!)
    }

    private static func day(_ y: Int, _ m: Int, _ d: Int) -> Date {
        Calendar.gregorianUTC.date(from: DateComponents(year: y, month: m, day: d))!
    }

    private static func add(_ date: Date, _ days: Int) -> Date {
        Calendar.gregorianUTC.date(byAdding: .day, value: days, to: date)!
    }

    private static func dayLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.gregorianUTC
        f.timeZone = TimeZone(identifier: "UTC")
        f.locale = AppLanguagePreference.resolveCurrent().locale
        f.setLocalizedDateFormatFromTemplate("dMMM")
        return f.string(from: date)
    }

    private static func rangeLabel(_ range: ClosedRange<Date>) -> String {
        "\(dayLabel(range.lowerBound)) – \(dayLabel(range.upperBound))"
    }
}
