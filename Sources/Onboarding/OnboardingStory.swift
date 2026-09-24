import Foundation

/// Copy for the story beats wrapped around the questionnaire: the promise after
/// the opening verse, the reflections that answer the first questions, the
/// guided prayer, and the commitment before the paywall. Authored per language
/// side by side, like OnboardingRelief.
enum OnboardingStory {
    static func text(_ byLanguage: [AppLanguage: String]) -> String {
        byLanguage[AppLanguagePreference.resolveCurrent()] ?? byLanguage[.en]!
    }

    // MARK: - Promise (after the verse)

    static let promiseLines: [[AppLanguage: String]] = [
        [.en: "God speaks every day.",
         .pt: "Deus fala todos os dias.",
         .es: "Dios habla todos los días."],
        [.en: "It's the rush of the day that keeps us from hearing.",
         .pt: "A rotina é que não deixa a gente ouvir.",
         .es: "Es la rutina la que no nos deja escuchar."],
        [.en: "A few minutes a day, in the rhythm of the Church.",
         .pt: "Poucos minutos por dia, no ritmo da Igreja.",
         .es: "Unos minutos al día, al ritmo de la Iglesia."],
    ]

    static let promiseLead: [AppLanguage: String] = [
        .en: "First, tell us where you are.",
        .pt: "Antes, conte onde você está.",
        .es: "Primero, cuéntanos dónde estás.",
    ]

    static let begin: [AppLanguage: String] = [.en: "Begin", .pt: "Começar", .es: "Comenzar"]

    // MARK: - Reflections (life-1 and life-2 answers)

    /// Keyed by option id. No statistics on purpose: a made-up number would cost
    /// more trust than it buys.
    static let reflections: [String: [AppLanguage: String]] = [
        "practicing": [
            .en: "Then this is about going deeper, not starting over.",
            .pt: "Então aqui é para aprofundar, não para recomeçar.",
            .es: "Entonces aquí se trata de profundizar, no de empezar de cero.",
        ],
        "returning": [
            .en: "Coming back is one of the oldest stories in the Gospel. The father ran to meet his son.",
            .pt: "Voltar é uma das histórias mais antigas do Evangelho. O pai correu ao encontro do filho.",
            .es: "Volver es una de las historias más antiguas del Evangelio. El padre corrió al encuentro del hijo.",
        ],
        "exploring": [
            .en: "Good to have you here. Nothing in this app assumes you already know the words.",
            .pt: "Que bom ter você aqui. Nada neste app supõe que você já conheça as palavras.",
            .es: "Qué bueno tenerte aquí. Nada en esta app supone que ya conozcas las palabras.",
        ],
        "struggling": [
            .en: "Hard seasons are part of faith, not a sign it's gone. The saints walked through them too.",
            .pt: "Tempos difíceis fazem parte da fé, não são sinal de que ela acabou. Os santos também passaram por eles.",
            .es: "Los tiempos difíciles son parte de la fe, no una señal de que se acabó. Los santos también pasaron por ellos.",
        ],
        "weekly": [
            .en: "The app follows the same calendar you live on Sunday, every day of the week.",
            .pt: "O app segue o mesmo calendário que você vive no domingo, todos os dias da semana.",
            .es: "La app sigue el mismo calendario que vives el domingo, todos los días de la semana.",
        ],
        "monthly": [
            .en: "Between one Mass and the next, the liturgy keeps going, and the app brings it to you.",
            .pt: "Entre uma Missa e outra, a liturgia continua, e o app leva ela até você.",
            .es: "Entre una Misa y otra, la liturgia sigue, y la app te la acerca.",
        ],
        "occasions": [
            .en: "Understanding the Mass part by part tends to change how those occasions feel.",
            .pt: "Entender a Missa parte por parte costuma mudar o jeito de viver essas ocasiões.",
            .es: "Entender la Misa parte por parte suele cambiar la forma de vivir esas ocasiones.",
        ],
        "trying": [
            .en: "Every return starts with a small step. This is one.",
            .pt: "Toda volta começa com um passo pequeno. Este é um.",
            .es: "Todo regreso empieza con un paso pequeño. Este es uno.",
        ],
    ]

