import Foundation

enum MockFormation {
    static let massPartTitles: [String] = [
        "Antes de tudo: por que ir à Missa",
        "O Sinal da Cruz e a saudação",
        "O Ato Penitencial",
        "O Kyrie",
        "O Glória",
        "A Coleta",
        "A Liturgia da Palavra",
        "O Credo",
        "A Oração dos Fiéis",
        "A Apresentação das Oferendas",
        "A Oração Eucarística",
        "A Consagração",
        "O Pai-Nosso e o Rito da Paz",
        "A Comunhão e o envio",
    ]

    static let massPart1 = FormationLesson(
        id: "mass-part-1",
        trackID: "mass-part-by-part",
        partNumber: 1,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "Antes de tudo: por que ir à Missa",
        bodyParagraphs: [
            "Antes de explicar qualquer parte da Missa, vale perguntar o óbvio: por que ir? A resposta mais comum — \u{201C}é obrigação\u{201D}, \u{201C}é o que se faz aos domingos\u{201D} — não está errada, mas é rasa demais para sustentar catorze partes de explicação. Esta trilha começa aqui porque, sem entender o que a Missa é, cada gesto que vier depois vai parecer só coreografia.",
            "A Missa não é uma peça sobre a Última Ceia, encenada de novo toda semana. É o memorial litúrgico do mesmo sacrifício de Cristo na cruz, tornado presente — não repetido, porque Cristo morreu uma única vez, mas presente de um jeito que ultrapassa o tempo. Quando você está na Missa, não está lembrando algo distante: está diante do mesmo ato pelo qual foi salvo.",
            "Por isso a Igreja chama a Eucaristia de \u{201C}fonte e ápice de toda a vida cristã\u{201D} — tudo o que você faz fora da Missa deveria fluir dela e conduzir de volta a ela. Não é o lugar onde você vai buscar uma boa sensação. É o lugar onde Cristo continua se oferecendo ao Pai, e onde você é convidado a entrar nessa oferta.",
            "É com isso em mente que a Missa começa: nem com um aviso, nem com uma leitura, mas com um sinal que já professa a fé inteira. É aí que a próxima parte começa.",
        ],
        quoteText: nil,
        quoteAttribution: nil,
        glossaryTerms: [GlossaryTerm(term: "memorial litúrgico", definition: "Não é uma simples lembrança do passado: é tornar presente, sacramentalmente, o único sacrifício de Cristo na cruz.")]
    )

    static let massPart2 = FormationLesson(
        id: "mass-part-2",
        trackID: "mass-part-by-part",
        partNumber: 2,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Sinal da Cruz e a saudação",
        bodyParagraphs: [
            "A Missa começa antes de qualquer palavra de boas-vindas: começa com a mão tocando a testa, o peito, os dois ombros. O Sinal da Cruz não é um gesto de abertura qualquer — é a profissão de fé mais curta que existe, dita com o corpo antes de ser dita com a boca: Pai, Filho e Espírito Santo, o Deus em nome de quem tudo o que vier a seguir vai acontecer.",
            "Depois vem a saudação — e aqui vale prestar atenção ao que ela não é. O padre não está dizendo \u{201C}bom dia\u{201D}. Ele está, na pessoa de Cristo, estendendo à assembleia a mesma graça que Paulo desejava às suas próprias comunidades, numa fórmula que o Missal preserva quase palavra por palavra.",
            "E a resposta do povo — \u{201C}e com o teu espírito\u{201D} — também não é formalidade. Ela reconhece que aquele homem, pelo sacramento da Ordem, recebeu um espírito capaz de agir in persona Christi — na pessoa de Cristo —, emprestando sua voz para consagrar, absolver, abençoar. A assembleia responde ao ministério, não à pessoa.",
            "Só depois desse duplo reconhecimento — quem é Deus, o que aquele padre pode fazer em nome de Cristo — é que a Missa segue para o primeiro gesto comunitário: parar e admitir que se errou.",
        ],
        quoteText: "A graça de Nosso Senhor Jesus Cristo, o amor do Pai e a comunhão do Espírito Santo estejam convosco.",
        quoteAttribution: "2 Coríntios 13, 13 — uma das saudações do Missal Romano.",
        glossaryTerms: [GlossaryTerm(term: "in persona Christi", definition: "Expressão latina: \u{201C}na pessoa de Cristo\u{201D}. Descreve como o sacerdote ordenado age nos ritos, emprestando sua voz e suas mãos a Cristo, e não a si mesmo.")]
    )

    static let atoPenitencial = FormationLesson(
        id: "mass-part-3",
        trackID: "mass-part-by-part",
        partNumber: 3,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Ato Penitencial",
        bodyParagraphs: [
            "Logo depois da saudação, antes de qualquer leitura, a assembleia para e admite que errou. Essa ordem não é casual: a Igreja não começa provando que é digna, começa dizendo que não é.",
            "O gesto de bater no peito acompanha as palavras mea culpa. É antigo, é corporal, e existe porque o corpo participa do que se reconhece. Três vezes, sem pressa.",
            "O que vem depois não é absolvição sacramental: o sacerdote pede a misericórdia, e a Igreja distingue isso da confissão. Pecado grave continua pedindo o sacramento — e é justamente essa distinção que a maioria nunca ouviu explicada.",
            "No domingo, quando o Kyrie for cantado, você vai reconhecer que ele responde ao que acabou de acontecer aqui.",
        ],
        quoteText: "Confesso a Deus todo-poderoso e a vós, irmãos e irmãs, que pequei muitas vezes por pensamentos e palavras, atos e omissões.",
        quoteAttribution: "Texto do Missal, citado como apoio.",
        glossaryTerms: [MockLiturgical.glossaryTerms[0]]
    )

