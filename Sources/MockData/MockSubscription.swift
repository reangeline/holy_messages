import Foundation

enum MockSubscription {
    static let plans: [SubscriptionPlan] = [
        .init(id: "monthly", title: "Mensal", rate: "R$ 19,90/mês", subtitle: "Cobrado todo mês", total: "R$ 19,90", badge: nil),
        .init(id: "annual", title: "Anual", rate: "R$ 9,90/mês", subtitle: "Cobrado uma vez por ano", total: "R$ 118,80/ano", badge: "Mais popular"),
        .init(id: "lifetime", title: "Vitalício", rate: "Pagamento único", subtitle: "Acesso para sempre", total: "R$ 349,90", badge: nil),
    ]

    static let hardshipEmail = "contato@missale.app"

    static let renewalOffDate = "14 de outubro"

    static let keepsForever = [
        "Seu calendário e tudo o que você registrou",
        "As partes de formação que você já percorreu",
        "Os terços rezados e as intenções",
        "Palavra do dia, santo do dia e o Terço completo",
    ]
}
