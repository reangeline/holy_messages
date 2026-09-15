import Foundation

/// Onboarding content, now fully trilingual (en/pt/es) since the app unifies
/// onboarding and the main app under one interface language. Each piece of
/// content is authored once per language as a parallel array/dictionary rather
/// than field-by-field, since the structs (LifeQuestion, SpiritualQuestion,
/// SampleTab) don't carry per-language variants themselves — simplest to keep
/// correct and easy to audit side by side.
enum MockOnboarding {
    // MARK: - Sample tabs (dIs1)

    static func sampleTabs(for language: AppLanguage) -> [SampleTab] {
        switch language {
        case .en:
            [
                .init(id: "verse", label: "Verse", kicker: "Today's verse", title: "Exaltation of the Holy Cross",
                      body: "Monday, September 14. Red vestments today — the color of blood and of the Cross. This screen carries the color of the day, and it changes when the calendar does.",
                      quote: "And as Moses lifted up the serpent in the desert, so must the Son of Man be lifted up."),
                .init(id: "saint", label: "Saint", kicker: "Saint of the day", title: "St. Notburga of Eben",
                      body: "A Tyrolean servant, dismissed from her post for giving the poor food that would otherwise be thrown away. She kept giving from what little she had.",
                      quote: "Remembered for what she did with the leftovers, and for not stopping when it cost her the job."),
                .init(id: "mass", label: "Mass", kicker: "The Mass, part by part · 1 of 14", title: "The Introductory Rites",
                      body: "Before anything is read or offered, the Church gathers and admits what it is.",
                      quote: "Why the sign of the cross comes first, and what the greeting actually claims."),
            ]
        case .pt:
            [
                .init(id: "verse", label: "Versículo", kicker: "Versículo de hoje", title: "Exaltação da Santa Cruz",
                      body: "Segunda-feira, 14 de setembro. Vestes vermelhas hoje — a cor do sangue e da Cruz. Esta tela carrega a cor do dia, e ela muda quando o calendário muda.",
                      quote: "Como Moisés levantou a serpente no deserto, assim deve ser levantado o Filho do Homem."),
                .init(id: "saint", label: "Santo", kicker: "Santo do dia", title: "Santa Notburga de Eben",
                      body: "Serva tirolesa, foi despedida do trabalho por dar aos pobres a comida que seria jogada fora. Continuou dando o pouco que tinha.",
                      quote: "Lembrada pelo que fazia com as sobras, e por não ter parado quando isso lhe custou o emprego."),
                .init(id: "mass", label: "Missa", kicker: "A Missa, parte por parte · 1 de 14", title: "Os Ritos Iniciais",
                      body: "Antes de qualquer leitura ou oferta, a Igreja se reúne e admite o que é.",
                      quote: "Por que o sinal da cruz vem primeiro, e o que a saudação realmente afirma."),
            ]
        case .es:
            [
                .init(id: "verse", label: "Versículo", kicker: "Versículo de hoy", title: "Exaltación de la Santa Cruz",
                      body: "Lunes, 14 de septiembre. Vestiduras rojas hoy — el color de la sangre y de la Cruz. Esta pantalla lleva el color del día, y cambia cuando cambia el calendario.",
                      quote: "Y como Moisés levantó la serpiente en el desierto, así debe ser levantado el Hijo del Hombre."),
                .init(id: "saint", label: "Santo", kicker: "Santo del día", title: "Santa Notburga de Eben",
                      body: "Sirvienta tirolesa, fue despedida de su trabajo por dar a los pobres la comida que se tiraría. Siguió dando de lo poco que tenía.",
                      quote: "Recordada por lo que hacía con las sobras, y por no detenerse cuando eso le costó el empleo."),
                .init(id: "mass", label: "Misa", kicker: "La Misa, parte por parte · 1 de 14", title: "Los Ritos Iniciales",
                      body: "Antes de que se lea o se ofrezca nada, la Iglesia se reúne y admite lo que es.",
                      quote: "Por qué la señal de la cruz viene primero, y qué afirma realmente el saludo."),
            ]
        }
    }

    // MARK: - Life-state questions (dIsLife × 4)