    static let massPart4 = FormationLesson(
        id: "mass-part-4",
        trackID: "mass-part-by-part",
        partNumber: 4,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Kyrie",
        bodyParagraphs: [
            "Se o Ato Penitencial já pediu misericórdia, por que a Missa pede de novo, em grego, logo em seguida? Porque é um pedido diferente — não um confessionário improvisado, mas o grito mais antigo da liturgia cristã, preservado em grego mesmo depois que todo o resto virou latim, e hoje na sua própria língua: o Kyrie.",
            "O Kyrie não é sobre um pecado específico. É a súplica de quem reconhece que está diante de um Rei — o mesmo clamor do cego Bartimeu à beira da estrada, dos dez leprosos, da mulher cananeia: \u{201C}tende piedade de mim\u{201D}. Não é vergonha. É a linguagem certa para se dirigir a alguém que pode, de fato, salvar.",
            "Historicamente, essa aclamação era cantada nove vezes — três para o Pai, três para o Filho, três para o Espírito. Hoje, na forma mais comum, são seis, mas a estrutura trinitária continua ali, discreta, para quem presta atenção.",
            "Depois de pedir misericórdia, a Missa muda de tom por completo: a próxima parte não pede mais nada — ela explode em louvor.",
        ],
        quoteText: "Kýrie, eléison. Christe, eléison. Kýrie, eléison.",
        quoteAttribution: "Texto invariável da Missa, mantido em grego desde os primeiros séculos.",
        glossaryTerms: [GlossaryTerm(term: "Kyrie", definition: "\u{201C}Senhor, tende piedade\u{201D}: invocação grega mantida na liturgia latina, logo após o Ato Penitencial.")]
    )

    static let massPart5 = FormationLesson(
        id: "mass-part-5",
        trackID: "mass-part-by-part",
        partNumber: 5,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Glória",
        bodyParagraphs: [
            "A Missa muda de registro nesta parte: do pedido de misericórdia do Kyrie para um louvor sem condições. O hino que abre esse louvor tem uma origem exata — é o canto dos anjos na noite em que Cristo nasceu, registrado pelo evangelista Lucas.",
            "O Glória é uma doxologia antiga do cristianismo — um hino de puro louvor, escrito séculos antes de existir um Missal como conhecemos hoje. Ele passa a maior parte do tempo apenas glorificando a Deus, antes de finalmente se voltar ao Cordeiro que tira o pecado do mundo, quase ao final.",
            "Por isso ele some no Advento e na Quaresma: são tempos de espera e de penitência, e cantar um hino de louvor pleno ali destoaria do que a própria estação está pedindo ao corpo da Igreja. Quando ele volta — na noite de Natal, na Vigília Pascal — o silêncio anterior faz seu retorno significar mais.",
            "Depois de louvar, a Missa faz uma pausa breve antes da Palavra: é a Coleta, e é ali que suas próprias intenções silenciosas entram na oração.",
        ],
        quoteText: "Glória a Deus nas alturas, e paz na terra aos homens por Ele amados.",
        quoteAttribution: "Lucas 2, 14 — o canto dos anjos em Belém que abre o hino.",
        glossaryTerms: [GlossaryTerm(term: "doxologia", definition: "Do grego \u{201C}palavra de glória\u{201D}: um hino ou fórmula que glorifica a Deus. O Glória é a grande doxologia da Missa.")]
    )

    static let massPart6 = FormationLesson(
        id: "mass-part-6",
        trackID: "mass-part-by-part",
        partNumber: 6,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Coleta",
        bodyParagraphs: [
            "\u{201C}Oremos.\u{201D} É a palavra mais curta do Missal, e a mais fácil de deixar passar em branco. Ela abre um silêncio breve — segundos, não minutos — em que cada pessoa na assembleia é convidada a colocar diante de Deus, sem dizer em voz alta, o que trouxe consigo naquele dia.",
            "Depois do silêncio, o padre reúne tudo isso numa única oração: a Coleta. O nome vem exatamente disso — \u{201C}coletar\u{201D}, recolher em uma fórmula só as intenções dispersas de todos os presentes, e endereçá-las ao Pai, pelo Filho, na unidade do Espírito Santo.",
            "É uma oração curta, quase sempre com a mesma estrutura, e fácil de ouvir como só mais um trecho decorado. Mas ela muda a cada dia, segue o tempo litúrgico e a festa do calendário — é o texto mais preciso e mais variável de toda a Missa até aquele ponto.",
            "Com a Coleta encerrada, a assembleia se senta. Começa a parte mais longa dos ritos iniciais até aqui — na verdade, uma Missa inteira dentro da Missa: a Liturgia da Palavra.",
        ],
        quoteText: nil,
        quoteAttribution: nil,
        glossaryTerms: [GlossaryTerm(term: "coleta", definition: "A oração que \u{201C}recolhe\u{201D} em uma só fórmula as intenções silenciosas de toda a assembleia, dirigida ao Pai, por Cristo, na unidade do Espírito Santo.")]
    )

