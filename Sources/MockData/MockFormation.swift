import Foundation

enum MockFormation {
    static let massPartTitles: [String] = [
        "Antes de tudo: por que ir à Missa",
        "O Sinal da Cruz e a saudação",
        "O Ato Penitencial",
        "O Kyrie",
        "O Glória",
        "A Coleta",
        "A Liturgia da Palavra",
        "O Credo",
        "A Oração dos Fiéis",
        "A Apresentação das Oferendas",
        "A Oração Eucarística",
        "A Consagração",
        "O Pai-Nosso e o Rito da Paz",
        "A Comunhão e o envio",
    ]

    static let atoPenitencial = FormationLesson(
        id: "mass-part-3",
        trackID: "mass-part-by-part",
        partNumber: 3,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Ato Penitencial",
        bodyParagraphs: [
            "Logo depois da saudação, antes de qualquer leitura, a assembleia para e admite que errou. Essa ordem não é casual: a Igreja não começa provando que é digna, começa dizendo que não é.",
            "O gesto de bater no peito acompanha as palavras mea culpa. É antigo, é corporal, e existe porque o corpo participa do que se reconhece. Três vezes, sem pressa.",
            "O que vem depois não é absolvição sacramental: o sacerdote pede a misericórdia, e a Igreja distingue isso da confissão. Pecado grave continua pedindo o sacramento — e é justamente essa distinção que a maioria nunca ouviu explicada.",
            "No domingo, quando o Kyrie for cantado, você vai reconhecer que ele responde ao que acabou de acontecer aqui.",
        ],
        quoteText: "Confesso a Deus todo-poderoso e a vós, irmãos e irmãs, que pequei muitas vezes por pensamentos e palavras, atos e omissões.",
        quoteAttribution: "Texto do Missal, citado como apoio.",
        glossaryTerms: [MockLiturgical.glossaryTerms[0]]
    )

    static let track = FormationTrack(
        id: "mass-part-by-part",
        title: "A Missa, parte por parte",
        meta: "Uma parte por dia, cerca de quatro minutos",
        progress: 3.0 / 14.0,
        nextUp: "Amanhã: O Kyrie",
        lessons: [atoPenitencial]
    )

    // The v1 track list per product spec §5 is: A Missa parte por parte (started,
    // above), Os sete sacramentos, O ano litúrgico, Sinais e símbolos, and As
    // orações explicadas. O Terço do zero and Como se confessar bem are kept as
    // extra tracks beyond that list rather than removed — they're already-written,
    // complementary content, not a gap.
    static let otherTracks: [FormationTrack] = [
        .init(id: "sacraments", title: "Os sete sacramentos", meta: "7 partes · 4 min cada", progress: 0, nextUp: "Parte 1: o que é um sacramento", lessons: []),
        .init(id: "liturgical-year", title: "O Ano Litúrgico", meta: "6 partes · 4 min cada", progress: 0, nextUp: "Parte 1: um ano que não começa em janeiro", lessons: []),
        .init(id: "signs-symbols", title: "Sinais e símbolos", meta: "5 partes · 4 min cada", progress: 0, nextUp: "Parte 1: por que fazemos o sinal da cruz", lessons: []),
        .init(id: "prayers-explained", title: "As orações explicadas", meta: "6 partes · 3 min cada", progress: 0, nextUp: "Parte 1: o Pai-Nosso, linha por linha", lessons: []),
        .init(id: "rosary-basics", title: "O Terço, do zero", meta: "7 partes · 3 min cada", progress: 0, nextUp: "Parte 1: por que rezar com contas", lessons: []),
        .init(id: "confession", title: "Como se confessar bem", meta: "5 partes · 3 min cada", progress: 0, nextUp: "Parte 1: exame de consciência, sem escrúpulo", lessons: []),
        // Spec §10: formation-only, not treatment — freedom/virtue language, never
        // shame, always ending in a real referral (confessor, professional, support
        // group). This pass only seeds the track slot; the lessons and the
        // referral screen are still to be built (posterior per the spec itself).
        .init(id: "freedom-virtue", title: "Liberdade e virtude", meta: "4 partes · 4 min cada", progress: 0, nextUp: "Parte 1: o que o vício imita, e o bem que ele imita", lessons: []),
    ]

    static let reviewerCredit = "Revisão de conteúdo por Pe. Daniel Vasconcelos."
}
