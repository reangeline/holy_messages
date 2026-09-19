import Foundation

enum MockWordOfDay {
    /// The pool a day's word is drawn from — one catalog per language, grown
    /// over time via the Acervo tool. See LocalizedCatalog.
    static var pool: [WordOfDay] { catalog.current }

    static let catalog = LocalizedCatalog(pt: ptPool, en: enPool)

    private static let ptPool: [WordOfDay] = [
        .init(
            id: "joao-3-14",
            quote: "Como Moisés levantou a serpente no deserto, assim deve ser levantado o Filho do Homem, para que todo o que nele crer tenha a vida eterna.",
            reference: "João 3, 14-15",
            translationNote: "Douay-Rheims, domínio público",
            context: "Jesus fala de noite, a um fariseu, e cita um episódio do deserto: uma serpente de bronze erguida num poste, que curava quem olhasse para ela. O verbo \"levantado\" é o mesmo que se usará para a crucificação. É por isso que este texto se lê hoje: a Cruz não é um acidente no fim da história, é o sinal erguido para ser olhado."
        ),
    ]

    /// English uses the Douay-Rheims wording — public domain, and already the
    /// translation this app cites for English-language scripture.
    private static let enPool: [WordOfDay] = [
        .init(
            id: "joao-3-14",
            quote: "And as Moses lifted up the serpent in the desert, so must the Son of man be lifted up: that whosoever believeth in him may not perish, but may have life everlasting.",
            reference: "John 3:14-15",
            translationNote: "Douay-Rheims, public domain",
            context: "Jesus is speaking at night, to a Pharisee, and he cites an episode from the desert: a bronze serpent raised on a pole, which healed whoever looked at it. The verb \"lifted up\" is the same one that will be used for the crucifixion. That is why this text is read today: the Cross is not an accident at the end of the story, it is the sign raised up to be looked at."
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

    static var today: WordOfDay { wordOfDay(for: MockLiturgical.today.dateKey) }

    static let massReadings: [MassReading] = [
        .init(id: "1", kicker: "Primeira leitura", title: "Números 21, 4b-9", summary: "A serpente de bronze no deserto — o sinal que cura quem olha para ele, prefigurando a Cruz."),
        .init(id: "2", kicker: "Salmo responsorial", title: "Salmo 77 (78)", summary: "\"Não esqueçais as obras do Senhor\" — a memória como forma de fidelidade."),
        .init(id: "3", kicker: "Segunda leitura", title: "Filipenses 2, 6-11", summary: "O hino da kenosis: Cristo se esvaziou até a morte de cruz, por isso Deus o exaltou."),
        .init(id: "4", kicker: "Evangelho", title: "João 3, 13-17", summary: "\"Deus amou o mundo de tal maneira que deu o seu Filho unigênito\" — o versículo mais citado da Escritura, no contexto da Cruz."),
    ]

    static let massReadingsFootnote = "Texto integral das leituras sob licença da conferência episcopal. Aqui aparecem a referência e o resumo autoral; o texto completo abre no lecionário licenciado."

    static let shareCardWatermark = "Missale"
}