    static func lifeQuestions(for language: AppLanguage) -> [LifeQuestion] {
        switch language {
        case .en:
            [
                .init(id: "life-1", title: "Where are you in your walk of faith?",
                      subtitle: "There's no wrong answer here.",
                      options: [
                        .init(id: "practicing", text: "Practicing, most weeks"),
                        .init(id: "returning", text: "Coming back after time away"),
                        .init(id: "exploring", text: "Exploring Catholicism"),
                        .init(id: "struggling", text: "Practicing, but going through a hard time"),
                      ], multiSelect: false, skippable: false),
                .init(id: "life-2", title: "How often do you get to Mass?",
                      subtitle: "Again, no wrong answer.",
                      options: [
                        .init(id: "weekly", text: "Every Sunday"),
                        .init(id: "monthly", text: "A few times a month"),
                        .init(id: "occasions", text: "Mostly on special occasions"),
                        .init(id: "trying", text: "I'm trying to get back into it"),
                      ], multiSelect: false, skippable: false),
                .init(id: "life-3", title: "What's missing most right now?",
                      subtitle: "Pick as many as fit.",
                      options: [
                        .init(id: "consistency", text: "Consistency"),
                        .init(id: "understanding", text: "Understanding what's happening at Mass"),
                        .init(id: "community", text: "A sense of community"),
                        .init(id: "peace", text: "Peace of mind"),
                      ], multiSelect: true, skippable: false),
                .init(id: "life-4", title: "Your state in life",
                      subtitle: "So we don't assume.",
                      options: [
                        .init(id: "single", text: "Single"),
                        .init(id: "married", text: "Married"),
                        .init(id: "religious", text: "Consecrated / religious life"),
                        .init(id: "prefer-not", text: "I'd rather not say"),
                      ], multiSelect: false, skippable: true),
            ]
        case .pt:
            [
                .init(id: "life-1", title: "Onde você está na sua caminhada de fé?",
                      subtitle: "Não existe resposta errada aqui.",
                      options: [
                        .init(id: "practicing", text: "Praticante, a maioria das semanas"),
                        .init(id: "returning", text: "Voltando depois de um tempo afastado"),
                        .init(id: "exploring", text: "Conhecendo o catolicismo"),
                        .init(id: "struggling", text: "Praticante, mas passando por um momento difícil"),
                      ], multiSelect: false, skippable: false),
                .init(id: "life-2", title: "Com que frequência você vai à Missa?",
                      subtitle: "De novo, não existe resposta errada.",
                      options: [
                        .init(id: "weekly", text: "Todo domingo"),
                        .init(id: "monthly", text: "Algumas vezes por mês"),
                        .init(id: "occasions", text: "Só em ocasiões especiais"),
                        .init(id: "trying", text: "Estou tentando voltar"),
                      ], multiSelect: false, skippable: false),
                .init(id: "life-3", title: "O que mais falta pra você agora?",
                      subtitle: "Escolha quantas fizerem sentido.",
                      options: [
                        .init(id: "consistency", text: "Constância"),
                        .init(id: "understanding", text: "Entender o que acontece na Missa"),
                        .init(id: "community", text: "Um senso de comunidade"),
                        .init(id: "peace", text: "Paz de espírito"),
                      ], multiSelect: true, skippable: false),
                .init(id: "life-4", title: "Seu estado de vida",
                      subtitle: "Pra não presumirmos nada.",
                      options: [
                        .init(id: "single", text: "Solteiro(a)"),
                        .init(id: "married", text: "Casado(a)"),
                        .init(id: "religious", text: "Vida consagrada / religiosa"),
                        .init(id: "prefer-not", text: "Prefiro não dizer"),
                      ], multiSelect: false, skippable: true),
            ]
        case .es:
            [
                .init(id: "life-1", title: "¿Dónde estás en tu camino de fe?",
                      subtitle: "No hay respuesta incorrecta aquí.",
                      options: [
                        .init(id: "practicing", text: "Practicante, la mayoría de las semanas"),
                        .init(id: "returning", text: "Volviendo después de un tiempo alejado"),
                        .init(id: "exploring", text: "Conociendo el catolicismo"),
                        .init(id: "struggling", text: "Practicante, pero pasando un momento difícil"),
                      ], multiSelect: false, skippable: false),
                .init(id: "life-2", title: "¿Con qué frecuencia vas a Misa?",
                      subtitle: "De nuevo, no hay respuesta incorrecta.",
                      options: [
                        .init(id: "weekly", text: "Todos los domingos"),
                        .init(id: "monthly", text: "Algunas veces al mes"),
                        .init(id: "occasions", text: "Solo en ocasiones especiales"),
                        .init(id: "trying", text: "Estoy intentando volver"),
                      ], multiSelect: false, skippable: false),
                .init(id: "life-3", title: "¿Qué es lo que más te falta ahora?",
                      subtitle: "Elige tantas como encajen.",
                      options: [
                        .init(id: "consistency", text: "Constancia"),
                        .init(id: "understanding", text: "Entender lo que pasa en la Misa"),
                        .init(id: "community", text: "Un sentido de comunidad"),
                        .init(id: "peace", text: "Paz mental"),
                      ], multiSelect: true, skippable: false),
                .init(id: "life-4", title: "Tu estado de vida",
                      subtitle: "Para no asumir nada.",
                      options: [
                        .init(id: "single", text: "Soltero/a"),
                        .init(id: "married", text: "Casado/a"),
                        .init(id: "religious", text: "Vida consagrada / religiosa"),
                        .init(id: "prefer-not", text: "Prefiero no decirlo"),
                      ], multiSelect: false, skippable: true),
            ]
        }
    }

