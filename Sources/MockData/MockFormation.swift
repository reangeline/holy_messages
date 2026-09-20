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

    static let trackCatalog = LocalizedCatalog(pt: ptTrack)

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