    static let massPart7 = FormationLesson(
        id: "mass-part-7",
        trackID: "mass-part-by-part",
        partNumber: 7,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Liturgia da Palavra",
        bodyParagraphs: [
            "Depois da Coleta, a assembleia se senta para ouvir — e o que acontece aqui não é uma pausa educativa antes da \u{201C}parte que importa\u{201D}. O Concílio Vaticano II foi direto: Cristo está presente na sua própria palavra, tanto quanto está presente no altar. Ouvir não é preparação. Já é encontro.",
            "A estrutura é sempre a mesma: uma primeira leitura (quase sempre do Antigo Testamento), o Salmo Responsorial cantado ou recitado em resposta, uma segunda leitura nos domingos e solenidades (sempre do Novo Testamento, fora dos evangelhos), e por fim o Evangelho — o único texto que só um ministro ordenado pode proclamar, de pé, muitas vezes com vela e incenso.",
            "As leituras não são escolhidas ao acaso: seguem o lecionário, um ciclo de três anos aos domingos (A, B e C, cada um centrado num evangelho sinótico) e de dois anos nos dias de semana. Isso significa que, ano após ano, a Igreja inteira está ouvindo — no mesmo domingo, em qualquer país — exatamente o mesmo texto.",
            "Depois do Evangelho vem a homilia, e depois da homilia, de pé, a assembleia inteira responde ao que acabou de ouvir com uma única palavra que resume tudo: eu creio.",
        ],
        quoteText: "Palavra do Senhor. — Graças a Deus.",
        quoteAttribution: "Aclamação fixa do Missal Romano, ao final de cada leitura.",
        glossaryTerms: [MockLiturgical.glossaryTerms[2]]
    )

    static let massPart8 = FormationLesson(
        id: "mass-part-8",
        trackID: "mass-part-by-part",
        partNumber: 8,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Credo",
        bodyParagraphs: [
            "\u{201C}Creio.\u{201D} Depois de ouvir a Palavra, a Missa não passa direto para a próxima coisa — ela para para que a assembleia responda com uma profissão de fé, de pé, em voz alta, junta. Não é uma opinião pessoal sendo compartilhada. É a mesma fé que a Igreja professa há mais de mil e seiscentos anos, palavra por palavra.",
            "O texto que se reza aos domingos — o Credo Niceno — foi forjado em dois concílios, Niceia (325) e Constantinopla (381), justamente para fechar a porta a quem ensinava que Cristo não era plenamente Deus. Cada frase carrega essa disputa dentro de si, mesmo que hoje soe apenas como um resumo bonito.",
            "É o caso da palavra \u{201C}consubstancial\u{201D}, inserida a dedo no Credo para fechar a porta a quem dizia que o Filho era parecido com o Pai, mas não da mesma substância divina. A frase inteira em que ela aparece está na citação abaixo.",
            "Com a fé professada, a Missa muda de direção outra vez: da escuta para a intercessão. É a Oração dos Fiéis, e ali a assembleia para de responder e começa a pedir.",
        ],
        quoteText: "Deus verdadeiro de Deus verdadeiro, gerado, não criado, consubstancial ao Pai.",
        quoteAttribution: "Credo Niceno, Missal Romano.",
        glossaryTerms: [GlossaryTerm(term: "consubstancial", definition: "Termo do Credo que traduz o grego homooúsios: o Filho não é parecido com o Pai, é da mesma substância — verdadeiramente Deus, como o Pai.")]
    )

    static let massPart9 = FormationLesson(
        id: "mass-part-9",
        trackID: "mass-part-by-part",
        partNumber: 9,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Oração dos Fiéis",
        bodyParagraphs: [
            "Depois do Credo vem um momento que, por boa parte da história da Igreja latina, quase desapareceu: a Oração dos Fiéis, ou oração universal. O Concílio Vaticano II a restaurou de propósito, porque ela cumpre algo que nenhuma outra parte da Missa cumpre — dá à assembleia leiga a palavra para interceder.",
            "As intenções seguem uma ordem clássica: primeiro pela Igreja, depois pelas autoridades e pelo bem comum do mundo, depois pelos que sofrem alguma necessidade, e por fim pela comunidade local ali reunida. Um leigo — não o padre — normalmente as proclama.",
            "Isso não é um detalhe de organização. É o sacerdócio comum dos fiéis em ação: cada pessoa ali, pelo Batismo, tem parte no sacerdócio de Cristo e intercede diante de Deus, mesmo sem jamais consagrar um sacramento.",
            "Terminadas as intercessões, os ritos da Palavra se encerram. A Missa muda de matéria: até aqui era só palavra; a partir de agora, pão e vinho começam a chegar ao altar.",
        ],
        quoteText: "Por [intenção], oremos ao Senhor. — Senhor, escutai a nossa prece.",
        quoteAttribution: "Uma entre as fórmulas possíveis para a resposta da assembleia.",
        glossaryTerms: [GlossaryTerm(term: "sacerdócio comum dos fiéis", definition: "Pelo Batismo, todo cristão participa do sacerdócio de Cristo — não celebrando os sacramentos, mas oferecendo sua vida e intercedendo, como aqui na Oração dos Fiéis.")]
    )

    static let massPart10 = FormationLesson(
        id: "mass-part-10",
        trackID: "mass-part-by-part",
        partNumber: 10,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Apresentação das Oferendas",
        bodyParagraphs: [
            "O pão e o vinho não aparecem no altar por conta própria. Alguém os traz — muitas vezes em procissão, junto com a coleta em dinheiro — e esse gesto simples marca a virada da Missa: do fim da Liturgia da Palavra para o início do Ofertório, a primeira metade da Liturgia Eucarística.",
            "O padre então ergue o pão e reza uma bênção de origem judaica, dirigida a Deus como \u{201C}Senhor do universo\u{201D} pelo fruto da terra e do trabalho humano — a mesma estrutura se repete, em seguida, com o vinho.",
            "Vale notar o que este momento não é: ainda não é a consagração. É preparação — o pão continua pão, o vinho continua vinho. É por isso que esta parte da Missa costuma passar quase despercebida: nada muda visivelmente ainda, mas tudo está sendo colocado no lugar certo para o que vem a seguir.",
            "Com as oferendas no altar, o padre convida a assembleia: \u{201C}Orai, irmãos e irmãs, para que o nosso sacrifício seja aceito por Deus, Pai todo-poderoso.\u{201D} É o sinal de que a parte mais densa da Missa está prestes a começar.",
        ],
        quoteText: "Bendito sejais, Senhor, Deus do universo, pelo pão que recebemos de vossa bondade, fruto da terra e do trabalho do homem; ele se tornará para nós pão da vida.",
        quoteAttribution: "Oração sobre o pão, Missal Romano.",
        glossaryTerms: [GlossaryTerm(term: "Ofertório", definition: "O momento em que o pão, o vinho e as ofertas da comunidade são trazidos ao altar — preparação para o sacrifício, ainda não a consagração.")]
    )

