import Foundation

extension Calendar {
    /// A fixed UTC gregorian calendar for pure year/month/day arithmetic
    /// (month length, starting weekday) — avoids the device's own time zone
    /// shifting a computed date across a day boundary.
    static let gregorianUTC: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}

/// Which Marian antiphon is prayed at the Angelus hours: Regina Caeli replaces the
/// Angelus for the whole of Eastertide (Easter Sunday through Pentecost).
enum MarianAntiphonPeriod {
    case angelus
    case reginaCaeli
}

extension MockLiturgical {
    /// Stub: this pass has no real Easter-date computation (movable feasts aren't
    /// modeled), so this always returns `.angelus`. Structured to take a `Date` so a
    /// real liturgical calendar engine can replace the body later without touching
    /// call sites (notably AngelusScheduler, which calls this once per scheduled day).
    static func marianAntiphonPeriod(on date: Date) -> MarianAntiphonPeriod {
        .angelus
    }
}

enum MockLiturgical {
    /// The app's fixed "today" for this mocked-data pass, matching the design's demo day.
    /// One catalog per language — see LocalizedCatalog.
    static var today: LiturgicalDay { todayCatalog.current }

    static let todayCatalog = LocalizedCatalog(pt: ptToday)

    private static let ptToday = LiturgicalDay(
        dateKey: "2026-09-14",
        seasonName: "Tempo Comum · 23ª semana",
        feastName: "Exaltação da Santa Cruz",
        rank: .feast,
        color: .red,
        explanation: "Vermelho é a cor do sangue e do fogo: mártires, Pentecostes e a Cruz. Hoje a Igreja exalta a Cruz, então as vestes são vermelhas — e este app também."
    )

    static var tomorrow: LiturgicalDay { tomorrowCatalog.current }

    static let tomorrowCatalog = LocalizedCatalog(pt: ptTomorrow)

    private static let ptTomorrow = LiturgicalDay(
        dateKey: "2026-09-15",
        seasonName: "Tempo Comum · 23ª semana",
        feastName: "Nossa Senhora das Dores",
        rank: .memorial,
        color: .white,
        explanation: "Amanhã, Nossa Senhora das Dores, é memória — e a tela fica branca."
    )

    static var ranksExplainer: String { ranksExplainerCatalog.current }

    static let ranksExplainerCatalog = LocalizedCatalog(pt: ptRanksExplainer)

    private static let ptRanksExplainer = "Memória, festa, solenidade. Hoje é festa: entra o Glória, não entra o Credo. Amanhã, Nossa Senhora das Dores, é memória — e a tela fica branca."

    static let colorGuide: [LiturgicalColorInfo] = [
        .init(color: .red), .init(color: .white), .init(color: .green), .init(color: .purple), .init(color: .rose),
    ]

    static var glossaryTerms: [GlossaryTerm] { glossaryCatalog.current }

    static let glossaryCatalog = LocalizedCatalog(pt: ptGlossaryTerms)

    private static let ptGlossaryTerms: [GlossaryTerm] = [
        .init(term: "mea culpa", definition: "\"Por minha culpa\": expressão latina do Ato Penitencial, dita enquanto se bate no peito."),
        .init(term: "Kyrie", definition: "\"Senhor, tende piedade\": invocação grega mantida na liturgia latina, logo após o Ato Penitencial."),
        .init(term: "lecionário", definition: "O livro litúrgico com as leituras da Missa organizadas por dia e ciclo."),
        .init(term: "Completas", definition: "A última oração do dia no Ofício Divino, antes do repouso noturno."),
    ]

    static var seasons: [LiturgicalSeason] { seasonsCatalog.current }

    static let seasonsCatalog = LocalizedCatalog(pt: ptSeasons)

    private static let ptSeasons: [LiturgicalSeason] = [
        .init(id: "advent", name: "Advento", dateRange: "29 nov a 24 dez", color: .purple, summaryLine: "Quatro semanas de espera, preparando o Natal do Senhor."),
        .init(id: "lent", name: "Quaresma", dateRange: "5 mar a 17 abr", color: .purple, summaryLine: "Quarenta dias de jejum, oração e esmola, rumo à Páscoa."),
        .init(id: "easter", name: "Tempo Pascal", dateRange: "18 abr a 6 jun", color: .white, summaryLine: "Cinquenta dias de alegria pela Ressurreição."),
        .init(id: "ordinary", name: "Tempo Comum", dateRange: "8 jun a 28 nov", color: .green, summaryLine: "A vida ordinária da Igreja, semana após semana."),
    ]

    static var lentRetrospective: SeasonRetrospective { lentRetrospectiveCatalog.current }

    static let lentRetrospectiveCatalog = LocalizedCatalog(pt: ptLentRetrospective)

    private static let ptLentRetrospective = SeasonRetrospective(
        seasonID: "lent",
        seasonLabel: "Quaresma · 5 mar a 17 abr",
        color: .purple,
        title: "Sua Quaresma",
        narrative: "Você atravessou os quarenta dias em aridez, e foi até o fim deles.",
        accompaniments: [
            "40 dias seguidos de Terço, do primeiro ao último",
            "Os Salmos 62, 129 e 41 voltaram mais de uma vez",
            "Santa Teresa de Calcutá e São João da Cruz apareceram sete vezes",
            "Duas confissões: 12 de março e 9 de abril",
            "A trilha da Missa chegou à Liturgia Eucarística",
        ],
        milestoneTitle: "Marcos",
        milestoneBody: "Você voltou a rezar em março, depois de três semanas sem registro. Na Semana Santa, registrou paz pela primeira vez no ano.",
        closingLine: "Sua Páscoa começa em 18 de abril e ainda está sendo escrita."
    )

