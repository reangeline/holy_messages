import Foundation

enum MockWordOfDay {
    /// The pool a day's word is drawn from — one catalog per language, grown
    /// over time via the Acervo tool. See LocalizedCatalog.
    static var pool: [WordOfDay] { catalog.current }

    static let catalog = LocalizedCatalog(pt: ptPool, en: enPool, es: esPool)

    /// Fonte: António Pereira de Figueiredo, *Biblia Sagrada Illustrada*, vol. III,
    /// Porto, 1896 — edição católica histórica em domínio público, conferida no
    /// fac-símile (Mt 5 na p. impressa 7 / PDF 20; Jo 3 na p. impressa 162 / PDF 175).
    /// **Não** é a tradução litúrgica atual da CNBB. Grafia e pontuação foram
    /// atualizadas para leitura, e dois artefatos de OCR corrigidos ("levantodo",
    /// "ccu"); o vocabulário é o da edição. A numeração segue as edições atuais, não
    /// a da Vulgata, que inverte 5,4 e 5,5 — ver o comentário em `renumber`.
    private static let ptPool: [WordOfDay] = [
        .init(
            id: "joao-3-14",
            quote: "E como Moisés no deserto levantou a serpente, assim importa que seja levantado o Filho do Homem, para que todo o que crê nele não pereça, mas tenha a vida eterna.",
            reference: "João 3, 14-15",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "Jesus fala de noite, a um fariseu, e cita um episódio do deserto: uma serpente de bronze erguida num poste, que curava quem olhasse para ela. O verbo \"levantado\" é o mesmo que se usará para a crucificação. É por isso que este texto se lê hoje: a Cruz não é um acidente no fim da história, é o sinal erguido para ser olhado."
        ),
        .init(
            id: "mateus-5-3-pt",
            quote: "Bem-aventurados os pobres de espírito; porque deles é o reino dos céus.",
            reference: "Mateus 5, 3",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "Jesus começa o Sermão da Montanha ensinando aos discípulos. A primeira bem-aventurança orienta o desejo para o Reino dos céus. O Catecismo lê as bem-aventuranças como o centro da pregação de Jesus."
        ),
        .init(
            id: "mateus-5-4-pt",
            quote: "Bem-aventurados os que choram; porque eles serão consolados.",
            reference: "Mateus 5, 4",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "Jesus continua a série de bem-aventuranças no monte. A promessa de consolação acompanha os que choram. O versículo pertence ao ensinamento inicial do Sermão da Montanha."
        ),
        .init(
            id: "mateus-5-5-pt",
            quote: "Bem-aventurados os mansos; porque eles possuirão a terra.",
            reference: "Mateus 5, 5",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "A segunda bem-aventurança segue o anúncio do Reino. Jesus associa a mansidão à posse da terra prometida. O contexto é a sequência das bem-aventuranças dirigidas aos discípulos."
        ),
        .init(
            id: "mateus-5-6-pt",
            quote: "Bem-aventurados os que têm fome e sede de justiça; porque eles serão fartos.",
            reference: "Mateus 5, 6",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "A fome e a sede são imagens de um desejo intenso. Jesus apresenta a justiça como aquilo que os discípulos devem buscar. A promessa de saciedade fecha esta bem-aventurança."
        ),
        .init(
            id: "mateus-5-7-pt",
            quote: "Bem-aventurados os misericordiosos; porque eles alcançarão misericórdia.",
            reference: "Mateus 5, 7",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "Jesus fala aos discípulos na sequência das bem-aventuranças. O versículo relaciona a misericórdia praticada com a misericórdia recebida. A promessa pertence ao anúncio do Reino que abre o Sermão da Montanha."
        ),
        .init(
            id: "mateus-5-8-pt",
            quote: "Bem-aventurados os limpos de coração; porque eles verão a Deus.",
            reference: "Mateus 5, 8",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "A bem-aventurança situa a pureza do coração diante da promessa de ver Deus. Jesus continua o discurso dirigido aos discípulos. O tema está ligado à orientação interior da vida cristã."
        ),
        .init(
            id: "mateus-5-9-pt",
            quote: "Bem-aventurados os pacíficos; porque eles serão chamados filhos de Deus.",
            reference: "Mateus 5, 9",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "Esta é uma das bem-aventuranças pronunciadas por Jesus no monte, diante dos discípulos. A promessa associa os pacíficos à condição de filhos de Deus. O Catecismo apresenta as bem-aventuranças como descrição das atitudes características da vida cristã."
        ),
        .init(
            id: "mateus-5-10-pt",
            quote: "Bem-aventurados os que padecem perseguição por amor de justiça; porque deles é o reino dos céus.",
            reference: "Mateus 5, 10",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "A série termina com a perseguição sofrida por causa da justiça. Jesus retoma a promessa do Reino dos céus apresentada no primeiro versículo. O discurso prepara a exortação seguinte sobre a alegria no sofrimento."
        ),
        .init(
            id: "mateus-5-11-pt",
            quote: "Bem-aventurados sois, quando vos injuriarem e vos perseguirem e disserem todo o mal contra vós mentindo, por meu respeito;",
            reference: "Mateus 5, 11",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "Jesus passa da formulação geral das bem-aventuranças a uma palavra direta aos discípulos. A perseguição descrita inclui insulto, perseguição e acusação mentirosa. O motivo indicado é a relação com Jesus."
        ),
        .init(
            id: "mateus-5-12-pt",
            quote: "Folgai e exultai, porque o vosso galardão é copioso nos céus; pois assim também perseguiram aos profetas que foram antes de vós.",
            reference: "Mateus 5, 12",
            translationNote: "Figueiredo 1896 · domínio público, grafia atualizada",
            context: "A resposta de Jesus à perseguição é alegria pela recompensa nos céus. Ele liga a experiência dos discípulos à dos profetas anteriores. O versículo conclui a série das bem-aventuranças de Mateus 5."
        ),
    ]

