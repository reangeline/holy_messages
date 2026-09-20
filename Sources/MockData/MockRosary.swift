import Foundation

enum MockRosary {
    /// Each language is its own catalog, not a translation of the Portuguese
    /// one — the English mystery names, fruits and prayer texts are the fixed
    /// English Catholic wordings. A language with no catalog falls back to
    /// Portuguese; see LocalizedCatalog.
    static var mysteries: [RosaryMystery] { mysteryCatalog.current }

    static let mysteryCatalog = LocalizedCatalog(pt: ptMysteries, en: enMysteries)

    private static let ptMysteries: [RosaryMystery] = [
        .init(mysterySet: .joyful, decades: [
            .init(title: "A Anunciação", description: "O Anjo Gabriel anuncia à Virgem Maria que ela conceberá o Filho de Deus pelo poder do Espírito Santo, e ela aceita ser a Mãe do Salvador.", fruit: "A humildade e a aceitação da vontade de Deus.", scriptureRef: "Lucas 1, 26-38"),
            .init(title: "A Visitação", description: "Nossa Senhora visita sua prima Santa Isabel, levando Jesus em seu ventre.", fruit: "A caridade e o amor ao próximo.", scriptureRef: "Lucas 1, 39-56"),
            .init(title: "A Natividade", description: "O Nascimento de Jesus na gruta de Belém.", fruit: "O desapego dos bens da Terra e a pobreza de espírito.", scriptureRef: "Lucas 2, 1-20"),
            .init(title: "A Apresentação no Templo", description: "A Apresentação do Menino Jesus no Templo e a Purificação de Maria.", fruit: "A obediência e a pureza de coração.", scriptureRef: "Lucas 2, 22-40"),
            .init(title: "O Encontro com Jesus no Templo", description: "O reencontro de Jesus no Templo, entre os doutores da Lei.", fruit: "A busca por Deus e a fidelidade aos Seus ensinamentos.", scriptureRef: "Lucas 2, 41-52"),
        ]),
        .init(mysterySet: .sorrowful, decades: [
            .init(title: "A Agonia no Horto", description: "A Agonia de Jesus no Horto das Oliveiras.", fruit: "A contrição dos pecados e a oração perseverante.", scriptureRef: "Mateus 26, 36-46 (também em Lucas 22, 39-46)"),
            .init(title: "A Flagelação", description: "A Flagelação de Nosso Senhor Jesus Cristo, atado à coluna.", fruit: "A mortificação dos sentidos e a pureza do corpo.", scriptureRef: "Mateus 27, 26 (também em Marcos 15, 15 e João 19, 1)"),
            .init(title: "A Coroação de Espinhos", description: "A Coroação de espinhos de Jesus.", fruit: "O desprezo do orgulho humano e a pureza da mente.", scriptureRef: "Mateus 27, 27-31 (também em João 19, 2-3)"),
            .init(title: "Jesus Carrega a Cruz", description: "Jesus carregando a Cruz pesada a caminho do Calvário.", fruit: "A paciência nas tribulações e a aceitação dos nossos sofrimentos.", scriptureRef: "Lucas 23, 26-32 (também em João 19, 16-17)"),
            .init(title: "A Crucificação e Morte", description: "A Crucificação, agonia e morte de Jesus na Cruz.", fruit: "O amor a Deus, o perdão dos inimigos e a salvação das almas.", scriptureRef: "Lucas 23, 33-49 (também em João 19, 18-30)"),
        ]),
        .init(mysterySet: .glorious, decades: [
            .init(title: "A Ressurreição", description: "A Ressurreição de Nosso Senhor Jesus Cristo.", fruit: "A fé e a certeza da vida eterna.", scriptureRef: "Mateus 28, 1-10 (também em Lucas 24, 1-12 e João 20, 1-18)"),
            .init(title: "A Ascensão", description: "A Ascensão de Jesus ao Céu.", fruit: "A esperança e o desejo das realidades celestiais.", scriptureRef: "Atos dos Apóstolos 1, 6-11 (também em Lucas 24, 50-53)"),
            .init(title: "A Descida do Espírito Santo", description: "A Descida do Espírito Santo sobre Maria e os Apóstolos no Cenáculo, em Pentecostes.", fruit: "O zelo apostólico e os dons do Espírito Santo.", scriptureRef: "Atos dos Apóstolos 2, 1-13"),
            .init(title: "A Assunção de Maria", description: "A Assunção de Nossa Senhora ao Céu em corpo e alma.", fruit: "A graça de uma boa morte e a união filial com Maria.", scriptureRef: "Sem relato explícito nos Evangelhos — a tradição se apoia em Apocalipse 12, 1 e Cântico dos Cânticos 2, 10-11"),
            .init(title: "A Coroação de Maria", description: "A Coroação de Maria Santíssima como Rainha dos Céus e da Terra.", fruit: "A perseverança final e a total confiança na realeza de Maria.", scriptureRef: "Também associado a Apocalipse 12, 1"),
        ]),
        .init(mysterySet: .luminous, decades: [
            .init(title: "O Batismo no Jordão", description: "O Batismo de Jesus no Rio Jordão pelas mãos de João Batista.", fruit: "A fidelidade às promessas do Batismo e o estado de graça.", scriptureRef: "Mateus 3, 13-17 (também em Marcos 1, 9-11 e Lucas 3, 21-22)"),
            .init(title: "As Bodas de Caná", description: "A autorrevelação de Jesus nas Bodas de Caná, seu primeiro milagre, por intercessão de Maria.", fruit: "A confiança na intercessão de Maria e a santificação das famílias.", scriptureRef: "João 2, 1-12"),
            .init(title: "O Anúncio do Reino", description: "O anúncio do Reino de Deus, com o convite à conversão.", fruit: "O arrependimento dos pecados e o desejo de santidade.", scriptureRef: "Marcos 1, 14-15 (também em Mateus 4, 17)"),
            .init(title: "A Transfiguração", description: "A Transfiguração de Jesus no Monte Tabor, diante de Pedro, Tiago e João.", fruit: "O desejo de contemplar a face de Deus e a renovação espiritual.", scriptureRef: "Mateus 17, 1-9 (também em Marcos 9, 2-10 e Lucas 9, 28-36)"),
            .init(title: "A Instituição da Eucaristia", description: "A Instituição da Eucaristia na Última Ceia.", fruit: "A devoção ao Santíssimo Sacramento e a comunhão frequente.", scriptureRef: "Mateus 26, 26-29 (também em Lucas 22, 14-20 e 1 Coríntios 11, 23-25)"),
        ]),
    ]

