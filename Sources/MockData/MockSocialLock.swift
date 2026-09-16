import Foundation

enum MockSocialLock {
    /// Triggers anchored to the Church's own hours and disciplines, not generic
    /// "focus time" — see spec §8.1. Angelus and Lent start enabled to match the
    /// spec's own emphasis on them (the traditional triple Angelus, and Lent as
    /// the single best acquisition/engagement window of the year).
    static let rules: [SocialLockRule] = [
        .init(id: "angelus", title: "Angelus", subtitle: "Meio-dia e 18h", detail: "Três minutos, duas vezes ao dia — três, se quiser o tríplice tradicional às 6h.", isEnabled: true),
        .init(id: "hours", title: "Horas da Liturgia das Horas", subtitle: "Laudes, Vésperas, Completas", detail: "Uma janela curta em cada uma, no horário que você já reza.", isEnabled: false),
        .init(id: "mercy", title: "Terço da Divina Misericórdia", subtitle: "15h", detail: "A Hora da Misericórdia, todos os dias.", isEnabled: false),
        .init(id: "friday", title: "Sexta-feira, dia de penitência", subtitle: "Janela da tarde", detail: "Uma janela mais longa, lembrando a disciplina tradicional de sexta-feira.", isEnabled: false),
        .init(id: "eucharistic-fast", title: "Jejum eucarístico", subtitle: "A hora antes da comunhão", detail: "Exige saber o horário da sua Missa — configure abaixo quando for construído de verdade.", isEnabled: false),
        .init(id: "mass-adoration", title: "Duração da Missa e adoração", subtitle: "Manual, por enquanto", detail: "Ativar manualmente quando for à Missa ou à adoração.", isEnabled: false),
    ]

    static let lentWindowNote = "Quaresma inteira, 5 de março a 17 de abril, com exceção dos domingos — o jejum tradicional de redes sociais. Configurável como período único de 40 dias."
}
