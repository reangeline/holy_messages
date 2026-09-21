import Foundation

/// The Portuguese text here is the source of truth and doubles as the
/// localization key: SettingsView looks each string up in the SettingsDetail
/// table, so the list follows the interface language instead of staying
/// Portuguese in English and Spanish. (That table's other keys are English —
/// mixed, but the alternative was translating the data itself.)
enum MockSettings {
    static let subscriptionStatusLine = "Assinatura anual · renova em 14 de outubro"
    static let buildLine = "Missale 1.0 (build 214) · o que você registra fica neste aparelho."

    static let groups: [SettingsGroup] = [
        .init(id: "account", label: "Conta", items: [
            .init(id: "subscription", title: "Assinatura", subtitle: "Anual · renova em 14 de outubro", value: "Ativa", destination: .subscription),
        ]),
        .init(id: "preferences", label: "Preferências", items: [
            .init(id: "calendar", title: "Calendário litúrgico", subtitle: "Região e forma do rito", value: nil, destination: .regionalCalendar),
            .init(id: "language", title: "Idioma", subtitle: "Interface do app", value: nil, destination: .language),
        ]),
        .init(id: "privacy", label: "Privacidade", items: [
            .init(id: "data", title: "Seus dados", subtitle: "Sincronização, exportar, apagar", value: nil, destination: .data),
        ]),
        .init(id: "about", label: "Sobre", items: [
            .init(id: "support", title: "Suporte", subtitle: "Gente responde, não um formulário", value: nil, destination: .support),
            .init(id: "terms", title: "Termos de uso", subtitle: "", value: nil, destination: .legal(.terms)),
            .init(id: "privacy-policy", title: "Política de privacidade", subtitle: "", value: nil, destination: .legal(.privacy)),
        ]),
    ]

    static let dailyReadingHours: [(id: String, label: String)] = [
        ("6", "6h"), ("7", "7h"), ("8", "8h"), ("12", "12h"), ("20", "20h"),
    ]
    static let selectedDailyReadingHourID = "7"


    static let quietHoursNote = "Durante a Missa de domingo e entre 22h e 6h, nada é enviado. Não há como este app te interromper na Missa."

    static let regions: [RegionOption] = [
        .init(id: "us", name: "Estados Unidos", subtitle: "Calendário próprio da USCCB", isSelected: true),
        .init(id: "br", name: "Brasil", subtitle: "Calendário próprio da CNBB", isSelected: false),
        .init(id: "pt", name: "Portugal", subtitle: "Calendário próprio da CEP", isSelected: false),
        .init(id: "mx", name: "México", subtitle: "Calendário próprio do CEM", isSelected: false),
        .init(id: "ie", name: "Irlanda", subtitle: "Calendário próprio do ICBC", isSelected: false),
        .init(id: "general", name: "Calendário romano geral", subtitle: "Sem próprio nacional", isSelected: false),
    ]

    /// The calendar a person most likely wants before touching the picker,
    /// taken from the interface language instead of a hardcoded country: pt is
    /// Brazil, en the United States, es Mexico — the three regions the content
    /// catalogs are being authored for.
    /// The region currently in force: what was stored, or the language's default
    /// when nothing was ever chosen. Both the Settings row and the picker screen
    /// resolve through here — the row showing a fixed mock value was why going
    /// back from the picker still displayed the previous calendar.
    static func selectedRegion(stored: String, language: AppLanguage) -> RegionOption? {
        let id = stored.isEmpty ? defaultRegionID(for: language) : stored
        return regions.first { $0.id == id }
    }

    static func defaultRegionID(for language: AppLanguage) -> String {
        switch language {
        case .pt: "br"
        case .en: "us"
        case .es: "mx"
        }
    }

    static let regionalEffectNote = "A Ascensão cai no domingo, a Epifania no domingo seguinte a 1º de janeiro, e o dia de hoje mostra também os santos do próprio país."
    static let riteFormNote = "Forma do rito: ordinária e 1962. A trilha da Missa segue a forma escolhida no início, e pode ser trocada na trilha."

    static let dataSyncNote = "Mesmo ligada, o registro de estado e as anotações do Exame não sobem: eles nunca saem deste aparelho. Sincronizam a assinatura, o progresso das trilhas e os terços rezados."
    static let dataExportNote = "Seu calendário, os registros, as intenções e o progresso, em um arquivo legível. Sem conta e sem nuvem no meio."
    static let dataDeleteNote = "Apaga o calendário, os registros, as anotações e o progresso deste aparelho. É imediato e não tem volta — exporte antes, se quiser guardar."
    static let dataPrivacyNote = "Não vendemos dados, não há rastreadores de terceiros e não há anúncios. A analítica é anônima e pode ser desligada abaixo."


    static let contentProcessNote = "Os textos explicativos são autorais e passam por revisão antes de publicar. Citações litúrgicas aparecem como apoio, com a fonte. Encontrou um erro doutrinal? Escreva — corrigimos e registramos a correção."
    static let errorsEmail = "erros@missale.app"
    static let licensingNote = "As traduções litúrgicas usadas neste app estão licenciadas junto à conferência episcopal correspondente. As bíblicas são de domínio público, com a versão indicada em cada texto."

    static let supportEmail = "ola@missale.app"
    static let accessEmail = "acesso@missale.app"

    static let faq: [FAQItem] = [
        .init(id: "1", question: "Por que o app tem cor diferente todo dia?", answer: "A cor segue a liturgia do dia — vermelho para mártires e a Cruz, roxo no Advento e na Quaresma, branco nas solenidades, verde no Tempo Comum. Não é personalização, é o calendário da Igreja."),
        .init(id: "2", question: "Meus registros de humor ficam salvos onde?", answer: "Só neste aparelho. Não sobem nem com a sincronização ligada — veja Seus dados."),
        .init(id: "3", question: "O app substitui a confissão?", answer: "Não, de jeito nenhum. Veja a Nota pastoral para as três declarações completas sobre o que este app é e não é."),
        .init(id: "4", question: "Posso usar sem pagar?", answer: "Sim — palavra do dia, santo do dia, o Terço completo e a rede pastoral são grátis para sempre. E se o preço for o problema para o resto, escreva para nós."),
        .init(id: "5", question: "Como funciona o calendário do meu país?", answer: "Cada conferência episcopal tem um calendário próprio sobre o romano geral, com datas e santos específicos. Escolha o seu em Calendário litúrgico."),
        .init(id: "6", question: "Posso cancelar quando quiser?", answer: "Sim, sem perguntas de saída e sem oferta de desconto. Veja Assinatura → Cancelar a renovação."),
    ]
}
