import Foundation

enum MockMood {
    // Vocabulary and grouping fixed by product spec: consolação needs its own
    // words (not just "absence of desolação"), or improvement becomes illegible
    // in the calendar/retrospective — a blank day and a good day would look the
    // same. See spec §1.2.
    static let stateGroups: [MoodStateGroup] = [
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

    // Each state keeps a small pool of variations (3 for now, growing toward the
    // 15–20 the spec asks for) so the same tap doesn't return the same Psalm and
    // saint every time — see MoodHistoryStore.lastReliefIndex / relief(for:excluding:).
    static let reliefByState: [String: [ReliefContent]] = [
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
        ],
    ]

    /// Picks a variation for `stateID`, avoiding `excluding` (the index shown last
    /// time) whenever more than one variation exists — see
    /// MoodHistoryStore.lastReliefIndex / recordReliefShown.
    static func relief(for stateID: String, excluding: Int? = nil) -> (content: ReliefContent, index: Int) {
        let variants = reliefByState[stateID] ?? [defaultRelief]
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

    static let pastoralCareParishName = "Paróquia Nossa Senhora Aparecida"
}