    static let massPart11 = FormationLesson(
        id: "mass-part-11",
        trackID: "mass-part-by-part",
        partNumber: 11,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Oração Eucarística",
        bodyParagraphs: [
            "Tudo o que aconteceu até aqui — saudação, perdão, palavra, intercessão, oferendas — foi preparação para isto: a Oração Eucarística, o centro de gravidade de toda a Missa. Existem várias versões (a Igreja usa hoje mais de dez), mas todas seguem o mesmo esqueleto.",
            "Ela começa com um diálogo fixo entre o padre e a assembleia — praticamente idêntico em qualquer Missa, em qualquer país, há séculos, e reproduzido na citação abaixo.",
            "Depois vem o Santo (\u{201C}Santo, Santo, Santo…\u{201D}), e então a epiclese: o padre estende as mãos sobre o pão e o vinho e pede ao Pai que envie o Espírito Santo para transformá-los. É esse gesto — não um efeito visual, não um clima — que a Igreja identifica como o pedido concreto do que está prestes a acontecer.",
            "Depois da epiclese vem o momento mais denso de toda a Missa, aquele para o qual catorze partes estão apontando: a Consagração.",
        ],
        quoteText: "Corações ao alto! — Já os temos no Senhor. Demos graças ao Senhor, nosso Deus! — É nosso dever e nossa salvação.",
        quoteAttribution: "Diálogo do Prefácio, fixo em toda Missa — Missal Romano.",
        glossaryTerms: [GlossaryTerm(term: "epiclese", definition: "Do grego \u{201C}invocação\u{201D}: o momento em que o sacerdote estende as mãos sobre o pão e o vinho pedindo ao Pai que envie o Espírito Santo para consagrá-los.")]
    )

    static let massPart12 = FormationLesson(
        id: "mass-part-12",
        trackID: "mass-part-by-part",
        partNumber: 12,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Consagração",
        bodyParagraphs: [
            "É aqui que tudo converge. O padre, agindo in persona Christi, repete as mesmas palavras que Cristo disse na última ceia sobre o pão e o cálice, registradas por Paulo em sua carta aos Coríntios.",
            "A Igreja usa uma palavra técnica para o que acontece nesse instante: transubstanciação. Não é um símbolo mudando de sentido, nem uma metáfora ficando mais forte. Toda a substância do pão e do vinho se torna, de fato, o Corpo e o Sangue de Cristo — enquanto tudo o que os sentidos percebem (cor, sabor, peso) continua exatamente igual.",
            "Não é uma repetição da cruz — Cristo morreu uma única vez, e isso não muda. É o mesmo sacrifício, tornado presente sacramentalmente, sobre aquele altar, naquele instante. É por isso que o silêncio e o ajoelhar-se, aqui, não são cerimônia: são a reação sensata a algo real acontecendo.",
            "Depois da elevação, a assembleia responde com uma aclamação de fé, e a Oração Eucarística caminha para seu fim: mais intercessões, e por fim uma doxologia final que todos ratificam com uma só palavra.",
        ],
        quoteText: "Isto é o meu corpo, que é dado por vós; fazei isto em memória de mim… Este cálice é a nova aliança no meu sangue; fazei isto, todas as vezes que o beberdes, em memória de mim.",
        quoteAttribution: "1 Coríntios 11, 24-25.",
        glossaryTerms: [GlossaryTerm(term: "transubstanciação", definition: "O termo teológico para o que acontece na consagração: toda a substância do pão e do vinho se torna o Corpo e o Sangue de Cristo, permanecendo apenas as aparências — cor, sabor, forma — de pão e vinho.")]
    )

    static let massPart13 = FormationLesson(
        id: "mass-part-13",
        trackID: "mass-part-by-part",
        partNumber: 13,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "O Pai-Nosso e o Rito da Paz",
        bodyParagraphs: [
            "Depois do Grande Amém, a assembleia se levanta para a última esticada antes da Comunhão: o Rito da Comunhão, que começa com a oração mais antiga e mais repetida do cristianismo — o Pai-Nosso, a única oração que o próprio Cristo ensinou, palavra por palavra, aos discípulos.",
            "Rezá-lo aqui não é decoração: pedir \u{201C}o pão nosso de cada dia\u{201D} antes de receber o Pão da vida, e pedir perdão \u{201C}assim como perdoamos\u{201D} antes de se aproximar do altar, são condições, não coincidências.",
            "Depois vem o Rito da Paz — e ele existe exatamente onde a Escritura manda que exista: antes da oferta, não depois. Se alguém se lembra de ter algo contra o irmão, o lugar de resolver isso é antes de se aproximar do altar, não depois.",
            "Por fim, o padre parte o pão enquanto a assembleia canta o Cordeiro de Deus — e é só depois desse gesto, chamado Fração, que a Missa chega à sua última parte: a própria Comunhão.",
        ],
        quoteText: "Se, portanto, estiveres para apresentar tua oferta sobre o altar, e ali te lembrares de que teu irmão tem alguma coisa contra ti, deixa ali tua oferta diante do altar, vai primeiro reconciliar-te com teu irmão, e depois vem e apresenta tua oferta.",
        quoteAttribution: "Mateus 5, 23-24 — o texto por trás do Rito da Paz.",
        glossaryTerms: [GlossaryTerm(term: "Grande Amém", definition: "A aclamação da assembleia ao final da Oração Eucarística — o \u{201C}sim\u{201D} comunitário a tudo o que acabou de ser rezado, antes de se preparar para a Comunhão.")]
    )

