import Foundation

enum MockSaints {
    static let notburga = Saint(
        id: "notburga",
        name: "Santa Notburga de Eben",
        lifespan: "c. 1265 – 1313 · serva",
        role: "Serva, padroeira dos pobres",
        rank: "Memória",
        calendarNote: "Calendário próprio · Áustria e Alemanha",
        bioParagraphs: [
            "Serva tirolesa, foi despedida da casa onde trabalhava por distribuir aos pobres a comida que seria jogada fora. Passou a trabalhar no campo e continuou repartindo a própria parte.",
            "Não deixou escritos nem visões. É lembrada pelo que fazia com as sobras, e por não ter parado quando isso lhe custou o emprego.",
        ],
        whyItMattersToday: "No dia em que a Igreja exalta a Cruz, ela mostra a forma mais comum dela: perder algo concreto por não recuar do que é justo.",
        prayer: "Deus, que ensinastes a vossa serva Notburga a repartir o pouco que tinha, dai-nos a coragem de fazer o que é justo quando isso nos custa. Amém.",
        // Maître au fond maillé, década de 1490, British Museum P_1915-0508-1,
        // domínio público via Wikimedia. Crédito completo no manifest do lote de
        // imagens da pesquisa.
        artworkName: "notburga"
    )

    static let johnGabrielPerboyre = Saint(
        id: "perboyre",
        name: "São João Gabriel Perboyre",
        lifespan: "1802 – 1840 · missionário e mártir",
        role: "Padre lazarista, mártir na China",
        rank: "Memória facultativa",
        calendarNote: "Calendário próprio · missões lazaristas",
        bioParagraphs: [
            "Padre francês da Congregação da Missão, partiu para a China sabendo que a perseguição aos missionários era real. Foi preso, torturado e, por fim, estrangulado por se recusar a pisar numa cruz.",
        ],
        whyItMattersToday: "Sua morte imitou deliberadamente a Paixão: foi arrastado por ruas, açoitado e exposto — uma vida moldada pela Cruz até o fim.",
        prayer: "Senhor, que destes a João Gabriel a força de não recuar diante do sofrimento, dai-nos parte da mesma fortaleza. Amém."
    )

    /// Region-keyed sanctoral cycle — see SaintCalendarRegion. Only `.general` is
    /// populated so far; a country override would be another entry with the same
    /// `dateKey` and a different `region`, resolved by `saint(on:region:)` below.
    /// One catalog per language — see LocalizedCatalog.
    static var calendar: [SaintOfDay] { catalog.current }

    static let catalog = LocalizedCatalog(
        pt: ptCalendar + ptImportedCalendar.filter { !handWrittenDates.contains($0.dateKey) },
        en: enImportedCalendar.filter { !handWrittenDates.contains($0.dateKey) } + ptCalendar,
        es: esImportedCalendar.filter { !handWrittenDates.contains($0.dateKey) } + ptCalendar
    )

    /// Dates with a hand-written record, which wins over the imported one: those
    /// two have a real biography, a "why it matters today" and a prayer, and the
    /// imported batch only carries the factual first paragraph.
    private static let handWrittenDates: Set<String> = ["09-14", "09-23"]

    private static let ptCalendar: [SaintOfDay] = [
        SaintOfDay(dateKey: "09-14", region: .general, saint: notburga),
        SaintOfDay(dateKey: "09-23", region: .general, saint: johnGabrielPerboyre),
    ]

    /// Looks up the saint for a fixed date ("MM-dd"), preferring `region` and
    /// falling back to the General Roman Calendar when the region has no override
    /// for that date. Returns nil rather than a placeholder — an empty day is a
    /// correct answer for a sanctoral cycle that isn't fully populated yet.
    static func saint(on dateKey: String, region: SaintCalendarRegion = .general) -> Saint? {
        if let regional = calendar.first(where: { $0.dateKey == dateKey && $0.region == region }) {
            return regional.saint
        }
        return calendar.first { $0.dateKey == dateKey && $0.region == .general }?.saint
    }

    static let saintsForYou: [SaintRecommendation] = [
        .init(id: "john-of-the-cross", name: "São João da Cruz", reason: "Escreveu sobre a \"noite escura\" — a oração que não sente nada e continua mesmo assim."),
        .init(id: "teresa-calcutta", name: "Santa Teresa de Calcutá", reason: "Viveu décadas de aridez na oração enquanto servia, e não escondeu isso depois de morta."),
        .init(id: "therese", name: "Santa Teresinha do Menino Jesus", reason: "Descreveu a fé como um túnel escuro, mesmo nos últimos meses de vida."),
        .init(id: "cure-ars", name: "São João Maria Vianney", reason: "Padre que passava horas em confissionário sem sinal algum de consolação sensível."),
    ]

    /// The archive is the sanctoral itself, ordered by date — it used to be a
    /// separate hand-typed list of six names, where only one row could be opened
    /// because only one had a record behind it.
    static var archive: [SaintOfDay] {
        calendar.sorted { $0.dateKey < $1.dateKey }
    }
}
