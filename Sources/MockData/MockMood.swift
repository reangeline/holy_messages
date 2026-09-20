import Foundation

enum MockMood {
    // Vocabulary and grouping fixed by product spec: consolação needs its own
    // words (not just "absence of desolação"), or improvement becomes illegible
    // in the calendar/retrospective — a blank day and a good day would look the
    // same. See spec §1.2.
    /// One catalog per language — see LocalizedCatalog.
    static var stateGroups: [MoodStateGroup] { stateGroupsCatalog.current }

    static let stateGroupsCatalog = LocalizedCatalog(
        pt: ptStateGroups,
        en: enStateGroups,
        es: esStateGroups
    )

    private static let ptStateGroups: [MoodStateGroup] = [
        .init(id: "consolation", label: "Consolação", items: [
            .init(id: "peace", label: "Em paz"),
            .init(id: "grateful", label: "Grato"),
            .init(id: "joyful", label: "Alegre"),
            .init(id: "hopeful", label: "Esperançoso"),
            .init(id: "forgiven", label: "Perdoado"),
            .init(id: "loved", label: "Amado"),
            .init(id: "steadfast", label: "Firme"),
        ]),
        .init(id: "desolation", label: "Desolação", items: [
            .init(id: "empty", label: "Vazio"),
            .init(id: "anxious", label: "Ansioso"),
            .init(id: "guilty", label: "Culpado", isCrisisTrigger: true, isScrupulosityTrigger: true),
            .init(id: "grief", label: "Enlutado", isCrisisTrigger: true),
            .init(id: "lonely", label: "Sozinho"),
            .init(id: "angry", label: "Com raiva", isCrisisTrigger: true),
            .init(id: "dryness", label: "Árido na oração"),
            .init(id: "doubtful", label: "Em dúvida"),
            .init(id: "tired", label: "Cansado"),
        ]),
    ]

    private static let enStateGroups: [MoodStateGroup] = [
        .init(id: "consolation", label: "Consolation", items: [
            .init(id: "peace", label: "At peace"),
            .init(id: "grateful", label: "Grateful"),
            .init(id: "joyful", label: "Joyful"),
            .init(id: "hopeful", label: "Hopeful"),
            .init(id: "forgiven", label: "Forgiven"),
            .init(id: "loved", label: "Loved"),
            .init(id: "steadfast", label: "Steadfast"),
        ]),
        .init(id: "desolation", label: "Desolation", items: [
            .init(id: "empty", label: "Empty"),
            .init(id: "anxious", label: "Anxious"),
            .init(id: "guilty", label: "Guilty", isCrisisTrigger: true, isScrupulosityTrigger: true),
            .init(id: "grief", label: "Grieving", isCrisisTrigger: true),
            .init(id: "lonely", label: "Lonely"),
            .init(id: "angry", label: "Angry", isCrisisTrigger: true),
            .init(id: "dryness", label: "Dry in prayer"),
            .init(id: "doubtful", label: "Doubtful"),
            .init(id: "tired", label: "Tired"),
        ]),
    ]

    private static let esStateGroups: [MoodStateGroup] = [
        .init(id: "consolation", label: "Consuelo", items: [
            .init(id: "peace", label: "En paz"),
            .init(id: "grateful", label: "Agradecido"),
            .init(id: "joyful", label: "Alegre"),
            .init(id: "hopeful", label: "Esperanzado"),
            .init(id: "forgiven", label: "Perdonado"),
            .init(id: "loved", label: "Amado"),
            .init(id: "steadfast", label: "Firme"),
        ]),
        .init(id: "desolation", label: "Desolación", items: [
            .init(id: "empty", label: "Vacío"),
            .init(id: "anxious", label: "Ansioso"),
            .init(id: "guilty", label: "Culpable", isCrisisTrigger: true, isScrupulosityTrigger: true),
            .init(id: "grief", label: "De duelo", isCrisisTrigger: true),
            .init(id: "lonely", label: "Solo"),
            .init(id: "angry", label: "Enojado", isCrisisTrigger: true),
            .init(id: "dryness", label: "Árido en la oración"),
            .init(id: "doubtful", label: "Con dudas"),
            .init(id: "tired", label: "Cansado"),
        ]),
    ]

    /// Shown as a discreet, one-line nudge inside the relief screen the 1st/2nd time
    /// a scrupulosity-trigger state is logged within 14 days (3rd time redirects
    /// outright — see MoodHistoryStore.scrupulosityShouldRedirect).
    static let confessorNudgeLine = "Se isso for sobre um pecado específico, um confessor fixo resolve melhor do que reler isto de novo."

    static let defaultRelief = ReliefContent(
        title: "Isso também é matéria de oração",
        psalmRef: "Salmo 34",
        psalmText: "Bendirei ao Senhor em todo tempo; o seu louvor estará continuamente na minha boca.",
        psalmWhy: "Um salmo de louvor não exige que o dia tenha sido bom — só que se volte a olhar para Deus.",
        saintName: "Santa Teresinha do Menino Jesus",
        saintWhy: "Atravessou meses sem sentir nada na fé e continuou os pequenos gestos do dia mesmo assim.",
        stepTitle: "Um passo concreto",
        stepBody: "Antes de dormir, nomeie uma coisa de hoje pela qual vale dizer obrigado — mesmo que pequena."
    )

    // Each state keeps a small pool of variations (5 as of this pass, growing
    // toward the 15–20 the spec asks for) so the same tap doesn't return the same
    // Psalm and saint every time — see MoodHistoryStore.lastReliefIndex /
    // relief(for:excluding:).
    /// One catalog per language — see LocalizedCatalog.
    static var reliefByState: [String: [ReliefContent]] { reliefCatalog.current }

    // Os catálogos novos só substituem a base quando o importador aceitou as
    // quinze respostas distintas por estado. Português e inglês já passaram:
    // são 240 respostas cada, com salmo extraído de edição pública no próprio
    // idioma. O espanhol ainda não tem Saltério católico em domínio público com
    // texto limpo, então continua na ponte de OnboardingRelief — ver o guard em
    // relief(for:excluding:language:).
    static let reliefCatalog = LocalizedCatalog(
        pt: ptReviewedReliefByState.isEmpty ? ptReliefByState : ptReviewedReliefByState,
        en: enReviewedReliefByState.isEmpty ? nil : enReviewedReliefByState,
        es: esReviewedReliefByState.isEmpty ? nil : esReviewedReliefByState
    )

