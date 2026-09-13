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
        prayer: "Deus, que ensinastes a vossa serva Notburga a repartir o pouco que tinha, dai-nos a coragem de fazer o que é justo quando isso nos custa. Amém."
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

    static let saintsForYou: [SaintRecommendation] = [
        .init(id: "john-of-the-cross", name: "São João da Cruz", reason: "Escreveu sobre a \"noite escura\" — a oração que não sente nada e continua mesmo assim."),
        .init(id: "teresa-calcutta", name: "Santa Teresa de Calcutá", reason: "Viveu décadas de aridez na oração enquanto servia, e não escondeu isso depois de morta."),
        .init(id: "therese", name: "Santa Teresinha do Menino Jesus", reason: "Descreveu a fé como um túnel escuro, mesmo nos últimos meses de vida."),
        .init(id: "cure-ars", name: "São João Maria Vianney", reason: "Padre que passava horas em confissionário sem sinal algum de consolação sensível."),
    ]

    static let archiveList: [(name: String, subtitle: String, date: String)] = [
        ("Santa Notburga de Eben", "Serva, padroeira dos pobres", "14 de setembro"),
        ("Nossa Senhora das Dores", "Memória", "15 de setembro"),
        ("São Roberto Belarmino", "Bispo e doutor da Igreja", "17 de setembro"),
        ("Santo André Kim Taegon e companheiros", "Mártires da Coreia", "20 de setembro"),
        ("São Mateus", "Apóstolo e evangelista", "21 de setembro"),
        ("São Pio de Pietrelcina", "Presbítero, estigmatizado", "23 de setembro"),
    ]
}
