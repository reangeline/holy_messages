import Foundation

enum MockSubscription {

    static let hardshipEmail = "acesso@missale.app"

    static let renewalOffDate = "14 de outubro de 2026"

    static let keepsForever = [
        "Seu calendário e tudo o que você registrou",
        "As partes de formação que você já percorreu",
        "Os terços rezados e as intenções",
        "Palavra do dia, santo do dia e o Terço completo",
        "A rede de encaminhamento pastoral",
    ]

    static let cancelWhatHappens = [
        "Você mantém o acesso completo até \(renewalOffDate).",
        "Nada é cobrado depois dessa data.",
        "Nenhum dado é apagado, e nada fica trancado atrás de um aviso.",
    ]

    static let cancelPausedNote = "As trilhas que você ainda não abriu e as festas futuras explicadas. Voltam do ponto onde pararam se você assinar de novo — o progresso não é zerado."
}