    static let massPart14 = FormationLesson(
        id: "mass-part-14",
        trackID: "mass-part-by-part",
        partNumber: 14,
        partsTotal: 14,
        kicker: "A Missa, parte por parte",
        title: "A Comunhão e o envio",
        bodyParagraphs: [
            "Depois de receber a Comunhão — e responder \u{201C}Amém\u{201D} a \u{201C}o Corpo de Cristo\u{201D}, não como cortesia, mas como profissão de fé de que é mesmo Ele —, a Missa não termina de repente. Há um breve silêncio de ação de graças, uma oração final, e só então a despedida.",
            "Essa despedida tem um detalhe que a maioria nunca percebeu: a própria palavra \u{201C}Missa\u{201D} vem dela. Em latim, a fórmula de despedida era \u{201C}Ite, missa est\u{201D} — algo como \u{201C}ide, sois enviados\u{201D}. Foi esse verbo, mittere, enviar, que deu nome à celebração inteira.",
            "Ou seja: a Missa nunca foi pensada como um evento fechado em si mesmo. Ela termina, estruturalmente, com um envio — a ordem de sair e viver, na semana, o que acabou de acontecer no altar.",
            "Estas catorze partes descrevem uma única Missa. A sua, especificamente, na sua paróquia, no seu domingo, é a única que realmente conta — e agora você sabe, parte por parte, o que está acontecendo nela.",
        ],
        quoteText: "Ide em paz, glorificando o Senhor com vossa vida.",
        quoteAttribution: "Uma das fórmulas de despedida do Missal Romano.",
        glossaryTerms: [GlossaryTerm(term: "Ite, missa est", definition: "A antiga despedida em latim de que vem o próprio nome \u{201C}Missa\u{201D}: \u{201C}ide, sois enviados\u{201D}. A palavra que dá nome a este app nasce exatamente aqui.")]
    )

    /// Ordered by partNumber — this order is what drives "next up" once a lesson
    /// is marked complete. See FormationProgressStore.nextLesson(_:).
    static var track: FormationTrack { trackCatalog.current }

    static let trackCatalog = LocalizedCatalog(pt: ptTrack, en: enTrack, es: esTrack)

    private static let ptTrack = FormationTrack(
        id: "mass-part-by-part",
        title: "A Missa, parte por parte",
        meta: "Uma parte por dia, cerca de quatro minutos",
        // progress/nextUp below are unused now that all 14 lessons exist —
        // FormationTrack.liveProgress/liveNextUpLabel compute the real values
        // from FormationProgressStore instead. Kept only as the struct's
        // required fallback for tracks that don't have lessons written yet.
        progress: 3.0 / 14.0,
        nextUp: "Amanhã: O Kyrie",
        lessons: [
            massPart1, massPart2, atoPenitencial, massPart4, massPart5, massPart6, massPart7,
            massPart8, massPart9, massPart10, massPart11, massPart12, massPart13, massPart14,
        ]
    )