    /// English uses the Douay-Rheims wording — public domain, and already the
    /// translation this app cites for English-language scripture.
    /// Source: Douay-Rheims 1899 American Edition, Matthew 5 and John 3, as published
    /// in the public domain by eBible.org. **Not** the current USCCB liturgical
    /// translation. Verse numbers follow current editions rather than the Vulgate's,
    /// which swaps 5:4 and 5:5.
    private static let enPool: [WordOfDay] = [
        .init(
            id: "joao-3-14",
            quote: "And as Moses lifted up the serpent in the desert, so must the Son of man be lifted up: that whosoever believeth in him may not perish, but may have life everlasting.",
            reference: "John 3:14-15",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Jesus is speaking at night, to a Pharisee, and he cites an episode from the desert: a bronze serpent raised on a pole, which healed whoever looked at it. The verb \"lifted up\" is the same one that will be used for the crucifixion. That is why this text is read today: the Cross is not an accident at the end of the story, it is the sign raised up to be looked at."
        ),
        .init(
            id: "mateus-5-3-en",
            quote: "Blessed are the poor in spirit: for theirs is the kingdom of heaven.",
            reference: "Matthew 5:3",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Jesus begins the Sermon on the Mount by teaching the disciples. The first beatitude directs desire toward the kingdom of heaven. The Catechism presents the beatitudes as the center of Jesus’ preaching."
        ),
        .init(
            id: "mateus-5-4-en",
            quote: "Blessed are they that mourn: for they shall be comforted.",
            reference: "Matthew 5:4",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Jesus continues the series of beatitudes on the mountain. The promise of comfort accompanies those who mourn. The verse belongs to the opening teaching of the Sermon on the Mount."
        ),
        .init(
            id: "mateus-5-5-en",
            quote: "Blessed are the meek: for they shall possess the land.",
            reference: "Matthew 5:5",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "The second beatitude follows the announcement of the kingdom. Jesus connects meekness with possessing the promised land. The setting is the sequence of beatitudes addressed to the disciples."
        ),
        .init(
            id: "mateus-5-6-en",
            quote: "Blessed are they that hunger and thirst after justice: for they shall have their fill.",
            reference: "Matthew 5:6",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Hunger and thirst are images of an intense desire. Jesus presents justice as what the disciples are to seek. The promise of being filled closes this beatitude."
        ),
        .init(
            id: "mateus-5-7-en",
            quote: "Blessed are the merciful: for they shall obtain mercy.",
            reference: "Matthew 5:7",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Jesus speaks to the disciples in the sequence of beatitudes. The verse connects mercy given with mercy received. The promise belongs to the announcement of the kingdom that opens the Sermon on the Mount."
        ),
        .init(
            id: "mateus-5-8-en",
            quote: "Blessed are the clean of heart: for they shall see God.",
            reference: "Matthew 5:8",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "The beatitude places purity of heart before the promise of seeing God. Jesus continues the discourse addressed to the disciples. The theme concerns the interior direction of Christian life."
        ),
        .init(
            id: "mateus-5-9-en",
            quote: "Blessed are the peacemakers: for they shall be called children of God.",
            reference: "Matthew 5:9",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "This is one of the beatitudes Jesus pronounces on the mountain before the disciples. The promise associates peacemakers with being called children of God. The Catechism presents the beatitudes as a description of the attitudes characteristic of Christian life."
        ),
        .init(
            id: "mateus-5-10-en",
            quote: "Blessed are they that suffer persecution for justice’ sake: for theirs is the kingdom of heaven.",
            reference: "Matthew 5:10",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "The series ends with persecution suffered for the sake of justice. Jesus returns to the promise of the kingdom of heaven given in the first verse. The discourse prepares the following exhortation about joy in suffering."
        ),
        .init(
            id: "mateus-5-11-en",
            quote: "Blessed are ye when they shall revile you, and persecute you, and speak all that is evil against you, untruly, for my sake:",
            reference: "Matthew 5:11",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Jesus moves from the general form of the beatitudes to a direct word to the disciples. The persecution described includes insult, pursuit, and false accusation. The stated reason is their relationship with Jesus."
        ),
        .init(
            id: "mateus-5-12-en",
            quote: "Be glad and rejoice, for your reward is very great in heaven. For so they persecuted the prophets that were before you.",
            reference: "Matthew 5:12",
            translationNote: "Douay-Rheims 1899 · public domain",
            context: "Jesus’ response to persecution is joy because of the reward in heaven. He connects the disciples’ experience with that of the prophets who came before them. The verse concludes Matthew 5’s sequence of beatitudes."
        ),
    ]

