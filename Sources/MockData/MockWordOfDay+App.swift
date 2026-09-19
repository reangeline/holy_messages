import Foundation

/// The parts of MockWordOfDay that depend on the rest of the app's mock data.
/// They live apart because MockWordOfDay.swift itself is compiled into the
/// widget extension too, and a widget has no business pulling in the liturgical
/// calendar or the Mass bulletin — see project.yml.
extension MockWordOfDay {
    static var today: WordOfDay { wordOfDay(for: MockLiturgical.today.dateKey) }

    static let massReadings: [MassReading] = [
        .init(id: "1", kicker: "Primeira leitura", title: "Números 21, 4b-9", summary: "A serpente de bronze no deserto — o sinal que cura quem olha para ele, prefigurando a Cruz."),
        .init(id: "2", kicker: "Salmo responsorial", title: "Salmo 77 (78)", summary: "\"Não esqueçais as obras do Senhor\" — a memória como forma de fidelidade."),
        .init(id: "3", kicker: "Segunda leitura", title: "Filipenses 2, 6-11", summary: "O hino da kenosis: Cristo se esvaziou até a morte de cruz, por isso Deus o exaltou."),
        .init(id: "4", kicker: "Evangelho", title: "João 3, 13-17", summary: "\"Deus amou o mundo de tal maneira que deu o seu Filho unigênito\" — o versículo mais citado da Escritura, no contexto da Cruz."),
    ]

    static let massReadingsFootnote = "Texto integral das leituras sob licença da conferência episcopal. Aqui aparecem a referência e o resumo autoral; o texto completo abre no lecionário licenciado."

    static let shareCardWatermark = "Missale"
}