    // MARK: - Spiritual check-in questions (dIsSpirit × 4)

    static func spiritualQuestions(for language: AppLanguage) -> [SpiritualQuestion] {
        switch language {
        case .en:
            [
                .init(id: "spirit-1", title: "How has prayer been going lately?",
                      subtitle: "Not a test. Just naming it.",
                      options: [
                        .init(id: "alive", text: "Alive, I feel it"),
                        .init(id: "dry", text: "Dry, but I keep showing up"),
                        .init(id: "absent", text: "Almost nonexistent"),
                        .init(id: "doubtful", text: "Full of doubts"),
                      ]),
                .init(id: "spirit-2", title: "What's weighing on you most right now?",
                      subtitle: "",
                      options: [
                        .init(id: "tired", text: "Tiredness"),
                        .init(id: "fear", text: "Fear about the future"),
                        .init(id: "lonely", text: "Loneliness"),
                        .init(id: "meaningless", text: "A sense that nothing means much"),
                      ]),
                .init(id: "spirit-3", title: "Does any of this describe what you're carrying?",
                      subtitle: "These deserve more than an app — we'll say so if you pick one.",
                      options: [
                        .init(id: "grief", text: "Grief or loss", isCrisisTrigger: true),
                        .init(id: "anger", text: "Anger or resentment", isCrisisTrigger: true),
                        .init(id: "guilt", text: "Guilt", isCrisisTrigger: true),
                        .init(id: "none", text: "None of these"),
                      ]),
                .init(id: "spirit-4", title: "How is your relationship with God today?",
                      subtitle: "",
                      options: [
                        .init(id: "close", text: "Close"),
                        .init(id: "distant-present", text: "Distant, but still there"),
                        .init(id: "confused", text: "Confused"),
                        .init(id: "unsure", text: "I'm not sure God is there"),
                      ]),
            ]
        case .pt:
            [
                .init(id: "spirit-1", title: "Como tem sido sua oração ultimamente?",
                      subtitle: "Não é um teste. É só nomear.",
                      options: [
                        .init(id: "alive", text: "Viva, eu sinto"),
                        .init(id: "dry", text: "Seca, mas eu continuo aparecendo"),
                        .init(id: "absent", text: "Quase inexistente"),
                        .init(id: "doubtful", text: "Cheia de dúvidas"),
                      ]),
                .init(id: "spirit-2", title: "O que mais pesa em você agora?",
                      subtitle: "",
                      options: [
                        .init(id: "tired", text: "Cansaço"),
                        .init(id: "fear", text: "Medo do futuro"),
                        .init(id: "lonely", text: "Solidão"),
                        .init(id: "meaningless", text: "A sensação de que nada faz muito sentido"),
                      ]),
                .init(id: "spirit-3", title: "Alguma dessas descreve o que você carrega?",
                      subtitle: "Isso merece mais que um app — diremos isso se você escolher uma delas.",
                      options: [
                        .init(id: "grief", text: "Luto ou perda", isCrisisTrigger: true),
                        .init(id: "anger", text: "Raiva ou ressentimento", isCrisisTrigger: true),
                        .init(id: "guilt", text: "Culpa", isCrisisTrigger: true),
                        .init(id: "none", text: "Nenhuma dessas"),
                      ]),
                .init(id: "spirit-4", title: "Como está sua relação com Deus hoje?",
                      subtitle: "",
                      options: [
                        .init(id: "close", text: "Próxima"),
                        .init(id: "distant-present", text: "Distante, mas ainda presente"),
                        .init(id: "confused", text: "Confusa"),
                        .init(id: "unsure", text: "Não tenho certeza se Deus está aí"),
                      ]),
            ]
        case .es:
            [
                .init(id: "spirit-1", title: "¿Cómo ha estado tu oración últimamente?",
                      subtitle: "No es una prueba. Solo nombrarlo.",
                      options: [
                        .init(id: "alive", text: "Viva, la siento"),
                        .init(id: "dry", text: "Seca, pero sigo presentándome"),
                        .init(id: "absent", text: "Casi inexistente"),
                        .init(id: "doubtful", text: "Llena de dudas"),
                      ]),
                .init(id: "spirit-2", title: "¿Qué es lo que más te pesa ahora?",
                      subtitle: "",
                      options: [
                        .init(id: "tired", text: "Cansancio"),
                        .init(id: "fear", text: "Miedo al futuro"),
                        .init(id: "lonely", text: "Soledad"),
                        .init(id: "meaningless", text: "La sensación de que nada tiene mucho sentido"),
                      ]),
                .init(id: "spirit-3", title: "¿Alguna de estas describe lo que llevas?",
                      subtitle: "Esto merece más que una app — lo diremos si eliges una de ellas.",
                      options: [
                        .init(id: "grief", text: "Duelo o pérdida", isCrisisTrigger: true),
                        .init(id: "anger", text: "Ira o resentimiento", isCrisisTrigger: true),
                        .init(id: "guilt", text: "Culpa", isCrisisTrigger: true),
                        .init(id: "none", text: "Ninguna de estas"),
                      ]),
                .init(id: "spirit-4", title: "¿Cómo está tu relación con Dios hoy?",
                      subtitle: "",
                      options: [
                        .init(id: "close", text: "Cercana"),
                        .init(id: "distant-present", text: "Distante, pero todavía presente"),
                        .init(id: "confused", text: "Confusa"),
                        .init(id: "unsure", text: "No estoy seguro/a de que Dios esté ahí"),
                      ]),
            ]
        }
    }

