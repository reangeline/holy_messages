import Foundation

/// Everything the liturgical engine has to *name*, in one language.
///
/// Three different kinds of text share this struct, and they follow different
/// rules:
///
/// 1. **Season and celebration titles.** These are the proper titles used by
///    each language's edition of the Roman Missal — not translations made here.
///    English follows the Roman Missal as published for the United States; the
///    Spanish titles follow the Misal Romano. **They should be confirmed against
///    those editions before publishing**, the same way the sanctoral batch is
///    being confirmed against the Martyrology.
/// 2. **The explanatory sentences.** These are this app's own editorial copy —
///    my writing, not liturgical text — so each language gets its own sentence
///    written for it rather than a rendering of the Portuguese one.
/// 3. **Ordinal form.** Purely a language convention: Portuguese writes
///    "23º Domingo do Tempo Comum", English "23rd Sunday in Ordinary Time",
///    Spanish "Domingo 23 del Tiempo Ordinario" — different suffixes *and* a
///    different word order, which is why the whole title is a format string
///    instead of a noun the call site concatenates.
struct LiturgicalNames {
    // MARK: Seasons
    let advent: String
    let christmasTime: String
    let ordinaryTime: String
    let lent: String
    let triduum: String
    let easterTime: String

    /// The label above the celebration: "Tempo Comum · 23ª semana".
    /// Placeholders: {season}, {n}.
    let seasonWeekFormat: String

    // MARK: Sundays — {n} is the week number
    let sundayOfAdvent: String
    let sundayOfLent: String
    let sundayOfEaster: String
    let sundayInOrdinaryTime: String

    // MARK: Days with no proper celebration
    let weekdayOfAdvent: String
    let weekdayOfLent: String
    let weekdayOfEasterTime: String
    let weekdayOfOrdinaryTime: String
    let dayInOctaveOfChristmas: String

    // MARK: Solemnities and feasts the engine computes
    let nativity: String
    let maryMotherOfGod: String
    let epiphany: String
    let baptismOfTheLord: String
    let palmSunday: String
    let holyThursday: String
    let goodFriday: String
    let holySaturday: String
    let easterSunday: String
    let divineMercySunday: String
    let ascension: String
    let pentecost: String
    let trinitySunday: String
    let corpusChristi: String
    let sacredHeart: String
    let christTheKing: String

    // MARK: Editorial copy — this app's sentences, not liturgical texts
    let adventExplanation: String
    /// One per week of Advent, so the days don't all repeat one sentence.
    let adventWeekExplanations: [String]
    /// 17 to 24 December: the "O" antiphons of Vespers, one per day, then the eve.
    let lateAdventExplanations: [String]
    let gaudeteExplanation: String
    let christmasExplanation: String
    let lentExplanation: String
    let laetareExplanation: String
    let palmSundayExplanation: String
    let holyThursdayExplanation: String
    let goodFridayExplanation: String
    let holySaturdayExplanation: String
    let easterExplanation: String
    let ordinaryExplanation: String

    /// How this language writes the week number inside a title.
    let ordinal: (Int) -> String

    func seasonLabel(_ season: String, week: Int) -> String {
        seasonWeekFormat
            .replacingOccurrences(of: "{season}", with: season)
            .replacingOccurrences(of: "{n}", with: ordinal(week))
    }

    func sunday(_ format: String, week: Int) -> String {
        format.replacingOccurrences(of: "{n}", with: ordinal(week))
    }
}

enum LiturgicalNameCatalog {
    static var current: LiturgicalNames { catalog.current }

    static let catalog = LocalizedCatalog(pt: portuguese, en: english, es: spanish)