    private static let ptReliefByState: [String: [ReliefContent]] = [
        "peace": [
            ReliefContent(
                title: "A paz que o mundo não dá",
                psalmRef: "Salmo 23",
                psalmText: "O Senhor é o meu pastor; nada me faltará. Junto a águas tranquilas ele me conduz.",
                psalmWhy: "A paz do salmo não vem de nada ter dado errado — vem de saber quem conduz.",
                saintName: "Santa Teresa d'Ávila",
                saintWhy: "Ensinava a repetir \"nada te perturbe\" bem no meio das dificuldades reais do dia, não na ausência delas.",
                stepTitle: "Um passo concreto",
                stepBody: "Guarde esta paz com um minuto de silêncio antes da próxima tarefa, sem apressar a transição."
            ),
            ReliefContent(
                title: "Deitar em paz",
                psalmRef: "Salmo 4",
                psalmText: "Em paz me deito e logo adormeço, pois só vós, Senhor, me fazeis repousar seguro.",
                psalmWhy: "O salmista dorme em paz não porque resolveu tudo, mas porque confia em quem vigia.",
                saintName: "São Francisco de Assis",
                saintWhy: "Fez da paz uma saudação e um programa de vida inteiro: \"O Senhor vos dê a paz.\"",
                stepTitle: "Um passo concreto",
                stepBody: "Termine o dia com a Oração da Paz de São Francisco, devagar, uma frase por vez."
            ),
            ReliefContent(
                title: "Como criança no colo",
                psalmRef: "Salmo 131",
                psalmText: "Aquietei e acalmei a minha alma, como criança desmamada nos braços de sua mãe.",
                psalmWhy: "É uma paz que não entende tudo e não precisa entender — só descansa.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Chamou de \"pequena via\" justamente essa confiança de criança, sem grandeza nem ansiedade.",
                stepTitle: "Um passo concreto",
                stepBody: "Ofereça esta paz por alguém que hoje está do outro lado do estado que você já atravessou."
            ),
            ReliefContent(
                title: "Palavras de paz",
                psalmRef: "Salmo 85",
                psalmText: "Escutarei o que Deus, o Senhor, vai dizer: palavras de paz para o seu povo e para os seus fiéis.",
                psalmWhy: "A paz aqui é uma palavra que se escuta, não um sentimento que se produz sozinho.",
                saintName: "São Bento",
                saintWhy: "Resumiu a vida monástica no lema “Ora et labora”, buscando a paz no ritmo simples entre oração e trabalho.",
                stepTitle: "Um passo concreto",
                stepBody: "Escolha uma tarefa comum de hoje e faça-a devagar, como se fosse parte da oração."
            ),
            ReliefContent(
                title: "Ele é a nossa paz",
                psalmRef: "Efésios 2, 14",
                psalmText: "Porque ele é a nossa paz, ele que dos dois povos fez um só.",
                psalmWhy: "A paz cristã não é ausência de conflito — é alguém que reconcilia o que estava dividido.",
                saintName: "São Francisco de Sales",
                saintWhy: "Ensinava que a alma mansa consegue mais num dia do que a inquieta em dez anos.",
                stepTitle: "Um passo concreto",
                stepBody: "Se há alguém com quem você está em atrito, ore por essa pessoa antes de dormir hoje."
            ),
        ],
        "grateful": [
            ReliefContent(
                title: "Nenhum benefício esquecido",
                psalmRef: "Salmo 103",
                psalmText: "Bendize, ó minha alma, ao Senhor, e não te esqueças de nenhum de seus benefícios.",
                psalmWhy: "A gratidão bíblica é um exercício de memória, não só um sentimento do momento.",
                saintName: "São Francisco de Assis",
                saintWhy: "Cantou o sol, a lua, a água e até a morte como dádivas — nada era pequeno demais para agradecer.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva as três coisas de hoje pelas quais vale dizer obrigado, mesmo as pequenas."
            ),
            ReliefContent(
                title: "Porque a sua misericórdia dura para sempre",
                psalmRef: "Salmo 136",
                psalmText: "Rendei graças ao Senhor, porque ele é bom, porque a sua misericórdia dura para sempre.",
                psalmWhy: "O salmo repete o mesmo refrão 26 vezes — a gratidão, na tradição, é para se repetir, não para se esgotar.",
                saintName: "Santa Clara de Assis",
                saintWhy: "Vivia agradecendo mesmo na pobreza extrema que escolheu, sem tratar isso como resignação.",
                stepTitle: "Um passo concreto",
                stepBody: "Agradeça em voz alta, mesmo sozinho — a gratidão dita muda algo que a gratidão só pensada não muda."
            ),
            ReliefContent(
                title: "Encontrar Deus em tudo",
                psalmRef: "Salmo 116",
                psalmText: "Que darei eu ao Senhor por todos os benefícios que me tem feito?",
                psalmWhy: "A pergunta do salmista não busca uma resposta de valor igual — busca só uma resposta de amor.",
                saintName: "Santo Inácio de Loyola",
                saintWhy: "Ensinou a \"encontrar Deus em todas as coisas\", inclusive nas mais comuns do dia.",
                stepTitle: "Um passo concreto",
                stepBody: "Releia o dia de trás para frente e note onde Deus esteve sem você ter percebido na hora."
            ),
            ReliefContent(
                title: "Agradecer nas pequenas provas",
                psalmRef: "Salmo 92",
                psalmText: "Bom é render graças ao Senhor e cantar louvores ao teu nome, ó Altíssimo.",
                psalmWhy: "O salmo liga gratidão a louvor: agradecer já é uma forma de rezar.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Agradecia a Deus até pelas provações pequenas do dia a dia, chamando tudo de dom.",
                stepTitle: "Um passo concreto",
                stepBody: "Agradeça hoje por algo que normalmente você reclamaria."
            ),
            ReliefContent(
                title: "Em tudo dai graças",
                psalmRef: "1 Tessalonicenses 5, 18",
                psalmText: "Em tudo dai graças, porque esta é a vontade de Deus em Cristo Jesus para convosco.",
                psalmWhy: "“Em tudo” inclui o que ainda dói — a gratidão aqui não espera o alívio chegar primeiro.",
                saintName: "São Paulo",
                saintWhy: "Escreveu isso de dentro de uma vida marcada por perseguições, não de um momento tranquilo.",
                stepTitle: "Um passo concreto",
                stepBody: "Nomeie uma coisa difícil de hoje e agradeça por ela mesmo sem entender o motivo."
            ),
        ],
        "joyful": [
            ReliefContent(
                title: "Servi ao Senhor com alegria",
                psalmRef: "Salmo 100",
                psalmText: "Aclamai ao Senhor com júbilo, toda a terra; servi ao Senhor com alegria.",
                psalmWhy: "A alegria aqui é mandamento, não coincidência — a fé autoriza a comemorar.",
                saintName: "São Filipe Neri",
                saintWhy: "Fazia da alegria um caminho de santidade e dizia que um santo triste é um triste santo.",
                stepTitle: "Um passo concreto",
                stepBody: "Compartilhe esta alegria com alguém hoje — ela cresce quando é dada, não quando é guardada."
            ),
            ReliefContent(
                title: "A boca cheia de riso",
                psalmRef: "Salmo 126",
                psalmText: "Então a nossa boca se encheu de riso, e a nossa língua de cântico.",
                psalmWhy: "É a alegria de quem lembra de uma libertação concreta, não uma alegria sem motivo.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Via a alegria simples do dia a dia como parte da santidade, não como distração dela.",
                stepTitle: "Um passo concreto",
                stepBody: "Reze um Glória a Deus só por esta alegria, sem pedir mais nada nela."
            ),
            ReliefContent(
                title: "Provai e vede",
                psalmRef: "Salmo 34",
                psalmText: "Provai e vede que o Senhor é bom; feliz o homem que nele se refugia.",
                psalmWhy: "O convite é experimental — a alegria de hoje é evidência, não teoria.",
                saintName: "São Francisco de Assis",
                saintWhy: "Via em cada criatura um motivo de louvor, do sol ao irmão lobo.",
                stepTitle: "Um passo concreto",
                stepBody: "Guarde uma frase de hoje para lembrar desta alegria num dia mais difícil."
            ),
            ReliefContent(
                title: "Plenitude de alegria",
                psalmRef: "Salmo 16",
                psalmText: "Na tua presença há plenitude de alegria; à tua direita, delícias perpétuas.",
                psalmWhy: "A alegria do salmo tem endereço: está na presença de Deus, não em outro lugar.",
                saintName: "São João Bosco",
                saintWhy: "Dizia aos jovens que a santidade está em servir a Deus sempre alegre, e construiu uma obra inteira sobre essa ideia.",
                stepTitle: "Um passo concreto",
                stepBody: "Compartilhe com alguém, hoje, o que está te dando alegria."
            ),
            ReliefContent(
                title: "A alegria do Senhor é a força",
                psalmRef: "Neemias 8, 10",
                psalmText: "Não vos entristeçais, porque a alegria do Senhor é a vossa força.",
                psalmWhy: "A alegria aqui não é frivolidade — é o que sustenta, especialmente nos dias difíceis.",
                saintName: "Santa Clara de Assis",
                saintWhy: "Viveu na pobreza mais radical e ainda assim é lembrada pela alegria que contagiava as irmãs.",
                stepTitle: "Um passo concreto",
                stepBody: "Deixe essa alegria sustentar uma tarefa chata que você vem adiando."
            ),
        ],
        "hopeful": [
            ReliefContent(
                title: "A quem temerei?",
                psalmRef: "Salmo 27",
                psalmText: "O Senhor é a minha luz e a minha salvação; a quem temerei?",
                psalmWhy: "A esperança bíblica não nega o perigo — só nega que ele tenha a palavra final.",
                saintName: "Santa Joana d'Arc",
                saintWhy: "Manteve a esperança mesmo diante do julgamento e da fogueira, sem que isso fosse ingenuidade.",
                stepTitle: "Um passo concreto",
                stepBody: "Nomeie o que você está esperando e entregue esse pedido a Deus em uma frase simples."
            ),
            ReliefContent(
                title: "Anos de espera não perdidos",
                psalmRef: "Salmo 130",
                psalmText: "Espero no Senhor, a minha alma espera, e na sua palavra confio.",
                psalmWhy: "É uma espera ativa, apoiada numa palavra concreta, não uma espera vazia.",
                saintName: "Santa Mônica",
                saintWhy: "Esperou e rezou por décadas pela conversão do filho Agostinho, sem perder a esperança.",
                stepTitle: "Um passo concreto",
                stepBody: "Reze hoje por alguém cuja conversão ou mudança você está esperando há tempo."
            ),
            ReliefContent(
                title: "Ainda o louvarei",
                psalmRef: "Salmo 42",
                psalmText: "Por que estás abatida, ó minha alma? Espera em Deus, pois ainda o louvarei.",
                psalmWhy: "O salmista fala com a própria alma para lembrá-la do que ainda não se vê.",
                saintName: "Santo Agostinho",
                saintWhy: "Escreveu que o coração é inquieto até descansar em Deus — e a espera faz parte desse caminho.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva a esperança de hoje para poder reler quando ela parecer mais distante."
            ),
            ReliefContent(
                title: "A esperança não confunde",
                psalmRef: "Romanos 5, 5",
                psalmText: "A esperança não confunde, porque o amor de Deus foi derramado em nossos corações.",
                psalmWhy: "A esperança aqui se apoia num amor já dado, não numa garantia de que tudo vai dar certo.",
                saintName: "São Padre Pio",
                saintWhy: "Dizia que a esperança cristã nunca decepciona, porque não depende da nossa força.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva o que você espera e entregue, em oração, a parte que não depende de você."
            ),
            ReliefContent(
                title: "Minha esperança desde a juventude",
                psalmRef: "Salmo 71",
                psalmText: "Tu és a minha esperança, Senhor Deus, a minha confiança desde a minha juventude.",
                psalmWhy: "É uma esperança antiga, construída ao longo do tempo, não inventada na crise de hoje.",
                saintName: "São José",
                saintWhy: "Agiu sobre a promessa de um anjo em sonho, sem nenhuma outra garantia.",
                stepTitle: "Um passo concreto",
                stepBody: "Dê um passo pequeno e concreto hoje na direção do que você espera, mesmo sem ver o caminho todo."
            ),
        ],
        "forgiven": [
            ReliefContent(
                title: "Coberto, não escondido",
                psalmRef: "Salmo 32",
                psalmText: "Bem-aventurado aquele cuja transgressão é perdoada, cujo pecado é coberto.",
                psalmWhy: "O perdão bíblico não finge que nada aconteceu — cobre o que aconteceu com misericórdia.",
                saintName: "São Pedro",
                saintWhy: "Negou Jesus três vezes e foi, ainda assim, confirmado como a rocha da Igreja.",
                stepTitle: "Um passo concreto",
                stepBody: "Deixe este perdão ser suficiente hoje — não reabra o mesmo caso de consciência."
            ),
            ReliefContent(
                title: "Não segundo os nossos pecados",
                psalmRef: "Salmo 103",
                psalmText: "Não nos trata segundo os nossos pecados, nem nos retribui segundo as nossas iniquidades.",
                psalmWhy: "A medida do perdão de Deus é a sua misericórdia, não o tamanho da falta.",
                saintName: "Santo Agostinho",
                saintWhy: "Escreveu sobre os próprios pecados sem poupar detalhes, e ainda assim se tornou doutor da graça.",
                stepTitle: "Um passo concreto",
                stepBody: "Agradeça pela absolvição recebida em vez de recalculá-la."
            ),
            ReliefContent(
                title: "Purificado de novo",
                psalmRef: "Salmo 51",
                psalmText: "Lava-me completamente da minha iniquidade, e purifica-me do meu pecado.",
                psalmWhy: "É o salmo da penitência mais rezado da tradição — pedir para ser lavado, não só perdoado.",
                saintName: "Santa Maria Madalena",
                saintWhy: "A tradição a lembra menos pelo que carregou e mais por como amou depois de ser perdoada.",
                stepTitle: "Um passo concreto",
                stepBody: "Marque a próxima confissão já, para não deixar o alívio de hoje sem continuidade."
            ),
            ReliefContent(
                title: "Brancos como a neve",
                psalmRef: "Isaías 1, 18",
                psalmText: "Ainda que os vossos pecados sejam como escarlate, ficarão brancos como a neve.",
                psalmWhy: "A promessa não minimiza a gravidade do pecado — promete uma limpeza completa dele.",
                saintName: "São João Maria Vianney",
                saintWhy: "Passava até 16 horas por dia confessando, dizendo que Deus perdoa mais depressa do que uma mãe tira o filho do fogo.",
                stepTitle: "Um passo concreto",
                stepBody: "Se faz tempo que você não se confessa, marque um horário esta semana."
            ),
            ReliefContent(
                title: "O filho que voltou",
                psalmRef: "Lucas 15, 20",
                psalmText: "Quando ainda estava longe, seu pai o viu e, cheio de compaixão, correu, abraçou-o e o beijou.",
                psalmWhy: "O pai corre antes mesmo do pedido de perdão terminar — a iniciativa é dele, não do filho.",
                saintName: "Santa Teresa d'Ávila",
                saintWhy: "Viveu anos ainda apegada a distrações mundanas antes de se converter de vez à oração, e nunca escondeu esse período.",
                stepTitle: "Um passo concreto",
                stepBody: "Releia a parábola do filho pródigo (Lucas 15) inteira, devagar."
            ),
        ],
        "loved": [
            ReliefContent(
                title: "Tecido por Deus",
                psalmRef: "Salmo 139",
                psalmText: "Tu me sondas e me conheces... tu me teceste no ventre de minha mãe.",
                psalmWhy: "Ser amado, aqui, é ser conhecido em detalhe — não apesar disso, mas por causa disso.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Fez da pequena via inteira uma resposta a se saber amada, não uma tentativa de merecer o amor.",
                stepTitle: "Um passo concreto",
                stepBody: "Fique um minuto só recebendo este amor, sem tentar retribuir nada ainda."
            ),
            ReliefContent(
                title: "Como um pai se compadece",
                psalmRef: "Salmo 103",
                psalmText: "Como um pai se compadece de seus filhos, assim o Senhor se compadece dos que o temem.",
                psalmWhy: "A compaixão paterna do salmo não depende de mérito — depende só do vínculo.",
                saintName: "São João Apóstolo",
                saintWhy: "É lembrado como \"o discípulo amado\" — não por ser diferente dos outros, mas por ter se deixado saber amado.",
                stepTitle: "Um passo concreto",
                stepBody: "Diga a alguém hoje algo que revele que você também o ama, sem esperar a ocasião perfeita."
            ),
            ReliefContent(
                title: "Eu sou do meu amado",
                psalmRef: "Cântico dos Cânticos 6, 3",
                psalmText: "Eu sou do meu amado, e o meu amado é meu.",
                psalmWhy: "A tradição sempre leu este verso também como a alma diante de Deus, não só como poesia humana.",
                saintName: "Santa Teresa d'Ávila",
                saintWhy: "Descreveu a vida de oração como uma amizade próxima com quem sabemos que nos ama.",
                stepTitle: "Um passo concreto",
                stepBody: "Reze hoje sem pedir nada — só para estar com quem já te ama."
            ),
            ReliefContent(
                title: "Escolhido antes de nascer",
                psalmRef: "Jeremias 1, 5",
                psalmText: "Antes de te formar no ventre, eu te conheci; antes que saísses dele, te consagrei.",
                psalmWhy: "Ser amado, aqui, vem antes de qualquer mérito ou até de qualquer ação sua.",
                saintName: "São José",
                saintWhy: "Nenhuma palavra sua está registrada nos Evangelhos, e ainda assim foi escolhido para criar o próprio Filho de Deus.",
                stepTitle: "Um passo concreto",
                stepBody: "Releia hoje algo que alguém já te escreveu ou disse que mostrava esse amor."
            ),
            ReliefContent(
                title: "Ele nos amou primeiro",
                psalmRef: "1 João 4, 19",
                psalmText: "Nós amamos porque ele nos amou primeiro.",
                psalmWhy: "A ordem importa: o amor de Deus vem primeiro, o nosso é resposta, não conquista.",
                saintName: "Santo Agostinho",
                saintWhy: "Descreveu a própria conversão como o encontro tardio com um amor que já existia havia muito tempo, contado nas Confissões.",
                stepTitle: "Um passo concreto",
                stepBody: "Diga em voz alta, hoje, que você é amado — mesmo que ainda não sinta isso por completo."
            ),
        ],
        "steadfast": [
            ReliefContent(
                title: "Só ele é a minha rocha",
                psalmRef: "Salmo 62",
                psalmText: "Só em Deus repousa a minha alma; dele vem a minha salvação. Só ele é a minha rocha.",
                psalmWhy: "Firmeza, na tradição, não é força própria — é apoio numa rocha que não é a nossa.",
                saintName: "São Pedro",
                saintWhy: "Recebeu o próprio nome de \"rocha\" mesmo sendo, por natureza, instável — a firmeza veio de outro lugar.",
                stepTitle: "Um passo concreto",
                stepBody: "Nomeie em que rocha você está apoiado hoje antes de seguir para a próxima tarefa."
            ),
            ReliefContent(
                title: "Refúgio e fortaleza",
                psalmRef: "Salmo 46",
                psalmText: "Deus é o nosso refúgio e fortaleza, socorro bem presente na angústia.",
                psalmWhy: "O salmo nomeia a angústia real e, mesmo assim, chama Deus de presente — não de distante.",
                saintName: "Santo Inácio de Loyola",
                saintWhy: "Depois de ferido em batalha, reconstruiu a vida inteira sobre uma firmeza que não era mais militar.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva a decisão que esta firmeza sustenta hoje, para poder reler quando vacilar."
            ),
            ReliefContent(
                title: "Uma coisa pedi",
                psalmRef: "Salmo 27",
                psalmText: "Uma coisa pedi ao Senhor, e a buscarei: habitar na casa do Senhor todos os dias da minha vida.",
                psalmWhy: "A firmeza do salmista vem de ter simplificado o pedido a uma coisa só.",
                saintName: "Santa Joana d'Arc",
                saintWhy: "Manteve a mesma resposta sob interrogatório repetido, sem se deixar dividir.",
                stepTitle: "Um passo concreto",
                stepBody: "Escolha hoje uma coisa só para pedir, em vez de uma lista inteira."
            ),
            ReliefContent(
                title: "O voto de estabilidade",
                psalmRef: "Salmo 16",
                psalmText: "Conservo o Senhor sempre diante de mim; ele está à minha direita, e eu não vacilarei.",
                psalmWhy: "Firmeza, aqui, vem de manter o olhar fixo em alguém, não de força de vontade própria.",
                saintName: "São Bento",
                saintWhy: "Fez da estabilidade um voto formal dos seus monges: permanecer no mesmo lugar e não fugir das dificuldades.",
                stepTitle: "Um passo concreto",
                stepBody: "Escolha uma coisa que você estava pensando em abandonar e dê mais um dia a ela."
            ),
            ReliefContent(
                title: "Combati o bom combate",
                psalmRef: "2 Timóteo 4, 7",
                psalmText: "Combati o bom combate, terminei a carreira, guardei a fé.",
                psalmWhy: "É um balanço feito quase no fim da vida — a firmeza aqui é medida em anos, não num dia só.",
                saintName: "São Paulo",
                saintWhy: "Escreveu essas palavras preso, esperando a própria execução, sem recuar do que tinha pregado.",
                stepTitle: "Um passo concreto",
                stepBody: "Lembre de um compromisso antigo que você mantém até hoje, e agradeça por ele."
            ),
        ],
        "empty": [
            ReliefContent(
                title: "A tristeza não precisa ser escondida de Deus",
                psalmRef: "Salmo 42",
                psalmText: "Por que estás abatida, ó minha alma, e por que te perturbas dentro de mim? Espera em Deus.",
                psalmWhy: "O salmista fala consigo mesmo, admitindo a tristeza antes de decidir esperar.",
                saintName: "Santa Teresa de Calcutá",
                saintWhy: "Viveu décadas de escuridão interior enquanto servia os mais pobres, sem esconder a dificuldade em cartas.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva uma linha sobre o que pesa hoje — só para você, sem precisar resolver nada agora."
            ),
            ReliefContent(
                title: "Como terra seca, sem água",
                psalmRef: "Salmo 63",
                psalmText: "Ó Deus, tu és o meu Deus, ansiosamente te busco; a minha alma tem sede de ti, como terra seca e sedenta, sem água.",
                psalmWhy: "O vazio, aqui, vira busca — não é tratado como ausência de Deus, mas como sede dele.",
                saintName: "São João da Cruz",
                saintWhy: "Deu nome de \"noite escura\" a esse vazio e ensinou que ele pode purificar em vez de destruir.",
                stepTitle: "Um passo concreto",
                stepBody: "Fique cinco minutos em silêncio sem tentar preencher o vazio com nada."
            ),
            ReliefContent(
                title: "Até quando, Senhor?",
                psalmRef: "Salmo 13",
                psalmText: "Até quando, Senhor? Esquecer-te-ás de mim para sempre?",
                psalmWhy: "A tradição guarda este grito como oração legítima, não como falta de fé.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Atravessou uma \"noite da fé\" no fim da vida e continuou os pequenos gestos mesmo sem sentir nada.",
                stepTitle: "Um passo concreto",
                stepBody: "Diga esta pergunta a Deus em voz alta, sem suavizá-la."
            ),
            ReliefContent(
                title: "Vaidade das vaidades",
                psalmRef: "Eclesiastes 1, 2",
                psalmText: "Vaidade das vaidades, diz o Pregador, vaidade das vaidades; tudo é vaidade.",
                psalmWhy: "A Bíblia tem um livro inteiro dedicado a nomear o vazio sem pressa de resolvê-lo na mesma página.",
                saintName: "Santo Agostinho",
                saintWhy: "Descreveu o próprio coração como inquieto até descansar em Deus — o vazio, para ele, era sinal de uma busca ainda não terminada.",
                stepTitle: "Um passo concreto",
                stepBody: "Nomeie o que você tentou usar para preencher esse vazio nos últimos dias."
            ),
            ReliefContent(
                title: "Do pranto à dança",
                psalmRef: "Salmo 30, 11",
                psalmText: "Convertes-te o meu pranto em dança; tiraste-me o cilício e me cingiste de alegria.",
                psalmWhy: "O salmista lembra uma reviravolta passada como prova de que o vazio de hoje não é a palavra final.",
                saintName: "São Padre Pio",
                saintWhy: "Viveu longos períodos de aridez espiritual e via neles uma passagem, não um destino.",
                stepTitle: "Um passo concreto",
                stepBody: "Lembre de uma vez em que um vazio parecido já passou, e anote como foi."
            ),
        ],
        "anxious": [
            ReliefContent(
                title: "A ansiedade também pode virar oração",
                psalmRef: "Salmo 55",
                psalmText: "Lança sobre o Senhor o teu fardo, e ele te sustentará; jamais permitirá que o justo seja abalado.",
                psalmWhy: "\"Lançar\" é um verbo de ação: entregar o peso, não apenas descrevê-lo.",
                saintName: "São Padre Pio",
                saintWhy: "Aconselhava: \"reze, espere e não se preocupe\" — não porque fosse fácil, mas porque a preocupação sozinha não ajuda.",
                stepTitle: "Um passo concreto",
                stepBody: "Respire fundo três vezes e reze um Pai-Nosso devagar, prestando atenção em cada palavra."
            ),
            ReliefContent(
                title: "Não andeis ansiosos",
                psalmRef: "Filipenses 4, 6-7",
                psalmText: "Não andeis ansiosos por coisa alguma... e a paz de Deus guardará os vossos corações.",
                psalmWhy: "A carta não manda deixar de sentir — manda entregar em oração o que se sente.",
                saintName: "São Paulo",
                saintWhy: "Escreveu essas palavras preso, sem saber o próprio destino — não de um lugar confortável.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva o que te preocupa numa lista curta e ofereça cada item, um por um."
            ),
            ReliefContent(
                title: "As tuas consolações",
                psalmRef: "Salmo 94",
                psalmText: "Quando a ansiedade já ia grande dentro de mim, as tuas consolações confortaram a minha alma.",
                psalmWhy: "O salmista nomeia o tamanho da ansiedade antes de nomear o consolo — nenhum dos dois é escondido.",
                saintName: "São Francisco de Sales",
                saintWhy: "Escreveu que nada perturba tanto a alma quanto a própria ansiedade em querer se livrar dela depressa.",
                stepTitle: "Um passo concreto",
                stepBody: "Reduza o próximo passo ao menor tamanho possível — só o que cabe nesta hora."
            ),
            ReliefContent(
                title: "Não temas receber",
                psalmRef: "Mateus 1, 20",
                psalmText: "José, filho de Davi, não temas receber Maria, tua esposa.",
                psalmWhy: "O anjo fala direto ao medo de José antes de explicar qualquer coisa — a ansiedade é nomeada primeiro.",
                saintName: "São José",
                saintWhy: "Recebeu uma notícia que mudava tudo, em sonho, sem tempo de se preparar, e agiu com confiança mesmo assim.",
                stepTitle: "Um passo concreto",
                stepBody: "Nomeie exatamente o que está te deixando ansioso, numa frase só."
            ),
            ReliefContent(
                title: "Aquietai-vos",
                psalmRef: "Salmo 46, 10",
                psalmText: "Aquietai-vos e sabei que eu sou Deus; serei exaltado entre as nações.",
                psalmWhy: "O mandamento é literal: parar, antes de qualquer outra coisa.",
                saintName: "Santa Teresa d'Ávila",
                saintWhy: "Escreveu o poema “Nada te perturbe” depois de décadas aprendendo, na prática, a aquietar a própria mente inquieta.",
                stepTitle: "Um passo concreto",
                stepBody: "Fique um minuto inteiro em silêncio antes de reagir ao que te preocupa."
            ),
        ],
        "guilty": [
            ReliefContent(
                title: "Segundo a tua bondade",
                psalmRef: "Salmo 51",
                psalmText: "Tem misericórdia de mim, ó Deus, segundo a tua bondade; apaga as minhas transgressões.",
                psalmWhy: "O pedido não é medido pela falta — é medido pela bondade de quem perdoa.",
                saintName: "Rei Davi",
                saintWhy: "Escreveu este salmo depois de uma falta grave, sem se esconder dela nem ficar preso a ela.",
                stepTitle: "Um passo concreto",
                stepBody: "Leve isto à confissão em vez de continuar revisando sozinho."
            ),
            ReliefContent(
                title: "Em ti há perdão",
                psalmRef: "Salmo 130",
                psalmText: "Se tu, Senhor, observares os pecados, quem subsistirá? Mas em ti há perdão.",
                psalmWhy: "O salmo admite que ninguém resistiria a um julgamento só pelos próprios méritos — e aponta para o perdão, não para o desespero.",
                saintName: "Santo Agostinho",
                saintWhy: "Escreveu sobre os próprios pecados em detalhe nas Confissões, e isso não o afastou da santidade — foi parte do caminho até ela.",
                stepTitle: "Um passo concreto",
                stepBody: "Marque um horário de confissão fixo esta semana, com um confessor de sua confiança."
            ),
            ReliefContent(
                title: "Fiel e justo para perdoar",
                psalmRef: "1 João 1, 9",
                psalmText: "Se confessarmos os nossos pecados, ele é fiel e justo para nos perdoar e nos purificar de toda injustiça.",
                psalmWhy: "A promessa é condicional só à confissão — não a sentir-se merecedor primeiro.",
                saintName: "Santa Maria Madalena",
                saintWhy: "A tradição a lembra pelo muito que amou depois de ser perdoada, não pelo que carregou antes.",
                stepTitle: "Um passo concreto",
                stepBody: "Depois de se confessar, considere o caso encerrado — reabri-lo sozinho não é fidelidade, é escrúpulo."
            ),
            ReliefContent(
                title: "Tira o pecado do mundo",
                psalmRef: "João 1, 29",
                psalmText: "Eis o Cordeiro de Deus, que tira o pecado do mundo.",
                psalmWhy: "A culpa encontra aqui um endereço concreto: não é carregada sozinha, é tirada por outro.",
                saintName: "São João Maria Vianney",
                saintWhy: "Dedicou a vida inteira a ouvir confissões, convencido de que nenhuma culpa era grande demais para a misericórdia de Deus.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva o que está pesando e leve esse papel para a confissão."
            ),
            ReliefContent(
                title: "Restaurado depois da queda",
                psalmRef: "João 21, 17",
                psalmText: "Simão, filho de João, amas-me? [...] Apascenta as minhas ovelhas.",
                psalmWhy: "Jesus pergunta a Pedro três vezes se ele o ama — uma vez por cada negação — e devolve, em vez de cobrar, uma missão.",
                saintName: "São Pedro",
                saintWhy: "Foi confirmado como líder da Igreja depois de ter negado Jesus três vezes na mesma noite.",
                stepTitle: "Um passo concreto",
                stepBody: "Depois de confessado, aceite uma tarefa concreta de serviço, por menor que seja."
            ),
        ],
        "grief": [
            ReliefContent(
                title: "Perto dos de coração quebrantado",
                psalmRef: "Salmo 34",
                psalmText: "Perto está o Senhor dos que têm o coração quebrantado, e salva os de espírito abatido.",
                psalmWhy: "A proximidade prometida é justamente no quebrantamento, não depois dele.",
                saintName: "Nossa Senhora das Dores",
                saintWhy: "A tradição guarda sete dores marianas — o luto tem lugar reconhecido na vida de Maria, não é exceção a evitar.",
                stepTitle: "Um passo concreto",
                stepBody: "Acenda uma vela ou reze um Ave-Maria por quem você perdeu, sem pressa de seguir em frente."
            ),
            ReliefContent(
                title: "Jesus chorou",
                psalmRef: "João 11, 35",
                psalmText: "Jesus chorou.",
                psalmWhy: "O versículo mais curto do Evangelho é sobre luto — Deus feito homem chora por um amigo, mesmo sabendo o que viria depois.",
                saintName: "Santa Mônica",
                saintWhy: "Chorou anos pelo filho antes de qualquer sinal de conversão — o luto e a esperança conviveram nela.",
                stepTitle: "Um passo concreto",
                stepBody: "Permita-se chorar hoje, se vier — não é falta de fé, é parte dela."
            ),
            ReliefContent(
                title: "Preciosa aos olhos do Senhor",
                psalmRef: "Salmo 116",
                psalmText: "Preciosa é aos olhos do Senhor a morte dos seus santos.",
                psalmWhy: "A tradição lê a morte como preciosa a Deus, não como derrota — sem que isso minimize a dor de quem fica.",
                saintName: "São Padre Pio",
                saintWhy: "Acompanhou muitos moribundos e dizia que rezar por eles era um dos atos mais importantes do dia.",
                stepTitle: "Um passo concreto",
                stepBody: "Ofereça uma Missa ou um terço pela pessoa que você perdeu."
            ),
            ReliefContent(
                title: "Meu filho, meu filho",
                psalmRef: "2 Samuel 18, 33",
                psalmText: "Meu filho Absalão! Meu filho, meu filho Absalão! Quem me dera que eu morrera por ti!",
                psalmWhy: "É um dos lamentos mais crus da Bíblia, sem nenhuma tentativa de suavizar a dor.",
                saintName: "Rei Davi",
                saintWhy: "Chorou abertamente pela morte do próprio filho, mesmo sendo rei, sem esconder o luto de ninguém.",
                stepTitle: "Um passo concreto",
                stepBody: "Diga o nome de quem você perdeu em voz alta, hoje."
            ),
            ReliefContent(
                title: "Bem-aventurados os que choram",
                psalmRef: "Mateus 5, 4",
                psalmText: "Bem-aventurados os que choram, porque serão consolados.",
                psalmWhy: "A bem-aventurança não pula o choro para chegar ao consolo — ela nomeia os dois.",
                saintName: "Santa Teresa de Calcutá",
                saintWhy: "Segurava a mão de moribundos para que ninguém morresse sozinho, tratando o luto de cada família como algo sagrado.",
                stepTitle: "Um passo concreto",
                stepBody: "Permita-se um tempo determinado hoje só para lembrar, sem culpa por ainda sentir falta."
            ),
        ],
        "lonely": [
            ReliefContent(
                title: "Estou sozinho e aflito",
                psalmRef: "Salmo 25",
                psalmText: "Estou sozinho e aflito; volta-te para mim e tem piedade de mim.",
                psalmWhy: "O salmista nomeia a solidão diretamente a Deus, em vez de escondê-la ou minimizá-la.",
                saintName: "São Francisco Xavier",
                saintWhy: "Morreu sozinho numa ilha, longe de todos os que conhecia, ainda em missão.",
                stepTitle: "Um passo concreto",
                stepBody: "Mande uma mensagem simples para alguém hoje, mesmo que pareça pouco."
            ),
            ReliefContent(
                title: "Estou convosco todos os dias",
                psalmRef: "Mateus 28, 20",
                psalmText: "Eis que eu estou convosco todos os dias, até o fim dos tempos.",
                psalmWhy: "A promessa não depende de sentir companhia — é feita para valer mesmo quando não se sente.",
                saintName: "Santa Teresa de Calcutá",
                saintWhy: "Falava da solidão dos mais pobres e via nela um lugar onde Cristo mesmo se fazia presente.",
                stepTitle: "Um passo concreto",
                stepBody: "Faça uma visita ao Santíssimo, ou apenas uma pausa de oração, e nomeie esta solidão ali."
            ),
            ReliefContent(
                title: "Um lar para os solitários",
                psalmRef: "Salmo 68",
                psalmText: "Deus dá aos solitários um lar; liberta os presos e os leva à prosperidade.",
                psalmWhy: "O salmo promete lar a quem não tem, não conforto abstrato — algo concreto.",
                saintName: "São José",
                saintWhy: "Atravessou o exílio no Egito longe de tudo o que conhecia, protegendo em silêncio quem lhe foi confiado.",
                stepTitle: "Um passo concreto",
                stepBody: "Procure uma comunidade paroquial próxima esta semana, mesmo que seja só para conhecer."
            ),
            ReliefContent(
                title: "Não é bom que o homem esteja só",
                psalmRef: "Gênesis 2, 18",
                psalmText: "Não é bom que o homem esteja só; far-lhe-ei uma ajudadora idônea para ele.",
                psalmWhy: "Desde o início, a Escritura já reconhece a solidão como algo que não deveria ser permanente.",
                saintName: "São Bento",
                saintWhy: "Viveu como eremita antes de fundar comunidades — passou pela solidão antes de construir um jeito de vida em conjunto.",
                stepTitle: "Um passo concreto",
                stepBody: "Procure hoje uma comunidade de oração ou um grupo da paróquia para conhecer."
            ),
            ReliefContent(
                title: "Não temas, eu sou contigo",
                psalmRef: "Isaías 41, 10",
                psalmText: "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus.",
                psalmWhy: "A promessa é de presença, não de companhia visível — o que muda é saber que não está mesmo sozinho.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Viveu boa parte da vida religiosa num convento pequeno e fechado, sem nunca viajar, e ainda assim é padroeira das missões.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva uma carta ou mensagem para alguém que também pode estar sozinho hoje."
            ),
        ],
        "angry": [
            ReliefContent(
                title: "Confia e faze o bem",
                psalmRef: "Salmo 37",
                psalmText: "Não te irrites por causa dos que praticam o mal... confia no Senhor e faze o bem.",
                psalmWhy: "O salmo não nega o motivo da raiva — só pede para não deixar que ela decida a próxima ação.",
                saintName: "São Francisco de Sales",
                saintWhy: "Era conhecido pela mansidão, mas escreveu que aprendeu isso enfrentando o próprio temperamento difícil.",
                stepTitle: "Um passo concreto",
                stepBody: "Espere uma hora antes de responder a quem te irritou hoje."
            ),
            ReliefContent(
                title: "Irai-vos, e não pequeis",
                psalmRef: "Efésios 4, 26",
                psalmText: "Irai-vos, e não pequeis; não se ponha o sol sobre a vossa ira.",
                psalmWhy: "A raiva em si não é condenada — o texto pede só que ela não vire moradia.",
                saintName: "Santo Inácio de Loyola",
                saintWhy: "Teve um temperamento combativo antes da conversão e aprendeu a discernir os próprios impulsos antes de agir.",
                stepTitle: "Um passo concreto",
                stepBody: "Nomeie exatamente o que te irritou, numa frase, antes de decidir o que fazer com isso."
            ),
            ReliefContent(
                title: "Consultai em silêncio o coração",
                psalmRef: "Salmo 4",
                psalmText: "Irai-vos, mas não pequeis; consultai em silêncio o vosso coração, sobre o leito, e sossegai.",
                psalmWhy: "O conselho é literal: adiar a decisão até o silêncio poder falar mais alto que a raiva.",
                saintName: "Santa Teresa d'Ávila",
                saintWhy: "Descrevia o próprio gênio forte e ensinava a levar cada reação primeiro à oração.",
                stepTitle: "Um passo concreto",
                stepBody: "Ofereça esta raiva em oração antes de decidir se vai falar sobre ela ainda hoje."
            ),
            ReliefContent(
                title: "A resposta branda",
                psalmRef: "Provérbios 15, 1",
                psalmText: "A resposta branda desvia o furor, mas a palavra dura suscita a ira.",
                psalmWhy: "O provérbio não pede pra fingir que não há raiva — pede pra escolher a resposta com cuidado.",
                saintName: "Santo Agostinho",
                saintWhy: "Tinha um temperamento intenso na juventude e escreveu, já bispo, sobre transformar a paixão em zelo em vez de violência.",
                stepTitle: "Um passo concreto",
                stepBody: "Antes de responder, escreva o que você diria — e releia antes de enviar ou falar."
            ),
            ReliefContent(
                title: "Pronto para ouvir, lento para se irar",
                psalmRef: "Tiago 1, 19-20",
                psalmText: "Todo homem seja pronto para ouvir, tardio para falar, tardio para se irar; porque a ira do homem não opera a justiça de Deus.",
                psalmWhy: "A ordem importa: ouvir vem antes de falar, e falar vem antes de se irar.",
                saintName: "São Padre Pio",
                saintWhy: "Era conhecido por respostas diretas, mas insistia que a caridade vinha sempre antes da correção.",
                stepTitle: "Um passo concreto",
                stepBody: "Pratique hoje ouvir até o fim antes de formular sua resposta."
            ),
        ],
        "dryness": [
            ReliefContent(
                title: "A aridez também é oração",
                psalmRef: "Salmo 62",
                psalmText: "Minha alma tem sede de vós; minha carne vos deseja, como terra árida, sedenta, sem água.",
                psalmWhy: "O salmista descreve a sede antes de descrever a saciedade — a busca já é o começo da resposta.",
                saintName: "São João da Cruz",
                saintWhy: "Chamou esse deserto de \"noite escura\" e ensinou que ele purifica em vez de destruir a fé.",
                stepTitle: "Um passo concreto",
                stepBody: "Reze o Terço de hoje até o fim, mesmo sem sentir nada. A fidelidade, aqui, importa mais que o sentimento."
            ),
            ReliefContent(
                title: "Terra sedenta",
                psalmRef: "Salmo 143",
                psalmText: "A minha alma tem sede de ti como terra sedenta.",
                psalmWhy: "A sede é sinal de vida, não de fracasso na oração — quem não sente nada raramente reza sobre isso.",
                saintName: "Santa Teresa d'Ávila",
                saintWhy: "Passou anos de aridez no início da vida de oração antes de qualquer consolação sensível.",
                stepTitle: "Um passo concreto",
                stepBody: "Mantenha o mesmo horário de oração de sempre, mesmo sentindo que \"não está adiantando\"."
            ),
            ReliefContent(
                title: "Dia e noite clamo",
                psalmRef: "Salmo 88",
                psalmText: "Senhor, Deus da minha salvação, dia e noite clamo diante de ti.",
                psalmWhy: "É um dos salmos mais duros do saltério e, ainda assim, permanece dirigido a Deus, não abandonado.",
                saintName: "Santa Teresa de Calcutá",
                saintWhy: "Viveu décadas sem sentir a presença de Deus na oração e continuou rezando e servindo assim mesmo.",
                stepTitle: "Um passo concreto",
                stepBody: "Troque o pedido de \"sentir algo\" por um pedido de fidelidade só por hoje."
            ),
            ReliefContent(
                title: "Sequer sinto que rezo",
                psalmRef: "Salmo 22",
                psalmText: "Deus meu, Deus meu, por que me desamparaste? [...] Clamo de dia, e não me respondes.",
                psalmWhy: "É o salmo que o próprio Jesus reza na cruz — a aridez extrema tem lugar até ali.",
                saintName: "Santa Teresinha do Menino Jesus",
                saintWhy: "Nos últimos meses de vida, descreveu não sentir nada na fé, e continuou rezando mesmo assim.",
                stepTitle: "Um passo concreto",
                stepBody: "Reze uma oração decorada até o fim, mesmo sentindo que as palavras estão vazias."
            ),
            ReliefContent(
                title: "Sem consolação sensível",
                psalmRef: "Salmo 42, 3",
                psalmText: "As minhas lágrimas têm sido o meu alimento de dia e de noite, enquanto me dizem continuamente: Onde está o teu Deus?",
                psalmWhy: "A pergunta dos outros (“onde está o teu Deus?”) é tão dura quanto a própria aridez.",
                saintName: "São Padre Pio",
                saintWhy: "Relatou longos períodos sem nenhuma consolação sensível na oração, apesar da intensidade conhecida da sua vida espiritual.",
                stepTitle: "Um passo concreto",
                stepBody: "Continue com o tempo de oração de hoje, mesmo reduzido, em vez de pular por completo."
            ),
        ],
        "doubtful": [
            ReliefContent(
                title: "Ajuda a minha pouca fé",
                psalmRef: "Marcos 9, 24",
                psalmText: "Creio, Senhor! Ajuda a minha pouca fé.",
                psalmWhy: "A frase junta fé e dúvida na mesma respiração — não são tratadas como incompatíveis.",
                saintName: "São Tomé Apóstolo",
                saintWhy: "Pediu para ver antes de crer e, mesmo assim, é lembrado pela confissão de fé mais direta dos Evangelhos.",
                stepTitle: "Um passo concreto",
                stepBody: "Diga esta frase em voz alta hoje, sem esperar a dúvida desaparecer primeiro."
            ),
            ReliefContent(
                title: "Quase resvalaram os meus pés",
                psalmRef: "Salmo 73",
                psalmText: "Quase resvalaram os meus pés... mas entendi isso quando entrei no santuário de Deus.",
                psalmWhy: "O salmista admite que quase perdeu a fé vendo o mundo, e situa a resposta num lugar de oração, não num argumento.",
                saintName: "Santo Agostinho",
                saintWhy: "Passou anos afastado antes de qualquer certeza, e via a própria busca como parte do caminho até a fé.",
                stepTitle: "Um passo concreto",
                stepBody: "Leve esta dúvida a um padre ou a alguém de confiança, em vez de resolvê-la sozinho lendo mais um artigo."
            ),
            ReliefContent(
                title: "Compaixão pelos que duvidam",
                psalmRef: "Judas 1, 22",
                psalmText: "Tende compaixão de alguns que estão em dúvida.",
                psalmWhy: "A dúvida, aqui, pede compaixão — inclusive a que se tem consigo mesmo.",
                saintName: "Beata Teresa de Calcutá",
                saintWhy: "Suas cartas revelaram décadas de crise de fé ao lado de uma vida inteira de serviço — as duas coisas coexistiram nela.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva a dúvida como ela é, sem tentar resolvê-la ainda — só nomeá-la já é oração."
            ),
            ReliefContent(
                title: "Por que duvidaste?",
                psalmRef: "Mateus 14, 31",
                psalmText: "Ó homem de pequena fé, por que duvidaste?",
                psalmWhy: "Pedro só afunda depois de já ter dado alguns passos sobre a água — a dúvida chegou no meio do caminho, não antes dele.",
                saintName: "São Pedro",
                saintWhy: "Teve fé o bastante para sair do barco, e dúvida o bastante para começar a afundar — as duas coisas ao mesmo tempo.",
                stepTitle: "Um passo concreto",
                stepBody: "Dê o próximo passo mesmo com dúvida, em vez de esperar ela desaparecer primeiro."
            ),
            ReliefContent(
                title: "Fé é o que ainda não se vê",
                psalmRef: "Hebreus 11, 1",
                psalmText: "Ora, a fé é o firme fundamento das coisas que se esperam, e a prova das coisas que se não veem.",
                psalmWhy: "A definição já pressupõe que fé e dúvida vivem perto uma da outra — fé é precisamente sobre o que não se vê.",
                saintName: "São João da Cruz",
                saintWhy: "Escreveu que a fé é como a noite para a alma: escura, mas é exatamente o caminho para a luz.",
                stepTitle: "Um passo concreto",
                stepBody: "Escreva uma pergunta que você tem sobre a fé e leve a um padre ou catequista de confiança."
            ),
        ],
        "tired": [
            ReliefContent(
                title: "Eu vos aliviarei",
                psalmRef: "Mateus 11, 28",
                psalmText: "Vinde a mim, todos os que estais cansados e sobrecarregados, e eu vos aliviarei.",
                psalmWhy: "O convite é dirigido justamente a quem está cansado — não a quem já resolveu o cansaço sozinho.",
                saintName: "São José",
                saintWhy: "Trabalhador manual, sem nenhuma palavra sua registrada nos Evangelhos — a santidade dele foi feita de trabalho silencioso.",
                stepTitle: "Um passo concreto",
                stepBody: "Permita-se descansar hoje sem culpa, como um ato de confiança, não de preguiça."
            ),
            ReliefContent(
                title: "Sobem com asas como águias",
                psalmRef: "Isaías 40, 31",
                psalmText: "Os que esperam no Senhor renovam as suas forças; sobem com asas como águias.",
                psalmWhy: "A força prometida não é produzida pelo esforço próprio — é renovada em quem espera.",
                saintName: "Santa Teresa de Calcutá",
                saintWhy: "Mantinha um ritmo de trabalho exaustivo e insistia que a oração vinha antes, não depois de exausta.",
                stepTitle: "Um passo concreto",
                stepBody: "Encurte a oração de hoje em vez de pulá-la — cinco minutos bastam quando o corpo está no limite."
            ),
            ReliefContent(
                title: "O guarda de Israel não dorme",
                psalmRef: "Salmo 121",
                psalmText: "Não adormecerá aquele que te guarda. Eis que não adormece, nem dorme, o guarda de Israel.",
                psalmWhy: "Você pode descansar exatamente porque a vigília não depende de você continuar acordado.",
                saintName: "São Padre Pio",
                saintWhy: "Vivia exausto pelo próprio corpo e ainda assim confiava a vigilância inteira a Deus, noite após noite.",
                stepTitle: "Um passo concreto",
                stepBody: "Durma mais cedo hoje, entregando o que ficou pendente para amanhã."
            ),
            ReliefContent(
                title: "Descanso no sétimo dia",
                psalmRef: "Gênesis 2, 2-3",
                psalmText: "E, havendo Deus terminado no dia sétimo a obra que fizera, descansou no sétimo dia de toda a obra que tinha feito.",
                psalmWhy: "Se até Deus descansa depois de criar, o cansaço não é falha — é parte do próprio ritmo da criação.",
                saintName: "São João Bosco",
                saintWhy: "Trabalhava exaustivamente pelos jovens e dizia aos padres que descansar também era obedecer a Deus.",
                stepTitle: "Um passo concreto",
                stepBody: "Reserve hoje um tempo de descanso real, sem culpa, como parte do plano — não como sobra dele."
            ),
            ReliefContent(
                title: "Ele dá o sono ao seu amado",
                psalmRef: "Salmo 127, 2",
                psalmText: "Inútil vos será levantar de madrugada, repousar tarde [...] pois ele o dá aos seus amados enquanto dormem.",
                psalmWhy: "O salmo desafia diretamente a ideia de que só o esforço extra garante o resultado.",
                saintName: "Santo Inácio de Loyola",
                saintWhy: "Ensinava a fazer o exame antes de dormir e depois descansar de fato, confiando o resto a Deus.",
                stepTitle: "Um passo concreto",
                stepBody: "Vá dormir hoje sem terminar a lista de tarefas, confiando o resto ao amanhã."
            ),
        ],
    ]

