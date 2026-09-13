import Foundation

enum MockLiturgical {
    /// The app's fixed "today" for this mocked-data pass, matching the design's demo day.
    static let today = LiturgicalDay(
        dateKey: "2026-09-14",
        weekdayLabel: "Segunda-feira",
        dayMonthLabel: "14 de setembro",
        seasonName: "Tempo Comum · 23ª semana",
        feastName: "Exaltação da Santa Cruz",
        rank: .feast,
        color: .red,
        explanation: "Vermelho é a cor do sangue e do fogo: mártires, Pentecostes e a Cruz. Hoje a Igreja exalta a Cruz, então as vestes são vermelhas — e este app também."
    )

    static let tomorrow = LiturgicalDay(
        dateKey: "2026-09-15",
        weekdayLabel: "Terça-feira",
        dayMonthLabel: "15 de setembro",
        seasonName: "Tempo Comum · 23ª semana",
        feastName: "Nossa Senhora das Dores",
        rank: .memorial,
        color: .white,
        explanation: "Amanhã, Nossa Senhora das Dores, é memória — e a tela fica branca."
    )

    static let ranksExplainer = "Memória, festa, solenidade. Hoje é festa: entra o Glória, não entra o Credo. Amanhã, Nossa Senhora das Dores, é memória — e a tela fica branca."

    static let colorGuide: [LiturgicalColorInfo] = [
        .init(color: .red), .init(color: .white), .init(color: .green), .init(color: .purple), .init(color: .rose),
    ]

    static let glossaryTerms: [GlossaryTerm] = [
        .init(term: "mea culpa", definition: "\"Por minha culpa\": expressão latina do Ato Penitencial, dita enquanto se bate no peito."),
        .init(term: "Kyrie", definition: "\"Senhor, tende piedade\": invocação grega mantida na liturgia latina, logo após o Ato Penitencial."),
        .init(term: "lecionário", definition: "O livro litúrgico com as leituras da Missa organizadas por dia e ciclo."),
        .init(term: "Completas", definition: "A última oração do dia no Ofício Divino, antes do repouso noturno."),
    ]

    static let seasons: [LiturgicalSeason] = [
        .init(id: "advent", name: "Advento", dateRange: "29 nov a 24 dez", color: .purple, summaryLine: "Quatro semanas de espera, preparando o Natal do Senhor."),
        .init(id: "lent", name: "Quaresma", dateRange: "5 mar a 17 abr", color: .purple, summaryLine: "Quarenta dias de jejum, oração e esmola, rumo à Páscoa."),
        .init(id: "easter", name: "Tempo Pascal", dateRange: "18 abr a 6 jun", color: .white, summaryLine: "Cinquenta dias de alegria pela Ressurreição."),
        .init(id: "ordinary", name: "Tempo Comum", dateRange: "8 jun a 28 nov", color: .green, summaryLine: "A vida ordinária da Igreja, semana após semana."),
    ]

    static let lentRetrospective = SeasonRetrospective(
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

    static let sampleDayDetail = DayDetail(
        dateLabel: "Segunda-feira, 8 de setembro",
        feastName: "Natividade de Nossa Senhora",
        color: .white,
        loggedStateTitle: "Aridez na oração",
        loggedNote: "Rezei o Terço sem sentir nada. Fui até o fim.",
        psalmRef: "Salmo 62",
        psalmText: "Minha alma tem sede de vós; minha carne vos deseja, como terra árida, sedenta, sem água.",
        liturgyNote: "Festa da Natividade de Maria, cor branca. Leitura de Miqueias 5 e o Evangelho da genealogia.",
        otherActivity: "Terço rezado · Mistérios Gozosos · intenção: pela minha mãe"
    )

    /// A month grid for September 2026 (30 days). Weeks 2 (feast, red) and a handful
    /// of scattered logged marks, otherwise plain Ordinary Time green.
    static let septemberDays: [CalendarDayMark] = (1...30).map { day in
        let color: LiturgicalColor = (day == 8) ? .white : (day == 14 ? .red : .green)
        let logged = [3, 8, 11, 14, 19, 24].contains(day)
        return CalendarDayMark(dateKey: String(format: "2026-09-%02d", day), dayNumber: day, color: color, hasLoggedEntry: logged)
    }
}