    static let portuguese = LiturgicalNames(
        advent: "Advento",
        christmasTime: "Tempo do Natal",
        ordinaryTime: "Tempo Comum",
        lent: "Quaresma",
        triduum: "Tríduo Pascal",
        easterTime: "Tempo Pascal",
        seasonWeekFormat: "{season} · {n}ª semana",
        sundayOfAdvent: "{n}º Domingo do Advento",
        sundayOfLent: "{n}º Domingo da Quaresma",
        sundayOfEaster: "{n}º Domingo da Páscoa",
        sundayInOrdinaryTime: "{n}º Domingo do Tempo Comum",
        weekdayOfAdvent: "Feria do Advento",
        weekdayOfLent: "Feria da Quaresma",
        weekdayOfEasterTime: "Feria do Tempo Pascal",
        weekdayOfOrdinaryTime: "Feria do Tempo Comum",
        dayInOctaveOfChristmas: "Oitava do Natal",
        nativity: "Natividade do Senhor",
        maryMotherOfGod: "Santa Maria, Mãe de Deus",
        epiphany: "Epifania do Senhor",
        baptismOfTheLord: "Batismo do Senhor",
        palmSunday: "Domingo de Ramos da Paixão do Senhor",
        holyThursday: "Quinta-feira Santa · Missa da Ceia do Senhor",
        goodFriday: "Sexta-feira Santa da Paixão do Senhor",
        holySaturday: "Sábado Santo",
        easterSunday: "Páscoa da Ressurreição do Senhor",
        divineMercySunday: "Domingo da Divina Misericórdia",
        ascension: "Ascensão do Senhor",
        pentecost: "Pentecostes",
        trinitySunday: "Santíssima Trindade",
        corpusChristi: "Corpo e Sangue de Cristo",
        sacredHeart: "Sagrado Coração de Jesus",
        christTheKing: "Nosso Senhor Jesus Cristo, Rei do Universo",
        adventExplanation: "Advento: quatro semanas de espera e preparação para o Natal do Senhor.",
        adventWeekExplanations: [
            "1ª semana do Advento: vigiar. As leituras olham para a volta do Senhor no fim dos tempos, antes de olhar para o presépio.",
            "2ª semana do Advento: preparar o caminho. João Batista chama à conversão — endireitar o que está torto para receber quem vem.",
            "3ª semana do Advento: a alegria de quem já vê a chegada perto. João aponta para Jesus: \"Eis o Cordeiro de Deus\".",
            "4ª semana do Advento: Maria entra em cena. As leituras contam o anúncio a José e a Maria, e a espera fica com rosto.",
        ],
        lateAdventExplanations: [
            "17 de dezembro — começam as antífonas do Ó: \"Ó Sabedoria\". A liturgia deixa a volta de Cristo e passa a preparar diretamente o Natal.",
            "18 de dezembro — \"Ó Adonai\": o Senhor que falou a Moisés na sarça e deu a Lei no Sinai.",
            "19 de dezembro — \"Ó Raiz de Jessé\": o rebento da família de Davi, sinal erguido para os povos.",
            "20 de dezembro — \"Ó Chave de Davi\": aquele que abre o que ninguém fecha e liberta quem está preso.",
            "21 de dezembro — \"Ó Oriente\": o sol que nasce do alto, no dia mais curto do ano no hemisfério norte.",
            "22 de dezembro — \"Ó Rei das nações\": a pedra angular que une o que estava dividido.",
            "23 de dezembro — \"Ó Emanuel\": Deus conosco. Lidas de trás para a frente, as iniciais latinas formam \"ero cras\" — \"estarei aí amanhã\".",
            "24 de dezembro — véspera do Natal. De manhã ainda é Advento; à tarde começa a Vigília da Natividade do Senhor.",
        ],
        gaudeteExplanation: "3º Domingo do Advento — \"Gaudete\", alegrai-vos: a cor muda para rosa, antecipando a alegria do Natal que se aproxima.",
        christmasExplanation: "Tempo do Natal: a celebração do nascimento do Senhor se estende até o Batismo do Senhor.",
        lentExplanation: "Quaresma: quarenta dias de jejum, oração e esmola, preparando a Páscoa.",
        laetareExplanation: "4º Domingo da Quaresma — \"Laetare\", alegrai-vos: um respiro rosa na metade do caminho até a Páscoa.",
        palmSundayExplanation: "Domingo de Ramos: entra-se na Semana Santa lendo a Paixão inteira, com a alegria dos ramos e o peso da cruz no mesmo dia.",
        holyThursdayExplanation: "O Tríduo Pascal começa esta noite: a instituição da Eucaristia e do sacerdócio.",
        goodFridayExplanation: "Único dia do ano sem celebração da Missa — a liturgia é da Paixão, com adoração da cruz.",
        holySaturdayExplanation: "Dia de silêncio litúrgico junto ao sepulcro — sem Missa até a Vigília Pascal, à noite.",
        easterExplanation: "Tempo Pascal: cinquenta dias de alegria pela Ressurreição, até Pentecostes.",
        ordinaryExplanation: "Tempo Comum: a vida ordinária da Igreja, semana após semana, fora dos grandes tempos fortes.",
        ordinal: { "\($0)" }
    )