    // MARK: - Guided prayer (after the relief screen)

    static let prayerEyebrow: [AppLanguage: String] = [
        .en: "Before we go on", .pt: "Antes de continuar", .es: "Antes de seguir",
    ]
    static let prayerTitle: [AppLanguage: String] = [
        .en: "Let's pray together, now.",
        .pt: "Vamos rezar juntos, agora.",
        .es: "Recemos juntos, ahora.",
    ]
    static let prayerBody: [AppLanguage: String] = [
        .en: "One Our Father, slowly. A breath first, then follow each phrase.",
        .pt: "Um Pai-Nosso, devagar. Primeiro uma respiração, depois acompanhe cada frase.",
        .es: "Un Padre Nuestro, despacio. Primero una respiración, después sigue cada frase.",
    ]
    static let prayerStart: [AppLanguage: String] = [.en: "Pray now", .pt: "Rezar agora", .es: "Rezar ahora"]
    static let prayerSkip: [AppLanguage: String] = [.en: "Not now", .pt: "Agora não", .es: "Ahora no"]

    /// Wording follows the Compendium text the prayer catalog already uses.
    static let ourFather: [AppLanguage: [String]] = [
        .en: [
            "Our Father, who art in heaven, hallowed be thy name;",
            "thy kingdom come, thy will be done on earth as it is in heaven.",
            "Give us this day our daily bread,",
            "and forgive us our trespasses, as we forgive those who trespass against us;",
            "and lead us not into temptation, but deliver us from evil.",
            "Amen.",
        ],
        .pt: [
            "Pai Nosso que estais nos Céus, santificado seja o vosso Nome;",
            "venha a nós o vosso Reino, seja feita a vossa vontade assim na terra como no Céu.",
            "O pão nosso de cada dia nos dai hoje,",
            "perdoai-nos as nossas ofensas assim como nós perdoamos a quem nos tem ofendido,",
            "e não nos deixeis cair em tentação, mas livrai-nos do Mal.",
            "Amém.",
        ],
        .es: [
            "Padre nuestro que estás en el cielo, santificado sea tu Nombre;",
            "venga a nosotros tu Reino; hágase tu voluntad en la tierra como en el cielo.",
            "Danos hoy nuestro pan de cada día;",
            "perdona nuestras ofensas, como también nosotros perdonamos a los que nos ofenden;",
            "no nos dejes caer en la tentación, y líbranos del mal.",
            "Amén.",
        ],
    ]

    static let prayedTitle: [AppLanguage: String] = [
        .en: "Your first prayer with Missale",
        .pt: "Sua primeira oração no Missale",
        .es: "Tu primera oración en Missale",
    ]
    static let prayedBody: [AppLanguage: String] = [
        .en: "The next one arrives tomorrow morning.",
        .pt: "Amanhã cedo chega a próxima.",
        .es: "Mañana temprano llega la próxima.",
    ]
    static let continueLabel: [AppLanguage: String] = [.en: "Continue", .pt: "Continuar", .es: "Continuar"]

    // MARK: - Commitment (synthesis, before the paywall)

    static let commitmentEyebrow: [AppLanguage: String] = [
        .en: "My commitment", .pt: "Meu compromisso", .es: "Mi compromiso",
    ]
    static let holdToCommit: [AppLanguage: String] = [
        .en: "Hold to commit",
        .pt: "Segure para se comprometer",
        .es: "Mantén pulsado para comprometerte",
    ]

