import Foundation

enum MockRosary {
    static let mysteries: [RosaryMystery] = [
        .init(mysterySet: .joyful, dayLabel: "Segunda-feira e sábado", isTodays: true, decades: [
            "A Anunciação", "A Visitação", "A Natividade", "A Apresentação no Templo", "O Encontro com Jesus no Templo",
        ]),
        .init(mysterySet: .sorrowful, dayLabel: "Terça-feira e sexta-feira", isTodays: false, decades: [
            "A Agonia no Horto", "A Flagelação", "A Coroação de Espinhos", "Jesus Carrega a Cruz", "A Crucificação e Morte",
        ]),
        .init(mysterySet: .glorious, dayLabel: "Quarta-feira e domingo", isTodays: false, decades: [
            "A Ressurreição", "A Ascensão", "A Descida do Espírito Santo", "A Assunção de Maria", "A Coroação de Maria",
        ]),
        .init(mysterySet: .luminous, dayLabel: "Quinta-feira", isTodays: false, decades: [
            "O Batismo no Jordão", "As Bodas de Caná", "O Anúncio do Reino", "A Transfiguração", "A Instituição da Eucaristia",
        ]),
    ]

    static let todays = mysteries.first { $0.isTodays }!

    static let signOfCross = "Em nome do Pai, e do Filho, e do Espírito Santo. Amém."
    static let apostlesCreed = "Creio em Deus Pai todo-poderoso, criador do céu e da terra, e em Jesus Cristo, seu único Filho, nosso Senhor..."
    static let ourFather = "Pai nosso que estais nos céus, santificado seja o vosso nome. Venha a nós o vosso reino, seja feita a vossa vontade, assim na terra como no céu."
    static let hailMary = "Ave Maria, cheia de graça, o Senhor é convosco, bendita sois vós entre as mulheres e bendito é o fruto do vosso ventre, Jesus."
    static let gloryBe = "Glória ao Pai, e ao Filho, e ao Espírito Santo. Como era no princípio, agora e sempre. Amém."
    static let fatimaPrayer = "Ó meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o céu, principalmente as que mais precisarem."

    /// The full bead-by-bead sequence for a mystery set, in guided-prayer order.
    static func beads(for mystery: RosaryMystery) -> [RosaryBead] {
        var beads: [RosaryBead] = []
        var i = 0
        func add(_ kind: RosaryBead.BeadKind, decade: Int? = nil) {
            beads.append(.init(index: i, kind: kind, mysteryIndex: decade))
            i += 1
        }
        add(.crucifix)
        add(.ourFather)
        for _ in 0..<3 { add(.hailMary) }
        add(.glory)
        for decade in 0..<5 {
            add(.announcement, decade: decade)
            add(.ourFather, decade: decade)
            for _ in 0..<10 { add(.hailMary, decade: decade) }
            add(.glory, decade: decade)
        }
        return beads
    }

    static func step(for bead: RosaryBead, mystery: RosaryMystery) -> RosaryPrayerStep {
        let decadeLabel = bead.mysteryIndex.map { "\(ordinal($0 + 1)) mistério \(mystery.mysterySet.rawValue.lowercased()) · \(mystery.decades[$0])" } ?? "Sinal da Cruz"
        switch bead.kind {
        case .crucifix:
            return .init(beadLabel: "Sinal da Cruz", kicker: "Ao segurar o crucifixo", text: signOfCross, hint: "Toque em qualquer lugar para avançar.")
        case .announcement:
            return .init(beadLabel: decadeLabel, kicker: "Anúncio do mistério", text: mystery.decades[bead.mysteryIndex ?? 0], hint: "Faça uma breve pausa antes do Pai-Nosso desta dezena.")
        case .ourFather:
            return .init(beadLabel: decadeLabel, kicker: "Conta maior", text: ourFather, hint: "Toque em qualquer lugar para avançar. Avanço automático está ligado.")
        case .hailMary:
            return .init(beadLabel: decadeLabel, kicker: "Ave-Maria", text: hailMary, hint: "Dez contas por dezena, meditando o mistério.")
        case .glory:
            return .init(beadLabel: decadeLabel, kicker: "Glória ao Pai", text: gloryBe + "\n\n" + fatimaPrayer, hint: "Fecha a dezena. A próxima começa no anúncio seguinte.")
        }
    }

    private static func ordinal(_ n: Int) -> String {
        switch n {
        case 1: "Primeiro"
        case 2: "Segundo"
        case 3: "Terceiro"
        case 4: "Quarto"
        case 5: "Quinto"
        default: "\(n)º"
        }
    }

    static let novena = Novena(title: "Novena das 54 dias", currentDay: 23, totalDays: 54)

    static let log: [RosaryLogEntry] = [
        .init(id: "1", title: "Mistérios Gozosos", subtitle: "Guiado · intenção: pela minha mãe", dateLabel: "Ontem"),
        .init(id: "2", title: "Mistérios Dolorosos", subtitle: "Modo iniciante", dateLabel: "Sexta-feira"),
        .init(id: "3", title: "Mistérios Gloriosos", subtitle: "Tela apagada", dateLabel: "Domingo"),
    ]

    static let howTo: [PrayerHowTo] = [
        .init(id: "1", title: "O que fazer com a mente", body: "Não é preciso visualizar nada com perfeição. Basta voltar a atenção ao mistério sempre que ela se perder — isso também é oração."),
        .init(id: "2", title: "E se eu errar a conta?", body: "Não tem problema. O terço não é um exame; se perder a conta, comece a dezena de novo ou apenas continue."),
        .init(id: "3", title: "Preciso terminar de uma vez?", body: "Não. Pode-se rezar uma dezena por vez ao longo do dia, se for o que der para fazer hoje."),
        .init(id: "4", title: "Posso rezar sem o objeto físico?", body: "Sim — os dedos contam as Ave-Marias tão bem quanto as contas. O terço físico é ajuda, não exigência."),
    ]

    static let otherPrayers: [PrayerItem] = [
        .init(id: "angelus", title: "Angelus", subtitle: "Memória da Encarnação, três vezes ao dia", timeLabel: "6h · 12h · 18h", reminderEnabled: true),
        .init(id: "mercy", title: "Coroazinha da Misericórdia", subtitle: "Nove contas, na Hora da Misericórdia", timeLabel: "15h", reminderEnabled: false),
        .init(id: "compline", title: "Completas", subtitle: "Última oração do dia", timeLabel: "21h30", reminderEnabled: true),
        .init(id: "examen", title: "Exame", subtitle: "Revisão do dia diante de Deus", timeLabel: "21h30", reminderEnabled: true),
        .init(id: "litany", title: "Ladainha de Nossa Senhora", subtitle: "Invocações marianas", timeLabel: "Sem lembrete", reminderEnabled: false),
    ]

    static let examenSteps: [ExamenStep] = [
        .init(number: 1, title: "Gratidão", subtitle: "Reveja o dia e agradeça pelo que houve de bom nele."),
        .init(number: 2, title: "Pedido de luz", subtitle: "Peça ao Espírito Santo para ver o dia com clareza."),
        .init(number: 3, title: "Revisão", subtitle: "Onde houve consolação, e onde houve desolação?"),
        .init(number: 4, title: "Resposta", subtitle: "Peça perdão pelo que precisar, e decida um passo para amanhã."),
    ]
}