    /// Picks a variation for `stateID`, avoiding `excluding` (the index shown last
    /// time) whenever more than one variation exists — see
    /// MoodHistoryStore.lastReliefIndex / recordReliefShown.
    static func relief(
        for stateID: String,
        excluding: Int? = nil,
        language: AppLanguage = AppLanguagePreference.resolveCurrent()
    ) -> (content: ReliefContent, index: Int) {
        guard language == .pt || reliefCatalog.hasOwnCatalog(for: language) else {
            return (OnboardingRelief.content(spirit2: onboardingState(for: stateID), language: language), 0)
        }

        let variants = reliefCatalog[language][stateID] ?? [defaultRelief]
        guard variants.count > 1 else {
            return (variants.first ?? defaultRelief, 0)
        }
        var pool = Array(variants.indices)
        if let excluding {
            pool.removeAll { $0 == excluding }
        }
        let chosen = pool.randomElement() ?? 0
        return (variants[chosen], chosen)
    }

    /// The temporary trilingual pool has four reviewed pastoral responses. It
    /// prevents a Portuguese fallback while the complete 15-per-state catalog
    /// is researched and imported. Once that catalog exists, `reliefCatalog`
    /// takes precedence and this bridge is unused.
    private static func onboardingState(for stateID: String) -> String? {
        switch stateID {
        case "tired": "tired"
        case "anxious", "angry", "guilty": "fear"
        case "lonely": "lonely"
        case "empty", "dryness", "doubtful", "grief": "meaningless"
        default: nil
        }
    }

    static let pastoralCareParishName = "Paróquia Nossa Senhora Aparecida"

    /// Which group ("consolation"/"desolation") a state id belongs to — used to
    /// give the calendar's daily mark its own (still neutral, non-judgmental)
    /// color per group, instead of one flat "something was logged" dot. See
    /// CalendarRootView.dayCell.
    static func group(forStateID id: String) -> String? {
        stateGroups.first { $0.items.contains { $0.id == id } }?.id
    }

    static func stateLabel(for stateID: String) -> String? {
        stateGroups.lazy.flatMap(\.items).first { $0.id == stateID }?.label
    }

    static func saintNames(for stateID: String) -> [String] {
        (ptReliefByState[stateID] ?? []).map(\.saintName)
    }
}