    /// Spanish historical Catholic edition, retained as a separate catalog.
    /// Fuente: Félix Torres Amat, *Sagrada Biblia*, tomo I, Madrid, 1823 — edición
    /// católica histórica en dominio público, comprobada en el facsímil (p. impresa 8 /
    /// PDF 26). **No** es la traducción litúrgica actual. La grafía se actualizó para
    /// la lectura; las glosas del traductor ("ó de ser justos y santos") son de la
    /// edición y se conservan. La numeración sigue las ediciones actuales.
    private static let esPool: [WordOfDay] = [
        .init(
            id: "mateus-5-3-es",
            quote: "Bienaventurados los pobres de espíritu, porque de ellos es el reino de los cielos.",
            reference: "Mateo 5, 3",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "Jesús comienza el Sermón de la Montaña enseñando a los discípulos. La primera bienaventuranza orienta el deseo hacia el reino de los cielos. El Catecismo presenta las bienaventuranzas como el centro de la predicación de Jesús."
        ),
        .init(
            id: "mateus-5-4-es",
            quote: "Bienaventurados los que lloran, porque ellos serán consolados.",
            reference: "Mateo 5, 4",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "Jesús continúa la serie de bienaventuranzas en el monte. La promesa de consuelo acompaña a quienes lloran. El versículo pertenece a la enseñanza inicial del Sermón de la Montaña."
        ),
        .init(
            id: "mateus-5-5-es",
            quote: "Bienaventurados los mansos y humildes, porque ellos poseerán la tierra.",
            reference: "Mateo 5, 5",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "La segunda bienaventuranza sigue al anuncio del reino. Jesús relaciona la mansedumbre con la posesión de la tierra prometida. El contexto es la secuencia de bienaventuranzas dirigidas a los discípulos."
        ),
        .init(
            id: "mateus-5-6-es",
            quote: "Bienaventurados los que tienen hambre y sed de la justicia, o de ser justos y santos, porque serán saciados.",
            reference: "Mateo 5, 6",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "El hambre y la sed son imágenes de un deseo intenso. Jesús presenta la justicia como aquello que los discípulos deben buscar. La promesa de saciedad cierra esta bienaventuranza."
        ),
        .init(
            id: "mateus-5-7-es",
            quote: "Bienaventurados los misericordiosos, porque ellos alcanzarán misericordia.",
            reference: "Mateo 5, 7",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "Jesús habla a los discípulos en la secuencia de las bienaventuranzas. El versículo relaciona la misericordia practicada con la misericordia recibida. La promesa pertenece al anuncio del reino que abre el Sermón de la Montaña."
        ),
        .init(
            id: "mateus-5-8-es",
            quote: "Bienaventurados los que tienen puro su corazón, porque ellos verán a Dios.",
            reference: "Mateo 5, 8",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "La bienaventuranza sitúa la pureza del corazón ante la promesa de ver a Dios. Jesús continúa el discurso dirigido a los discípulos. El tema se relaciona con la orientación interior de la vida cristiana."
        ),
        .init(
            id: "mateus-5-9-es",
            quote: "Bienaventurados los pacíficos, porque ellos serán llamados hijos de Dios.",
            reference: "Mateo 5, 9",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "Esta es una de las bienaventuranzas pronunciadas por Jesús en el monte, ante los discípulos. La promesa asocia a los pacíficos con la condición de hijos de Dios. El Catecismo presenta las bienaventuranzas como descripción de las actitudes características de la vida cristiana."
        ),
        .init(
            id: "mateus-5-10-es",
            quote: "Bienaventurados los que padecen persecución por la justicia o por ser justos, porque de ellos es el reino de los cielos.",
            reference: "Mateo 5, 10",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "La serie termina con la persecución sufrida por causa de la justicia. Jesús retoma la promesa del reino de los cielos presentada en el primer versículo. El discurso prepara la exhortación siguiente sobre la alegría en el sufrimiento."
        ),
        .init(
            id: "mateus-5-11-es",
            quote: "Dichosos seréis cuando los hombres por su causa os maldijeren, y os persiguieren, y dijeren con mentira toda suerte de mal contra vosotros.",
            reference: "Mateo 5, 11",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "Jesús pasa de la formulación general de las bienaventuranzas a una palabra directa a los discípulos. La persecución descrita incluye insulto, persecución y acusación mentirosa. El motivo indicado es la relación con Jesús."
        ),
        .init(
            id: "mateus-5-12-es",
            quote: "Alegraos entonces y regocijaos, porque es muy grande la recompensa que os aguarda en los cielos. Del mismo modo persiguieron a los profetas que ha habido antes de vosotros.",
            reference: "Mateo 5, 12",
            translationNote: "Torres Amat 1823 · dominio público, grafía actualizada",
            context: "La respuesta de Jesús a la persecución es la alegría por la recompensa en los cielos. Él vincula la experiencia de los discípulos con la de los profetas anteriores. El versículo concluye la serie de bienaventuranzas de Mateo 5."
        ),
    ]

    /// A stable (non-randomized-per-process) hash, unlike Swift's own Hasher —
    /// needed so the same dateKey always picks the same pool index across app
    /// launches, not just within one run. FNV-1a.
    private static func stableHash(_ string: String) -> UInt64 {
        var hash: UInt64 = 14_695_981_039_346_656_037
        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1_099_511_628_211
        }
        return hash
    }

    /// Delivers one pool entry per day — looks random from one day to the next,
    /// but is stable within the same day (same dateKey always resolves to the
    /// same entry, so relaunching the app doesn't change today's word).
    static func wordOfDay(for dateKey: String) -> WordOfDay {
        guard !pool.isEmpty else {
            return WordOfDay(id: "empty", quote: "", reference: "", translationNote: "", context: "")
        }
        let index = Int(stableHash(dateKey) % UInt64(pool.count))
        return pool[index]
    }
}
