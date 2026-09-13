import Foundation

enum MockMood {
    static let stateGroups: [MoodStateGroup] = [
        .init(id: "consolation", label: "Consolação", items: [
            .init(id: "peace", label: "Em paz"),
            .init(id: "grateful", label: "Grato"),
            .init(id: "hopeful", label: "Esperançoso"),
            .init(id: "joyful", label: "Alegre"),
            .init(id: "trusting", label: "Confiante"),
        ]),
        .init(id: "desolation", label: "Desolação", items: [
            .init(id: "dryness", label: "Árido na oração"),
            .init(id: "anxious", label: "Ansioso"),
            .init(id: "sad", label: "Triste"),
            .init(id: "doubtful", label: "Em dúvida"),
            .init(id: "tired", label: "Cansado"),
            .init(id: "grief", label: "Enlutado", isCrisisTrigger: true),
            .init(id: "resentful", label: "Ressentido", isCrisisTrigger: true),
            .init(id: "guilty", label: "Culpado", isCrisisTrigger: true, isScrupulosityTrigger: true),
            .init(id: "shame_confession", label: "Vergonha, faz tempo que não me confesso", isScrupulosityTrigger: true),
        ]),
    ]

    /// Shown as a discreet, one-line nudge inside the relief screen the 1st/2nd time
    /// a scrupulosity-trigger state is logged within 14 days (3rd time redirects
    /// outright — see MoodHistoryStore.scrupulosityShouldRedirect).
    static let confessorNudgeLine = "Se isso for sobre um pecado específico, um confessor fixo resolve melhor do que reler isto de novo."

    static let defaultRelief = ReliefContent(
        title: "Isso também é matéria de oração",
        psalmRef: "Salmo 34",
        psalmText: "Bendirei ao Senhor em todo tempo; o seu louvor estará continuamente na minha boca.",
        psalmWhy: "Um salmo de louvor não exige que o dia tenha sido bom — só que se volte a olhar para Deus.",
        saintName: "Santa Teresinha do Menino Jesus",
        saintWhy: "Atravessou meses sem sentir nada na fé e continuou os pequenos gestos do dia mesmo assim.",
        stepTitle: "Um passo concreto",
        stepBody: "Antes de dormir, nomeie uma coisa de hoje pela qual vale dizer obrigado — mesmo que pequena."
    )

    static let reliefByState: [String: ReliefContent] = [
        "dryness": ReliefContent(
            title: "A aridez também é oração",
            psalmRef: "Salmo 62",
            psalmText: "Minha alma tem sede de vós; minha carne vos deseja, como terra árida, sedenta, sem água.",
            psalmWhy: "O salmista descreve a sede antes de descrever a saciedade — a busca já é o começo da resposta.",
            saintName: "São João da Cruz",
            saintWhy: "Chamou esse deserto de \"noite escura\" e ensinou que ele purifica em vez de destruir a fé.",
            stepTitle: "Um passo concreto",
            stepBody: "Reze o Terço de hoje até o fim, mesmo sem sentir nada. A fidelidade, aqui, importa mais que o sentimento."
        ),
        "sad": ReliefContent(
            title: "A tristeza não precisa ser escondida de Deus",
            psalmRef: "Salmo 42",
            psalmText: "Por que estás abatida, ó minha alma, e por que te perturbas dentro de mim? Espera em Deus.",
            psalmWhy: "O salmista fala consigo mesmo, admitindo a tristeza antes de decidir esperar.",
            saintName: "Santa Teresa de Calcutá",
            saintWhy: "Viveu décadas de escuridão interior enquanto servia os mais pobres, sem esconder a dificuldade em cartas.",
            stepTitle: "Um passo concreto",
            stepBody: "Escreva uma linha sobre o que pesa hoje — só para você, sem precisar resolver nada agora."
        ),
        "anxious": ReliefContent(
            title: "A ansiedade também pode virar oração",
            psalmRef: "Salmo 55",
            psalmText: "Lança sobre o Senhor o teu fardo, e ele te sustentará; jamais permitirá que o justo seja abalado.",
            psalmWhy: "\"Lançar\" é um verbo de ação: entregar o peso, não apenas descrevê-lo.",
            saintName: "São Padre Pio",
            saintWhy: "Aconselhava: \"reze, espere e não se preocupe\" — não porque fosse fácil, mas porque a preocupação sozinha não ajuda.",
            stepTitle: "Um passo concreto",
            stepBody: "Respire fundo três vezes e reze um Pai-Nosso devagar, prestando atenção em cada palavra."
        ),
    ]

    static func relief(for stateID: String) -> ReliefContent {
        reliefByState[stateID] ?? defaultRelief
    }

    static let pastoralCareParishName = "Paróquia Nossa Senhora Aparecida"
}