    static let english = LiturgicalNames(
        advent: "Advent",
        christmasTime: "Christmas Time",
        ordinaryTime: "Ordinary Time",
        lent: "Lent",
        triduum: "Paschal Triduum",
        easterTime: "Easter Time",
        seasonWeekFormat: "{season} · week {n}",
        sundayOfAdvent: "{n} Sunday of Advent",
        sundayOfLent: "{n} Sunday of Lent",
        sundayOfEaster: "{n} Sunday of Easter",
        sundayInOrdinaryTime: "{n} Sunday in Ordinary Time",
        weekdayOfAdvent: "Weekday of Advent",
        weekdayOfLent: "Weekday of Lent",
        weekdayOfEasterTime: "Weekday of Easter Time",
        weekdayOfOrdinaryTime: "Weekday in Ordinary Time",
        dayInOctaveOfChristmas: "Day within the Octave of Christmas",
        nativity: "The Nativity of the Lord",
        maryMotherOfGod: "Mary, the Holy Mother of God",
        epiphany: "The Epiphany of the Lord",
        baptismOfTheLord: "The Baptism of the Lord",
        palmSunday: "Palm Sunday of the Passion of the Lord",
        holyThursday: "Thursday of the Lord's Supper",
        goodFriday: "Friday of the Passion of the Lord",
        holySaturday: "Holy Saturday",
        easterSunday: "Easter Sunday of the Resurrection of the Lord",
        divineMercySunday: "Divine Mercy Sunday",
        ascension: "The Ascension of the Lord",
        pentecost: "Pentecost Sunday",
        trinitySunday: "The Most Holy Trinity",
        corpusChristi: "The Most Holy Body and Blood of Christ",
        sacredHeart: "The Most Sacred Heart of Jesus",
        christTheKing: "Our Lord Jesus Christ, King of the Universe",
        adventExplanation: "Advent: four weeks of waiting and preparation for the Nativity of the Lord.",
        adventWeekExplanations: [
            "First week of Advent: keep watch. The readings look to the Lord's return at the end of time before they look to the manger.",
            "Second week of Advent: prepare the way. John the Baptist calls for conversion — make straight what is crooked for the one who is coming.",
            "Third week of Advent: the joy of seeing the arrival close. John points to Jesus: \"Behold the Lamb of God\".",
            "Fourth week of Advent: Mary steps forward. The readings tell of the annunciation to Joseph and to Mary, and the waiting takes on a face.",
        ],
        lateAdventExplanations: [
            "17 December — the O Antiphons begin: \"O Wisdom\". The liturgy turns from Christ's return to preparing directly for Christmas.",
            "18 December — \"O Adonai\": the Lord who spoke to Moses in the burning bush and gave the Law on Sinai.",
            "19 December — \"O Root of Jesse\": the shoot of David's line, raised as a sign for the peoples.",
            "20 December — \"O Key of David\": who opens what no one shuts and sets the captive free.",
            "21 December — \"O Dayspring\": the rising sun from on high, on the shortest day of the year in the northern hemisphere.",
            "22 December — \"O King of the Nations\": the cornerstone who makes one what was divided.",
            "23 December — \"O Emmanuel\": God with us. Read backwards, the Latin initials spell \"ero cras\" — \"tomorrow I will be there\".",
            "24 December — Christmas Eve. The morning is still Advent; in the evening the Vigil of the Nativity of the Lord begins.",
        ],
        gaudeteExplanation: "Third Sunday of Advent — \"Gaudete\", rejoice: the color turns rose, anticipating the joy of the Christmas now close at hand.",
        christmasExplanation: "Christmas Time: the celebration of the Lord's birth runs through to the Baptism of the Lord.",
        lentExplanation: "Lent: forty days of fasting, prayer and almsgiving, preparing for Easter.",
        laetareExplanation: "Fourth Sunday of Lent — \"Laetare\", rejoice: a rose-colored breath halfway to Easter.",
        palmSundayExplanation: "Palm Sunday: Holy Week opens by reading the whole Passion, with the joy of the palms and the weight of the cross on the same day.",
        holyThursdayExplanation: "The Paschal Triduum begins tonight: the institution of the Eucharist and of the priesthood.",
        goodFridayExplanation: "The one day of the year with no Mass — the liturgy is of the Passion, with the adoration of the cross.",
        holySaturdayExplanation: "A day of liturgical silence at the tomb — no Mass until the Easter Vigil, at night.",
        easterExplanation: "Easter Time: fifty days of joy at the Resurrection, through to Pentecost.",
        ordinaryExplanation: "Ordinary Time: the ordinary life of the Church, week after week, outside the great seasons.",
        // 1st, 2nd, 3rd, 4th … 21st, 22nd, 23rd — the English suffix rule,
        // including the 11/12/13 exception.
        ordinal: { n in
            let suffix: String
            switch (n % 100, n % 10) {
            case (11, _), (12, _), (13, _): suffix = "th"
            case (_, 1): suffix = "st"
            case (_, 2): suffix = "nd"
            case (_, 3): suffix = "rd"
            default: suffix = "th"
            }
            return "\(n)\(suffix)"
        }
    )

