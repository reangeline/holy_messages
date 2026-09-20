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

    static let todayCatalog = LocalizedCatalog(pt: ptToday, en: enToday, es: esToday)

    private static let ptToday = LiturgicalDay(
        dateKey: "2026-09-14",
        seasonName: "Tempo Comum · 23ª semana",
        feastName: "Exaltação da Santa Cruz",
        rank: .feast,
        color: .red,
        explanation: "Vermelho é a cor do sangue e do fogo: mártires, Pentecostes e a Cruz. Hoje a Igreja exalta a Cruz, então as vestes são vermelhas — e este app também."
    )

    // The celebration titles are the proper names used by each language's
    // Roman-calendar tradition. The explanatory sentences are separate
    // editorial copy, written for their own catalog rather than translated at
    // render time.
    private static let enToday = LiturgicalDay(
        dateKey: "2026-09-14",
        seasonName: "Ordinary Time · 23rd week",
        feastName: "Exaltation of the Holy Cross",
        rank: .feast,
        color: .red,
        explanation: "Red is the color of blood and fire: martyrs, Pentecost, and the Cross. Today the Church celebrates the Exaltation of the Holy Cross, so red is used in the liturgy."
    )

    private static let esToday = LiturgicalDay(
        dateKey: "2026-09-14",
        seasonName: "Tiempo Ordinario · semana 23",
        feastName: "Exaltación de la Santa Cruz",
        rank: .feast,
        color: .red,
        explanation: "El rojo es el color de la sangre y del fuego: mártires, Pentecostés y la Cruz. Hoy la Iglesia celebra la Exaltación de la Santa Cruz, por eso la liturgia usa el rojo."
    )

    static var tomorrow: LiturgicalDay { tomorrowCatalog.current }

    static let tomorrowCatalog = LocalizedCatalog(pt: ptTomorrow, en: enTomorrow, es: esTomorrow)

    private static let ptTomorrow = LiturgicalDay(
        dateKey: "2026-09-15",
        seasonName: "Tempo Comum · 23ª semana",
        feastName: "Nossa Senhora das Dores",
        rank: .memorial,
        color: .white,
        explanation: "Amanhã, Nossa Senhora das Dores, é memória — e a tela fica branca."
    )

    private static let enTomorrow = LiturgicalDay(
        dateKey: "2026-09-15",
        seasonName: "Ordinary Time · 23rd week",
        feastName: "Our Lady of Sorrows",
        rank: .memorial,
        color: .white,
        explanation: "Tomorrow is the Memorial of Our Lady of Sorrows, celebrated with white vestments."
    )

    private static let esTomorrow = LiturgicalDay(
        dateKey: "2026-09-15",
        seasonName: "Tiempo Ordinario · semana 23",
        feastName: "Nuestra Señora de los Dolores",
        rank: .memorial,
        color: .white,
        explanation: "Mañana se celebra la memoria de Nuestra Señora de los Dolores con vestiduras blancas."
    )

    static var ranksExplainer: String { ranksExplainerCatalog.current }

    static let ranksExplainerCatalog = LocalizedCatalog(
        pt: ptRanksExplainer,
        en: "Memorial, feast, solemnity. Today is a feast: the Gloria is sung, but not the Creed. Tomorrow, Our Lady of Sorrows is a memorial, so the screen is white.",
        es: "Memoria, fiesta, solemnidad. Hoy es fiesta: se canta el Gloria, pero no el Credo. Mañana, Nuestra Señora de los Dolores es memoria, por eso la pantalla es blanca."
    )

    private static let ptRanksExplainer = "Memória, festa, solenidade. Hoje é festa: entra o Glória, não entra o Credo. Amanhã, Nossa Senhora das Dores, é memória — e a tela fica branca."

    static let colorGuide: [LiturgicalColorInfo] = [
        .init(color: .red), .init(color: .white), .init(color: .green), .init(color: .purple), .init(color: .rose),
    ]

    static var glossaryTerms: [GlossaryTerm] { glossaryCatalog.current }

    static let glossaryCatalog = LocalizedCatalog(
        pt: ptGlossaryTerms,
        en: enGlossaryTerms,
        es: esGlossaryTerms
    )

    private static let ptGlossaryTerms: [GlossaryTerm] = [
        .init(term: "mea culpa", definition: "\"Por minha culpa\": expressão latina do Ato Penitencial, dita enquanto se bate no peito."),
        .init(term: "Kyrie", definition: "\"Senhor, tende piedade\": invocação grega mantida na liturgia latina, logo após o Ato Penitencial."),
        .init(term: "lecionário", definition: "O livro litúrgico com as leituras da Missa organizadas por dia e ciclo."),
        .init(term: "Completas", definition: "A última oração do dia no Ofício Divino, antes do repouso noturno."),
    ]

    private static let enGlossaryTerms: [GlossaryTerm] = [
        .init(term: "mea culpa", definition: "‘Through my fault’: the Latin expression in the Penitential Act, said while striking the breast."),
        .init(term: "Kyrie", definition: "‘Lord, have mercy’: a Greek invocation preserved in the Roman liturgy after the Penitential Act."),
        .init(term: "lectionary", definition: "The liturgical book that orders the readings for Mass by day and cycle."),
        .init(term: "Compline", definition: "The final prayer of the day in the Liturgy of the Hours, before night rest."),
    ]

    private static let esGlossaryTerms: [GlossaryTerm] = [
        .init(term: "mea culpa", definition: "‘Por mi culpa’: expresión latina del acto penitencial, dicha mientras se golpea el pecho."),
        .init(term: "Kyrie", definition: "‘Señor, ten piedad’: invocación griega conservada en la liturgia romana después del acto penitencial."),
        .init(term: "leccionario", definition: "El libro litúrgico que organiza las lecturas de la Misa según el día y el ciclo."),
        .init(term: "Completas", definition: "La última oración del día en la Liturgia de las Horas, antes del descanso nocturno."),
    ]

    static var seasons: [LiturgicalSeason] { seasonsCatalog.current }

    static let seasonsCatalog = LocalizedCatalog(pt: ptSeasons, en: enSeasons, es: esSeasons)

    private static let ptSeasons: [LiturgicalSeason] = [
        .init(id: "advent", name: "Advento", dateRange: "29 nov a 24 dez", color: .purple, summaryLine: "Quatro semanas de espera, preparando o Natal do Senhor."),
        .init(id: "lent", name: "Quaresma", dateRange: "18 fev a 2 abr", color: .purple, summaryLine: "Quarenta dias de jejum, oração e esmola, rumo à Páscoa."),
        .init(id: "easter", name: "Tempo Pascal", dateRange: "5 abr a 24 mai", color: .white, summaryLine: "Cinquenta dias de alegria pela Ressurreição."),
        .init(id: "ordinary", name: "Tempo Comum", dateRange: "12 jan a 17 fev · 25 mai a 28 nov", color: .green, summaryLine: "A vida ordinária da Igreja, semana após semana."),
    ]

    private static let enSeasons: [LiturgicalSeason] = [
        .init(id: "advent", name: "Advent", dateRange: "29 Nov – 24 Dec", color: .purple, summaryLine: "Four weeks of waiting, preparing for the Lord’s Nativity."),
        .init(id: "lent", name: "Lent", dateRange: "18 Feb – 2 Apr", color: .purple, summaryLine: "Forty days of fasting, prayer, and almsgiving on the way to Easter."),
        .init(id: "easter", name: "Easter Time", dateRange: "5 Apr – 24 May", color: .white, summaryLine: "Fifty days of joy in the Resurrection."),
        .init(id: "ordinary", name: "Ordinary Time", dateRange: "12 Jan – 17 Feb · 25 May – 28 Nov", color: .green, summaryLine: "The ordinary life of the Church, week after week."),
    ]

    private static let esSeasons: [LiturgicalSeason] = [
        .init(id: "advent", name: "Adviento", dateRange: "29 nov – 24 dic", color: .purple, summaryLine: "Cuatro semanas de espera, preparando la Navidad del Señor."),
        .init(id: "lent", name: "Cuaresma", dateRange: "18 feb – 2 abr", color: .purple, summaryLine: "Cuarenta días de ayuno, oración y limosna en camino hacia Pascua."),
        .init(id: "easter", name: "Tiempo Pascual", dateRange: "5 abr – 24 may", color: .white, summaryLine: "Cincuenta días de alegría por la Resurrección."),
        .init(id: "ordinary", name: "Tiempo Ordinario", dateRange: "12 ene – 17 feb · 25 may – 28 nov", color: .green, summaryLine: "La vida ordinaria de la Iglesia, semana tras semana."),
    ]

    static var lentRetrospective: SeasonRetrospective { lentRetrospectiveCatalog.current }

    static let lentRetrospectiveCatalog = LocalizedCatalog(
        pt: ptLentRetrospective,
        en: enLentRetrospective,
        es: esLentRetrospective
    )

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
            "Duas confissões: 12 e 30 de março",
            "A trilha da Missa chegou à Liturgia Eucarística",
        ],
        milestoneTitle: "Marcos",
        milestoneBody: "Você voltou a rezar em março, depois de três semanas sem registro. Na Semana Santa, registrou paz pela primeira vez no ano.",
        closingLine: "Sua Páscoa começa em 5 de abril e ainda está sendo escrita."
    )

    private static let enLentRetrospective = SeasonRetrospective(
        seasonID: "lent",
        seasonLabel: "Lent · 18 Feb – 2 Apr",
        color: .purple,
        title: "Your Lent",
        narrative: "You went through the forty days in dryness and stayed with them to the end.",
        accompaniments: [
            "40 consecutive days of the Rosary, from the first to the last",
            "Psalms 62, 129, and 41 returned more than once",
            "St Teresa of Calcutta and St John of the Cross appeared seven times",
            "Two confessions: 12 and 30 March",
            "The Mass track reached the Liturgy of the Eucharist",
        ],
        milestoneTitle: "Milestones",
        milestoneBody: "You returned to prayer in March after three weeks without a record. During Holy Week, you recorded peace for the first time that year.",
        closingLine: "Easter begins on 5 April and is still being written."
    )

    private static let esLentRetrospective = SeasonRetrospective(
        seasonID: "lent",
        seasonLabel: "Cuaresma · 18 feb – 2 abr",
        color: .purple,
        title: "Tu Cuaresma",
        narrative: "Atravesaste los cuarenta días en aridez y los llevaste hasta el final.",
        accompaniments: [
            "40 días seguidos de Rosario, del primero al último",
            "Los Salmos 62, 129 y 41 volvieron más de una vez",
            "Santa Teresa de Calcuta y san Juan de la Cruz aparecieron siete veces",
            "Dos confesiones: 12 y 30 de marzo",
            "La formación sobre la Misa llegó a la Liturgia Eucarística",
        ],
        milestoneTitle: "Hitos",
        milestoneBody: "Volviste a la oración en marzo, después de tres semanas sin registro. En Semana Santa registraste paz por primera vez ese año.",
        closingLine: "La Pascua comienza el 5 de abril y todavía se está escribiendo."
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

    static let currentWeekCatalog = LocalizedCatalog(pt: ptCurrentWeek, en: enCurrentWeek, es: esCurrentWeek)

    private static let ptCurrentWeek = LiturgicalWeek(
        id: "2026-w23-ordinary",
        name: "24ª Semana do Tempo Comum",
        sundayCycle: "Domingo · Ciclo A",
        weekdayCycle: "Semana · Ano II",
        gospelThreadBody: "Depois das celebrações da Cruz e de Nossa Senhora das Dores, a leitura ferial retoma Lucas 7–8: Jesus na casa do fariseu, as mulheres que o acompanhavam e a parábola do semeador.",
        whatChangesNote: nil,
        days: [
            LiturgicalWeekDay(dateKey: "2026-09-13", dayNumber: 13, color: .green, rank: .feast, celebrationName: "24º Domingo do Tempo Comum", isHolyDayOfObligation: true, isAbstinenceDay: false, mysterySet: .forWeekday(1)),
            LiturgicalWeekDay(dateKey: "2026-09-14", dayNumber: 14, color: .red, rank: .feast, celebrationName: "Exaltação da Santa Cruz", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(2)),
            LiturgicalWeekDay(dateKey: "2026-09-15", dayNumber: 15, color: .white, rank: .memorial, celebrationName: "Nossa Senhora das Dores", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(3)),
            LiturgicalWeekDay(dateKey: "2026-09-16", dayNumber: 16, color: .red, rank: .memorial, celebrationName: "Santos Cornélio e Cipriano", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(4)),
            LiturgicalWeekDay(dateKey: "2026-09-17", dayNumber: 17, color: .green, rank: .optionalMemorial, celebrationName: "São Roberto Belarmino", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(5)),
            LiturgicalWeekDay(dateKey: "2026-09-18", dayNumber: 18, color: .green, rank: .weekday, celebrationName: nil, isHolyDayOfObligation: false, isAbstinenceDay: true, mysterySet: .forWeekday(6)),
            LiturgicalWeekDay(dateKey: "2026-09-19", dayNumber: 19, color: .green, rank: .weekday, celebrationName: nil, isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(7)),
        ]
    )

    private static let enCurrentWeek = LiturgicalWeek(
        id: "2026-w24-ordinary",
        name: "24th Week in Ordinary Time",
        sundayCycle: "Sunday · Cycle A",
        weekdayCycle: "Weekdays · Year II",
        gospelThreadBody: "After the celebrations of the Cross and Our Lady of Sorrows, the weekday Gospel resumes in Luke 7–8: Jesus at the Pharisee’s house, the women who accompanied him, and the parable of the sower.",
        whatChangesNote: nil,
        days: [
            LiturgicalWeekDay(dateKey: "2026-09-13", dayNumber: 13, color: .green, rank: .feast, celebrationName: "24th Sunday in Ordinary Time", isHolyDayOfObligation: true, isAbstinenceDay: false, mysterySet: .forWeekday(1)),
            LiturgicalWeekDay(dateKey: "2026-09-14", dayNumber: 14, color: .red, rank: .feast, celebrationName: "Exaltation of the Holy Cross", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(2)),
            LiturgicalWeekDay(dateKey: "2026-09-15", dayNumber: 15, color: .white, rank: .memorial, celebrationName: "Our Lady of Sorrows", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(3)),
            LiturgicalWeekDay(dateKey: "2026-09-16", dayNumber: 16, color: .red, rank: .memorial, celebrationName: "Saints Cornelius and Cyprian", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(4)),
            LiturgicalWeekDay(dateKey: "2026-09-17", dayNumber: 17, color: .green, rank: .optionalMemorial, celebrationName: "Saint Robert Bellarmine", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(5)),
            LiturgicalWeekDay(dateKey: "2026-09-18", dayNumber: 18, color: .green, rank: .weekday, celebrationName: nil, isHolyDayOfObligation: false, isAbstinenceDay: true, mysterySet: .forWeekday(6)),
            LiturgicalWeekDay(dateKey: "2026-09-19", dayNumber: 19, color: .green, rank: .optionalMemorial, celebrationName: "Saint Januarius", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(7)),
        ]
    )

    private static let esCurrentWeek = LiturgicalWeek(
        id: "2026-w24-ordinary",
        name: "24.ª semana del Tiempo Ordinario",
        sundayCycle: "Domingo · Ciclo A",
        weekdayCycle: "Ferial · Año II",
        gospelThreadBody: "Después de las celebraciones de la Cruz y de Nuestra Señora de los Dolores, el Evangelio ferial retoma Lucas 7–8: Jesús en casa del fariseo, las mujeres que lo acompañaban y la parábola del sembrador.",
        whatChangesNote: nil,
        days: [
            LiturgicalWeekDay(dateKey: "2026-09-13", dayNumber: 13, color: .green, rank: .feast, celebrationName: "24.º Domingo del Tiempo Ordinario", isHolyDayOfObligation: true, isAbstinenceDay: false, mysterySet: .forWeekday(1)),
            LiturgicalWeekDay(dateKey: "2026-09-14", dayNumber: 14, color: .red, rank: .feast, celebrationName: "Exaltación de la Santa Cruz", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(2)),
            LiturgicalWeekDay(dateKey: "2026-09-15", dayNumber: 15, color: .white, rank: .memorial, celebrationName: "Nuestra Señora de los Dolores", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(3)),
            LiturgicalWeekDay(dateKey: "2026-09-16", dayNumber: 16, color: .red, rank: .memorial, celebrationName: "Santos Cornelio y Cipriano", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(4)),
            LiturgicalWeekDay(dateKey: "2026-09-17", dayNumber: 17, color: .green, rank: .optionalMemorial, celebrationName: "San Roberto Belarmino", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(5)),
            LiturgicalWeekDay(dateKey: "2026-09-18", dayNumber: 18, color: .green, rank: .weekday, celebrationName: nil, isHolyDayOfObligation: false, isAbstinenceDay: true, mysterySet: .forWeekday(6)),
            LiturgicalWeekDay(dateKey: "2026-09-19", dayNumber: 19, color: .green, rank: .optionalMemorial, celebrationName: "San Jenaro", isHolyDayOfObligation: false, isAbstinenceDay: false, mysterySet: .forWeekday(7)),
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