    // These two tracks are original catechetical copy in their respective
    // languages. Their sequence and doctrinal statements follow the General
    // Instruction of the Roman Missal, especially nos. 27–90. They do not
    // translate the Portuguese lesson text or reproduce Missal prayers; the
    // approved prayers remain in their own language-specific catalogs.
    private static let enTrack = FormationTrack(
        id: "mass-part-by-part",
        title: "The Mass, part by part",
        meta: "One part a day, about four minutes",
        progress: 3.0 / 14.0,
        nextUp: "Tomorrow: The Kyrie",
        lessons: [
            authoredMassLesson(1, kicker: "The Mass, part by part", title: "Before anything else: why go to Mass", body: ["Mass is the Eucharistic celebration in which the Church gathers around the sacrifice and memorial of Christ. It is not a reenactment of the Last Supper or a weekly religious performance.", "The rest of this path follows one celebration. Its first question is not whether we feel ready, but how the Church gathers us to take part in Christ’s offering."], term: "memorial", definition: "In the liturgy, a memorial makes present sacramentally the one saving work of Christ; it is more than recalling a past event."),
            authoredMassLesson(2, kicker: "The Mass, part by part", title: "The Sign of the Cross and the greeting", body: ["The introductory rites begin when the people gather and the ministers enter. In the Sign of the Cross, the assembly invokes the Father, the Son, and the Holy Spirit before any other action.", "The liturgical greeting is more than a welcome. It expresses the gathered Church and the priest’s ministry in the celebration; the people’s response belongs to that dialogue."], term: "introductory rites", definition: "The opening rites that gather the faithful and dispose them to hear the Word and celebrate the Eucharist."),
            authoredMassLesson(3, kicker: "The Mass, part by part", title: "The Penitential Act", body: ["After the invitation to acknowledge sin, the whole assembly keeps a brief silence and uses one of the forms provided by the Roman Missal. It prepares those gathered to celebrate the sacred mysteries.", "The Penitential Act is not sacramental confession. It asks God’s mercy within Mass; serious sin still calls for the Sacrament of Reconciliation before receiving Communion."], term: "Penitential Act", definition: "The part of the introductory rites in which the assembly acknowledges sin and asks God’s mercy."),
            authoredMassLesson(4, kicker: "The Mass, part by part", title: "Kyrie, Lord have mercy", body: ["The Kyrie is an acclamation addressed to the Lord, ordinarily sung or said by all. It may follow the Penitential Act, or form part of it according to the rite used.", "Its Greek words have remained in the Roman Rite across centuries. The Church does not use them to list failures but to call on Christ with trust: Lord, have mercy."], term: "Kyrie", definition: "A Greek acclamation meaning ‘Lord, have mercy,’ addressed to Christ in the Mass."),
            authoredMassLesson(5, kicker: "The Mass, part by part", title: "The Gloria", body: ["The Gloria is an ancient hymn of praise to God and to the Lamb. On Sundays outside Advent and Lent, on solemnities, and on feasts, it is sung or said by the gathered assembly.", "It opens from the angels’ praise at Christ’s birth and leads into adoration, thanksgiving, and supplication. Its absence in penitential seasons gives those seasons their own voice."], term: "doxology", definition: "A formula or hymn that gives glory to God. The Gloria is the great doxology of the Mass."),
            authoredMassLesson(6, kicker: "The Mass, part by part", title: "The Collect", body: ["When the priest says ‘Let us pray,’ the people join a short silence and bring their intentions before God. The priest then speaks the Collect on behalf of the whole assembly.", "The prayer usually addresses the Father through the Son in the Holy Spirit and concludes the introductory rites. Its changing text gives the day or celebration a particular focus."], term: "Collect", definition: "The prayer that gathers the silent prayer of the assembly and concludes the introductory rites."),
            authoredMassLesson(7, kicker: "The Mass, part by part", title: "The Liturgy of the Word", body: ["In the readings, God speaks to the people; in the psalm, the people answer God’s word. The Gospel receives special honor because Christ is present in his word proclaimed in the Church.", "On Sundays the lectionary ordinarily gives a first reading, psalm, second reading, Gospel, and homily. This is not an introduction to the Eucharist; it is one of the two principal parts of Mass."], term: "lectionary", definition: "The liturgical book that orders the Scripture readings for Mass according to day and cycle."),
            authoredMassLesson(8, kicker: "The Mass, part by part", title: "The Creed", body: ["On Sundays and solemnities, the Profession of Faith allows the people to answer the word they have heard. The Creed is said by the priest together with the people, not as a private statement.", "The Nicene-Constantinopolitan Creed names the Church’s faith in the Father, Son, and Holy Spirit. Its words link the assembly to the faith handed on through the councils and baptism."], term: "Profession of Faith", definition: "The Creed proclaimed by the whole assembly in response to the Scriptures and homily."),
            authoredMassLesson(9, kicker: "The Mass, part by part", title: "The Prayer of the Faithful", body: ["In the Universal Prayer, the faithful exercise their baptismal intercession. The intentions normally include the Church, public authorities and the world, people in need, and the local community.", "A minister may announce the intentions and the people respond. The priest introduces and concludes the prayer, keeping it directed to God and joined to the celebration."], term: "Universal Prayer", definition: "The intercessions in which the gathered faithful pray for the Church, the world, people in need, and the local community."),
            authoredMassLesson(10, kicker: "The Mass, part by part", title: "The Preparation of the Gifts", body: ["Bread and wine are brought to the altar and prepared for the Eucharistic Prayer. Other gifts for the poor or for the Church may be received, but they are placed apart from the eucharistic table.", "This moment does not yet consecrate the gifts. It brings the signs of Christ’s sacrifice to the altar and turns the celebration toward the Eucharistic Prayer."], term: "Preparation of the Gifts", definition: "The beginning of the Liturgy of the Eucharist, when bread and wine are brought to the altar."),
            authoredMassLesson(11, kicker: "The Mass, part by part", title: "The Eucharistic Prayer", body: ["The Eucharistic Prayer is the center and high point of the whole celebration. Through the priest, the people join Christ in giving thanks to the Father and offering the sacrifice.", "Its elements include thanksgiving, the Holy Holy, invocation of the Spirit, the institution narrative, memorial, offering, intercessions, and final doxology. The assembly’s Amen seals this prayer."], term: "epiclesis", definition: "The invocation in which the Church asks the Father to send the Holy Spirit upon the gifts and the people."),
            authoredMassLesson(12, kicker: "The Mass, part by part", title: "The consecration", body: ["Within the Eucharistic Prayer, the priest recounts Christ’s words and actions at the Last Supper. By the power of the Holy Spirit, bread and wine become Christ’s Body and Blood.", "The Church keeps silence and adoration here because this is not a dramatic interruption. It belongs to the one prayer in which Christ’s sacrifice is made sacramentally present."], term: "consecration", definition: "The moment within the Eucharistic Prayer in which bread and wine become the Body and Blood of Christ."),
            authoredMassLesson(13, kicker: "The Mass, part by part", title: "The Lord’s Prayer and the Rite of Peace", body: ["The Communion Rite begins with the Lord’s Prayer, where the assembly asks for daily bread and forgiveness. The embolism and doxology lead into the prayer for peace.", "The sign of peace expresses ecclesial communion and love before Communion. It is offered soberly to those nearby; it is not a break from the rite or a substitute for reconciliation."], term: "Rite of Peace", definition: "The rite in which the Church asks for peace and the faithful offer a restrained sign of peace before Communion."),
            authoredMassLesson(14, kicker: "The Mass, part by part", title: "Communion and mission", body: ["The faithful approach to receive the Body and Blood of Christ according to the Church’s discipline. After Communion, silence, a psalm, or a hymn can help the assembly give thanks for the gift received.", "The concluding rites bless and dismiss the people. Mass ends by sending the Church into daily life, so that what is celebrated at the altar bears fruit in the world."], term: "dismissal", definition: "The final sending forth of the assembly to live what it has celebrated in the Eucharist.")
        ]
    )

