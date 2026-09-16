import Foundation

enum MockRosary {
    static let mysteries: [RosaryMystery] = [
        .init(mysterySet: .joyful, dayLabel: "Segunda-feira e sábado", decades: [
            .init(title: "A Anunciação", description: "O Anjo Gabriel anuncia à Virgem Maria que ela conceberá o Filho de Deus pelo poder do Espírito Santo, e ela aceita ser a Mãe do Salvador.", fruit: "A humildade e a aceitação da vontade de Deus.", scriptureRef: "Lucas 1, 26-38"),
            .init(title: "A Visitação", description: "Nossa Senhora visita sua prima Santa Isabel, levando Jesus em seu ventre.", fruit: "A caridade e o amor ao próximo.", scriptureRef: "Lucas 1, 39-56"),
            .init(title: "A Natividade", description: "O Nascimento de Jesus na gruta de Belém.", fruit: "O desapego dos bens da Terra e a pobreza de espírito.", scriptureRef: "Lucas 2, 1-20"),
            .init(title: "A Apresentação no Templo", description: "A Apresentação do Menino Jesus no Templo e a Purificação de Maria.", fruit: "A obediência e a pureza de coração.", scriptureRef: "Lucas 2, 22-40"),
            .init(title: "O Encontro com Jesus no Templo", description: "O reencontro de Jesus no Templo, entre os doutores da Lei.", fruit: "A busca por Deus e a fidelidade aos Seus ensinamentos.", scriptureRef: "Lucas 2, 41-52"),
        ]),
        .init(mysterySet: .sorrowful, dayLabel: "Terça-feira e sexta-feira", decades: [
            .init(title: "A Agonia no Horto", description: "A Agonia de Jesus no Horto das Oliveiras.", fruit: "A contrição dos pecados e a oração perseverante.", scriptureRef: "Mateus 26, 36-46 (também em Lucas 22, 39-46)"),
            .init(title: "A Flagelação", description: "A Flagelação de Nosso Senhor Jesus Cristo, atado à coluna.", fruit: "A mortificação dos sentidos e a pureza do corpo.", scriptureRef: "Mateus 27, 26 (também em Marcos 15, 15 e João 19, 1)"),
            .init(title: "A Coroação de Espinhos", description: "A Coroação de espinhos de Jesus.", fruit: "O desprezo do orgulho humano e a pureza da mente.", scriptureRef: "Mateus 27, 27-31 (também em João 19, 2-3)"),
            .init(title: "Jesus Carrega a Cruz", description: "Jesus carregando a Cruz pesada a caminho do Calvário.", fruit: "A paciência nas tribulações e a aceitação dos nossos sofrimentos.", scriptureRef: "Lucas 23, 26-32 (também em João 19, 16-17)"),
            .init(title: "A Crucificação e Morte", description: "A Crucificação, agonia e morte de Jesus na Cruz.", fruit: "O amor a Deus, o perdão dos inimigos e a salvação das almas.", scriptureRef: "Lucas 23, 33-49 (também em João 19, 18-30)"),
        ]),
        .init(mysterySet: .glorious, dayLabel: "Quarta-feira e domingo", decades: [
            .init(title: "A Ressurreição", description: "A Ressurreição de Nosso Senhor Jesus Cristo.", fruit: "A fé e a certeza da vida eterna.", scriptureRef: "Mateus 28, 1-10 (também em Lucas 24, 1-12 e João 20, 1-18)"),
            .init(title: "A Ascensão", description: "A Ascensão de Jesus ao Céu.", fruit: "A esperança e o desejo das realidades celestiais.", scriptureRef: "Atos dos Apóstolos 1, 6-11 (também em Lucas 24, 50-53)"),
            .init(title: "A Descida do Espírito Santo", description: "A Descida do Espírito Santo sobre Maria e os Apóstolos no Cenáculo, em Pentecostes.", fruit: "O zelo apostólico e os dons do Espírito Santo.", scriptureRef: "Atos dos Apóstolos 2, 1-13"),
            .init(title: "A Assunção de Maria", description: "A Assunção de Nossa Senhora ao Céu em corpo e alma.", fruit: "A graça de uma boa morte e a união filial com Maria.", scriptureRef: "Sem relato explícito nos Evangelhos — a tradição se apoia em Apocalipse 12, 1 e Cântico dos Cânticos 2, 10-11"),
            .init(title: "A Coroação de Maria", description: "A Coroação de Maria Santíssima como Rainha dos Céus e da Terra.", fruit: "A perseverança final e a total confiança na realeza de Maria.", scriptureRef: "Também associado a Apocalipse 12, 1"),
        ]),
        .init(mysterySet: .luminous, dayLabel: "Quinta-feira", decades: [
            .init(title: "O Batismo no Jordão", description: "O Batismo de Jesus no Rio Jordão pelas mãos de João Batista.", fruit: "A fidelidade às promessas do Batismo e o estado de graça.", scriptureRef: "Mateus 3, 13-17 (também em Marcos 1, 9-11 e Lucas 3, 21-22)"),
            .init(title: "As Bodas de Caná", description: "A autorrevelação de Jesus nas Bodas de Caná, seu primeiro milagre, por intercessão de Maria.", fruit: "A confiança na intercessão de Maria e a santificação das famílias.", scriptureRef: "João 2, 1-12"),
            .init(title: "O Anúncio do Reino", description: "O anúncio do Reino de Deus, com o convite à conversão.", fruit: "O arrependimento dos pecados e o desejo de santidade.", scriptureRef: "Marcos 1, 14-15 (também em Mateus 4, 17)"),
            .init(title: "A Transfiguração", description: "A Transfiguração de Jesus no Monte Tabor, diante de Pedro, Tiago e João.", fruit: "O desejo de contemplar a face de Deus e a renovação espiritual.", scriptureRef: "Mateus 17, 1-9 (também em Marcos 9, 2-10 e Lucas 9, 28-36)"),
            .init(title: "A Instituição da Eucaristia", description: "A Instituição da Eucaristia na Última Ceia.", fruit: "A devoção ao Santíssimo Sacramento e a comunhão frequente.", scriptureRef: "Mateus 26, 26-29 (também em Lucas 22, 14-20 e 1 Coríntios 11, 23-25)"),
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
    static let apostlesCreed = "Creio em Deus Pai todo-poderoso, criador do céu e da terra. E em Jesus Cristo, seu único Filho, nosso Senhor, que foi concebido pelo poder do Espírito Santo, nasceu da Virgem Maria, padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado, desceu à mansão dos mortos, ressuscitou ao terceiro dia, subiu aos céus, está sentado à direita de Deus Pai todo-poderoso, donde há de vir a julgar os vivos e os mortos. Creio no Espírito Santo, na santa Igreja Católica, na comunhão dos santos, na remissão dos pecados, na ressurreição da carne, na vida eterna. Amém."
    static let ourFather = "Pai nosso, que estais nos céus, santificado seja o vosso nome, venha a nós o vosso reino, seja feita a vossa vontade, assim na terra como no céu. O pão nosso de cada dia nos dai hoje, perdoai-nos as nossas ofensas, assim como nós perdoamos a quem nos tem ofendido, e não nos deixeis cair em tentação, mas livrai-nos do mal. Amém."
    static let hailMary = "Ave Maria, cheia de graça, o Senhor é convosco, bendita sois vós entre as mulheres e bendito é o fruto do vosso ventre, Jesus. Santa Maria, Mãe de Deus, rogai por nós pecadores, agora e na hora da nossa morte. Amém."
    static let gloryBe = "Glória ao Pai, e ao Filho, e ao Espírito Santo. Como era no princípio, agora e sempre. Amém."
    static let fatimaPrayer = "Ó meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o céu, principalmente as que mais precisarem."
    static let hailHolyQueen = "Salve, Rainha, Mãe de misericórdia, vida, doçura e esperança nossa, salve! A vós bradamos, os degredados filhos de Eva. A vós suspiramos, gemendo e chorando neste vale de lágrimas. Eia, pois, advogada nossa, esses vossos olhos misericordiosos a nós volvei. E depois deste desterro, mostrai-nos Jesus, bendito fruto do vosso ventre. Ó clemente, ó piedosa, ó doce sempre Virgem Maria!"
    static let offeringPrayer = "Divino Jesus, nós Vos oferecemos este terço que vamos rezar, meditando nos mistérios da Vossa Redenção. Concedei-nos, por intercessão de Maria, Vossa Mãe Santíssima, a quem nos dirigimos, as virtudes necessárias para bem rezá-lo e a graça de ganharmos as indulgências anexas a esta santa devoção."
    static let intentionsPrompt = "Pessoais — um pedido de conversão, paciência, discernimento para uma decisão, ou a cura de alguma enfermidade. Pelos outros — familiares, amigos, doentes, desempregados, ou alguém que pediu suas orações. Sociais e universais — as almas do purgatório, o Papa, a Igreja, o fim das guerras, os mais necessitados. Agradecimento — por uma graça já alcançada ou pela proteção de cada dia."

    /// The full bead-by-bead sequence for a mystery set, in guided-prayer order.
    static func beads(for mystery: RosaryMystery) -> [RosaryBead] {
        var beads: [RosaryBead] = []
        var i = 0
        func add(_ kind: RosaryBead.BeadKind, decade: Int? = nil) {
            beads.append(.init(index: i, kind: kind, mysteryIndex: decade))
            i += 1
        }
        add(.crucifix)
        add(.intentions)
        add(.offering)
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
        let detail = bead.mysteryIndex.map { mystery.decades[$0] }
        let decadeLabel = detail.map { "\(ordinal((bead.mysteryIndex ?? 0) + 1)) mistério \(mystery.mysterySet.rawValue.lowercased()) · \($0.title)" } ?? "Sinal da Cruz"
        switch bead.kind {
        case .crucifix:
            return .init(beadLabel: "Sinal da Cruz", kicker: "Ao segurar o crucifixo", text: signOfCross, hint: "Toque em qualquer lugar para avançar.")
        case .intentions:
            return .init(beadLabel: "Intenções", kicker: "Por quem você reza hoje", text: intentionsPrompt, hint: "Exemplo: \u{201C}Ofereço este terço pela saúde da minha família, pela paz no mundo e por uma graça particular que necessito.\u{201D}")
        case .offering:
            return .init(beadLabel: "Oferecimento do terço", kicker: "Antes de começar", text: offeringPrayer, hint: "Tradicional, e opcional — oferece o terço inteiro antes da primeira conta.")
        case .creed:
            return .init(beadLabel: "Credo", kicker: "Na primeira conta", text: apostlesCreed, hint: "O Credo dos Apóstolos, rezado uma vez, prepara a fé antes dos mistérios.")
        case .announcement:
            let d = detail!
            return .init(beadLabel: decadeLabel, kicker: "Anúncio do mistério", text: d.description, hint: "Faça uma breve pausa antes do Pai-Nosso desta dezena.", fruit: d.fruit, scriptureRef: d.scriptureRef)
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
