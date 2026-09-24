import Foundation

/// The two records written by hand, before the imported sanctoral arrived.
///
/// Their Portuguese prayers used to be our own compositions ("Deus, que
/// ensinastes a vossa serva Notburga…"), which is the one thing this acervo
/// does not do with liturgical text. They now carry the invocation of the
/// Litany of Saints, the same form the other 35 records use: the Roman Missal
/// rubricates adding saints to the Litany at the Easter Vigil — "In the Litany
/// the names of some Saints may be added, especially the Titular Saint of the
/// church and the Patron Saints of the place and of those to be baptized"
/// (Missale Romanum, Easter Vigil, no. 43) — so the name is inserted into a
/// published form rather than a prayer being written for it.
///
/// Neither saint has a devotional prayer published in all three languages that
/// I could find: Notburga's are Tyrolean and in German, and the Vincentian
/// litany that carries Perboyre's name is on a community wiki with no stated
/// approving authority. The litany invocation is what the Church's own books
/// give for any saint, so that is what these two get.
enum MockSaints {
    private static let ptNotburga = Saint(
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
        prayer: "Santa Notburga, rogai por nós.",
        // Maître au fond maillé, década de 1490, British Museum P_1915-0508-1,
        // domínio público via Wikimedia. Crédito completo no manifest do lote de
        // imagens da pesquisa.
        artworkName: "notburga"
    )

    private static let ptJohnGabrielPerboyre = Saint(
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
        prayer: "São João Gabriel Perboyre, rogai por nós.",
        artworkName: "perboyre"
    )

    // The two records written before the imported sanctoral need their own
    // language records too. Otherwise English and Spanish calendars append the
    // Portuguese hand-written date as a fallback — which was visible in the
    // Saint of the Day widget.
    private static let enNotburga = Saint(
        id: "notburga",
        name: "St Notburga of Eben",
        lifespan: "c. 1265–1313 · laywoman",
        role: "Patron of domestic workers and farmers",
        rank: "Memorial",
        calendarNote: "Proper calendar · Austria and Germany",
        bioParagraphs: [
            "The Roman Martyrology remembers Notburga in Eben, Tyrol, for serving Christ in the poor while carrying out domestic work. Her traditional account links her care for people in need with her service in a noble household and later on a farm.",
            "She is honored in Tyrol as a patron of domestic workers and agriculture. Her memory keeps ordinary work, prayer, and care for the poor together."
        ],
        whyItMattersToday: "Notburga’s witness gives concrete form to charity: the person in front of us is not an interruption to work, but someone in whom Christ is to be served.",
        prayer: "St Notburga, pray for us.",
        artworkName: "notburga"
    )

    private static let esNotburga = Saint(
        id: "notburga",
        name: "Santa Notburga de Eben",
        lifespan: "c. 1265–1313 · laica",
        role: "Patrona de las trabajadoras domésticas y de los agricultores",
        rank: "Memoria",
        calendarNote: "Calendario propio · Austria y Alemania",
        bioParagraphs: [
            "El Martirologio Romano recuerda a Notburga en Eben, Tirol, por servir a Cristo en los pobres mientras realizaba las labores domésticas. Su relato tradicional une el cuidado de los necesitados con su servicio en una casa noble y después en el campo.",
            "En Tirol se la honra como patrona de las trabajadoras domésticas y de la agricultura. Su memoria mantiene unidos el trabajo ordinario, la oración y el cuidado de los pobres."
        ],
        whyItMattersToday: "El testimonio de Notburga da una forma concreta a la caridad: quien tenemos delante no interrumpe el trabajo, sino que es alguien en quien se sirve a Cristo.",
        prayer: "Santa Notburga, ruega por nosotros.",
        artworkName: "notburga"
    )

