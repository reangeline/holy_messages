import Foundation

enum OnboardingStep: Equatable {
    case verseIntro
    case promise
    case life(Int)
    case spiritualIntro
    case spiritual(Int)
    case relief
    case prayer
    case loader
    case synthesis
    case signIn
    case orientation
    case notificationTime
    case notificationPreview
    case paywall
}

/// Now trilingual (en/pt/es), keyed first by spirit-2 answer id then by
/// language, since the app unifies onboarding under one interface language.
/// Portuguese psalm renderings reuse the exact wording already used for the
/// same psalms in MockMood.swift, for consistency within the app.
enum OnboardingRelief {
    static let content: [String: [AppLanguage: ReliefContent]] = [
        "tired": [
            .en: ReliefContent(
                title: "Tiredness is not a lack of faith",
                psalmRef: "Psalm 62",
                psalmText: "My soul thirsteth after thee, my flesh, O how many ways! In a desert land, and where there is no way, and no water.",
                psalmWhy: "The psalmist names the thirst before naming any relief — the wanting is already a kind of prayer.",
                saintName: "St. John of the Cross",
                saintWhy: "He called this stretch the \"dark night\" and taught that it purifies faith rather than ending it.",
                stepTitle: "One concrete step",
                stepBody: "Say tonight's Rosary through to the end, even feeling nothing. Faithfulness matters more than feeling here."
            ),
            .pt: ReliefContent(
                title: "O cansaço não é falta de fé",
                psalmRef: "Salmo 62",
                psalmText: "Minha alma tem sede de vós; minha carne vos deseja, como terra árida, sedenta, sem água.",
                psalmWhy: "O salmista nomeia a sede antes de nomear qualquer alívio — o desejo já é uma forma de oração.",
                saintName: "São João da Cruz",
                saintWhy: "Chamou esse período de \"noite escura\" e ensinou que ele purifica a fé em vez de acabar com ela.",
                stepTitle: "Um passo concreto",
                stepBody: "Reze o Terço de hoje até o fim, mesmo sem sentir nada. A fidelidade importa mais que o sentimento aqui."
            ),
            .es: ReliefContent(
                title: "El cansancio no es falta de fe",
                psalmRef: "Salmo 62",
                psalmText: "Mi alma tiene sed de ti, mi carne te desea, como tierra árida, sedienta, sin agua.",
                psalmWhy: "El salmista nombra la sed antes de nombrar cualquier alivio — el deseo ya es una forma de oración.",
                saintName: "San Juan de la Cruz",
                saintWhy: "Llamó a este tramo la \"noche oscura\" y enseñó que purifica la fe en vez de acabar con ella.",
                stepTitle: "Un paso concreto",
                stepBody: "Reza el Rosario de esta noche hasta el final, aunque no sientas nada. Aquí la fidelidad importa más que el sentimiento."
            ),
        ],
        "fear": [
            .en: ReliefContent(
                title: "Fear can be handed over, not just felt",
                psalmRef: "Psalm 55",
                psalmText: "Cast thy care upon the Lord, and he shall sustain thee: he shall not suffer the just to waver for ever.",
                psalmWhy: "\"Cast\" is a verb of action — handing the weight over, not just describing it.",
                saintName: "St. Padre Pio",
                saintWhy: "His advice was \"pray, hope, and don't worry\" — not because it's easy, but because worry alone helps nothing.",
                stepTitle: "One concrete step",
                stepBody: "Take three slow breaths and pray one Our Father slowly, attending to each phrase."
            ),
            .pt: ReliefContent(
                title: "O medo pode ser entregue, não só sentido",
                psalmRef: "Salmo 55",
                psalmText: "Lança sobre o Senhor o teu fardo, e ele te sustentará; jamais permitirá que o justo seja abalado.",
                psalmWhy: "\"Lançar\" é um verbo de ação: entregar o peso, não apenas descrevê-lo.",
                saintName: "São Padre Pio",
                saintWhy: "Aconselhava: \"reze, espere e não se preocupe\" — não porque fosse fácil, mas porque a preocupação sozinha não ajuda.",
                stepTitle: "Um passo concreto",
                stepBody: "Respire fundo três vezes e reze um Pai-Nosso devagar, prestando atenção em cada frase."
            ),
            .es: ReliefContent(
                title: "El miedo se puede entregar, no solo sentir",
                psalmRef: "Salmo 55",
                psalmText: "Encomienda al Señor tu carga, y él te sustentará; jamás permitirá que el justo vacile.",
                psalmWhy: "\"Encomendar\" es un verbo de acción: entregar el peso, no solo describirlo.",
                saintName: "San Padre Pío",
                saintWhy: "Su consejo era \"reza, espera y no te preocupes\" — no porque sea fácil, sino porque preocuparse solo no ayuda en nada.",
                stepTitle: "Un paso concreto",
                stepBody: "Respira profundamente tres veces y reza un Padre Nuestro despacio, prestando atención a cada frase."
            ),
        ],
        "lonely": [
            .en: ReliefContent(
                title: "Loneliness is not the same as being unseen",
                psalmRef: "Psalm 27",
                psalmText: "For my father and my mother have left me: but the Lord hath taken me up.",
                psalmWhy: "The psalmist names abandonment plainly, then names who remains.",
                saintName: "St. Thérèse of Lisieux",
                saintWhy: "She lived her final months in profound spiritual darkness, largely unseen by those around her.",
                stepTitle: "One concrete step",
                stepBody: "Name one person you could reach out to this week — even just to say hello."
            ),
            .pt: ReliefContent(
                title: "Solidão não é o mesmo que ser invisível",
                psalmRef: "Salmo 27",
                psalmText: "Ainda que meu pai e minha mãe me abandonem, o Senhor me acolherá.",
                psalmWhy: "O salmista nomeia o abandono sem rodeios, e depois nomeia quem permanece.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Viveu seus últimos meses numa escuridão espiritual profunda, em grande parte despercebida por quem a cercava.",
                stepTitle: "Um passo concreto",
                stepBody: "Pense em uma pessoa que você poderia procurar essa semana — mesmo que só para dizer olá."
            ),
            .es: ReliefContent(
                title: "La soledad no es lo mismo que ser invisible",
                psalmRef: "Salmo 27",
                psalmText: "Aunque mi padre y mi madre me abandonen, el Señor me acogerá.",
                psalmWhy: "El salmista nombra el abandono sin rodeos, y luego nombra quién permanece.",
                saintName: "Santa Teresita del Niño Jesús",
                saintWhy: "Vivió sus últimos meses en una profunda oscuridad espiritual, en gran parte inadvertida por quienes la rodeaban.",
                stepTitle: "Un paso concreto",
                stepBody: "Piensa en una persona a la que podrías buscar esta semana — aunque sea solo para saludar."
            ),
        ],
        "meaningless": [
            .en: ReliefContent(
                title: "This dryness has a long tradition behind it",
                psalmRef: "Ecclesiastes 1:2",
                psalmText: "Vanity of vanities, said Ecclesiastes: vanity of vanities, and all is vanity.",
                psalmWhy: "Scripture itself contains a whole book that starts from exactly this feeling.",
                saintName: "St. Teresa of Calcutta",
                saintWhy: "She wrote for decades about an interior darkness that never fully lifted, while continuing to serve daily.",
                stepTitle: "One concrete step",
                stepBody: "Do one small, concrete act of service today — the meaning can follow the action instead of preceding it."
            ),
            .pt: ReliefContent(
                title: "Essa aridez tem uma longa tradição por trás",
                psalmRef: "Eclesiastes 1, 2",
                psalmText: "Vaidade das vaidades, diz o Eclesiastes; vaidade das vaidades, tudo é vaidade.",
                psalmWhy: "A própria Escritura tem um livro inteiro que começa exatamente por esse sentimento.",
                saintName: "Santa Teresa de Calcutá",
                saintWhy: "Escreveu por décadas sobre uma escuridão interior que nunca se dissipou de todo, enquanto continuava a servir todos os dias.",
                stepTitle: "Um passo concreto",
                stepBody: "Faça hoje um pequeno gesto concreto de serviço — o sentido pode vir depois da ação, em vez de antes dela."
            ),
            .es: ReliefContent(
                title: "Esta aridez tiene una larga tradición detrás",
                psalmRef: "Eclesiastés 1, 2",
                psalmText: "Vanidad de vanidades, dijo el Eclesiastés; vanidad de vanidades, todo es vanidad.",
                psalmWhy: "La propia Escritura tiene un libro entero que empieza exactamente por este sentimiento.",
                saintName: "Santa Teresa de Calcuta",
                saintWhy: "Escribió durante décadas sobre una oscuridad interior que nunca se disipó del todo, mientras seguía sirviendo cada día.",
                stepTitle: "Un paso concreto",
                stepBody: "Haz hoy un pequeño gesto concreto de servicio — el sentido puede venir después de la acción, en vez de antes."
            ),
        ],
    ]