    /// Keyed by the life-1 answer, so the sentence is the reader's own.
    static let commitments: [String: [AppLanguage: String]] = [
        "practicing": [
            .en: "I want to go deeper into what I already live.",
            .pt: "Quero ir mais fundo naquilo que já vivo.",
            .es: "Quiero ir más a fondo en lo que ya vivo.",
        ],
        "returning": [
            .en: "I want to come back, one day at a time.",
            .pt: "Quero voltar, um dia de cada vez.",
            .es: "Quiero volver, un día a la vez.",
        ],
        "exploring": [
            .en: "I want to get to know the faith of the Church, without hurry.",
            .pt: "Quero conhecer a fé da Igreja, sem pressa.",
            .es: "Quiero conocer la fe de la Iglesia, sin prisa.",
        ],
        "struggling": [
            .en: "I want to walk through this season without letting go of God's hand.",
            .pt: "Quero atravessar este tempo sem soltar a mão de Deus.",
            .es: "Quiero atravesar este tiempo sin soltar la mano de Dios.",
        ],
    ]
    static let commitmentFallback: [AppLanguage: String] = [
        .en: "I want to set aside a few minutes a day for God.",
        .pt: "Quero reservar alguns minutos por dia para Deus.",
        .es: "Quiero reservar unos minutos al día para Dios.",
    ]

    // MARK: - Plan (synthesis)

    typealias PlanStep = (title: [AppLanguage: String], subtitle: [AppLanguage: String])

    /// Three steps: the daily routine, the one the reader asked for in
    /// "what's missing most" (life-3), and the free daily word and saint. It
    /// used to be the same list for everyone under "built from what you told us".
    static func plan(missing: Set<String>) -> [PlanStep] {
        let chosen = ["understanding", "consistency", "peace", "community"].first { missing.contains($0) } ?? "understanding"
        return [routineStep, byMissing[chosen]!, freeStep]
    }

    private static let routineStep: PlanStep = (
        [.pt: "Seu dia com Deus", .en: "Your day with God", .es: "Tu día con Dios"],
        [.pt: "Cinco momentos, da manhã à noite: oferecimento, oração, como vai o dia, um capítulo do Novo Testamento e o Exame.",
         .en: "Five moments, from morning to night: the offering, a prayer, how the day is going, a New Testament chapter and the Examen.",
         .es: "Cinco momentos, de la mañana a la noche: ofrecimiento, oración, cómo va el día, un capítulo del Nuevo Testamento y el Examen."]
    )

    private static let freeStep: PlanStep = (
        [.pt: "A palavra e o santo do dia", .en: "The daily verse and saint", .es: "El versículo y el santo del día"],
        [.pt: "Grátis, todo dia, para sempre.", .en: "Free, every day, forever.", .es: "Gratis, todos los días, para siempre."]
    )

    private static let byMissing: [String: PlanStep] = [
        "understanding": (
            [.pt: "A Missa, parte por parte", .en: "The Mass, part by part", .es: "La Misa, parte por parte"],
            [.pt: "Uma parte curta por dia, para entender o que acontece no altar.",
             .en: "One short part a day, to understand what happens at the altar.",
             .es: "Una parte corta al día, para entender lo que sucede en el altar."]
        ),
        "consistency": (
            [.pt: "Um capítulo por dia", .en: "One chapter a day", .es: "Un capítulo al día"],
            [.pt: "O Novo Testamento inteiro, sem pressa: constância se faz com passos pequenos.",
             .en: "The whole New Testament, without hurry: consistency is built in small steps.",
             .es: "Todo el Nuevo Testamento, sin prisa: la constancia se hace con pasos pequeños."]
        ),
        "peace": (
            [.pt: "Hoje eu estou…", .en: "Today I am…", .es: "Hoy estoy…"],
            [.pt: "Quando o dia pesar, um salmo, um santo e um passo concreto.",
             .en: "When the day weighs heavy, a psalm, a saint and one concrete step.",
             .es: "Cuando el día pese, un salmo, un santo y un paso concreto."]
        ),
        "community": (
            [.pt: "O calendário da Igreja", .en: "The Church's calendar", .es: "El calendario de la Iglesia"],
            [.pt: "O mesmo dia que a Igreja inteira celebra, com o santo e a cor de cada dia.",
             .en: "The same day the whole Church is celebrating, with each day's saint and colour.",
             .es: "El mismo día que celebra toda la Iglesia, con el santo y el color de cada día."]
        ),
    ]
}