    private static let enJohnGabrielPerboyre = Saint(
        id: "perboyre",
        name: "St John Gabriel Perboyre",
        lifespan: "1802–1840 · Vincentian priest and martyr",
        role: "Missionary in China",
        rank: "Optional Memorial",
        calendarNote: "Proper calendar · Vincentian missions",
        bioParagraphs: [
            "John Gabriel Perboyre, a priest of the Congregation of the Mission, arrived in China in 1835 and served small Christian communities. During persecution he was arrested, tortured, and condemned to death for refusing to deny the faith.",
            "He was strangled on 11 September 1840. The Holy See’s account of his life remembers both his missionary service and his fidelity to Christ under persecution."
        ],
        whyItMattersToday: "Perboyre shows that Christian witness is not a search for suffering: it is fidelity to Christ and to the people entrusted to us when fear makes that fidelity costly.",
        prayer: "St John Gabriel Perboyre, pray for us.",
        artworkName: "perboyre"
    )

    private static let esJohnGabrielPerboyre = Saint(
        id: "perboyre",
        name: "San Juan Gabriel Perboyre",
        lifespan: "1802–1840 · sacerdote vicenciano y mártir",
        role: "Misionero en China",
        rank: "Memoria libre",
        calendarNote: "Calendario propio · misiones vicencianas",
        bioParagraphs: [
            "Juan Gabriel Perboyre, sacerdote de la Congregación de la Misión, llegó a China en 1835 y sirvió a pequeñas comunidades cristianas. Durante la persecución fue arrestado, torturado y condenado a muerte por negarse a renunciar a la fe.",
            "Murió estrangulado el 11 de septiembre de 1840. El relato de la Santa Sede recuerda tanto su servicio misionero como su fidelidad a Cristo en la persecución."
        ],
        whyItMattersToday: "Perboyre muestra que el testimonio cristiano no busca el sufrimiento: permanece fiel a Cristo y a las personas confiadas a nosotros cuando el miedo hace costosa esa fidelidad.",
        prayer: "San Juan Gabriel Perboyre, ruega por nosotros.",
        artworkName: "perboyre"
    )

    static var notburga: Saint { notburgaCatalog.current }
    static var johnGabrielPerboyre: Saint { johnGabrielPerboyreCatalog.current }

    private static let notburgaCatalog = LocalizedCatalog(pt: ptNotburga, en: enNotburga, es: esNotburga)
    private static let johnGabrielPerboyreCatalog = LocalizedCatalog(pt: ptJohnGabrielPerboyre, en: enJohnGabrielPerboyre, es: esJohnGabrielPerboyre)

    /// Region-keyed sanctoral cycle — see SaintCalendarRegion. Only `.general` is
    /// populated so far; a country override would be another entry with the same
    /// `dateKey` and a different `region`, resolved by `saint(on:region:)` below.
    /// One catalog per language — see LocalizedCatalog.
    static var calendar: [SaintOfDay] { catalog.current }

    /// Later batches (scripts/lotes/santos-*-lote) each have their own
    /// generated file, so reimporting the first batch from ~/Documents never
    /// drops them.
    static let catalog = LocalizedCatalog(
        pt: ptCalendar + ptImportedCalendar.filter { !handWrittenDates.contains($0.dateKey) }
            + ptCalendarSecondBatch + ptCalendarThirdBatch,
        en: enImportedCalendar.filter { !handWrittenDates.contains($0.dateKey) } + enCalendar
            + enCalendarSecondBatch + enCalendarThirdBatch,
        es: esImportedCalendar.filter { !handWrittenDates.contains($0.dateKey) } + esCalendar
            + esCalendarSecondBatch + esCalendarThirdBatch
    )

    /// Dates with a hand-written record, which wins over the imported one: those
    /// two have a real biography, a "why it matters today" and a prayer, and the
    /// imported batch only carries the factual first paragraph.
    // Perboyre estava em 23/09 — que é São Pio de Pietrelcina, e a ficha manual
    // escondia a importada. A memória dele é 11 de setembro.
    private static let handWrittenDates: Set<String> = ["09-14", "09-11"]

    private static let ptCalendar: [SaintOfDay] = [
        SaintOfDay(dateKey: "09-14", region: .general, saint: ptNotburga),
        SaintOfDay(dateKey: "09-11", region: .general, saint: ptJohnGabrielPerboyre),
    ]

    private static let enCalendar: [SaintOfDay] = [
        SaintOfDay(dateKey: "09-14", region: .general, saint: enNotburga),
        SaintOfDay(dateKey: "09-11", region: .general, saint: enJohnGabrielPerboyre),
    ]