    static let fallback: [AppLanguage: ReliefContent] = [
        .en: ReliefContent(
            title: "This too is something to bring to prayer",
            psalmRef: "Psalm 34",
            psalmText: "I will bless the Lord at all times: his praise shall be always in my mouth.",
            psalmWhy: "Praise here doesn't require a good day — only a willingness to look toward God again.",
            saintName: "St. Thérèse of Lisieux",
            saintWhy: "She kept to small, ordinary gestures of faith even through months of feeling nothing.",
            stepTitle: "One concrete step",
            stepBody: "Before bed, name one thing from today worth being grateful for — even something small."
        ),
        .pt: ReliefContent(
            title: "Isso também é matéria de oração",
            psalmRef: "Salmo 34",
            psalmText: "Bendirei ao Senhor em todo tempo; o seu louvor estará continuamente na minha boca.",
            psalmWhy: "Um salmo de louvor não exige que o dia tenha sido bom — só que se volte a olhar para Deus.",
            saintName: "Santa Teresinha do Menino Jesus",
            saintWhy: "Atravessou meses sem sentir nada na fé e continuou os pequenos gestos do dia mesmo assim.",
            stepTitle: "Um passo concreto",
            stepBody: "Antes de dormir, nomeie uma coisa de hoje pela qual vale dizer obrigado — mesmo que pequena."
        ),
        .es: ReliefContent(
            title: "Esto también es materia de oración",
            psalmRef: "Salmo 34",
            psalmText: "Bendeciré al Señor en todo tiempo; su alabanza estará siempre en mi boca.",
            psalmWhy: "Un salmo de alabanza no exige que el día haya sido bueno — solo la disposición a volver a mirar a Dios.",
            saintName: "Santa Teresita del Niño Jesús",
            saintWhy: "Atravesó meses sin sentir nada en la fe y aun así siguió con los pequeños gestos del día.",
            stepTitle: "Un paso concreto",
            stepBody: "Antes de dormir, nombra algo de hoy por lo que valga la pena dar gracias — aunque sea pequeño."
        ),
    ]

    static func content(spirit2: String?, language: AppLanguage) -> ReliefContent {
        if let spirit2, let byLanguage = content[spirit2], let match = byLanguage[language] {
            return match
        }
        return fallback[language] ?? fallback[.en]!
    }
}