    private static let enMysteries: [RosaryMystery] = [
        .init(mysterySet: .joyful, decades: [
            .init(title: "The Annunciation", description: "The Angel Gabriel announces to the Virgin Mary that she will conceive the Son of God by the power of the Holy Spirit, and she consents to be the Mother of the Saviour.", fruit: "Humility and acceptance of God's will.", scriptureRef: "Luke 1:26-38"),
            .init(title: "The Visitation", description: "Our Lady visits her cousin Saint Elizabeth, carrying Jesus in her womb.", fruit: "Charity and love of neighbour.", scriptureRef: "Luke 1:39-56"),
            .init(title: "The Nativity", description: "The birth of Jesus in the cave at Bethlehem.", fruit: "Detachment from the goods of this world and poverty of spirit.", scriptureRef: "Luke 2:1-20"),
            .init(title: "The Presentation in the Temple", description: "The presentation of the Child Jesus in the Temple and the purification of Mary.", fruit: "Obedience and purity of heart.", scriptureRef: "Luke 2:22-40"),
            .init(title: "The Finding in the Temple", description: "Finding Jesus again in the Temple, among the teachers of the Law.", fruit: "The search for God and fidelity to his teaching.", scriptureRef: "Luke 2:41-52"),
        ]),
        .init(mysterySet: .sorrowful, decades: [
            .init(title: "The Agony in the Garden", description: "The agony of Jesus in the Garden of Olives.", fruit: "Contrition for sin and perseverance in prayer.", scriptureRef: "Matthew 26:36-46 (also Luke 22:39-46)"),
            .init(title: "The Scourging at the Pillar", description: "The scourging of Our Lord Jesus Christ, bound to the pillar.", fruit: "Mortification of the senses and purity of body.", scriptureRef: "Matthew 27:26 (also Mark 15:15 and John 19:1)"),
            .init(title: "The Crowning with Thorns", description: "The crowning of Jesus with thorns.", fruit: "Contempt for human pride and purity of mind.", scriptureRef: "Matthew 27:27-31 (also John 19:2-3)"),
            .init(title: "The Carrying of the Cross", description: "Jesus carrying the heavy Cross on the way to Calvary.", fruit: "Patience in trials and acceptance of our own suffering.", scriptureRef: "Luke 23:26-32 (also John 19:16-17)"),
            .init(title: "The Crucifixion and Death", description: "The crucifixion, agony and death of Jesus on the Cross.", fruit: "Love of God, forgiveness of enemies and the salvation of souls.", scriptureRef: "Luke 23:33-49 (also John 19:18-30)"),
        ]),
        .init(mysterySet: .glorious, decades: [
            .init(title: "The Resurrection", description: "The resurrection of Our Lord Jesus Christ.", fruit: "Faith and the certainty of eternal life.", scriptureRef: "Matthew 28:1-10 (also Luke 24:1-12 and John 20:1-18)"),
            .init(title: "The Ascension", description: "The ascension of Jesus into heaven.", fruit: "Hope and desire for the things of heaven.", scriptureRef: "Acts 1:6-11 (also Luke 24:50-53)"),
            .init(title: "The Descent of the Holy Spirit", description: "The descent of the Holy Spirit upon Mary and the Apostles in the Upper Room, at Pentecost.", fruit: "Apostolic zeal and the gifts of the Holy Spirit.", scriptureRef: "Acts 2:1-13"),
            .init(title: "The Assumption of Mary", description: "The assumption of Our Lady into heaven, body and soul.", fruit: "The grace of a happy death and filial union with Mary.", scriptureRef: "No explicit account in the Gospels — tradition rests on Revelation 12:1 and Song of Songs 2:10-11"),
            .init(title: "The Coronation of Mary", description: "The crowning of Mary Most Holy as Queen of Heaven and Earth.", fruit: "Final perseverance and complete trust in Mary's queenship.", scriptureRef: "Also associated with Revelation 12:1"),
        ]),
        .init(mysterySet: .luminous, decades: [
            .init(title: "The Baptism in the Jordan", description: "The baptism of Jesus in the river Jordan at the hands of John the Baptist.", fruit: "Fidelity to the promises of Baptism and the state of grace.", scriptureRef: "Matthew 3:13-17 (also Mark 1:9-11 and Luke 3:21-22)"),
            .init(title: "The Wedding at Cana", description: "Jesus reveals himself at the wedding at Cana, his first miracle, at Mary's intercession.", fruit: "Trust in Mary's intercession and the sanctification of families.", scriptureRef: "John 2:1-12"),
            .init(title: "The Proclamation of the Kingdom", description: "The proclamation of the Kingdom of God, with the call to conversion.", fruit: "Repentance for sin and the desire for holiness.", scriptureRef: "Mark 1:14-15 (also Matthew 4:17)"),
            .init(title: "The Transfiguration", description: "The transfiguration of Jesus on Mount Tabor, before Peter, James and John.", fruit: "The desire to contemplate the face of God and spiritual renewal.", scriptureRef: "Matthew 17:1-9 (also Mark 9:2-10 and Luke 9:28-36)"),
            .init(title: "The Institution of the Eucharist", description: "The institution of the Eucharist at the Last Supper.", fruit: "Devotion to the Blessed Sacrament and frequent communion.", scriptureRef: "Matthew 26:26-29 (also Luke 22:14-20 and 1 Corinthians 11:23-25)"),
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

    static let prayerCatalog = LocalizedCatalog(pt: ptPrayers, en: enPrayers)

    /// The day's fixed prayers, in the app's current language.
    static var prayers: RosaryPrayerTexts { prayerCatalog.current }

    // Kept as individual accessors so beads(for:)/step(for:) and any call site
    // reads the same names as before, now resolved per language.
    static var signOfCross: String { prayers.signOfCross }
    static var apostlesCreed: String { prayers.apostlesCreed }
    static var ourFather: String { prayers.ourFather }
    static var hailMary: String { prayers.hailMary }
    static var gloryBe: String { prayers.gloryBe }
    static var fatimaPrayer: String { prayers.fatimaPrayer }
    static var hailHolyQueen: String { prayers.hailHolyQueen }
    static var offeringPrayer: String { prayers.offeringPrayer }

    private static let ptPrayers = RosaryPrayerTexts(
        signOfCross: "Em nome do Pai, e do Filho, e do Espírito Santo. Amém.",
        apostlesCreed: "Creio em Deus Pai todo-poderoso, criador do céu e da terra. E em Jesus Cristo, seu único Filho, nosso Senhor, que foi concebido pelo poder do Espírito Santo, nasceu da Virgem Maria, padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado, desceu à mansão dos mortos, ressuscitou ao terceiro dia, subiu aos céus, está sentado à direita de Deus Pai todo-poderoso, donde há de vir a julgar os vivos e os mortos. Creio no Espírito Santo, na santa Igreja Católica, na comunhão dos santos, na remissão dos pecados, na ressurreição da carne, na vida eterna. Amém.",
        ourFather: "Pai nosso, que estais nos céus, santificado seja o vosso nome, venha a nós o vosso reino, seja feita a vossa vontade, assim na terra como no céu. O pão nosso de cada dia nos dai hoje, perdoai-nos as nossas ofensas, assim como nós perdoamos a quem nos tem ofendido, e não nos deixeis cair em tentação, mas livrai-nos do mal. Amém.",
        hailMary: "Ave Maria, cheia de graça, o Senhor é convosco, bendita sois vós entre as mulheres e bendito é o fruto do vosso ventre, Jesus. Santa Maria, Mãe de Deus, rogai por nós pecadores, agora e na hora da nossa morte. Amém.",
        gloryBe: "Glória ao Pai, e ao Filho, e ao Espírito Santo. Como era no princípio, agora e sempre. Amém.",
        fatimaPrayer: "Ó meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o céu, principalmente as que mais precisarem.",
        hailHolyQueen: "Salve, Rainha, Mãe de misericórdia, vida, doçura e esperança nossa, salve! A vós bradamos, os degredados filhos de Eva. A vós suspiramos, gemendo e chorando neste vale de lágrimas. Eia, pois, advogada nossa, esses vossos olhos misericordiosos a nós volvei. E depois deste desterro, mostrai-nos Jesus, bendito fruto do vosso ventre. Ó clemente, ó piedosa, ó doce sempre Virgem Maria!",
        offeringPrayer: "Divino Jesus, nós Vos oferecemos este terço que vamos rezar, meditando nos mistérios da Vossa Redenção. Concedei-nos, por intercessão de Maria, Vossa Mãe Santíssima, a quem nos dirigimos, as virtudes necessárias para bem rezá-lo e a graça de ganharmos as indulgências anexas a esta santa devoção."
    )

    private static let enPrayers = RosaryPrayerTexts(
        signOfCross: "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",
        apostlesCreed: "I believe in God, the Father almighty, Creator of heaven and earth, and in Jesus Christ, his only Son, our Lord, who was conceived by the Holy Spirit, born of the Virgin Mary, suffered under Pontius Pilate, was crucified, died and was buried; he descended into hell; on the third day he rose again from the dead; he ascended into heaven, and is seated at the right hand of God the Father almighty; from there he will come to judge the living and the dead. I believe in the Holy Spirit, the holy catholic Church, the communion of saints, the forgiveness of sins, the resurrection of the body, and life everlasting. Amen.",
        ourFather: "Our Father, who art in heaven, hallowed be thy name; thy kingdom come; thy will be done on earth as it is in heaven. Give us this day our daily bread; and forgive us our trespasses as we forgive those who trespass against us; and lead us not into temptation, but deliver us from evil. Amen.",
        hailMary: "Hail Mary, full of grace, the Lord is with thee. Blessed art thou among women, and blessed is the fruit of thy womb, Jesus. Holy Mary, Mother of God, pray for us sinners, now and at the hour of our death. Amen.",
        gloryBe: "Glory be to the Father, and to the Son, and to the Holy Spirit. As it was in the beginning, is now, and ever shall be, world without end. Amen.",
        fatimaPrayer: "O my Jesus, forgive us our sins, save us from the fires of hell, and lead all souls to heaven, especially those in most need of thy mercy.",
        hailHolyQueen: "Hail, holy Queen, Mother of mercy, our life, our sweetness and our hope. To thee do we cry, poor banished children of Eve. To thee do we send up our sighs, mourning and weeping in this valley of tears. Turn then, most gracious advocate, thine eyes of mercy toward us, and after this our exile show unto us the blessed fruit of thy womb, Jesus. O clement, O loving, O sweet Virgin Mary!",
        offeringPrayer: "Divine Jesus, we offer thee this rosary which we are about to pray, meditating on the mysteries of thy redemption. Grant us, through the intercession of Mary, thy most holy Mother, the virtues we need to pray it well, and the grace to gain the indulgences attached to this holy devotion."
    )

    /// Guidance, not a prayer to recite — kept as short labeled categories
    /// (rather than one paragraph) so the view can render it plainly, without
    /// the italic quote styling used for actual prayer text. See RosaryPrayerStep.promptItems.
    static var intentionCategories: [RosaryPromptItem] { intentionCatalog.current }

    static let intentionCatalog = LocalizedCatalog(
        pt: [
            RosaryPromptItem(label: "Pessoais", detail: "Um pedido de conversão, paciência, discernimento para uma decisão, ou a cura de alguma enfermidade."),
            RosaryPromptItem(label: "Pelos outros", detail: "Familiares, amigos, doentes, desempregados, ou alguém que pediu suas orações."),
            RosaryPromptItem(label: "Sociais e universais", detail: "As almas do purgatório, o Papa, a Igreja, o fim das guerras, os mais necessitados."),
            RosaryPromptItem(label: "Agradecimento", detail: "Por uma graça já alcançada ou pela proteção de cada dia."),
        ],
        en: [
            RosaryPromptItem(label: "Personal", detail: "A request for conversion, patience, discernment about a decision, or healing from an illness."),
            RosaryPromptItem(label: "For others", detail: "Family, friends, the sick, the unemployed, or someone who asked for your prayers."),
            RosaryPromptItem(label: "Social and universal", detail: "The souls in purgatory, the Pope, the Church, an end to wars, those most in need."),
            RosaryPromptItem(label: "Thanksgiving", detail: "For a grace already received, or for each day's protection."),
        ]
    )

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
        let l = labels
        let detail = bead.mysteryIndex.map { mystery.decades[$0] }
        let decadeLabel = detail.map { "\(l.ordinal((bead.mysteryIndex ?? 0) + 1)) \(l.mysteryWord.lowercased()) \(mystery.mysterySet.displayName.lowercased()) · \($0.title)" } ?? l.signOfCross
        switch bead.kind {
        case .crucifix:
            return .init(beadLabel: l.signOfCross, kicker: l.crucifixKicker, text: signOfCross, hint: l.tapHint)
        case .intentions:
            return .init(beadLabel: l.intentions, kicker: l.intentionsKicker, text: l.intentionsText, hint: l.intentionsHint, promptItems: intentionCategories)
        case .offering:
            return .init(beadLabel: l.offering, kicker: l.offeringKicker, text: offeringPrayer, hint: l.offeringHint)
        case .creed:
            return .init(beadLabel: l.creed, kicker: l.creedKicker, text: apostlesCreed, hint: l.creedHint)
        case .announcement:
            let d = detail!
            let mysteryTitleLine = "\(l.ordinal((bead.mysteryIndex ?? 0) + 1)) \(l.mysteryWord) — \(d.title)"
            return .init(beadLabel: decadeLabel, kicker: l.announcementKicker, text: d.description, hint: l.announcementHint, fruit: d.fruit, scriptureRef: d.scriptureRef, mysteryTitleLine: mysteryTitleLine)
        case .ourFather:
            return .init(beadLabel: decadeLabel, kicker: l.ourFatherKicker, text: ourFather, hint: l.ourFatherHint)
        case .hailMary:
            return .init(beadLabel: decadeLabel, kicker: l.hailMaryKicker, text: hailMary, hint: l.hailMaryHint)
        case .glory:
            return .init(beadLabel: decadeLabel, kicker: l.gloryKicker, text: gloryBe + "\n\n" + fatimaPrayer, hint: l.gloryHint)
        case .hailHolyQueen:
            return .init(beadLabel: l.hailHolyQueen, kicker: l.hailHolyQueenKicker, text: hailHolyQueen, hint: l.hailHolyQueenHint)
        }
    }

    static var labels: RosaryStepLabels { labelCatalog.current }

    static let labelCatalog = LocalizedCatalog(pt: ptLabels, en: enLabels)

    private static let ptLabels = RosaryStepLabels(
        signOfCross: "Sinal da Cruz",
        crucifixKicker: "Ao segurar o crucifixo",
        tapHint: "Toque em qualquer lugar para avançar.",
        intentions: "Intenções",
        intentionsKicker: "Por quem você reza hoje",
        intentionsText: "Escolha por quem oferecer este terço — não precisa ser só uma coisa.",
        intentionsHint: "Exemplo: \u{201C}Ofereço este terço pela saúde da minha família, pela paz no mundo e por uma graça particular que necessito.\u{201D}",
        offering: "Oferecimento do terço",
        offeringKicker: "Antes de começar",
        offeringHint: "Tradicional, e opcional — oferece o terço inteiro antes da primeira conta.",
        creed: "Credo",
        creedKicker: "Na primeira conta",
        creedHint: "O Credo dos Apóstolos, rezado uma vez, prepara a fé antes dos mistérios.",
        announcementKicker: "Anúncio do mistério",
        announcementHint: "Faça uma breve pausa antes do Pai-Nosso desta dezena.",
        mysteryWord: "Mistério",
        ourFatherKicker: "Conta maior",
        ourFatherHint: "Toque em qualquer lugar para avançar. Avanço automático está ligado.",
        hailMaryKicker: "Ave-Maria",
        hailMaryHint: "Dez contas por dezena, meditando o mistério.",
        gloryKicker: "Glória ao Pai",
        gloryHint: "Fecha a dezena. A próxima começa no anúncio seguinte.",
        hailHolyQueen: "Salve Rainha",
        hailHolyQueenKicker: "Para encerrar",
        hailHolyQueenHint: "Encerra o terço. Pode seguir com o Sinal da Cruz.",
        ourFatherShort: "Pai-Nosso",
        gloryShort: "Glória",
        offeringShort: "Oferecimento",
        ordinals: ["Primeiro", "Segundo", "Terceiro", "Quarto", "Quinto"]
    )

    private static let enLabels = RosaryStepLabels(
        signOfCross: "Sign of the Cross",
        crucifixKicker: "Holding the crucifix",
        tapHint: "Tap anywhere to continue.",
        intentions: "Intentions",
        intentionsKicker: "Who you are praying for today",
        intentionsText: "Choose who to offer this rosary for — it doesn't have to be just one thing.",
        intentionsHint: "For example: \u{201C}I offer this rosary for my family's health, for peace in the world, and for a particular grace I need.\u{201D}",
        offering: "Offering of the Rosary",
        offeringKicker: "Before you begin",
        offeringHint: "Traditional, and optional — it offers the whole rosary before the first bead.",
        creed: "Creed",
        creedKicker: "On the first bead",
        creedHint: "The Apostles' Creed, prayed once, prepares faith before the mysteries.",
        announcementKicker: "Announcing the mystery",
        announcementHint: "Pause briefly before the Our Father of this decade.",
        mysteryWord: "Mystery",
        ourFatherKicker: "Large bead",
        ourFatherHint: "Tap anywhere to continue. Auto-advance is on.",
        hailMaryKicker: "Hail Mary",
        hailMaryHint: "Ten beads per decade, meditating on the mystery.",
        gloryKicker: "Glory Be",
        gloryHint: "This closes the decade. The next one begins at the following announcement.",
        hailHolyQueen: "Hail Holy Queen",
        hailHolyQueenKicker: "To close",
        hailHolyQueenHint: "This ends the rosary. You may follow it with the Sign of the Cross.",
        ourFatherShort: "Our Father",
        gloryShort: "Glory Be",
        offeringShort: "Offering",
        ordinals: ["First", "Second", "Third", "Fourth", "Fifth"]
    )

    static let novena = Novena(title: "Novena das 54 dias", currentDay: 23, totalDays: 54)

    /// One catalog per language — see LocalizedCatalog.
    static var howTo: [PrayerHowTo] { howToCatalog.current }

    static let howToCatalog = LocalizedCatalog(pt: ptHowTo)

    private static let ptHowTo: [PrayerHowTo] = [
        .init(id: "1", title: "Como segurar e avançar", body: "Segure o crucifixo entre o polegar e o indicador. A cada oração dita, deslize o polegar para a próxima conta — uma conta, uma oração, sempre nessa ordem."),
        .init(id: "2", title: "Por que começa pelo Credo", body: "As três contas iniciais (Credo, um Pai-Nosso, três Ave-Marias) preparam fé, esperança e caridade antes dos mistérios — não são preâmbulo dispensável."),
        .init(id: "3", title: "Por que o Glória fecha a dezena", body: "Cada dezena termina voltando à Trindade, e é o momento tradicional da Oração de Fátima (\"ó meu Jesus, perdoai-nos\") — opcional, por isso vem depois do Glória, não no lugar dele."),
        .init(id: "4", title: "O que fazer com a mente", body: "Não é preciso visualizar nada com perfeição. Basta voltar a atenção ao mistério sempre que ela se perder — isso também é oração."),
        .init(id: "5", title: "E se eu errar a conta?", body: "Não tem problema. O terço não é um exame; se perder a conta, comece a dezena de novo ou apenas continue."),
        .init(id: "6", title: "Quanto tempo leva", body: "O terço completo (cinco dezenas) leva de 18 a 20 minutos rezado com calma. Uma dezena avulsa leva menos de 4."),
        .init(id: "7", title: "Preciso terminar de uma vez?", body: "Não. Pode-se rezar uma dezena por vez ao longo do dia, em família, a dois, ou sozinho no carro — o que der para fazer hoje."),
        .init(id: "8", title: "Posso rezar sem o objeto físico?", body: "Sim — os dedos contam as Ave-Marias tão bem quanto as contas. O terço físico é ajuda, não exigência."),
    ]

    /// One catalog per language — see LocalizedCatalog.
    static var examenSteps: [ExamenStep] { examenStepsCatalog.current }

    static let examenStepsCatalog = LocalizedCatalog(pt: ptExamenSteps)

    private static let ptExamenSteps: [ExamenStep] = [
        .init(number: 1, title: "Gratidão", subtitle: "Reveja o dia e agradeça pelo que houve de bom nele."),
        .init(number: 2, title: "Pedido de luz", subtitle: "Peça ao Espírito Santo para ver o dia com clareza."),
        .init(number: 3, title: "Revisão", subtitle: "Onde houve consolação, e onde houve desolação?"),
        .init(number: 4, title: "Resposta", subtitle: "Peça perdão pelo que precisar, e decida um passo para amanhã."),
    ]
}
