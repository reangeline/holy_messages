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