    // MARK: - Notification time options (dIs15)

    static func notificationTimes(for language: AppLanguage) -> [(id: String, title: String, subtitle: String, hour: String)] {
        switch language {
        case .en:
            [
                ("morning", "Morning", "Right when the day starts", "7:00 AM"),
                ("midday", "Midday", "A pause, not a start", "12:00 PM"),
                ("evening", "Evening", "Before the day winds down", "8:30 PM"),
            ]
        case .pt:
            [
                ("morning", "Manhã", "Bem quando o dia começa", "7h"),
                ("midday", "Meio-dia", "Uma pausa, não um começo", "12h"),
                ("evening", "Noite", "Antes de o dia se encerrar", "20h30"),
            ]
        case .es:
            [
                ("morning", "Mañana", "Justo cuando empieza el día", "7:00"),
                ("midday", "Mediodía", "Una pausa, no un comienzo", "12:00"),
                ("evening", "Noche", "Antes de que termine el día", "20:30"),
            ]
        }
    }

    // MARK: - Formation-track synthesis steps (dIs14)

    static func planSteps(for language: AppLanguage) -> [(number: Int, title: String, subtitle: String)] {
        switch language {
        case .en:
            [
                (1, "The Mass, part by part", "One short part a day — you're starting at the Penitential Act."),
                (2, "The daily verse and saint", "Free, every day, forever."),
                (3, "The Rosary, guided", "Today's mystery, with a beginner mode and a teaching layer."),
            ]
        case .pt:
            [
                (1, "A Missa, parte por parte", "Uma parte curta por dia — você começa no Ato Penitencial."),
                (2, "A palavra e o santo do dia", "Grátis, todo dia, para sempre."),
                (3, "O Terço, guiado", "O mistério de hoje, com modo iniciante e camada de ensino."),
            ]
        case .es:
            [
                (1, "La Misa, parte por parte", "Una parte corta al día — empiezas en el Acto Penitencial."),
                (2, "El versículo y el santo del día", "Gratis, todos los días, para siempre."),
                (3, "El Rosario, guiado", "El misterio de hoy, con modo principiante y una capa de enseñanza."),
            ]
        }
    }
}
