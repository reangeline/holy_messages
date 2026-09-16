import Foundation

enum MockRosary {
    static let mysteries: [RosaryMystery] = [
        .init(mysterySet: .joyful, dayLabel: "Segunda-feira e sábado", decades: [
            "A Anunciação", "A Visitação", "A Natividade", "A Apresentação no Templo", "O Encontro com Jesus no Templo",
        ]),
        .init(mysterySet: .sorrowful, dayLabel: "Terça-feira e sexta-feira", decades: [
            "A Agonia no Horto", "A Flagelação", "A Coroação de Espinhos", "Jesus Carrega a Cruz", "A Crucificação e Morte",
        ]),
        .init(mysterySet: .glorious, dayLabel: "Quarta-feira e domingo", decades: [
            "A Ressurreição", "A Ascensão", "A Descida do Espírito Santo", "A Assunção de Maria", "A Coroação de Maria",
        ]),
        .init(mysterySet: .luminous, dayLabel: "Quinta-feira", decades: [
            "O Batismo no Jordão", "As Bodas de Caná", "O Anúncio do Reino", "A Transfiguração", "A Instituição da Eucaristia",
        ]),
    ]

    /// The traditional weekly schedule (Mon/Sat Joyful, Tue/Fri Sorrowful,
    /// Wed/Sun Glorious, Thu Luminous), keyed off the app's own "today" —
    /// genuinely computed, not a fixed demo value.
    static var todays: RosaryMystery {
        let weekday: Int
        if let date = MockLiturgical.date(fromKey: MockLiturgical.today.dateKey) {
            weekday = Calendar.gregorianUTC.component(.weekday, from: date)
        } else {
            weekday = 2 // Monday fallback
        }
        let set: MysterySet = switch weekday {
        case 1, 4: .glorious   // Sunday, Wednesday
        case 2, 7: .joyful     // Monday, Saturday
        case 3, 6: .sorrowful  // Tuesday, Friday
        default: .luminous     // Thursday
        }
        return mysteries.first { $0.mysterySet == set }!
    }

    static let signOfCross = "Em nome do Pai, e do Filho, e do Espírito Santo. Amém."
    static let apostlesCreed = "Creio em Deus Pai todo-poderoso, criador do céu e da terra, e em Jesus Cristo, seu único Filho, nosso Senhor..."
    static let ourFather = "Pai nosso que estais nos céus, santificado seja o vosso nome. Venha a nós o vosso reino, seja feita a vossa vontade, assim na terra como no céu."
    static let hailMary = "Ave Maria, cheia de graça, o Senhor é convosco, bendita sois vós entre as mulheres e bendito é o fruto do vosso ventre, Jesus."
    static let gloryBe = "Glória ao Pai, e ao Filho, e ao Espírito Santo. Como era no princípio, agora e sempre. Amém."
    static let fatimaPrayer = "Ó meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o céu, principalmente as que mais precisarem."
    static let hailHolyQueen = "Salve, Rainha, Mãe de misericórdia, vida, doçura e esperança nossa, salve! A vós bradamos, os degredados filhos de Eva. A vós suspiramos, gemendo e chorando neste vale de lágrimas. Eia, pois, advogada nossa, esses vossos olhos misericordiosos a nós volvei. E depois deste desterro, mostrai-nos Jesus, bendito fruto do vosso ventre. Ó clemente, ó piedosa, ó doce sempre Virgem Maria!"

    /// The full bead-by-bead sequence for a mystery set, in guided-prayer order.
    static func beads(for mystery: RosaryMystery) -> [RosaryBead] {
        var beads: [RosaryBead] = []
        var i = 0
        func add(_ kind: RosaryBead.BeadKind, decade: Int? = nil) {
            beads.append(.init(index: i, kind: kind, mysteryIndex: decade))
            i += 1
        }
        add(.crucifix)
        add(.creed)
        add(.ourFather)
        for _ in 0..<3 { add(.hailMary) }
        add(.glory)
        for decade in 0..<5 {
            add(.announcement, decade: decade)
            add(.ourFather, decade: decade)
            for _ in 0..<10 { add(.hailMary, decade: decade) }
            add(.glory, decade: decade)
        }
        add(.hailHolyQueen)
        return beads
    }