    /// "Today" and "tomorrow" keep their fuller hand-authored content (it's
    /// what the rest of the app's fixed demo day depends on); every other date
    /// now falls through to LiturgicalEngine instead of showing nothing.
    static func dayFeastInfo(for dateKey: String) -> (feastName: String, note: String?)? {
        switch dateKey {
        case today.dateKey: return (today.feastName, today.explanation)
        case tomorrow.dateKey: return (tomorrow.feastName, tomorrow.explanation)
        default:
            guard let date = date(fromKey: dateKey) else { return nil }
            let computed = LiturgicalEngine.day(for: date)
            return (computed.feastName, computed.explanation)
        }
    }

    /// The week containing "today" (Sun Sept 13 – Sat Sept 19, 2026), named for its
    /// Sunday per the liturgical convention — see LiturgicalWeek. Demo data: no real
    /// lectionary/cycle computation exists yet, so the Sunday/weekday cycle labels
    /// and the Gospel range are illustrative, not computed.
    static var currentWeek: LiturgicalWeek { currentWeekCatalog.current }

    static let currentWeekCatalog = LocalizedCatalog(pt: ptCurrentWeek)

    private static let ptCurrentWeek = LiturgicalWeek(
        id: "2026-w23-ordinary",
        name: "23ª Semana do Tempo Comum",
        sundayCycle: "Domingo · Ciclo B",
        weekdayCycle: "Semana · Ano II",
        gospelThreadBody: "De segunda a sábado, a Igreja lê Lucas 7 a 9 em sequência — a fé do centurião, a viúva de Naim, e Jesus perguntando aos discípulos quem dizem que ele é.",
        whatChangesNote: nil,
        days: [
            LiturgicalWeekDay(dateKey: "2026-09-13", dayNumber: 13, color: .green, rank: .feast, celebrationName: "23º Domingo do Tempo Comum", isHolyDayOfObligation: true, isAbstinenceDay: false, mysterySet: .forWeekday(1)),
            LiturgicalWeekDay(dateKey: "2026-09-14", dayNumber: 14, color: .red, rank: .feast, celebrationName: "Exaltação da Santa Cruz", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(2)),
            LiturgicalWeekDay(dateKey: "2026-09-15", dayNumber: 15, color: .white, rank: .memorial, celebrationName: "Nossa Senhora das Dores", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(3)),
            LiturgicalWeekDay(dateKey: "2026-09-16", dayNumber: 16, color: .green, rank: .optionalMemorial, celebrationName: "Santos Cornélio e Cipriano", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(4)),
            LiturgicalWeekDay(dateKey: "2026-09-17", dayNumber: 17, color: .green, rank: .optionalMemorial, celebrationName: "São Roberto Belarmino", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(5)),
            LiturgicalWeekDay(dateKey: "2026-09-18", dayNumber: 18, color: .green, rank: .weekday, celebrationName: nil, isHolyDayOfObligation: false, isAbstinenceDay: true, mysterySet: .forWeekday(6)),
            LiturgicalWeekDay(dateKey: "2026-09-19", dayNumber: 19, color: .green, rank: .weekday, celebrationName: nil, isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(7)),
        ]
    )

    /// A month grid for September 2026 (30 days): white on the 8th and 15th,
    /// red on the 14th ("today"), plain Ordinary Time green otherwise. No day
    /// carries a pre-baked "logged" flag — whether a day shows a registro mark
    /// is computed live from real Exame history at render time (only "today"
    /// can ever have one, since the rest of this calendar is a fixed/fictional
    /// date range) — see CalendarRootView.loggedGroup(for:).
    static let septemberDays: [CalendarDayMark] = (1...30).map { day in
        let color: LiturgicalColor = switch day {
        case 8, 15: .white
        case 14: .red
        default: .green
        }
        return CalendarDayMark(dateKey: String(format: "2026-09-%02d", day), dayNumber: day, color: color)
    }

    /// September 2026 keeps its hand-curated colors (today/tomorrow's fuller
    /// authored content depends on matching them exactly). Every other month
    /// is now real, not a green placeholder: LiturgicalEngine computes the
    /// actual color for each of its real days — see LiturgicalEngine.swift.
    static func days(year: Int, month: Int) -> [CalendarDayMark] {
        if year == 2026, month == 9 { return septemberDays }
        let cal = Calendar.gregorianUTC
        let first = firstOfMonth(year: year, month: month)
        guard let range = cal.range(of: .day, in: .month, for: first) else { return [] }
        return range.map { day in
            let date = cal.date(byAdding: .day, value: day - 1, to: first) ?? first
            let computed = LiturgicalEngine.day(for: date)
            return CalendarDayMark(dateKey: computed.dateKey, dayNumber: day, color: computed.color)
        }
    }

    static func date(fromKey dateKey: String) -> Date? {
        let parts = dateKey.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        return Calendar.gregorianUTC.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2]))
    }

    /// How many blank leading cells a Sunday-first week grid needs before day 1.
    static func leadingEmptyDays(year: Int, month: Int) -> Int {
        Calendar.gregorianUTC.component(.weekday, from: firstOfMonth(year: year, month: month)) - 1
    }

    /// Localized month name via Foundation's own locale data — genuinely correct
    /// in en/pt/es without hand-maintaining 12×3 translations.
    static func monthName(year: Int, month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = AppLanguagePreference.resolveCurrent().locale
        return formatter.monthSymbols[month - 1].localizedCapitalized
    }

    private static func firstOfMonth(year: Int, month: Int) -> Date {
        Calendar.gregorianUTC.date(from: DateComponents(year: year, month: month, day: 1)) ?? Date()
    }
}