    private static let esCalendar: [SaintOfDay] = [
        SaintOfDay(dateKey: "09-14", region: .general, saint: esNotburga),
        SaintOfDay(dateKey: "09-11", region: .general, saint: esJohnGabrielPerboyre),
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

    /// Every saint with a record on "MM-dd", in every region — the calendar's
    /// day screen lists them all, each opening its own page.
    static func saints(on monthDay: String) -> [Saint] {
        var vistos = Set<String>()
        return calendar.filter { $0.dateKey == monthDay }
            .map(\.saint)
            .filter { vistos.insert($0.id).inserted }
    }

    /// The saint for "MM-dd" when the sanctoral has a record for that day.
    /// On the many days it doesn't yet, a different saint from the catalog each
    /// day, not dated — it used to repeat the last dated saint with its own
    /// date ("Padre Pio · 23 de setembro" on the 24th), which read as stale.
    static func saintOfDay(on monthDay: String, region: SaintCalendarRegion = .general) -> (saint: Saint, isTodaysFeast: Bool) {
        if let exato = saint(on: monthDay, region: region) { return (exato, true) }
        var vistos = Set<String>()
        let acervo = calendar.map(\.saint).filter { vistos.insert($0.id).inserted }.sorted { $0.id < $1.id }
        guard !acervo.isEmpty else { return (notburga, false) }
        let partes = monthDay.split(separator: "-").compactMap { Int($0) }
        let dia = partes.count == 2 ? (partes[0] - 1) * 31 + partes[1] : 0
        return (acervo[dia % acervo.count], false)
    }

    /// Resolves a cross-feature link (for example, a devotional prayer) to the
    /// saint record in the catalog currently shown by the app.
    static func saint(withID id: String) -> Saint? {
        calendar.first { $0.saint.id == id }?.saint
    }

    /// Resolves the saint named by a pastoral response. New generated records
    /// should carry an id at their source; this name bridge keeps the reviewed
    /// Portuguese pool linkable while it is progressively migrated. It only
    /// contains identities that have a record in this archive.
    static func saint(referencedBy name: String) -> Saint? {
        let key = referenceKey(name)
        let id = saintReferenceIDs[key]
            ?? ([notburga, johnGabrielPerboyre] + ptImportedSaints + enImportedSaints + esImportedSaints
                + ptSaintsSecondBatch + enSaintsSecondBatch + esSaintsSecondBatch
                + ptSaintsThirdBatch + enSaintsThirdBatch + esSaintsThirdBatch)
                .first { referenceKey($0.name) == key }?.id
        return id.flatMap(saint(withID:))
    }

    private static let saintReferenceIDs: [String: String] = [
        "santateresinhadomeninojesus": "teresinha",
        "saintthereseoflisieux": "teresinha",
        "saintthereseofthechildjesus": "teresinha",
        "santateresitadelninojesus": "teresinha",
        "santateresadavila": "teresa-avila",
        "saintteresaofavila": "teresa-avila",
        "santateresadeavila": "teresa-avila",
        "santoinaciodeloyola": "inacio-loyola",
        "saintignatiusofloyola": "inacio-loyola",
        "sanignaciodeloyola": "inacio-loyola",
        "santoagostinho": "agostinho",
        "saintaugustine": "agostinho",
        "sanagustin": "agostinho",
        "saopadrepio": "padre-pio",
        "stpadrepio": "padre-pio",
        "sanpadrepio": "padre-pio",
        "santamariamadalena": "maria-madalena",
        "saintmarymagdalene": "maria-madalena",
        "santamariamagdalena": "maria-madalena",
        "saintjohnofthecross": "joao-cruz",
    ]

    private static func referenceKey(_ value: String) -> String {
        value.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .unicodeScalars
            .filter { CharacterSet.alphanumerics.contains($0) }
            .map(String.init)
            .joined()
    }

    /// The archive is the sanctoral itself, ordered by date — it used to be a
    /// separate hand-typed list of six names, where only one row could be opened
    /// because only one had a record behind it.
    static var archive: [SaintOfDay] {
        calendar.sorted { $0.dateKey < $1.dateKey }
    }
}