    static func step(for bead: RosaryBead, mystery: RosaryMystery) -> RosaryPrayerStep {
        let decadeLabel = bead.mysteryIndex.map { "\(ordinal($0 + 1)) mistério \(mystery.mysterySet.rawValue.lowercased()) · \(mystery.decades[$0])" } ?? "Sinal da Cruz"
        switch bead.kind {
        case .crucifix:
            return .init(beadLabel: "Sinal da Cruz", kicker: "Ao segurar o crucifixo", text: signOfCross, hint: "Toque em qualquer lugar para avançar.")
        case .creed:
            return .init(beadLabel: "Credo", kicker: "Na primeira conta", text: apostlesCreed, hint: "O Credo dos Apóstolos, rezado uma vez, prepara a fé antes dos mistérios.")
        case .announcement:
            return .init(beadLabel: decadeLabel, kicker: "Anúncio do mistério", text: mystery.decades[bead.mysteryIndex ?? 0], hint: "Faça uma breve pausa antes do Pai-Nosso desta dezena.")
        case .ourFather:
            return .init(beadLabel: decadeLabel, kicker: "Conta maior", text: ourFather, hint: "Toque em qualquer lugar para avançar. Avanço automático está ligado.")
        case .hailMary:
            return .init(beadLabel: decadeLabel, kicker: "Ave-Maria", text: hailMary, hint: "Dez contas por dezena, meditando o mistério.")
        case .glory:
            return .init(beadLabel: decadeLabel, kicker: "Glória ao Pai", text: gloryBe + "\n\n" + fatimaPrayer, hint: "Fecha a dezena. A próxima começa no anúncio seguinte.")
        case .hailHolyQueen:
            return .init(beadLabel: "Salve Rainha", kicker: "Para encerrar", text: hailHolyQueen, hint: "Encerra o terço. Pode seguir com o Sinal da Cruz.")
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

    static let howTo: [PrayerHowTo] = [
        .init(id: "1", title: "Como segurar e avançar", body: "Segure o crucifixo entre o polegar e o indicador. A cada oração dita, deslize o polegar para a próxima conta — uma conta, uma oração, sempre nessa ordem."),
        .init(id: "2", title: "Por que começa pelo Credo", body: "As três contas iniciais (Credo, um Pai-Nosso, três Ave-Marias) preparam fé, esperança e caridade antes dos mistérios — não são preâmbulo dispensável."),
        .init(id: "3", title: "Por que o Glória fecha a dezena", body: "Cada dezena termina voltando à Trindade, e é o momento tradicional da Oração de Fátima (\"ó meu Jesus, perdoai-nos\") — opcional, por isso vem depois do Glória, não no lugar dele."),
        .init(id: "4", title: "O que fazer com a mente", body: "Não é preciso visualizar nada com perfeição. Basta voltar a atenção ao mistério sempre que ela se perder — isso também é oração."),
        .init(id: "5", title: "E se eu errar a conta?", body: "Não tem problema. O terço não é um exame; se perder a conta, comece a dezena de novo ou apenas continue."),
        .init(id: "6", title: "Quanto tempo leva", body: "O terço completo (cinco dezenas) leva de 18 a 20 minutos rezado com calma. Uma dezena avulsa leva menos de 4."),
        .init(id: "7", title: "Preciso terminar de uma vez?", body: "Não. Pode-se rezar uma dezena por vez ao longo do dia, em família, a dois, ou sozinho no carro — o que der para fazer hoje."),
        .init(id: "8", title: "Posso rezar sem o objeto físico?", body: "Sim — os dedos contam as Ave-Marias tão bem quanto as contas. O terço físico é ajuda, não exigência."),
    ]

    static let examenSteps: [ExamenStep] = [
        .init(number: 1, title: "Gratidão", subtitle: "Reveja o dia e agradeça pelo que houve de bom nele."),
        .init(number: 2, title: "Pedido de luz", subtitle: "Peça ao Espírito Santo para ver o dia com clareza."),
        .init(number: 3, title: "Revisão", subtitle: "Onde houve consolação, e onde houve desolação?"),
        .init(number: 4, title: "Resposta", subtitle: "Peça perdão pelo que precisar, e decida um passo para amanhã."),
    ]
}