    private static let esTrack = FormationTrack(
        id: "mass-part-by-part",
        title: "La Misa, parte por parte",
        meta: "Una parte al día, unos cuatro minutos",
        progress: 3.0 / 14.0,
        nextUp: "Mañana: el Kyrie",
        lessons: [
            authoredMassLesson(1, kicker: "La Misa, parte por parte", title: "Antes de todo: por qué participar en la Misa", body: ["La Misa es la celebración eucarística en la que la Iglesia se reúne en torno al sacrificio y memorial de Cristo. No es una representación de la Última Cena ni una función religiosa semanal.", "Este camino sigue una sola celebración. La primera pregunta no es si nos sentimos preparados, sino cómo la Iglesia nos reúne para participar en la ofrenda de Cristo."], term: "memorial", definition: "En la liturgia, el memorial hace presente sacramentalmente la única obra salvadora de Cristo; no es sólo el recuerdo de un hecho pasado."),
            authoredMassLesson(2, kicker: "La Misa, parte por parte", title: "La señal de la cruz y el saludo", body: ["Los ritos iniciales comienzan cuando el pueblo se reúne y los ministros entran. En la señal de la cruz, la asamblea invoca al Padre, al Hijo y al Espíritu Santo antes de cualquier otra acción.", "El saludo litúrgico es más que una bienvenida. Expresa a la Iglesia reunida y el ministerio del sacerdote en la celebración; la respuesta del pueblo forma parte de ese diálogo."], term: "ritos iniciales", definition: "Los ritos que abren la Misa, reúnen a los fieles y los disponen a escuchar la Palabra y celebrar la Eucaristía."),
            authoredMassLesson(3, kicker: "La Misa, parte por parte", title: "El acto penitencial", body: ["Después de la invitación a reconocer el pecado, toda la asamblea guarda un breve silencio y usa una de las fórmulas del Misal Romano. Así se prepara para celebrar los sagrados misterios.", "El acto penitencial no es la confesión sacramental. Pide la misericordia de Dios dentro de la Misa; el pecado grave sigue requiriendo el sacramento de la Reconciliación antes de comulgar."], term: "acto penitencial", definition: "La parte de los ritos iniciales en la que la asamblea reconoce el pecado y pide la misericordia de Dios."),
            authoredMassLesson(4, kicker: "La Misa, parte por parte", title: "Kyrie, Señor, ten piedad", body: ["El Kyrie es una aclamación dirigida al Señor, que normalmente cantan o recitan todos. Puede seguir al acto penitencial o formar parte de él, según la fórmula que se use.", "Estas palabras griegas permanecen en el rito romano desde hace siglos. La Iglesia no las usa para enumerar culpas, sino para invocar confiadamente a Cristo: Señor, ten piedad."], term: "Kyrie", definition: "Aclamación griega que significa ‘Señor, ten piedad’ y se dirige a Cristo en la Misa."),
            authoredMassLesson(5, kicker: "La Misa, parte por parte", title: "El Gloria", body: ["El Gloria es un himno antiguo de alabanza a Dios y al Cordero. Los domingos fuera de Adviento y Cuaresma, en solemnidades y fiestas, lo canta o recita la asamblea.", "Parte de la alabanza de los ángeles en el nacimiento de Cristo y conduce a la adoración, la acción de gracias y la súplica. Su ausencia en los tiempos penitenciales deja que esos tiempos tengan su propia voz."], term: "doxología", definition: "Fórmula o himno que da gloria a Dios. El Gloria es la gran doxología de la Misa."),
            authoredMassLesson(6, kicker: "La Misa, parte por parte", title: "La oración colecta", body: ["Cuando el sacerdote dice ‘Oremos’, el pueblo se une en un breve silencio y presenta sus intenciones ante Dios. Después, el sacerdote dice la colecta en nombre de toda la asamblea.", "La oración se dirige habitualmente al Padre por el Hijo en el Espíritu Santo y concluye los ritos iniciales. Su texto cambiante da un acento propio al día o a la celebración."], term: "colecta", definition: "La oración que reúne la oración silenciosa de la asamblea y concluye los ritos iniciales."),
            authoredMassLesson(7, kicker: "La Misa, parte por parte", title: "La liturgia de la Palabra", body: ["En las lecturas, Dios habla a su pueblo; en el salmo, el pueblo responde a la palabra de Dios. El Evangelio recibe un honor especial porque Cristo está presente en la Palabra proclamada en la Iglesia.", "Los domingos, el leccionario suele ofrecer primera lectura, salmo, segunda lectura, Evangelio y homilía. No es una introducción a la Eucaristía: es una de las dos partes principales de la Misa."], term: "leccionario", definition: "El libro litúrgico que ordena las lecturas bíblicas de la Misa según el día y el ciclo."),
            authoredMassLesson(8, kicker: "La Misa, parte por parte", title: "El Credo", body: ["Los domingos y solemnidades, la profesión de fe permite responder a la Palabra escuchada. El Credo lo rezan el sacerdote y el pueblo, no como una declaración privada.", "El Credo niceno-constantinopolitano expresa la fe de la Iglesia en el Padre, el Hijo y el Espíritu Santo. Sus palabras unen a la asamblea con la fe transmitida por los concilios y el bautismo."], term: "profesión de fe", definition: "El Credo proclamado por toda la asamblea como respuesta a las Escrituras y a la homilía."),
            authoredMassLesson(9, kicker: "La Misa, parte por parte", title: "La oración universal", body: ["En la oración de los fieles, los bautizados ejercen su intercesión. Las intenciones incluyen normalmente a la Iglesia, a las autoridades y al mundo, a quienes sufren necesidad y a la comunidad local.", "Un ministro puede proponer las intenciones y el pueblo responde. El sacerdote introduce y concluye la oración, manteniéndola dirigida a Dios y unida a la celebración."], term: "oración universal", definition: "Las intercesiones en las que los fieles reunidos oran por la Iglesia, el mundo, quienes necesitan ayuda y la comunidad local."),
            authoredMassLesson(10, kicker: "La Misa, parte por parte", title: "La presentación de las ofrendas", body: ["El pan y el vino se llevan al altar y se preparan para la plegaria eucarística. Pueden recibirse otros dones para los pobres o para la Iglesia, pero se colocan fuera de la mesa eucarística.", "Este momento todavía no consagra los dones. Lleva al altar los signos del sacrificio de Cristo y orienta la celebración hacia la plegaria eucarística."], term: "presentación de las ofrendas", definition: "El comienzo de la liturgia eucarística, cuando se llevan al altar el pan y el vino."),
            authoredMassLesson(11, kicker: "La Misa, parte por parte", title: "La plegaria eucarística", body: ["La plegaria eucarística es el centro y culmen de toda la celebración. Por medio del sacerdote, el pueblo se une a Cristo para dar gracias al Padre y ofrecer el sacrificio.", "Incluye acción de gracias, Santo, invocación del Espíritu, relato de la institución, memorial, ofrenda, intercesiones y doxología final. El Amén de la asamblea sella esta oración."], term: "epíclesis", definition: "La invocación por la que la Iglesia pide al Padre que envíe el Espíritu Santo sobre los dones y sobre el pueblo."),
            authoredMassLesson(12, kicker: "La Misa, parte por parte", title: "La consagración", body: ["Dentro de la plegaria eucarística, el sacerdote narra las palabras y acciones de Cristo en la Última Cena. Por la fuerza del Espíritu Santo, el pan y el vino se convierten en el Cuerpo y la Sangre de Cristo.", "La Iglesia guarda silencio y adora porque no se trata de una interrupción teatral. Pertenece a la única oración que hace presente sacramentalmente el sacrificio de Cristo."], term: "consagración", definition: "El momento de la plegaria eucarística en el que el pan y el vino se convierten en el Cuerpo y la Sangre de Cristo."),
            authoredMassLesson(13, kicker: "La Misa, parte por parte", title: "El Padrenuestro y el rito de la paz", body: ["El rito de la Comunión comienza con el Padrenuestro, donde la asamblea pide el pan de cada día y el perdón. El embolismo y la doxología preparan la oración por la paz.", "El gesto de paz expresa la comunión y el amor eclesial antes de comulgar. Se ofrece con sobriedad a quienes están cerca; no interrumpe el rito ni sustituye la reconciliación."], term: "rito de la paz", definition: "El rito en el que la Iglesia pide la paz y los fieles ofrecen un signo sobrio de paz antes de la Comunión."),
            authoredMassLesson(14, kicker: "La Misa, parte por parte", title: "Comunión y envío", body: ["Los fieles se acercan a recibir el Cuerpo y la Sangre de Cristo según la disciplina de la Iglesia. Después de la Comunión, el silencio, un salmo o un himno ayudan a dar gracias por el don recibido.", "Los ritos conclusivos bendicen y envían al pueblo. La Misa termina enviando a la Iglesia a la vida cotidiana, para que lo celebrado en el altar dé fruto en el mundo."], term: "despedida", definition: "El envío final de la asamblea para vivir lo que ha celebrado en la Eucaristía.")
        ]
    )