    static let spanish = LiturgicalNames(
        advent: "Adviento",
        christmasTime: "Tiempo de Navidad",
        ordinaryTime: "Tiempo Ordinario",
        lent: "Cuaresma",
        triduum: "Triduo Pascual",
        easterTime: "Tiempo Pascual",
        seasonWeekFormat: "{season} · semana {n}",
        // Spanish puts the ordinal after the noun: "Domingo 2 de Adviento".
        sundayOfAdvent: "Domingo {n} de Adviento",
        sundayOfLent: "Domingo {n} de Cuaresma",
        sundayOfEaster: "Domingo {n} de Pascua",
        sundayInOrdinaryTime: "Domingo {n} del Tiempo Ordinario",
        weekdayOfAdvent: "Feria de Adviento",
        weekdayOfLent: "Feria de Cuaresma",
        weekdayOfEasterTime: "Feria del Tiempo Pascual",
        weekdayOfOrdinaryTime: "Feria del Tiempo Ordinario",
        dayInOctaveOfChristmas: "Día de la Octava de Navidad",
        nativity: "La Natividad del Señor",
        maryMotherOfGod: "Santa María, Madre de Dios",
        epiphany: "La Epifanía del Señor",
        baptismOfTheLord: "El Bautismo del Señor",
        palmSunday: "Domingo de Ramos de la Pasión del Señor",
        holyThursday: "Jueves Santo · Misa de la Cena del Señor",
        goodFriday: "Viernes Santo de la Pasión del Señor",
        holySaturday: "Sábado Santo",
        easterSunday: "Domingo de Pascua de la Resurrección del Señor",
        divineMercySunday: "Domingo de la Divina Misericordia",
        ascension: "La Ascensión del Señor",
        pentecost: "Domingo de Pentecostés",
        trinitySunday: "La Santísima Trinidad",
        corpusChristi: "El Cuerpo y la Sangre de Cristo",
        sacredHeart: "El Sagrado Corazón de Jesús",
        christTheKing: "Nuestro Señor Jesucristo, Rey del Universo",
        adventExplanation: "Adviento: cuatro semanas de espera y preparación para la Navidad del Señor.",
        adventWeekExplanations: [
            "Primera semana de Adviento: velar. Las lecturas miran a la vuelta del Señor al final de los tiempos antes de mirar al pesebre.",
            "Segunda semana de Adviento: preparar el camino. Juan el Bautista llama a la conversión — enderezar lo torcido para recibir al que viene.",
            "Tercera semana de Adviento: la alegría de ver cerca la llegada. Juan señala a Jesús: \"Este es el Cordero de Dios\".",
            "Cuarta semana de Adviento: entra María. Las lecturas cuentan el anuncio a José y a María, y la espera toma rostro.",
        ],
        lateAdventExplanations: [
            "17 de diciembre — empiezan las antífonas de la O: \"Oh Sabiduría\". La liturgia deja la vuelta de Cristo y prepara directamente la Navidad.",
            "18 de diciembre — \"Oh Adonai\": el Señor que habló a Moisés en la zarza y dio la Ley en el Sinaí.",
            "19 de diciembre — \"Oh Renuevo del tronco de Jesé\": el brote de la casa de David, alzado como signo para los pueblos.",
            "20 de diciembre — \"Oh Llave de David\": el que abre lo que nadie cierra y libera al cautivo.",
            "21 de diciembre — \"Oh Sol que nace de lo alto\", en el día más corto del año en el hemisferio norte.",
            "22 de diciembre — \"Oh Rey de las naciones\": la piedra angular que une lo que estaba dividido.",
            "23 de diciembre — \"Oh Emmanuel\": Dios con nosotros. Leídas al revés, las iniciales latinas forman \"ero cras\" — \"mañana estaré\".",
            "24 de diciembre — víspera de Navidad. Por la mañana todavía es Adviento; por la tarde empieza la Vigilia de la Natividad del Señor.",
        ],
        gaudeteExplanation: "Domingo 3 de Adviento — \"Gaudete\", alegraos: el color cambia a rosa, anticipando la alegría de la Navidad que se acerca.",
        christmasExplanation: "Tiempo de Navidad: la celebración del nacimiento del Señor se extiende hasta el Bautismo del Señor.",
        lentExplanation: "Cuaresma: cuarenta días de ayuno, oración y limosna, preparando la Pascua.",
        laetareExplanation: "Domingo 4 de Cuaresma — \"Laetare\", alegraos: un respiro rosa a mitad del camino hacia la Pascua.",
        palmSundayExplanation: "Domingo de Ramos: se entra en la Semana Santa leyendo la Pasión entera, con la alegría de los ramos y el peso de la cruz el mismo día.",
        holyThursdayExplanation: "El Triduo Pascual comienza esta noche: la institución de la Eucaristía y del sacerdocio.",
        goodFridayExplanation: "El único día del año sin celebración de la Misa — la liturgia es de la Pasión, con la adoración de la cruz.",
        holySaturdayExplanation: "Día de silencio litúrgico junto al sepulcro — sin Misa hasta la Vigilia Pascual, por la noche.",
        easterExplanation: "Tiempo Pascual: cincuenta días de alegría por la Resurrección, hasta Pentecostés.",
        ordinaryExplanation: "Tiempo Ordinario: la vida ordinaria de la Iglesia, semana tras semana, fuera de los grandes tiempos.",
        ordinal: { "\($0)" }
    )
}
