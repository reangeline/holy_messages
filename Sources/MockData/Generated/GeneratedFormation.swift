// GERADO — não editar à mão.
// Origem: ~/Documents/Missale-pesquisa/entregas, importado por
// scripts/import_acervo.py. Reimportar em vez de corrigir aqui.
//
// Formação por trilha. O terceiro parágrafo repetido nas 36 lições foi
// retirado; cada parte mantém os três parágrafos próprios que passaram na
// revisão. Os três catálogos foram redigidos em seu próprio idioma.

import Foundation

extension MockFormation {
    static let ptImportedOtherTracks: [FormationTrack] = [
        .init(
            id: "sacraments",
            title: "Os sete sacramentos",
            meta: "7 partes · 4 min cada",
            progress: 0,
            nextUp: "Parte 1: O Batismo",
            lessons: [
                .init(
                    id: "sacraments-1-pt",
                    trackID: "sacraments",
                    partNumber: 1,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "O Batismo",
                    bodyParagraphs: ["Como começa a vida sacramental? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra água será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Batismo é a porta dos sacramentos e comunica uma vida nova em Cristo; Catecismo §§1213–1284. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A próxima parte trata do sacramento que fortalece essa vida para o testemunho. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Batismo é a porta dos sacramentos e comunica uma vida nova em Cristo; Catecismo §§1213–1284.",
                    glossaryTerms: [.init(term: "água", definition: "Água: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "sacraments-2-pt",
                    trackID: "sacraments",
                    partNumber: 2,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "A Confirmação",
                    bodyParagraphs: ["O que a Confirmação acrescenta ao Batismo? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra unção será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Confirmação aperfeiçoa a graça batismal e vincula o cristão mais plenamente à Igreja; Catecismo §§1285–1321. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Depois da unção, a trilha chega ao sacramento que alimenta a comunhão. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Confirmação aperfeiçoa a graça batismal e vincula o cristão mais plenamente à Igreja; Catecismo §§1285–1321.",
                    glossaryTerms: [.init(term: "unção", definition: "Unção: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "sacraments-3-pt",
                    trackID: "sacraments",
                    partNumber: 3,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "A Eucaristia",
                    bodyParagraphs: ["Por que a Eucaristia é o centro da vida cristã? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Eucaristia será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Eucaristia torna presente o sacrifício de Cristo e é fonte e ápice da vida cristã; Catecismo §§1322–1419. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O próximo sacramento trata da volta concreta à comunhão quando há pecado. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Eucaristia torna presente o sacrifício de Cristo e é fonte e ápice da vida cristã; Catecismo §§1322–1419.",
                    glossaryTerms: [.init(term: "Eucaristia", definition: "Eucaristia: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "sacraments-4-pt",
                    trackID: "sacraments",
                    partNumber: 4,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "A Penitência",
                    bodyParagraphs: ["O que acontece quando a comunhão é ferida pelo pecado? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra reconciliação será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O sacramento da Penitência oferece conversão, confissão e absolvição por meio do ministério da Igreja; Catecismo §§1422–1498. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A trilha segue para um sacramento voltado à fragilidade do corpo e à doença. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O sacramento da Penitência oferece conversão, confissão e absolvição por meio do ministério da Igreja; Catecismo §§1422–1498.",
                    glossaryTerms: [.init(term: "reconciliação", definition: "Reconciliação: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "sacraments-5-pt",
                    trackID: "sacraments",
                    partNumber: 5,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "A Unção dos enfermos",
                    bodyParagraphs: ["A Unção é somente para os últimos instantes? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Unção dos enfermos será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Unção dos enfermos une a pessoa doente à paixão de Cristo, dá força e pode trazer o perdão dos pecados; Catecismo §§1499–1532. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O próximo tema muda da doença para o serviço ordenado da Igreja. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Unção dos enfermos une a pessoa doente à paixão de Cristo, dá força e pode trazer o perdão dos pecados; Catecismo §§1499–1532.",
                    glossaryTerms: [.init(term: "Unção dos enfermos", definition: "Unção dos enfermos: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "sacraments-6-pt",
                    trackID: "sacraments",
                    partNumber: 6,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "A Ordem",
                    bodyParagraphs: ["O que o sacramento da Ordem entrega à Igreja? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra sacerdócio ministerial será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Ordem configura o ministro a Cristo para servir a comunidade e celebrar os sacramentos; Catecismo §§1536–1600. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O último sacramento da série trata da aliança conjugal e da vida familiar. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Ordem configura o ministro a Cristo para servir a comunidade e celebrar os sacramentos; Catecismo §§1536–1600.",
                    glossaryTerms: [.init(term: "sacerdócio ministerial", definition: "Sacerdócio ministerial: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "sacraments-7-pt",
                    trackID: "sacraments",
                    partNumber: 7,
                    partsTotal: 7,
                    kicker: "Os sete sacramentos",
                    title: "O Matrimônio",
                    bodyParagraphs: ["Por que o Matrimônio é um sacramento? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra aliança será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Matrimônio estabelece uma aliança entre os cônjuges e participa da aliança de Cristo com a Igreja; Catecismo §§1601–1666. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Com os sete sacramentos vistos, a trilha passa a acompanhar o tempo em que a Igreja os celebra. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Matrimônio estabelece uma aliança entre os cônjuges e participa da aliança de Cristo com a Igreja; Catecismo §§1601–1666.",
                    glossaryTerms: [.init(term: "aliança", definition: "Aliança: termo usado nesta parte para nomear o núcleo do tema.")]
                )
            ]
        ),
        .init(
            id: "liturgical-year",
            title: "O Ano Litúrgico",
            meta: "6 partes · 4 min cada",
            progress: 0,
            nextUp: "Parte 1: O Advento",
            lessons: [
                .init(
                    id: "liturgical-year-1-pt",
                    trackID: "liturgical-year",
                    partNumber: 1,
                    partsTotal: 6,
                    kicker: "O Ano Litúrgico",
                    title: "O Advento",
                    bodyParagraphs: ["O que a Igreja espera no Advento? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Advento será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Advento articula a preparação para o Natal com a espera da segunda vinda de Cristo; Catecismo §§522–524. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A espera desemboca na celebração do nascimento do Senhor. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Advento articula a preparação para o Natal com a espera da segunda vinda de Cristo; Catecismo §§522–524.",
                    glossaryTerms: [.init(term: "Advento", definition: "Advento: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "liturgical-year-2-pt",
                    trackID: "liturgical-year",
                    partNumber: 2,
                    partsTotal: 6,
                    kicker: "O Ano Litúrgico",
                    title: "O Natal",
                    bodyParagraphs: ["Por que o Natal dura mais que um dia? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Encarnação será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Natal celebra a Encarnação do Filho de Deus e se prolonga no ciclo que manifesta sua humanidade verdadeira; Catecismo §§525–530. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Depois de contemplar o nascimento, o ano conduz ao início da missão pública. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Natal celebra a Encarnação do Filho de Deus e se prolonga no ciclo que manifesta sua humanidade verdadeira; Catecismo §§525–530.",
                    glossaryTerms: [.init(term: "Encarnação", definition: "Encarnação: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "liturgical-year-3-pt",
                    trackID: "liturgical-year",
                    partNumber: 3,
                    partsTotal: 6,
                    kicker: "O Ano Litúrgico",
                    title: "A Quaresma",
                    bodyParagraphs: ["Por que a Quaresma tem quarenta dias? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra conversão será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Quaresma recorda os quarenta dias de Cristo no deserto e organiza oração, jejum e esmola; Catecismo §§540, 1438. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A conversão prepara a passagem pelos dias centrais da Páscoa. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Quaresma recorda os quarenta dias de Cristo no deserto e organiza oração, jejum e esmola; Catecismo §§540, 1438.",
                    glossaryTerms: [.init(term: "conversão", definition: "Conversão: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "liturgical-year-4-pt",
                    trackID: "liturgical-year",
                    partNumber: 4,
                    partsTotal: 6,
                    kicker: "O Ano Litúrgico",
                    title: "O Tríduo Pascal",
                    bodyParagraphs: ["Por que Quinta, Sexta e Sábado formam uma única celebração? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Tríduo Pascal será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Tríduo Pascal acompanha a paixão, a morte e a sepultura do Senhor até a Vigília que anuncia a ressurreição; Normas do Ano Litúrgico, §§18–21. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A Vigília abre o tempo que celebra a presença do Ressuscitado. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Tríduo Pascal acompanha a paixão, a morte e a sepultura do Senhor até a Vigília que anuncia a ressurreição; Normas do Ano Litúrgico, §§18–21.",
                    glossaryTerms: [.init(term: "Tríduo Pascal", definition: "Tríduo Pascal: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "liturgical-year-5-pt",
                    trackID: "liturgical-year",
                    partNumber: 5,
                    partsTotal: 6,
                    kicker: "O Ano Litúrgico",
                    title: "O Tempo Pascal",
                    bodyParagraphs: ["O que a Igreja celebra durante cinquenta dias? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Páscoa será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Tempo Pascal prolonga a alegria da ressurreição e conduz à Ascensão e a Pentecostes; Catecismo §§638–667. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Depois de Pentecostes, a Igreja retoma o caminho cotidiano no Tempo Comum. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Tempo Pascal prolonga a alegria da ressurreição e conduz à Ascensão e a Pentecostes; Catecismo §§638–667.",
                    glossaryTerms: [.init(term: "Páscoa", definition: "Páscoa: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "liturgical-year-6-pt",
                    trackID: "liturgical-year",
                    partNumber: 6,
                    partsTotal: 6,
                    kicker: "O Ano Litúrgico",
                    title: "O Tempo Comum",
                    bodyParagraphs: ["Por que o Tempo Comum não é um tempo sem importância? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Tempo Comum será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Tempo Comum percorre a vida pública de Cristo e forma a assembleia na escuta continuada do Evangelho; Normas do Ano Litúrgico, §§43–44. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A próxima trilha observa como a Igreja comunica esse mistério por sinais. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Tempo Comum percorre a vida pública de Cristo e forma a assembleia na escuta continuada do Evangelho; Normas do Ano Litúrgico, §§43–44.",
                    glossaryTerms: [.init(term: "Tempo Comum", definition: "Tempo Comum: termo usado nesta parte para nomear o núcleo do tema.")]
                )
            ]
        ),
        .init(
            id: "signs-symbols",
            title: "Sinais e símbolos",
            meta: "5 partes · 4 min cada",
            progress: 0,
            nextUp: "Parte 1: A água",
            lessons: [
                .init(
                    id: "signs-symbols-1-pt",
                    trackID: "signs-symbols",
                    partNumber: 1,
                    partsTotal: 5,
                    kicker: "Sinais e símbolos",
                    title: "A água",
                    bodyParagraphs: ["Por que a água aparece no Batismo e nas bênçãos? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra água será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A água recorda criação, passagem e vida nova; na liturgia, seu significado depende da ação sacramental que a Igreja celebra; Catecismo §§1217–1222. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O próximo sinal acompanha a água com uma linguagem de consagração. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A água recorda criação, passagem e vida nova; na liturgia, seu significado depende da ação sacramental que a Igreja celebra; Catecismo §§1217–1222.",
                    glossaryTerms: [.init(term: "água", definition: "Água: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "signs-symbols-2-pt",
                    trackID: "signs-symbols",
                    partNumber: 2,
                    partsTotal: 5,
                    kicker: "Sinais e símbolos",
                    title: "O óleo",
                    bodyParagraphs: ["O que significa ser ungido? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra óleo será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O óleo simboliza força, cura e consagração; o Batismo, a Confirmação e a Unção dos enfermos usam óleos em ações distintas; Catecismo §§1241, 1289, 1513. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Da unção, a trilha passa ao sinal que torna visível a luz de Cristo. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O óleo simboliza força, cura e consagração; o Batismo, a Confirmação e a Unção dos enfermos usam óleos em ações distintas; Catecismo §§1241, 1289, 1513.",
                    glossaryTerms: [.init(term: "óleo", definition: "Óleo: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "signs-symbols-3-pt",
                    trackID: "signs-symbols",
                    partNumber: 3,
                    partsTotal: 5,
                    kicker: "Sinais e símbolos",
                    title: "A luz",
                    bodyParagraphs: ["Por que a vela é acesa na liturgia? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra luz será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A luz da vela aponta para Cristo e para a fé recebida; no Batismo, a vela acesa é ligada ao círio pascal; Catecismo §1243. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A luz prepara a atenção para o sinal que sobe e envolve a oração. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A luz da vela aponta para Cristo e para a fé recebida; no Batismo, a vela acesa é ligada ao círio pascal; Catecismo §1243.",
                    glossaryTerms: [.init(term: "luz", definition: "Luz: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "signs-symbols-4-pt",
                    trackID: "signs-symbols",
                    partNumber: 4,
                    partsTotal: 5,
                    kicker: "Sinais e símbolos",
                    title: "O incenso",
                    bodyParagraphs: ["O que o incenso expressa? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra incenso será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O incenso pode honrar o altar, o Evangelho, as oferendas e o povo, evocando a oração que se eleva; Instrução Geral do Missal Romano, §§75, 276. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Depois do movimento do incenso, a trilha termina com o sinal que não produz som. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O incenso pode honrar o altar, o Evangelho, as oferendas e o povo, evocando a oração que se eleva; Instrução Geral do Missal Romano, §§75, 276.",
                    glossaryTerms: [.init(term: "incenso", definition: "Incenso: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "signs-symbols-5-pt",
                    trackID: "signs-symbols",
                    partNumber: 5,
                    partsTotal: 5,
                    kicker: "Sinais e símbolos",
                    title: "O silêncio",
                    bodyParagraphs: ["Por que o silêncio também é uma ação litúrgica? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra silêncio será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O silêncio permite acolher a Palavra, responder interiormente e acompanhar a oração da Igreja; Instrução Geral do Missal Romano, §45. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Com o silêncio, a trilha abre caminho para as orações que usam palavras fixas. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O silêncio permite acolher a Palavra, responder interiormente e acompanhar a oração da Igreja; Instrução Geral do Missal Romano, §45.",
                    glossaryTerms: [.init(term: "silêncio", definition: "Silêncio: termo usado nesta parte para nomear o núcleo do tema.")]
                )
            ]
        ),
        .init(
            id: "prayers-explained",
            title: "As orações explicadas",
            meta: "6 partes · 3 min cada",
            progress: 0,
            nextUp: "Parte 1: O Pai-Nosso",
            lessons: [
                .init(
                    id: "prayers-explained-1-pt",
                    trackID: "prayers-explained",
                    partNumber: 1,
                    partsTotal: 6,
                    kicker: "As orações explicadas",
                    title: "O Pai-Nosso",
                    bodyParagraphs: ["Por que a oração ensinada por Jesus começa chamando Deus de Pai? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Pai-Nosso será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Pai-Nosso reúne a relação filial com Deus e os pedidos que ordenam a vida cristã; Catecismo §§2759–2865. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A próxima oração contempla Maria dentro do mistério de Cristo. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Pai-Nosso reúne a relação filial com Deus e os pedidos que ordenam a vida cristã; Catecismo §§2759–2865.",
                    glossaryTerms: [.init(term: "Pai-Nosso", definition: "Pai-Nosso: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "prayers-explained-2-pt",
                    trackID: "prayers-explained",
                    partNumber: 2,
                    partsTotal: 6,
                    kicker: "As orações explicadas",
                    title: "A Ave-Maria",
                    bodyParagraphs: ["Como a Ave-Maria reúne Bíblia e intercessão? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Ave-Maria será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A primeira parte da Ave-Maria vem da saudação do anjo e de Isabel; a segunda pede a intercessão de Maria; Catecismo §§2673–2679. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Da saudação mariana, a trilha passa à fórmula breve de louvor trinitário. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A primeira parte da Ave-Maria vem da saudação do anjo e de Isabel; a segunda pede a intercessão de Maria; Catecismo §§2673–2679.",
                    glossaryTerms: [.init(term: "Ave-Maria", definition: "Ave-Maria: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "prayers-explained-3-pt",
                    trackID: "prayers-explained",
                    partNumber: 3,
                    partsTotal: 6,
                    kicker: "As orações explicadas",
                    title: "O Glória",
                    bodyParagraphs: ["O que a oração do Glória afirma? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra doxologia será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Glória louva o Pai, o Filho e o Espírito Santo e encerra muitas orações com uma doxologia; Catecismo §2628. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O louvor trinitário conduz à profissão de fé da Igreja. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Glória louva o Pai, o Filho e o Espírito Santo e encerra muitas orações com uma doxologia; Catecismo §2628.",
                    glossaryTerms: [.init(term: "doxologia", definition: "Doxologia: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "prayers-explained-4-pt",
                    trackID: "prayers-explained",
                    partNumber: 4,
                    partsTotal: 6,
                    kicker: "As orações explicadas",
                    title: "O Credo",
                    bodyParagraphs: ["Por que a Igreja recita o Credo? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Credo será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Credo resume a fé recebida dos apóstolos e professada no Batismo e na liturgia; Catecismo §§185–197. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A profissão comum prepara uma oração que pede proteção e cuidado. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Credo resume a fé recebida dos apóstolos e professada no Batismo e na liturgia; Catecismo §§185–197.",
                    glossaryTerms: [.init(term: "Credo", definition: "Credo: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "prayers-explained-5-pt",
                    trackID: "prayers-explained",
                    partNumber: 5,
                    partsTotal: 6,
                    kicker: "As orações explicadas",
                    title: "A Salve-Rainha",
                    bodyParagraphs: ["Por que a Salve-Rainha fala de exílio e esperança? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Salve-Rainha será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Salve-Rainha é uma oração mariana que apresenta a vida como peregrinação e pede o olhar misericordioso de Cristo; Catecismo §§2679–2682. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A última oração explicada acompanha os horários do dia. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Salve-Rainha é uma oração mariana que apresenta a vida como peregrinação e pede o olhar misericordioso de Cristo; Catecismo §§2679–2682.",
                    glossaryTerms: [.init(term: "Salve-Rainha", definition: "Salve-Rainha: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "prayers-explained-6-pt",
                    trackID: "prayers-explained",
                    partNumber: 6,
                    partsTotal: 6,
                    kicker: "As orações explicadas",
                    title: "O Angelus",
                    bodyParagraphs: ["Como o Angelus marca o dia? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Angelus será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Angelus recorda a Anunciação e a Encarnação em três momentos de oração; sua forma se consolidou na tradição ocidental. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A trilha seguinte reúne essas orações ao redor dos mistérios do Rosário. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Angelus recorda a Anunciação e a Encarnação em três momentos de oração; sua forma se consolidou na tradição ocidental.",
                    glossaryTerms: [.init(term: "Angelus", definition: "Angelus: termo usado nesta parte para nomear o núcleo do tema.")]
                )
            ]
        ),
        .init(
            id: "rosary-basics",
            title: "O Terço, do zero",
            meta: "7 partes · 3 min cada",
            progress: 0,
            nextUp: "Parte 1: O que é o Rosário",
            lessons: [
                .init(
                    id: "rosary-basics-1-pt",
                    trackID: "rosary-basics",
                    partNumber: 1,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "O que é o Rosário",
                    bodyParagraphs: ["O Rosário é repetição ou contemplação? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra Rosário será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O Rosário une repetição vocal e contemplação dos mistérios da vida de Cristo com Maria; São João Paulo II, Rosarium Virginis Mariae, §§12–17. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A próxima parte mostra como a sequência organiza a oração. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O Rosário une repetição vocal e contemplação dos mistérios da vida de Cristo com Maria; São João Paulo II, Rosarium Virginis Mariae, §§12–17.",
                    glossaryTerms: [.init(term: "Rosário", definition: "Rosário: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "rosary-basics-2-pt",
                    trackID: "rosary-basics",
                    partNumber: 2,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "A estrutura",
                    bodyParagraphs: ["Por que o Terço tem contas e dezenas? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra dezena será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A estrutura do Terço oferece um ritmo corporal para anunciar, meditar e repetir o Pai-Nosso e a Ave-Maria. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Com a estrutura clara, a trilha começa pelos mistérios da alegria. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A estrutura do Terço oferece um ritmo corporal para anunciar, meditar e repetir o Pai-Nosso e a Ave-Maria.",
                    glossaryTerms: [.init(term: "dezena", definition: "Dezena: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "rosary-basics-3-pt",
                    trackID: "rosary-basics",
                    partNumber: 3,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "Os mistérios gozosos",
                    bodyParagraphs: ["O que os mistérios gozosos contemplam? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra mistério gozoso será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. Os mistérios gozosos percorrem a Anunciação, a Visitação, o nascimento, a apresentação e Jesus encontrado no templo. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Depois da alegria da infância de Cristo, a trilha contempla seus sinais públicos. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "Os mistérios gozosos percorrem a Anunciação, a Visitação, o nascimento, a apresentação e Jesus encontrado no templo.",
                    glossaryTerms: [.init(term: "mistério gozoso", definition: "Mistério gozoso: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "rosary-basics-4-pt",
                    trackID: "rosary-basics",
                    partNumber: 4,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "Os mistérios luminosos",
                    bodyParagraphs: ["Por que existem mistérios luminosos? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra mistério luminoso será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. Os mistérios luminosos acompanham o Batismo de Jesus, Caná, o anúncio do Reino, a Transfiguração e a Eucaristia. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A luz da missão conduz à contemplação do sofrimento redentor. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "Os mistérios luminosos acompanham o Batismo de Jesus, Caná, o anúncio do Reino, a Transfiguração e a Eucaristia.",
                    glossaryTerms: [.init(term: "mistério luminoso", definition: "Mistério luminoso: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "rosary-basics-5-pt",
                    trackID: "rosary-basics",
                    partNumber: 5,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "Os mistérios dolorosos",
                    bodyParagraphs: ["Como rezar diante da paixão sem transformar dor em espetáculo? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra mistério doloroso será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. Os mistérios dolorosos acompanham a agonia, a flagelação, a coroação, o caminho da cruz e a morte de Jesus. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A paixão não é a última palavra; a próxima sequência contempla a ressurreição. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "Os mistérios dolorosos acompanham a agonia, a flagelação, a coroação, o caminho da cruz e a morte de Jesus.",
                    glossaryTerms: [.init(term: "mistério doloroso", definition: "Mistério doloroso: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "rosary-basics-6-pt",
                    trackID: "rosary-basics",
                    partNumber: 6,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "Os mistérios gloriosos",
                    bodyParagraphs: ["O que os mistérios gloriosos anunciam? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra mistério glorioso será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. Os mistérios gloriosos celebram a ressurreição, a ascensão, Pentecostes, a Assunção e a coroação de Maria. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A última parte reúne método e Escritura para rezar sem automatismo. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "Os mistérios gloriosos celebram a ressurreição, a ascensão, Pentecostes, a Assunção e a coroação de Maria.",
                    glossaryTerms: [.init(term: "mistério glorioso", definition: "Mistério glorioso: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "rosary-basics-7-pt",
                    trackID: "rosary-basics",
                    partNumber: 7,
                    partsTotal: 7,
                    kicker: "O Terço, do zero",
                    title: "Rezar com a Escritura",
                    bodyParagraphs: ["Como manter o Evangelho dentro de cada dezena? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra lectio divina será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A meditação do Rosário pode começar com uma breve leitura do texto bíblico correspondente; a repetição serve à permanência diante do mistério. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Com a Escritura no centro, a trilha deixa um método simples para continuar a oração. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A meditação do Rosário pode começar com uma breve leitura do texto bíblico correspondente; a repetição serve à permanência diante do mistério.",
                    glossaryTerms: [.init(term: "lectio divina", definition: "Lectio divina: termo usado nesta parte para nomear o núcleo do tema.")]
                )
            ]
        ),
        .init(
            id: "confession",
            title: "Como se confessar bem",
            meta: "5 partes · 3 min cada",
            progress: 0,
            nextUp: "Parte 1: Por que confessar",
            lessons: [
                .init(
                    id: "confession-1-pt",
                    trackID: "confession",
                    partNumber: 1,
                    partsTotal: 5,
                    kicker: "Como se confessar bem",
                    title: "Por que confessar",
                    bodyParagraphs: ["Por que a Igreja mantém o sacramento da Confissão? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra pecado será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A Confissão reconcilia o pecador com Deus e com a Igreja quando há arrependimento e verdade; Catecismo §§1422–1449. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O próximo passo prepara o exame que dá nome concreto ao pecado. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A Confissão reconcilia o pecador com Deus e com a Igreja quando há arrependimento e verdade; Catecismo §§1422–1449.",
                    glossaryTerms: [.init(term: "pecado", definition: "Pecado: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "confession-2-pt",
                    trackID: "confession",
                    partNumber: 2,
                    partsTotal: 5,
                    kicker: "Como se confessar bem",
                    title: "O exame de consciência",
                    bodyParagraphs: ["Como examinar a consciência sem transformar tudo em escrúpulo? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra consciência será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. O exame de consciência procura a verdade dos atos, das omissões e das circunstâncias sem fabricar culpas; Catecismo §§1776–1802. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Com a verdade nomeada, a pessoa pode passar ao arrependimento. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "O exame de consciência procura a verdade dos atos, das omissões e das circunstâncias sem fabricar culpas; Catecismo §§1776–1802.",
                    glossaryTerms: [.init(term: "consciência", definition: "Consciência: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "confession-3-pt",
                    trackID: "confession",
                    partNumber: 3,
                    partsTotal: 5,
                    kicker: "Como se confessar bem",
                    title: "A contrição",
                    bodyParagraphs: ["O que torna o arrependimento cristão? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra contrição será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A contrição é dor pelo pecado e rejeição dele, acompanhada do propósito de não voltar a pecar; Catecismo §§1451–1453. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: O arrependimento conduz à acusação simples e completa. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A contrição é dor pelo pecado e rejeição dele, acompanhada do propósito de não voltar a pecar; Catecismo §§1451–1453.",
                    glossaryTerms: [.init(term: "contrição", definition: "Contrição: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "confession-4-pt",
                    trackID: "confession",
                    partNumber: 4,
                    partsTotal: 5,
                    kicker: "Como se confessar bem",
                    title: "A acusação",
                    bodyParagraphs: ["Como falar os pecados ao confessor? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra acusação será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A acusação deve ser sincera, clara e integral quanto aos pecados graves de que a pessoa se recorda; Catecismo §§1455–1456. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: Depois da acusação, o sacramento chega à absolvição e à reparação. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A acusação deve ser sincera, clara e integral quanto aos pecados graves de que a pessoa se recorda; Catecismo §§1455–1456.",
                    glossaryTerms: [.init(term: "acusação", definition: "Acusação: termo usado nesta parte para nomear o núcleo do tema.")]
                ),
                .init(
                    id: "confession-5-pt",
                    trackID: "confession",
                    partNumber: 5,
                    partsTotal: 5,
                    kicker: "Como se confessar bem",
                    title: "A penitência e a paz",
                    bodyParagraphs: ["Por que existe uma penitência depois da absolvição? Essa pergunta aparece porque a prática cristã costuma chegar antes da explicação: a pessoa participa, repete palavras e percebe gestos, mas nem sempre sabe o que a Igreja está afirmando. Esta parte começa pelo sentido do tema e pelo lugar que ele ocupa na vida da comunidade. O objetivo não é oferecer uma definição isolada, mas mostrar como a celebração, a Escritura e a tradição se iluminam mutuamente. A palavra satisfação será usada com precisão, porque seu significado muda quando passa da linguagem comum para a liturgia.", "A Igreja lê este tema dentro de uma história de salvação, e não como uma invenção devocional recente. A satisfação ajuda a reparar o dano e a retomar uma vida coerente; a absolvição restaura a comunhão, e a penitência dá forma ao retorno; Catecismo §§1459–1460. Isso explica por que a liturgia conserva determinadas palavras, gestos e tempos: eles ligam a assembleia de hoje ao testemunho apostólico e à oração de gerações anteriores. A doutrina não elimina o mistério, mas impede que cada pessoa invente um significado privado para o rito. A formação começa quando a experiência concreta encontra uma referência que pode ser consultada.", "Este tema prepara o seguinte porque a formação litúrgica não é uma coleção de curiosidades. Cada parte recebe o que veio antes e abre espaço para a próxima, como uma oração que cresce sem perder a unidade. Ao terminar, fica uma pergunta verificável para a próxima etapa: A trilha termina aqui, mas a reconciliação continua na vida concreta. A resposta será construída a partir do rito, da Escritura e das fontes da Igreja, sem transformar o conteúdo em conselho genérico ou em promessa de resultado imediato."],
                    quoteText: nil,
                    quoteAttribution: "A satisfação ajuda a reparar o dano e a retomar uma vida coerente; a absolvição restaura a comunhão, e a penitência dá forma ao retorno; Catecismo §§1459–1460.",
                    glossaryTerms: [.init(term: "satisfação", definition: "Satisfação: termo usado nesta parte para nomear o núcleo do tema.")]
                )
            ]
        ),
    ]

    static let enImportedOtherTracks: [FormationTrack] = [
        .init(
            id: "sacraments",
            title: "The seven sacraments",
            meta: "7 parts · 4 min each",
            progress: 0,
            nextUp: "Part 1: Baptism",
            lessons: [
                .init(
                    id: "sacraments-1-en",
                    trackID: "sacraments",
                    partNumber: 1,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "Baptism",
                    bodyParagraphs: ["How does sacramental life begin? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of water in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word water will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Baptism inside a history of salvation, not as a recent devotional invention. Baptism is the door of the sacraments and communicates new life in Christ; Catechism §§1213–1284. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next part treats the sacrament that strengthens this life for witness. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Baptism is the door of the sacraments and communicates new life in Christ; Catechism §§1213–1284.",
                    glossaryTerms: [.init(term: "water", definition: "Water: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "sacraments-2-en",
                    trackID: "sacraments",
                    partNumber: 2,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "Confirmation",
                    bodyParagraphs: ["What does Confirmation add to Baptism? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of anointing in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word anointing will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Confirmation inside a history of salvation, not as a recent devotional invention. Confirmation perfects baptismal grace and binds the Christian more fully to the Church; Catechism §§1285–1321. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: After anointing, the path reaches the sacrament that feeds communion. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Confirmation perfects baptismal grace and binds the Christian more fully to the Church; Catechism §§1285–1321.",
                    glossaryTerms: [.init(term: "anointing", definition: "Anointing: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "sacraments-3-en",
                    trackID: "sacraments",
                    partNumber: 3,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "The Eucharist",
                    bodyParagraphs: ["Why is the Eucharist the center of Christian life? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Eucharist in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Eucharist will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Eucharist inside a history of salvation, not as a recent devotional invention. The Eucharist makes Christ’s sacrifice present and is the source and summit of Christian life; Catechism §§1322–1419. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next sacrament concerns the return to communion when sin has wounded it. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Eucharist makes Christ’s sacrifice present and is the source and summit of Christian life; Catechism §§1322–1419.",
                    glossaryTerms: [.init(term: "Eucharist", definition: "Eucharist: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "sacraments-4-en",
                    trackID: "sacraments",
                    partNumber: 4,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "Penance",
                    bodyParagraphs: ["What happens when sin wounds communion? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of reconciliation in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word reconciliation will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Penance inside a history of salvation, not as a recent devotional invention. The Sacrament of Penance offers conversion, confession, and absolution through the ministry of the Church; Catechism §§1422–1498. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The path continues to a sacrament addressed to bodily weakness and illness. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Sacrament of Penance offers conversion, confession, and absolution through the ministry of the Church; Catechism §§1422–1498.",
                    glossaryTerms: [.init(term: "reconciliation", definition: "Reconciliation: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "sacraments-5-en",
                    trackID: "sacraments",
                    partNumber: 5,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "Anointing of the Sick",
                    bodyParagraphs: ["Is Anointing only for the final moments of life? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Anointing of the Sick in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Anointing of the Sick will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Anointing of the Sick inside a history of salvation, not as a recent devotional invention. Anointing unites the sick person to Christ’s passion, gives strength, and can bring forgiveness of sins; Catechism §§1499–1532. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next subject moves from illness to the ordained service of the Church. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Anointing unites the sick person to Christ’s passion, gives strength, and can bring forgiveness of sins; Catechism §§1499–1532.",
                    glossaryTerms: [.init(term: "Anointing of the Sick", definition: "Anointing of the Sick: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "sacraments-6-en",
                    trackID: "sacraments",
                    partNumber: 6,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "Holy Orders",
                    bodyParagraphs: ["What does Holy Orders give to the Church? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of ministerial priesthood in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word ministerial priesthood will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Holy Orders inside a history of salvation, not as a recent devotional invention. Holy Orders configures the minister to Christ for service and the celebration of the sacraments; Catechism §§1536–1600. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The final sacrament in this series concerns the conjugal covenant and family life. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Holy Orders configures the minister to Christ for service and the celebration of the sacraments; Catechism §§1536–1600.",
                    glossaryTerms: [.init(term: "ministerial priesthood", definition: "Ministerial priesthood: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "sacraments-7-en",
                    trackID: "sacraments",
                    partNumber: 7,
                    partsTotal: 7,
                    kicker: "The seven sacraments",
                    title: "Marriage",
                    bodyParagraphs: ["Why is Marriage a sacrament? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of covenant in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word covenant will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Marriage inside a history of salvation, not as a recent devotional invention. Marriage establishes a covenant between the spouses and participates in Christ’s covenant with the Church; Catechism §§1601–1666. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: With the seven sacraments in view, the path turns to the time in which the Church celebrates them. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Marriage establishes a covenant between the spouses and participates in Christ’s covenant with the Church; Catechism §§1601–1666.",
                    glossaryTerms: [.init(term: "covenant", definition: "Covenant: the term used in this lesson for the core subject.")]
                )
            ]
        ),
        .init(
            id: "liturgical-year",
            title: "The liturgical year",
            meta: "6 parts · 4 min each",
            progress: 0,
            nextUp: "Part 1: Advent",
            lessons: [
                .init(
                    id: "liturgical-year-1-en",
                    trackID: "liturgical-year",
                    partNumber: 1,
                    partsTotal: 6,
                    kicker: "The liturgical year",
                    title: "Advent",
                    bodyParagraphs: ["What does the Church await in Advent? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Advent in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Advent will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Advent inside a history of salvation, not as a recent devotional invention. Advent joins preparation for Christmas to expectation of Christ’s second coming; Catechism §§522–524. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: Waiting opens into the celebration of the Lord’s birth. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Advent joins preparation for Christmas to expectation of Christ’s second coming; Catechism §§522–524.",
                    glossaryTerms: [.init(term: "Advent", definition: "Advent: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "liturgical-year-2-en",
                    trackID: "liturgical-year",
                    partNumber: 2,
                    partsTotal: 6,
                    kicker: "The liturgical year",
                    title: "Christmas",
                    bodyParagraphs: ["Why does Christmas last longer than one day? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Incarnation in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Incarnation will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Christmas inside a history of salvation, not as a recent devotional invention. Christmas celebrates the Incarnation of the Son of God and continues through a season that manifests his true humanity; Catechism §§525–530. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: After contemplating the birth, the year leads to the beginning of public ministry. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Christmas celebrates the Incarnation of the Son of God and continues through a season that manifests his true humanity; Catechism §§525–530.",
                    glossaryTerms: [.init(term: "Incarnation", definition: "Incarnation: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "liturgical-year-3-en",
                    trackID: "liturgical-year",
                    partNumber: 3,
                    partsTotal: 6,
                    kicker: "The liturgical year",
                    title: "Lent",
                    bodyParagraphs: ["Why does Lent last forty days? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of conversion in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word conversion will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Lent inside a history of salvation, not as a recent devotional invention. Lent recalls Christ’s forty days in the desert and orders prayer, fasting, and almsgiving; Catechism §§540, 1438. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: Conversion prepares the passage through the central days of Easter. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Lent recalls Christ’s forty days in the desert and orders prayer, fasting, and almsgiving; Catechism §§540, 1438.",
                    glossaryTerms: [.init(term: "conversion", definition: "Conversion: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "liturgical-year-4-en",
                    trackID: "liturgical-year",
                    partNumber: 4,
                    partsTotal: 6,
                    kicker: "The liturgical year",
                    title: "The Paschal Triduum",
                    bodyParagraphs: ["Why do Thursday, Friday, and Saturday form one celebration? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Paschal Triduum in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Paschal Triduum will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Paschal Triduum inside a history of salvation, not as a recent devotional invention. The Paschal Triduum follows the Lord’s passion, death, and burial until the Vigil announces the Resurrection; Universal Norms, §§18–21. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The Vigil opens the season that celebrates the presence of the risen Christ. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Paschal Triduum follows the Lord’s passion, death, and burial until the Vigil announces the Resurrection; Universal Norms, §§18–21.",
                    glossaryTerms: [.init(term: "Paschal Triduum", definition: "Paschal Triduum: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "liturgical-year-5-en",
                    trackID: "liturgical-year",
                    partNumber: 5,
                    partsTotal: 6,
                    kicker: "The liturgical year",
                    title: "Easter Time",
                    bodyParagraphs: ["What does the Church celebrate during fifty days? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Easter in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Easter will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Easter Time inside a history of salvation, not as a recent devotional invention. Easter Time prolongs the joy of the Resurrection and leads to the Ascension and Pentecost; Catechism §§638–667. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: After Pentecost, the Church resumes its daily path in Ordinary Time. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Easter Time prolongs the joy of the Resurrection and leads to the Ascension and Pentecost; Catechism §§638–667.",
                    glossaryTerms: [.init(term: "Easter", definition: "Easter: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "liturgical-year-6-en",
                    trackID: "liturgical-year",
                    partNumber: 6,
                    partsTotal: 6,
                    kicker: "The liturgical year",
                    title: "Ordinary Time",
                    bodyParagraphs: ["Why is Ordinary Time not an unimportant season? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Ordinary Time in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Ordinary Time will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Ordinary Time inside a history of salvation, not as a recent devotional invention. Ordinary Time walks through Christ’s public life and forms the assembly through continued listening to the Gospel; Universal Norms, §§43–44. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next path observes how the Church communicates this mystery through signs. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Ordinary Time walks through Christ’s public life and forms the assembly through continued listening to the Gospel; Universal Norms, §§43–44.",
                    glossaryTerms: [.init(term: "Ordinary Time", definition: "Ordinary Time: the term used in this lesson for the core subject.")]
                )
            ]
        ),
        .init(
            id: "signs-symbols",
            title: "Signs and symbols",
            meta: "5 parts · 4 min each",
            progress: 0,
            nextUp: "Part 1: Water",
            lessons: [
                .init(
                    id: "signs-symbols-1-en",
                    trackID: "signs-symbols",
                    partNumber: 1,
                    partsTotal: 5,
                    kicker: "Signs and symbols",
                    title: "Water",
                    bodyParagraphs: ["Why does water appear in Baptism and blessings? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of water in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word water will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Water inside a history of salvation, not as a recent devotional invention. Water recalls creation, passage, and life; in the liturgy its meaning depends on the sacramental action being celebrated; Catechism §§1217–1222. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next sign joins water to the language of consecration. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Water recalls creation, passage, and life; in the liturgy its meaning depends on the sacramental action being celebrated; Catechism §§1217–1222.",
                    glossaryTerms: [.init(term: "water", definition: "Water: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "signs-symbols-2-en",
                    trackID: "signs-symbols",
                    partNumber: 2,
                    partsTotal: 5,
                    kicker: "Signs and symbols",
                    title: "Oil",
                    bodyParagraphs: ["What does anointing mean? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of oil in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word oil will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Oil inside a history of salvation, not as a recent devotional invention. Oil signifies strength, healing, and consecration; Baptism, Confirmation, and Anointing use oils in distinct actions; Catechism §§1241, 1289, 1513. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: From anointing, the path moves to the sign that makes Christ’s light visible. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Oil signifies strength, healing, and consecration; Baptism, Confirmation, and Anointing use oils in distinct actions; Catechism §§1241, 1289, 1513.",
                    glossaryTerms: [.init(term: "oil", definition: "Oil: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "signs-symbols-3-en",
                    trackID: "signs-symbols",
                    partNumber: 3,
                    partsTotal: 5,
                    kicker: "Signs and symbols",
                    title: "Light",
                    bodyParagraphs: ["Why is a candle lit in the liturgy? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of light in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word light will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Light inside a history of salvation, not as a recent devotional invention. Candlelight points to Christ and to the faith received; in Baptism the lighted candle is linked to the paschal candle; Catechism §1243. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: Light prepares attention for the sign that rises and surrounds prayer. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Candlelight points to Christ and to the faith received; in Baptism the lighted candle is linked to the paschal candle; Catechism §1243.",
                    glossaryTerms: [.init(term: "light", definition: "Light: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "signs-symbols-4-en",
                    trackID: "signs-symbols",
                    partNumber: 4,
                    partsTotal: 5,
                    kicker: "Signs and symbols",
                    title: "Incense",
                    bodyParagraphs: ["What does incense express? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of incense in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word incense will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Incense inside a history of salvation, not as a recent devotional invention. Incense may honor the altar, the Gospel, the offerings, and the people, evoking prayer that rises; General Instruction of the Roman Missal, §§75, 276. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: After incense moves through the church, the path ends with the sign that makes no sound. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Incense may honor the altar, the Gospel, the offerings, and the people, evoking prayer that rises; General Instruction of the Roman Missal, §§75, 276.",
                    glossaryTerms: [.init(term: "incense", definition: "Incense: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "signs-symbols-5-en",
                    trackID: "signs-symbols",
                    partNumber: 5,
                    partsTotal: 5,
                    kicker: "Signs and symbols",
                    title: "Silence",
                    bodyParagraphs: ["Why is silence also a liturgical action? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of silence in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word silence will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Silence inside a history of salvation, not as a recent devotional invention. Silence allows the assembly to receive the Word, respond inwardly, and accompany the Church’s prayer; General Instruction, §45. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: With silence, the path opens toward prayers that use fixed words. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Silence allows the assembly to receive the Word, respond inwardly, and accompany the Church’s prayer; General Instruction, §45.",
                    glossaryTerms: [.init(term: "silence", definition: "Silence: the term used in this lesson for the core subject.")]
                )
            ]
        ),
        .init(
            id: "prayers-explained",
            title: "Prayers explained",
            meta: "6 parts · 3 min each",
            progress: 0,
            nextUp: "Part 1: The Lord’s Prayer",
            lessons: [
                .init(
                    id: "prayers-explained-1-en",
                    trackID: "prayers-explained",
                    partNumber: 1,
                    partsTotal: 6,
                    kicker: "Prayers explained",
                    title: "The Lord’s Prayer",
                    bodyParagraphs: ["Why does the prayer taught by Jesus begin by calling God Father? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Lord’s Prayer in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Lord’s Prayer will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Lord’s Prayer inside a history of salvation, not as a recent devotional invention. The Lord’s Prayer joins filial relation to God with the petitions that order Christian life; Catechism §§2759–2865. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next prayer contemplates Mary within the mystery of Christ. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Lord’s Prayer joins filial relation to God with the petitions that order Christian life; Catechism §§2759–2865.",
                    glossaryTerms: [.init(term: "Lord’s Prayer", definition: "Lord’s Prayer: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "prayers-explained-2-en",
                    trackID: "prayers-explained",
                    partNumber: 2,
                    partsTotal: 6,
                    kicker: "Prayers explained",
                    title: "The Hail Mary",
                    bodyParagraphs: ["How does the Hail Mary join Scripture and intercession? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Hail Mary in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Hail Mary will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Hail Mary inside a history of salvation, not as a recent devotional invention. The first part comes from the angel’s greeting and Elizabeth’s words; the second asks Mary’s intercession; Catechism §§2673–2679. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: From the Marian greeting, the path moves to a brief formula of Trinitarian praise. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The first part comes from the angel’s greeting and Elizabeth’s words; the second asks Mary’s intercession; Catechism §§2673–2679.",
                    glossaryTerms: [.init(term: "Hail Mary", definition: "Hail Mary: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "prayers-explained-3-en",
                    trackID: "prayers-explained",
                    partNumber: 3,
                    partsTotal: 6,
                    kicker: "Prayers explained",
                    title: "The Glory Be",
                    bodyParagraphs: ["What does the Glory Be affirm? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of doxology in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word doxology will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Glory Be inside a history of salvation, not as a recent devotional invention. The Glory Be praises the Father, Son, and Holy Spirit and closes many prayers with a doxology; Catechism §2628. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: Trinitarian praise leads toward the Church’s profession of faith. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Glory Be praises the Father, Son, and Holy Spirit and closes many prayers with a doxology; Catechism §2628.",
                    glossaryTerms: [.init(term: "doxology", definition: "Doxology: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "prayers-explained-4-en",
                    trackID: "prayers-explained",
                    partNumber: 4,
                    partsTotal: 6,
                    kicker: "Prayers explained",
                    title: "The Creed",
                    bodyParagraphs: ["Why does the Church recite the Creed? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Creed in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Creed will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Creed inside a history of salvation, not as a recent devotional invention. The Creed summarizes the faith received from the apostles and professed in Baptism and the liturgy; Catechism §§185–197. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The common profession prepares a prayer that asks for protection and care. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Creed summarizes the faith received from the apostles and professed in Baptism and the liturgy; Catechism §§185–197.",
                    glossaryTerms: [.init(term: "Creed", definition: "Creed: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "prayers-explained-5-en",
                    trackID: "prayers-explained",
                    partNumber: 5,
                    partsTotal: 6,
                    kicker: "Prayers explained",
                    title: "The Salve Regina",
                    bodyParagraphs: ["Why does the Salve Regina speak of exile and hope? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Salve Regina in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Salve Regina will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Salve Regina inside a history of salvation, not as a recent devotional invention. The Salve Regina presents life as pilgrimage and asks for Christ’s merciful gaze; Catechism §§2679–2682. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The final prayer explained accompanies the hours of the day. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Salve Regina presents life as pilgrimage and asks for Christ’s merciful gaze; Catechism §§2679–2682.",
                    glossaryTerms: [.init(term: "Salve Regina", definition: "Salve Regina: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "prayers-explained-6-en",
                    trackID: "prayers-explained",
                    partNumber: 6,
                    partsTotal: 6,
                    kicker: "Prayers explained",
                    title: "The Angelus",
                    bodyParagraphs: ["How does the Angelus mark the day? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Angelus in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Angelus will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Angelus inside a history of salvation, not as a recent devotional invention. The Angelus recalls the Annunciation and the Incarnation in three moments of prayer; its form grew within Western tradition. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next path gathers these prayers around the mysteries of the Rosary. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Angelus recalls the Annunciation and the Incarnation in three moments of prayer; its form grew within Western tradition.",
                    glossaryTerms: [.init(term: "Angelus", definition: "Angelus: the term used in this lesson for the core subject.")]
                )
            ]
        ),
        .init(
            id: "rosary-basics",
            title: "The Rosary, from the beginning",
            meta: "7 parts · 3 min each",
            progress: 0,
            nextUp: "Part 1: What the Rosary Is",
            lessons: [
                .init(
                    id: "rosary-basics-1-en",
                    trackID: "rosary-basics",
                    partNumber: 1,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "What the Rosary Is",
                    bodyParagraphs: ["Is the Rosary repetition or contemplation? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Rosary in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Rosary will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads What the Rosary Is inside a history of salvation, not as a recent devotional invention. The Rosary joins vocal repetition to contemplation of Christ’s life with Mary; John Paul II, Rosarium Virginis Mariae, §§12–17. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next part shows how the sequence orders the prayer. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Rosary joins vocal repetition to contemplation of Christ’s life with Mary; John Paul II, Rosarium Virginis Mariae, §§12–17.",
                    glossaryTerms: [.init(term: "Rosary", definition: "Rosary: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "rosary-basics-2-en",
                    trackID: "rosary-basics",
                    partNumber: 2,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "The Structure",
                    bodyParagraphs: ["Why does the Rosary have beads and decades? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of decade in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word decade will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Structure inside a history of salvation, not as a recent devotional invention. The structure gives the body a rhythm for announcing, meditating, and repeating the Our Father and Hail Mary. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: With the structure clear, the path begins with the Joyful Mysteries. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The structure gives the body a rhythm for announcing, meditating, and repeating the Our Father and Hail Mary.",
                    glossaryTerms: [.init(term: "decade", definition: "Decade: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "rosary-basics-3-en",
                    trackID: "rosary-basics",
                    partNumber: 3,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "The Joyful Mysteries",
                    bodyParagraphs: ["What do the Joyful Mysteries contemplate? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Joyful Mystery in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Joyful Mystery will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Joyful Mysteries inside a history of salvation, not as a recent devotional invention. The Joyful Mysteries walk through the Annunciation, Visitation, birth, presentation, and finding of Jesus in the Temple. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: After Christ’s childhood joy, the path contemplates his public signs. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Joyful Mysteries walk through the Annunciation, Visitation, birth, presentation, and finding of Jesus in the Temple.",
                    glossaryTerms: [.init(term: "Joyful Mystery", definition: "Joyful Mystery: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "rosary-basics-4-en",
                    trackID: "rosary-basics",
                    partNumber: 4,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "The Luminous Mysteries",
                    bodyParagraphs: ["Why are there Luminous Mysteries? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Luminous Mystery in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Luminous Mystery will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Luminous Mysteries inside a history of salvation, not as a recent devotional invention. The Luminous Mysteries accompany Jesus’ Baptism, Cana, the proclamation of the Kingdom, the Transfiguration, and the Eucharist. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The light of mission leads to contemplation of redemptive suffering. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Luminous Mysteries accompany Jesus’ Baptism, Cana, the proclamation of the Kingdom, the Transfiguration, and the Eucharist.",
                    glossaryTerms: [.init(term: "Luminous Mystery", definition: "Luminous Mystery: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "rosary-basics-5-en",
                    trackID: "rosary-basics",
                    partNumber: 5,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "The Sorrowful Mysteries",
                    bodyParagraphs: ["How can one pray the Passion without turning pain into spectacle? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Sorrowful Mystery in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Sorrowful Mystery will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Sorrowful Mysteries inside a history of salvation, not as a recent devotional invention. The Sorrowful Mysteries accompany the agony, scourging, crowning, way of the Cross, and death of Jesus. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The Passion is not the final word; the next sequence contemplates the Resurrection. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Sorrowful Mysteries accompany the agony, scourging, crowning, way of the Cross, and death of Jesus.",
                    glossaryTerms: [.init(term: "Sorrowful Mystery", definition: "Sorrowful Mystery: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "rosary-basics-6-en",
                    trackID: "rosary-basics",
                    partNumber: 6,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "The Glorious Mysteries",
                    bodyParagraphs: ["What do the Glorious Mysteries announce? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of Glorious Mystery in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word Glorious Mystery will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Glorious Mysteries inside a history of salvation, not as a recent devotional invention. The Glorious Mysteries celebrate the Resurrection, Ascension, Pentecost, Assumption, and Mary’s coronation. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The final part brings method and Scripture together for prayer without automatic repetition. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The Glorious Mysteries celebrate the Resurrection, Ascension, Pentecost, Assumption, and Mary’s coronation.",
                    glossaryTerms: [.init(term: "Glorious Mystery", definition: "Glorious Mystery: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "rosary-basics-7-en",
                    trackID: "rosary-basics",
                    partNumber: 7,
                    partsTotal: 7,
                    kicker: "The Rosary, from the beginning",
                    title: "Praying with Scripture",
                    bodyParagraphs: ["How can the Gospel remain inside each decade? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of lectio divina in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word lectio divina will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Praying with Scripture inside a history of salvation, not as a recent devotional invention. Rosary meditation can begin with a brief reading of the corresponding biblical passage; repetition serves staying before the mystery. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: With Scripture at the center, the path leaves a simple method for continuing prayer. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Rosary meditation can begin with a brief reading of the corresponding biblical passage; repetition serves staying before the mystery.",
                    glossaryTerms: [.init(term: "lectio divina", definition: "Lectio divina: the term used in this lesson for the core subject.")]
                )
            ]
        ),
        .init(
            id: "confession",
            title: "How to make a good confession",
            meta: "5 parts · 3 min each",
            progress: 0,
            nextUp: "Part 1: Why Confess?",
            lessons: [
                .init(
                    id: "confession-1-en",
                    trackID: "confession",
                    partNumber: 1,
                    partsTotal: 5,
                    kicker: "How to make a good confession",
                    title: "Why Confess?",
                    bodyParagraphs: ["Why does the Church keep the Sacrament of Confession? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of sin in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word sin will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Why Confess? inside a history of salvation, not as a recent devotional invention. Confession reconciles the sinner with God and the Church when there is repentance and truth; Catechism §§1422–1449. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The next step prepares the examination that gives sin a concrete name. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Confession reconciles the sinner with God and the Church when there is repentance and truth; Catechism §§1422–1449.",
                    glossaryTerms: [.init(term: "sin", definition: "Sin: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "confession-2-en",
                    trackID: "confession",
                    partNumber: 2,
                    partsTotal: 5,
                    kicker: "How to make a good confession",
                    title: "Examination of Conscience",
                    bodyParagraphs: ["How can conscience be examined without becoming scrupulous? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of conscience in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word conscience will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Examination of Conscience inside a history of salvation, not as a recent devotional invention. An examination seeks the truth of acts and omissions without manufacturing guilt; Catechism §§1776–1802. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: With truth named, the person can move toward repentance. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "An examination seeks the truth of acts and omissions without manufacturing guilt; Catechism §§1776–1802.",
                    glossaryTerms: [.init(term: "conscience", definition: "Conscience: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "confession-3-en",
                    trackID: "confession",
                    partNumber: 3,
                    partsTotal: 5,
                    kicker: "How to make a good confession",
                    title: "Contrition",
                    bodyParagraphs: ["What makes repentance Christian? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of contrition in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word contrition will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Contrition inside a history of salvation, not as a recent devotional invention. Contrition is sorrow for sin and rejection of it, together with a resolve not to sin again; Catechism §§1451–1453. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: Repentance leads to a simple and complete confession. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Contrition is sorrow for sin and rejection of it, together with a resolve not to sin again; Catechism §§1451–1453.",
                    glossaryTerms: [.init(term: "contrition", definition: "Contrition: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "confession-4-en",
                    trackID: "confession",
                    partNumber: 4,
                    partsTotal: 5,
                    kicker: "How to make a good confession",
                    title: "The Accusation",
                    bodyParagraphs: ["How should sins be spoken to the confessor? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of accusation in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word accusation will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads The Accusation inside a history of salvation, not as a recent devotional invention. The accusation should be sincere, clear, and integral regarding remembered grave sins; Catechism §§1455–1456. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: After accusation, the sacrament reaches absolution and reparation. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "The accusation should be sincere, clear, and integral regarding remembered grave sins; Catechism §§1455–1456.",
                    glossaryTerms: [.init(term: "accusation", definition: "Accusation: the term used in this lesson for the core subject.")]
                ),
                .init(
                    id: "confession-5-en",
                    trackID: "confession",
                    partNumber: 5,
                    partsTotal: 5,
                    kicker: "How to make a good confession",
                    title: "Penance and Peace",
                    bodyParagraphs: ["Why is penance given after absolution? This question appears because Christian practice often comes before explanation: a person participates, repeats words, and notices gestures without always knowing what the Church is saying. This lesson begins with the place of satisfaction in the community’s life. It does not isolate a definition from prayer. It shows how celebration, Scripture, and tradition illuminate one another. The word satisfaction will be used carefully, because ordinary language and liturgical language do not always mean the same thing.", "The Church reads Penance and Peace inside a history of salvation, not as a recent devotional invention. Satisfaction helps repair harm and resume a coherent life; absolution restores communion, while penance gives return a concrete form; Catechism §§1459–1460. That reference explains why the liturgy keeps particular words, gestures, and seasons: they connect today’s assembly with apostolic testimony and generations of prayer. Doctrine does not remove mystery, but it keeps each person from inventing a private meaning for the rite. Formation begins when concrete experience meets a source that can be consulted.", "This topic prepares the next one because liturgical formation is not a collection of curiosities. Each part receives what came before and makes room for what follows, like one prayer growing without losing its unity. The next question is therefore concrete: The path ends here, but reconciliation continues in concrete life. The answer will be built from the rite, Scripture, and the Church’s sources, without turning the lesson into generic advice or a promise of immediate results."],
                    quoteText: nil,
                    quoteAttribution: "Satisfaction helps repair harm and resume a coherent life; absolution restores communion, while penance gives return a concrete form; Catechism §§1459–1460.",
                    glossaryTerms: [.init(term: "satisfaction", definition: "Satisfaction: the term used in this lesson for the core subject.")]
                )
            ]
        ),
    ]

    static let esImportedOtherTracks: [FormationTrack] = [
        .init(
            id: "sacraments",
            title: "Los siete sacramentos",
            meta: "7 partes · 4 min cada",
            progress: 0,
            nextUp: "Parte 1: El Bautismo",
            lessons: [
                .init(
                    id: "sacraments-1-es",
                    trackID: "sacraments",
                    partNumber: 1,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "El Bautismo",
                    bodyParagraphs: ["¿Cómo comienza la vida sacramental? Esta lección se detiene en el agua y la invocación trinitaria que incorporan a una persona a Cristo y a la Iglesia. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Bautismo es fundamento de toda la vida cristiana y puerta de los demás sacramentos; por él se recibe una vida nueva como hijo de Dios. Catecismo de la Iglesia Católica, §§1213–1284.", "Después del nuevo nacimiento, la siguiente pregunta es cómo esa gracia se fortalece para el testimonio. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Bautismo es fundamento de toda la vida cristiana y puerta de los demás sacramentos; por él se recibe una vida nueva como hijo de Dios. Catecismo de la Iglesia Católica, §§1213–1284.",
                    glossaryTerms: [.init(term: "agua", definition: "Signo sacramental de vida nueva y de unión con Cristo.")]
                ),
                .init(
                    id: "sacraments-2-es",
                    trackID: "sacraments",
                    partNumber: 2,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "La Confirmación",
                    bodyParagraphs: ["¿Qué recibe el bautizado en la Confirmación? Esta lección se detiene en la unción con el crisma y el don del Espíritu Santo. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La Confirmación perfecciona la gracia bautismal, une más firmemente a Cristo y fortalece para dar testimonio de la fe. Catecismo de la Iglesia Católica, §§1285–1321.", "La iniciación conduce a la mesa donde Cristo alimenta a su Iglesia. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La Confirmación perfecciona la gracia bautismal, une más firmemente a Cristo y fortalece para dar testimonio de la fe. Catecismo de la Iglesia Católica, §§1285–1321.",
                    glossaryTerms: [.init(term: "crisma", definition: "Óleo consagrado usado en la Confirmación como signo de consagración.")]
                ),
                .init(
                    id: "sacraments-3-es",
                    trackID: "sacraments",
                    partNumber: 3,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "La Eucaristía",
                    bodyParagraphs: ["¿Por qué la Eucaristía está en el centro de la vida cristiana? Esta lección se detiene en el memorial de la Pascua de Cristo y la comunión de la Iglesia. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La Eucaristía hace presente sacramentalmente el sacrificio de Cristo y es fuente y culmen de la vida eclesial. Catecismo de la Iglesia Católica, §§1322–1419.", "La comunión puede ser herida por el pecado; por eso el camino continúa con la reconciliación. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La Eucaristía hace presente sacramentalmente el sacrificio de Cristo y es fuente y culmen de la vida eclesial. Catecismo de la Iglesia Católica, §§1322–1419.",
                    glossaryTerms: [.init(term: "Eucaristía", definition: "Sacramento en el que Cristo entrega su Cuerpo y su Sangre a la Iglesia.")]
                ),
                .init(
                    id: "sacraments-4-es",
                    trackID: "sacraments",
                    partNumber: 4,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "La Penitencia",
                    bodyParagraphs: ["¿Qué sucede cuando el pecado hiere la comunión? Esta lección se detiene en la conversión, la confesión y la absolución celebradas en la Iglesia. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "Cristo instituyó el sacramento de la Reconciliación para que el bautizado vuelva a la comunión con Dios y con la Iglesia. Catecismo de la Iglesia Católica, §§1422–1498.", "La misericordia de Dios acompaña también la fragilidad corporal y la enfermedad. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "Cristo instituyó el sacramento de la Reconciliación para que el bautizado vuelva a la comunión con Dios y con la Iglesia. Catecismo de la Iglesia Católica, §§1422–1498.",
                    glossaryTerms: [.init(term: "reconciliación", definition: "Restablecimiento de la comunión con Dios y con la Iglesia.")]
                ),
                .init(
                    id: "sacraments-5-es",
                    trackID: "sacraments",
                    partNumber: 5,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "La Unción de los enfermos",
                    bodyParagraphs: ["¿La Unción está reservada únicamente a los últimos momentos? Esta lección se detiene en la oración de la Iglesia y la unción para quien sufre una enfermedad grave o la debilidad de la edad. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La Unción une al enfermo a la pasión de Cristo, le da fuerza y paz y puede conceder el perdón de los pecados. Catecismo de la Iglesia Católica, §§1499–1532.", "La vida de la Iglesia necesita también ministros ordenados para servir y celebrar los sacramentos. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La Unción une al enfermo a la pasión de Cristo, le da fuerza y paz y puede conceder el perdón de los pecados. Catecismo de la Iglesia Católica, §§1499–1532.",
                    glossaryTerms: [.init(term: "unción", definition: "Acción sacramental con óleo que expresa fortaleza, consuelo y consagración.")]
                ),
                .init(
                    id: "sacraments-6-es",
                    trackID: "sacraments",
                    partNumber: 6,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "El Orden sacerdotal",
                    bodyParagraphs: ["¿Para qué existe el sacramento del Orden? Esta lección se detiene en el servicio de los obispos, presbíteros y diáconos a la misión de Cristo y de la Iglesia. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Orden configura a algunos fieles con Cristo para el servicio de su pueblo, especialmente en la enseñanza, el culto y la guía pastoral. Catecismo de la Iglesia Católica, §§1536–1600.", "La última forma sacramental de servicio a la comunión es la alianza de los esposos. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Orden configura a algunos fieles con Cristo para el servicio de su pueblo, especialmente en la enseñanza, el culto y la guía pastoral. Catecismo de la Iglesia Católica, §§1536–1600.",
                    glossaryTerms: [.init(term: "Orden", definition: "Sacramento por el que algunos fieles son constituidos para servir a la Iglesia.")]
                ),
                .init(
                    id: "sacraments-7-es",
                    trackID: "sacraments",
                    partNumber: 7,
                    partsTotal: 7,
                    kicker: "Los siete sacramentos",
                    title: "El Matrimonio",
                    bodyParagraphs: ["¿Qué promete el Matrimonio cristiano? Esta lección se detiene en una alianza de toda la vida entre un hombre y una mujer, abierta al bien de los esposos y de los hijos. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Matrimonio establece una alianza entre los esposos y participa del amor de Cristo por su Iglesia. Catecismo de la Iglesia Católica, §§1601–1666.", "Con esta alianza se completa el recorrido por los siete sacramentos y sus distintas misiones. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Matrimonio establece una alianza entre los esposos y participa del amor de Cristo por su Iglesia. Catecismo de la Iglesia Católica, §§1601–1666.",
                    glossaryTerms: [.init(term: "alianza", definition: "Vínculo estable de amor y fidelidad asumido ante Dios y la Iglesia.")]
                )
            ]
        ),
        .init(
            id: "liturgical-year",
            title: "El año litúrgico",
            meta: "6 partes · 4 min cada",
            progress: 0,
            nextUp: "Parte 1: El Adviento",
            lessons: [
                .init(
                    id: "liturgical-year-1-es",
                    trackID: "liturgical-year",
                    partNumber: 1,
                    partsTotal: 6,
                    kicker: "El año litúrgico",
                    title: "El Adviento",
                    bodyParagraphs: ["¿Qué espera la Iglesia durante el Adviento? Esta lección se detiene en la venida de Cristo: su nacimiento celebrado en Navidad y su retorno glorioso al final de los tiempos. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Adviento dispone a celebrar la primera venida del Hijo de Dios y despierta la esperanza de su venida definitiva. Catecismo de la Iglesia Católica, §§522–524.", "La espera desemboca en la celebración del nacimiento del Señor. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Adviento dispone a celebrar la primera venida del Hijo de Dios y despierta la esperanza de su venida definitiva. Catecismo de la Iglesia Católica, §§522–524.",
                    glossaryTerms: [.init(term: "Adviento", definition: "Tiempo de preparación y esperanza antes de la Navidad.")]
                ),
                .init(
                    id: "liturgical-year-2-es",
                    trackID: "liturgical-year",
                    partNumber: 2,
                    partsTotal: 6,
                    kicker: "El año litúrgico",
                    title: "La Navidad",
                    bodyParagraphs: ["¿Qué confiesa la Iglesia al celebrar la Navidad? Esta lección se detiene en que el Hijo eterno de Dios asumió nuestra humanidad verdadera. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "En Navidad la Iglesia celebra el misterio de la Encarnación: Jesucristo es verdadero Dios y verdadero hombre. Catecismo de la Iglesia Católica, §§525–530.", "Después de manifestar a Cristo en su infancia, el año litúrgico conduce al desierto y a la Pascua. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "En Navidad la Iglesia celebra el misterio de la Encarnación: Jesucristo es verdadero Dios y verdadero hombre. Catecismo de la Iglesia Católica, §§525–530.",
                    glossaryTerms: [.init(term: "Encarnación", definition: "El Hijo de Dios asumió la naturaleza humana sin dejar de ser Dios.")]
                ),
                .init(
                    id: "liturgical-year-3-es",
                    trackID: "liturgical-year",
                    partNumber: 3,
                    partsTotal: 6,
                    kicker: "El año litúrgico",
                    title: "La Cuaresma",
                    bodyParagraphs: ["¿Para qué sirve el camino de la Cuaresma? Esta lección se detiene en la conversión, el recuerdo del Bautismo y la preparación para la Pascua. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "Los cuarenta días recuerdan a Cristo en el desierto; la Iglesia propone oración, ayuno y limosna como camino de conversión. Catecismo de la Iglesia Católica, §§540, 1438.", "La Cuaresma no termina en sí misma: conduce a los días centrales de la Pascua. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "Los cuarenta días recuerdan a Cristo en el desierto; la Iglesia propone oración, ayuno y limosna como camino de conversión. Catecismo de la Iglesia Católica, §§540, 1438.",
                    glossaryTerms: [.init(term: "conversión", definition: "Retorno del corazón a Dios que se expresa en la vida concreta.")]
                ),
                .init(
                    id: "liturgical-year-4-es",
                    trackID: "liturgical-year",
                    partNumber: 4,
                    partsTotal: 6,
                    kicker: "El año litúrgico",
                    title: "El Triduo Pascual",
                    bodyParagraphs: ["¿Qué celebra la Iglesia en los tres días del Triduo? Esta lección se detiene en la única Pascua del Señor, desde la Cena hasta la Vigilia Pascual. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Triduo concentra la pasión, muerte, sepultura y resurrección de Cristo en una sola celebración pascual. Normas universales sobre el año litúrgico, §§18–21.", "La Vigilia abre el tiempo en que la Iglesia canta la victoria de Cristo resucitado. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Triduo concentra la pasión, muerte, sepultura y resurrección de Cristo en una sola celebración pascual. Normas universales sobre el año litúrgico, §§18–21.",
                    glossaryTerms: [.init(term: "Triduo Pascual", definition: "Culmen del año litúrgico, dedicado al misterio pascual de Cristo.")]
                ),
                .init(
                    id: "liturgical-year-5-es",
                    trackID: "liturgical-year",
                    partNumber: 5,
                    partsTotal: 6,
                    kicker: "El año litúrgico",
                    title: "El Tiempo Pascual",
                    bodyParagraphs: ["¿Por qué la Pascua se prolonga durante cincuenta días? Esta lección se detiene en la alegría de la resurrección, la Ascensión y la venida del Espíritu Santo. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La resurrección de Cristo es el centro de la fe; el tiempo pascual prolonga su celebración hasta Pentecostés. Catecismo de la Iglesia Católica, §§638–667.", "Después de Pentecostés, el calendario vuelve a recorrer con paciencia la vida pública de Jesús. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La resurrección de Cristo es el centro de la fe; el tiempo pascual prolonga su celebración hasta Pentecostés. Catecismo de la Iglesia Católica, §§638–667.",
                    glossaryTerms: [.init(term: "Pascua", definition: "Celebración de la muerte y resurrección de Jesucristo.")]
                ),
                .init(
                    id: "liturgical-year-6-es",
                    trackID: "liturgical-year",
                    partNumber: 6,
                    partsTotal: 6,
                    kicker: "El año litúrgico",
                    title: "El Tiempo Ordinario",
                    bodyParagraphs: ["¿Qué tiene de ordinario este tiempo litúrgico? Esta lección se detiene en la escucha continuada del Evangelio y el crecimiento paciente en la vida de Cristo. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Tiempo Ordinario no es un vacío entre fiestas: acompaña a la Iglesia en el despliegue de la vida pública y la enseñanza de Jesús. Normas universales sobre el año litúrgico, §§43–44.", "El año litúrgico permite reconocer cómo los mismos misterios de Cristo dan forma a cada semana. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Tiempo Ordinario no es un vacío entre fiestas: acompaña a la Iglesia en el despliegue de la vida pública y la enseñanza de Jesús. Normas universales sobre el año litúrgico, §§43–44.",
                    glossaryTerms: [.init(term: "Tiempo Ordinario", definition: "Período que acompaña el crecimiento cotidiano en la vida de Cristo.")]
                )
            ]
        ),
        .init(
            id: "signs-symbols",
            title: "Signos y símbolos",
            meta: "5 partes · 4 min cada",
            progress: 0,
            nextUp: "Parte 1: El agua",
            lessons: [
                .init(
                    id: "signs-symbols-1-es",
                    trackID: "signs-symbols",
                    partNumber: 1,
                    partsTotal: 5,
                    kicker: "Signos y símbolos",
                    title: "El agua",
                    bodyParagraphs: ["¿Por qué el agua tiene tanta fuerza en la liturgia? Esta lección se detiene en la creación, el paso por el mar y el Bautismo como nacimiento a una vida nueva. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El agua bautismal hace memoria de las grandes obras de Dios y significa morir y resucitar con Cristo. Catecismo de la Iglesia Católica, §§1217–1222.", "Otro signo material de la liturgia es el óleo, usado de modo distinto según el sacramento. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El agua bautismal hace memoria de las grandes obras de Dios y significa morir y resucitar con Cristo. Catecismo de la Iglesia Católica, §§1217–1222.",
                    glossaryTerms: [.init(term: "agua", definition: "Elemento creado que, en el Bautismo, es signo de vida nueva.")]
                ),
                .init(
                    id: "signs-symbols-2-es",
                    trackID: "signs-symbols",
                    partNumber: 2,
                    partsTotal: 5,
                    kicker: "Signos y símbolos",
                    title: "El óleo",
                    bodyParagraphs: ["¿Qué expresa el óleo sacramental? Esta lección se detiene en la fortaleza, la curación y la consagración que Dios comunica mediante signos visibles. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El crisma en el Bautismo y la Confirmación, y el óleo de los enfermos, se usan en acciones sacramentales distintas. Catecismo de la Iglesia Católica, §§1241, 1289, 1513.", "La liturgia también usa la luz para hablar de Cristo y de la fe recibida. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El crisma en el Bautismo y la Confirmación, y el óleo de los enfermos, se usan en acciones sacramentales distintas. Catecismo de la Iglesia Católica, §§1241, 1289, 1513.",
                    glossaryTerms: [.init(term: "óleo", definition: "Aceite bendecido o consagrado empleado en diversos sacramentos.")]
                ),
                .init(
                    id: "signs-symbols-3-es",
                    trackID: "signs-symbols",
                    partNumber: 3,
                    partsTotal: 5,
                    kicker: "Signos y símbolos",
                    title: "La luz",
                    bodyParagraphs: ["¿Qué anuncia la vela encendida en la celebración? Esta lección se detiene en a Cristo, luz del mundo, y la fe que el bautizado está llamado a custodiar. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "En el rito del Bautismo se entrega una vela encendida en el cirio pascual como signo de la luz de Cristo. Catecismo de la Iglesia Católica, §1243.", "Junto a la luz, el incienso expresa honor y oración que se eleva. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "En el rito del Bautismo se entrega una vela encendida en el cirio pascual como signo de la luz de Cristo. Catecismo de la Iglesia Católica, §1243.",
                    glossaryTerms: [.init(term: "cirio pascual", definition: "Vela que representa a Cristo resucitado en la liturgia.")]
                ),
                .init(
                    id: "signs-symbols-4-es",
                    trackID: "signs-symbols",
                    partNumber: 4,
                    partsTotal: 5,
                    kicker: "Signos y símbolos",
                    title: "El incienso",
                    bodyParagraphs: ["¿Por qué se inciensa el altar, el Evangelio y la asamblea? Esta lección se detiene en el honor debido a Cristo presente en la acción litúrgica y la oración que asciende a Dios. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La Instrucción General del Misal Romano prevé el incienso en diversos momentos y objetos de la celebración. Instrucción General del Misal Romano, §§75, 276.", "Hay un signo menos visible pero decisivo para escuchar y orar: el silencio. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La Instrucción General del Misal Romano prevé el incienso en diversos momentos y objetos de la celebración. Instrucción General del Misal Romano, §§75, 276.",
                    glossaryTerms: [.init(term: "incienso", definition: "Resina aromática quemada como signo de honor y de oración.")]
                ),
                .init(
                    id: "signs-symbols-5-es",
                    trackID: "signs-symbols",
                    partNumber: 5,
                    partsTotal: 5,
                    kicker: "Signos y símbolos",
                    title: "El silencio",
                    bodyParagraphs: ["¿El silencio en la Misa es una pausa sin contenido? Esta lección se detiene en la escucha de la Palabra, la oración interior y la respuesta personal de cada participante. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El silencio sagrado corresponde a la naturaleza de la celebración y tiene distintos momentos y finalidades. Instrucción General del Misal Romano, §45.", "Los signos no sustituyen la fe; ayudan a que la Iglesia rece con el cuerpo y la voz. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El silencio sagrado corresponde a la naturaleza de la celebración y tiene distintos momentos y finalidades. Instrucción General del Misal Romano, §45.",
                    glossaryTerms: [.init(term: "silencio sagrado", definition: "Silencio que dispone a escuchar, orar y responder interiormente.")]
                )
            ]
        ),
        .init(
            id: "prayers-explained",
            title: "Las oraciones explicadas",
            meta: "6 partes · 3 min cada",
            progress: 0,
            nextUp: "Parte 1: El Padrenuestro",
            lessons: [
                .init(
                    id: "prayers-explained-1-es",
                    trackID: "prayers-explained",
                    partNumber: 1,
                    partsTotal: 6,
                    kicker: "Las oraciones explicadas",
                    title: "El Padrenuestro",
                    bodyParagraphs: ["¿Por qué el Padrenuestro ocupa un lugar único entre las oraciones? Esta lección se detiene en la oración que Jesús entregó a sus discípulos y que reúne las necesidades esenciales de la vida cristiana. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Padrenuestro es el resumen de todo el Evangelio y ordena siete peticiones dirigidas al Padre. Catecismo de la Iglesia Católica, §§2759–2865.", "La siguiente oración contempla el saludo del ángel a María y pide su intercesión. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Padrenuestro es el resumen de todo el Evangelio y ordena siete peticiones dirigidas al Padre. Catecismo de la Iglesia Católica, §§2759–2865.",
                    glossaryTerms: [.init(term: "Padrenuestro", definition: "Oración que Jesucristo enseñó a sus discípulos.")]
                ),
                .init(
                    id: "prayers-explained-2-es",
                    trackID: "prayers-explained",
                    partNumber: 2,
                    partsTotal: 6,
                    kicker: "Las oraciones explicadas",
                    title: "El Avemaría",
                    bodyParagraphs: ["¿De dónde nace el Avemaría? Esta lección se detiene en el saludo de Gabriel, la bendición de Isabel y la súplica confiada de la Iglesia a María. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La primera parte procede del Evangelio y la segunda invoca a la Madre de Dios para ahora y la hora de la muerte. Catecismo de la Iglesia Católica, §§2673–2679.", "Toda oración cristiana vuelve finalmente a la alabanza del Dios trino. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La primera parte procede del Evangelio y la segunda invoca a la Madre de Dios para ahora y la hora de la muerte. Catecismo de la Iglesia Católica, §§2673–2679.",
                    glossaryTerms: [.init(term: "Avemaría", definition: "Oración mariana formada por palabras del Evangelio y una súplica de la Iglesia.")]
                ),
                .init(
                    id: "prayers-explained-3-es",
                    trackID: "prayers-explained",
                    partNumber: 3,
                    partsTotal: 6,
                    kicker: "Las oraciones explicadas",
                    title: "El Gloria",
                    bodyParagraphs: ["¿Qué hace una doxología como el Gloria? Esta lección se detiene en dar gloria al Padre, al Hijo y al Espíritu Santo al final de una oración. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La alabanza reconoce a Dios por quien es; la doxología es una forma breve y constante de esa alabanza trinitaria. Catecismo de la Iglesia Católica, §2628.", "El Credo no es una oración espontánea: recoge la fe recibida y profesada por la Iglesia. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La alabanza reconoce a Dios por quien es; la doxología es una forma breve y constante de esa alabanza trinitaria. Catecismo de la Iglesia Católica, §2628.",
                    glossaryTerms: [.init(term: "doxología", definition: "Fórmula de alabanza dirigida a la Trinidad.")]
                ),
                .init(
                    id: "prayers-explained-4-es",
                    trackID: "prayers-explained",
                    partNumber: 4,
                    partsTotal: 6,
                    kicker: "Las oraciones explicadas",
                    title: "El Credo",
                    bodyParagraphs: ["¿Para qué se profesa el Credo? Esta lección se detiene en para confesar juntos la fe transmitida desde los apóstoles y recibida en el Bautismo. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "Los símbolos de la fe resumen de modo orgánico lo que la Iglesia cree, celebra y transmite. Catecismo de la Iglesia Católica, §§185–197.", "La oración mariana siguiente presenta a María como abogada en el camino de los creyentes. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "Los símbolos de la fe resumen de modo orgánico lo que la Iglesia cree, celebra y transmite. Catecismo de la Iglesia Católica, §§185–197.",
                    glossaryTerms: [.init(term: "símbolo de la fe", definition: "Síntesis de las verdades fundamentales que la Iglesia profesa.")]
                ),
                .init(
                    id: "prayers-explained-5-es",
                    trackID: "prayers-explained",
                    partNumber: 5,
                    partsTotal: 6,
                    kicker: "Las oraciones explicadas",
                    title: "La Salve Regina",
                    bodyParagraphs: ["¿Qué pide la Salve Regina? Esta lección se detiene en la mirada misericordiosa de María mientras la Iglesia camina hacia Cristo. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La piedad mariana conduce a Cristo y reconoce en María a una intercesora que ruega por las necesidades de sus hijos. Catecismo de la Iglesia Católica, §§2679–2682.", "El Ángelus retoma un momento concreto de esa historia: la Anunciación. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La piedad mariana conduce a Cristo y reconoce en María a una intercesora que ruega por las necesidades de sus hijos. Catecismo de la Iglesia Católica, §§2679–2682.",
                    glossaryTerms: [.init(term: "Salve Regina", definition: "Oración mariana que pide la intercesión de la Madre de misericordia.")]
                ),
                .init(
                    id: "prayers-explained-6-es",
                    trackID: "prayers-explained",
                    partNumber: 6,
                    partsTotal: 6,
                    kicker: "Las oraciones explicadas",
                    title: "El Ángelus",
                    bodyParagraphs: ["¿Qué se recuerda al rezar el Ángelus? Esta lección se detiene en la Anunciación y la Encarnación del Verbo en el sí de María. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Ángelus une las palabras del Evangelio con el Avemaría para contemplar que el Hijo de Dios se hizo hombre por nosotros. Compendio del Catecismo de la Iglesia Católica, apéndice: Oraciones comunes.", "Estas oraciones no son fórmulas aisladas: introducen a los misterios de Cristo que el Rosario contempla. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Ángelus une las palabras del Evangelio con el Avemaría para contemplar que el Hijo de Dios se hizo hombre por nosotros. Compendio del Catecismo de la Iglesia Católica, apéndice: Oraciones comunes.",
                    glossaryTerms: [.init(term: "Ángelus", definition: "Oración que recuerda la Anunciación y la Encarnación.")]
                )
            ]
        ),
        .init(
            id: "rosary-basics",
            title: "El Rosario, desde el principio",
            meta: "7 partes · 3 min cada",
            progress: 0,
            nextUp: "Parte 1: Qué es el Rosario",
            lessons: [
                .init(
                    id: "rosary-basics-1-es",
                    trackID: "rosary-basics",
                    partNumber: 1,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "Qué es el Rosario",
                    bodyParagraphs: ["¿Qué se contempla al rezar el Rosario? Esta lección se detiene en los principales acontecimientos de la vida de Cristo junto con María. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "El Rosario es una oración de contemplación cristológica: la repetición del Avemaría sostiene la mirada sobre el misterio anunciado. San Juan Pablo II, Rosarium Virginis Mariae, §§12–17.", "Para rezarlo con libertad conviene conocer primero la secuencia sencilla de cuentas y oraciones. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "El Rosario es una oración de contemplación cristológica: la repetición del Avemaría sostiene la mirada sobre el misterio anunciado. San Juan Pablo II, Rosarium Virginis Mariae, §§12–17.",
                    glossaryTerms: [.init(term: "Rosario", definition: "Oración que medita los misterios de Cristo con la repetición del Avemaría.")]
                ),
                .init(
                    id: "rosary-basics-2-es",
                    trackID: "rosary-basics",
                    partNumber: 2,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "La estructura",
                    bodyParagraphs: ["¿Cómo se organiza una decena del Rosario? Esta lección se detiene en el anuncio del misterio, un Padrenuestro, diez Avemarías y el Gloria. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La forma del Rosario ofrece un ritmo estable para la contemplación, sin reducir la oración a un conteo. Santa Sede, Los misterios del Santo Rosario.", "La primera serie de escenas lleva a Nazaret, a la Visitación y a la infancia de Jesús. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La forma del Rosario ofrece un ritmo estable para la contemplación, sin reducir la oración a un conteo. Santa Sede, Los misterios del Santo Rosario.",
                    glossaryTerms: [.init(term: "decena", definition: "Conjunto de diez Avemarías rezadas al contemplar un misterio.")]
                ),
                .init(
                    id: "rosary-basics-3-es",
                    trackID: "rosary-basics",
                    partNumber: 3,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "Los misterios gozosos",
                    bodyParagraphs: ["¿Qué muestran los misterios gozosos? Esta lección se detiene en la Encarnación y los primeros años de Jesús, recibidos en la fe de María. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "Los misterios gozosos recorren la Anunciación, la Visitación, el Nacimiento, la Presentación y el encuentro de Jesús en el Templo. Santa Sede, Los misterios del Santo Rosario.", "Los misterios luminosos pasan de la infancia a la manifestación pública del Señor. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "Los misterios gozosos recorren la Anunciación, la Visitación, el Nacimiento, la Presentación y el encuentro de Jesús en el Templo. Santa Sede, Los misterios del Santo Rosario.",
                    glossaryTerms: [.init(term: "misterios gozosos", definition: "Cinco escenas de la Encarnación y de la infancia de Jesús.")]
                ),
                .init(
                    id: "rosary-basics-4-es",
                    trackID: "rosary-basics",
                    partNumber: 4,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "Los misterios luminosos",
                    bodyParagraphs: ["¿Qué ilumina la vida pública de Jesús? Esta lección se detiene en su Bautismo, Caná, el anuncio del Reino, la Transfiguración y la Eucaristía. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "San Juan Pablo II propuso los misterios luminosos para contemplar momentos decisivos de la revelación de Cristo. Rosarium Virginis Mariae, §§19–21.", "La contemplación conduce después a la pasión, donde el amor de Cristo se entrega hasta el extremo. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "San Juan Pablo II propuso los misterios luminosos para contemplar momentos decisivos de la revelación de Cristo. Rosarium Virginis Mariae, §§19–21.",
                    glossaryTerms: [.init(term: "misterios luminosos", definition: "Cinco escenas de la manifestación pública de Jesucristo.")]
                ),
                .init(
                    id: "rosary-basics-5-es",
                    trackID: "rosary-basics",
                    partNumber: 5,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "Los misterios dolorosos",
                    bodyParagraphs: ["¿Por qué el Rosario contempla la pasión? Esta lección se detiene en porque en ella se revela el amor de Cristo que se entrega y vence el pecado. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "Los misterios dolorosos recorren la oración en el huerto, la flagelación, la coronación de espinas, el camino de la cruz y la crucifixión. Santa Sede, Los misterios del Santo Rosario.", "La historia no termina en la cruz: los misterios gloriosos anuncian la vida nueva de Cristo resucitado. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "Los misterios dolorosos recorren la oración en el huerto, la flagelación, la coronación de espinas, el camino de la cruz y la crucifixión. Santa Sede, Los misterios del Santo Rosario.",
                    glossaryTerms: [.init(term: "misterios dolorosos", definition: "Cinco escenas de la pasión y muerte de Jesucristo.")]
                ),
                .init(
                    id: "rosary-basics-6-es",
                    trackID: "rosary-basics",
                    partNumber: 6,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "Los misterios gloriosos",
                    bodyParagraphs: ["¿Qué celebra la Iglesia en los misterios gloriosos? Esta lección se detiene en la resurrección de Cristo, su Ascensión, Pentecostés y la gloria de María. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "Los misterios gloriosos abren la contemplación a la vida nueva del Resucitado y a la esperanza de la Iglesia. Santa Sede, Los misterios del Santo Rosario.", "Para que la repetición no se vuelva mecánica, el siguiente paso es volver al pasaje bíblico de cada misterio. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "Los misterios gloriosos abren la contemplación a la vida nueva del Resucitado y a la esperanza de la Iglesia. Santa Sede, Los misterios del Santo Rosario.",
                    glossaryTerms: [.init(term: "misterios gloriosos", definition: "Cinco escenas de Cristo resucitado y de la glorificación de María.")]
                ),
                .init(
                    id: "rosary-basics-7-es",
                    trackID: "rosary-basics",
                    partNumber: 7,
                    partsTotal: 7,
                    kicker: "El Rosario, desde el principio",
                    title: "Rezar con la Escritura",
                    bodyParagraphs: ["¿Cómo puede la Escritura acompañar el Rosario? Esta lección se detiene en con una breve lectura del pasaje antes de la decena y un momento de silencio para acogerlo. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La contemplación del misterio se nutre de la Palabra de Dios; el nombre de Jesús en el Avemaría concentra la atención en Cristo. Rosarium Virginis Mariae, §§29–31.", "La oración siguiente abre la puerta al sacramento de la reconciliación, donde también se escucha la llamada de Cristo. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La contemplación del misterio se nutre de la Palabra de Dios; el nombre de Jesús en el Avemaría concentra la atención en Cristo. Rosarium Virginis Mariae, §§29–31.",
                    glossaryTerms: [.init(term: "contemplación", definition: "Atención amorosa a Cristo presente en el misterio anunciado.")]
                )
            ]
        ),
        .init(
            id: "confession",
            title: "Cómo confesarse bien",
            meta: "5 partes · 3 min cada",
            progress: 0,
            nextUp: "Parte 1: Por qué confesarse",
            lessons: [
                .init(
                    id: "confession-1-es",
                    trackID: "confession",
                    partNumber: 1,
                    partsTotal: 5,
                    kicker: "Cómo confesarse bien",
                    title: "Por qué confesarse",
                    bodyParagraphs: ["¿Por qué la Iglesia propone confesarse? Esta lección se detiene en porque el pecado hiere la comunión y Cristo ofrece el perdón mediante el ministerio de la Iglesia. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "En el sacramento de la Penitencia, el bautizado se reconcilia con Dios y con la Iglesia por la conversión, la confesión y la absolución. Catecismo de la Iglesia Católica, §§1422–1449.", "La preparación comienza mirando la propia vida con verdad y sin fabricar culpas. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "En el sacramento de la Penitencia, el bautizado se reconcilia con Dios y con la Iglesia por la conversión, la confesión y la absolución. Catecismo de la Iglesia Católica, §§1422–1449.",
                    glossaryTerms: [.init(term: "confesión", definition: "Celebración sacramental de la reconciliación con Dios y con la Iglesia.")]
                ),
                .init(
                    id: "confession-2-es",
                    trackID: "confession",
                    partNumber: 2,
                    partsTotal: 5,
                    kicker: "Cómo confesarse bien",
                    title: "El examen de conciencia",
                    bodyParagraphs: ["¿Qué busca un examen de conciencia? Esta lección se detiene en reconocer actos, omisiones y motivaciones a la luz del amor de Dios. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La conciencia permite juzgar la calidad moral de los propios actos; necesita formarse y escuchar la verdad. Catecismo de la Iglesia Católica, §§1776–1802.", "Ver con verdad prepara una tristeza del pecado que no es desesperación, sino retorno a Dios. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La conciencia permite juzgar la calidad moral de los propios actos; necesita formarse y escuchar la verdad. Catecismo de la Iglesia Católica, §§1776–1802.",
                    glossaryTerms: [.init(term: "conciencia", definition: "Juicio interior por el que la persona reconoce la calidad moral de sus actos.")]
                ),
                .init(
                    id: "confession-3-es",
                    trackID: "confession",
                    partNumber: 3,
                    partsTotal: 5,
                    kicker: "Cómo confesarse bien",
                    title: "La contrición",
                    bodyParagraphs: ["¿Qué significa estar contrito? Esta lección se detiene en doler por haber pecado y decidir apartarse del mal por amor a Dios. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La contrición es dolor del alma y rechazo del pecado con propósito de no pecar de nuevo; es esencial para la Penitencia. Catecismo de la Iglesia Católica, §§1451–1453.", "La contrición se expresa con palabras claras ante el confesor, sin esconder deliberadamente lo grave. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La contrición es dolor del alma y rechazo del pecado con propósito de no pecar de nuevo; es esencial para la Penitencia. Catecismo de la Iglesia Católica, §§1451–1453.",
                    glossaryTerms: [.init(term: "contrición", definition: "Dolor por el pecado unido al propósito de una vida nueva.")]
                ),
                .init(
                    id: "confession-4-es",
                    trackID: "confession",
                    partNumber: 4,
                    partsTotal: 5,
                    kicker: "Cómo confesarse bien",
                    title: "La acusación de los pecados",
                    bodyParagraphs: ["¿Cómo se dicen los pecados en la confesión? Esta lección se detiene en con sencillez y sinceridad, nombrando los pecados graves recordados y sus circunstancias necesarias. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La confesión de los pecados al sacerdote es parte constitutiva del sacramento; ha de ser íntegra respecto de los pecados graves de los que se tiene conciencia. Catecismo de la Iglesia Católica, §§1455–1456.", "Después de la absolución, la penitencia concreta el deseo de reparar y volver a una vida coherente. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La confesión de los pecados al sacerdote es parte constitutiva del sacramento; ha de ser íntegra respecto de los pecados graves de los que se tiene conciencia. Catecismo de la Iglesia Católica, §§1455–1456.",
                    glossaryTerms: [.init(term: "acusación", definition: "Manifestación sincera de los pecados en el sacramento de la Penitencia.")]
                ),
                .init(
                    id: "confession-5-es",
                    trackID: "confession",
                    partNumber: 5,
                    partsTotal: 5,
                    kicker: "Cómo confesarse bien",
                    title: "La penitencia y la paz",
                    bodyParagraphs: ["¿Por qué el confesor propone una penitencia? Esta lección se detiene en para que el perdón recibido impulse a reparar el daño y a recomenzar de forma concreta. No ofrece una definición aislada: mira cómo ese signo o esa oración forma parte de la vida de la Iglesia.", "La satisfacción no compra el perdón: expresa el deseo de reparar y cooperar con la gracia que restaura la comunión. Catecismo de la Iglesia Católica, §§1459–1460.", "La reconciliación no concluye al salir del confesionario: se prolonga en obras de misericordia y en una vida renovada. La formación avanza cuando la fuente recibida se relaciona con una práctica concreta de oración y celebración."],
                    quoteText: nil,
                    quoteAttribution: "La satisfacción no compra el perdón: expresa el deseo de reparar y cooperar con la gracia que restaura la comunión. Catecismo de la Iglesia Católica, §§1459–1460.",
                    glossaryTerms: [.init(term: "satisfacción", definition: "Respuesta concreta de reparación que acompaña el perdón sacramental.")]
                )
            ]
        ),
    ]

    static let importedOtherTracksCatalog = LocalizedCatalog(
        pt: ptImportedOtherTracks,
        en: enImportedOtherTracks,
        es: esImportedOtherTracks
    )
}