    private static func authoredMassLesson(
        _ number: Int,
        kicker: String,
        title: String,
        body: [String],
        term: String,
        definition: String
    ) -> FormationLesson {
        FormationLesson(
            id: "mass-part-\(number)",
            trackID: "mass-part-by-part",
            partNumber: number,
            partsTotal: 14,
            kicker: kicker,
            title: title,
            bodyParagraphs: body,
            quoteText: nil,
            quoteAttribution: nil,
            glossaryTerms: [.init(term: term, definition: definition)]
        )
    }

    // The v1 track list per product spec §5 is: A Missa parte por parte (started,
    // above), Os sete sacramentos, O ano litúrgico, Sinais e símbolos, and As
    // orações explicadas. O Terço do zero and Como se confessar bem are kept as
    // extra tracks beyond that list rather than removed — they're already-written,
    // complementary content, not a gap.
    /// One catalog per language — see LocalizedCatalog.
    static var otherTracks: [FormationTrack] { otherTracksCatalog.current }

    /// The started track plus the rest, so a lesson screen can name its own
    /// track instead of hardcoding one title.
    static var allTracks: [FormationTrack] { [track] + otherTracks }

    static func track(withID id: String) -> FormationTrack? {
        allTracks.first { $0.id == id }
    }

    // Catálogo gerado: 36 lições próprias em português e inglês. O lote em
    // espanhol contém frases em inglês e, por política do Acervo, usa o
    // fallback explícito em português até haver uma fonte espanhola íntegra.
    static let otherTracksCatalog = importedOtherTracksCatalog

    static let reviewerCredit = "Revisão de conteúdo por Pe. Daniel Vasconcelos."
}
