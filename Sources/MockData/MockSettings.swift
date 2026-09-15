import Foundation

enum MockSettings {
    static let userName = "Tiago Moreira"
    static let subscriptionStatusLine = "Assinatura anual · renova em 14 de outubro"
    static let buildLine = "Missale 1.0 (build 214) · o que você registra fica neste aparelho."

    static let groups: [SettingsGroup] = [
        .init(id: "account", label: "Conta", items: [
            .init(id: "subscription", title: "Assinatura", subtitle: "Anual · renova em 14 de outubro", value: "Ativa", destination: .subscription),
        ]),
        .init(id: "preferences", label: "Preferências", items: [
            .init(id: "reminders", title: "Horários e lembretes", subtitle: "Leitura diária, Angelus, Divina Misericórdia", value: nil, destination: .reminders),
            .init(id: "calendar", title: "Calendário litúrgico", subtitle: "Região e forma do rito", value: "Estados Unidos", destination: .regionalCalendar),
            .init(id: "language", title: "Idioma", subtitle: "Interface do app", value: nil, destination: .language),
        ]),
        .init(id: "privacy", label: "Privacidade", items: [
            .init(id: "data", title: "Seus dados", subtitle: "Sincronização, exportar, apagar", value: nil, destination: .data),
        ]),
        .init(id: "about", label: "Sobre", items: [
            .init(id: "reviewers", title: "Quem revisou o conteúdo", subtitle: "Com nome, para você poder verificar", value: nil, destination: .reviewers),
            .init(id: "support", title: "Suporte", subtitle: "Gente responde, não um formulário", value: nil, destination: .support),
            .init(id: "terms", title: "Termos de uso", subtitle: "", value: nil, destination: .termsPlaceholder("Termos de uso")),
            .init(id: "privacy-policy", title: "Política de privacidade", subtitle: "", value: nil, destination: .termsPlaceholder("Política de privacidade")),
        ]),
    ]

    static let dailyReadingHours: [(id: String, label: String)] = [
        ("6", "6h"), ("7", "7h"), ("8", "8h"), ("12", "12h"), ("20", "20h"),
    ]
    static let selectedDailyReadingHourID = "7"

    static let reminders: [PrayerItem] = [
        .init(id: "angelus", title: "Angelus", subtitle: "Meio-dia e 18h, no fuso do aparelho", timeLabel: "12h · 18h", reminderEnabled: true),
        .init(id: "mercy", title: "Divina Misericórdia", subtitle: "Coroazinha, na Hora da Misericórdia", timeLabel: "15h", reminderEnabled: true),
        .init(id: "examen", title: "Exame e Completas", subtitle: "Revisão do dia diante de Deus", timeLabel: "21h30", reminderEnabled: true),
        .init(id: "rosary", title: "Terço", subtitle: "Lembrete opcional, sem cobrança se pular", timeLabel: "Sem lembrete", reminderEnabled: false),
    ]

    static let quietHoursNote = "Durante a Missa de domingo e entre 22h e 6h, nada é enviado. Não há como este app te interromper na Missa."

    static let regions: [RegionOption] = [
        .init(id: "us", name: "Estados Unidos", subtitle: "Calendário próprio da USCCB", isSelected: true),
        .init(id: "br", name: "Brasil", subtitle: "Calendário próprio da CNBB", isSelected: false),
        .init(id: "pt", name: "Portugal", subtitle: "Calendário próprio da CEP", isSelected: false),
        .init(id: "mx", name: "México", subtitle: "Calendário próprio do CEM", isSelected: false),
        .init(id: "ie", name: "Irlanda", subtitle: "Calendário próprio do ICBC", isSelected: false),
        .init(id: "general", name: "Calendário romano geral", subtitle: "Sem próprio nacional", isSelected: false),
    ]

    static let regionalEffectNote = "A Ascensão cai no domingo, a Epifania no domingo seguinte a 1º de janeiro, e o dia de hoje mostra também os santos do próprio país."
    static let riteFormNote = "Forma do rito: ordinária e 1962. A trilha da Missa segue a forma escolhida no início, e pode ser trocada na trilha."

    static let dataSyncNote = "Mesmo ligada, o registro de estado e as anotações do Exame não sobem: eles nunca saem deste aparelho. Sincronizam a assinatura, o progresso das trilhas e os terços rezados."
    static let dataExportNote = "Seu calendário, os registros, as intenções e o progresso, em um arquivo legível. Sem conta e sem nuvem no meio."
    static let dataDeleteNote = "Apaga o calendário, os registros, as anotações e o progresso deste aparelho. É imediato e não tem volta — exporte antes, se quiser guardar."
    static let dataPrivacyNote = "Não vendemos dados, não há rastreadores de terceiros e não há anúncios. A analítica é anônima e pode ser desligada abaixo."

    static let reviewers: [ContentReviewer] = [
        .init(id: "1", name: "Pe. Daniel Vasconcelos", role: "Revisão teológica", bio: "Pároco, revisa as trilhas de formação e o conteúdo litúrgico antes de publicar."),
        .init(id: "2", name: "Irmã Clara Times", role: "Revisão pastoral", bio: "Revisa o tom das telas de acompanhamento espiritual e da rede de encaminhamento."),
        .init(id: "3", name: "Marcos Villela", role: "Curadoria bíblica", bio: "Confere referências e traduções bíblicas usadas na palavra do dia."),
    ]

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
