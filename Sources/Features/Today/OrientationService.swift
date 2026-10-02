import Foundation

/// The orientação: what the reader wrote goes to Jev (through the Missale API)
/// and comes back as a choice from the reviewed collection; only the short
/// reflection under it is written (by Claude, see `reflect`). Two questions,
/// as measured in the laya-spike (47/48 states right, 7/8 risk phrases
/// caught, with English instructions over Portuguese text):
///
/// 1. which mood state the text describes, and whether it signals a risk to
///    the reader's life;
/// 2. in one call with two questions: which of that state's reviewed replies
///    fits the text best ("reply"), and which passage speaks to the reader
///    most ("passage"): a psalm from those replies or a Word of the Day verse
///    linked to the state. One call because each call spends one use.
enum OrientationService {

    struct Result: Equatable {
        /// Nil when Jev wasn't confident: the reader picks the state.
        let stateID: String?
        let reliefIndex: Int?
        /// What the red block shows; nil when the reply wasn't chosen either.
        var passage: OrientationPassage? = nil
        let showCrisisFirst: Bool
    }

    /// Below this, the state is the reader's call, not Jev's.
    static let minimumStateConfidence = 0.35
    /// Deliberately low: a false alarm costs one extra screen the reader can
    /// pass; a missed one could cost much more. None of the 48 ordinary test
    /// phrases reached it.
    static let riskThreshold = 0.3
    /// The passage is chosen among up to 32 candidates, so even a clear winner
    /// has a thin share (same reasoning as `IntentionVerse.minimumConfidence`).
    /// Below this the reply's own psalm is shown, as before the mix.
    static let minimumPassageConfidence = 0.2

    /// `free`: the onboarding's orientação, which runs on the account's
    /// lifetime allowance when there is no subscription.
    /// `context`: the onboarding's questionnaire answers. Jev's `state` carries
    /// them, risk question included (an answer like "Grief or loss" can help
    /// spot a risk); the local crisis check stays on what the reader wrote.
    static func orient(_ text: String, free: Bool = false, context: OnboardingContext = .empty) async throws -> Result {
#if DEBUG
        if let fake = debugFakeResult(for: text) { return fake }
#endif
        let token = try await AccountStore.shared.validAccessToken()
        let jws = await SubscriptionStore.shared.activeSubscriptionJWS()
        if jws == nil && !free { throw MissaleAPI.Failure.subscriptionRequired }
        let localRisk = CrisisPhrases.matches(text)

        let state = context.jevState(for: text)
        let first = try await MissaleAPI.decide(
            state: state,
            questions: [
                "state": ["type": "choice", "instructions": "Which spiritual and emotional state does the person describe?",
                          "criteria": stateCriteria],
                "risk": ["type": "noul", "instructions": riskQuestion],
            ],
            accessToken: token, subscriptionJWS: jws, free: free)

        let risk = ((first["risk"] as? [String: Any])?["noul"] as? Double) ?? 0
        let showCrisisFirst = localRisk || risk >= riskThreshold
        let stateAnswer = first["state"] as? [String: Any]
        let probabilities = stateAnswer?["probabilities"] as? [String: Double] ?? [:]
        guard let stateID = stateAnswer?["choice"] as? String,
              (probabilities[stateID] ?? 0) >= minimumStateConfidence,
              stateCriteria[stateID] != nil
        else {
            return Result(stateID: nil, reliefIndex: nil, showCrisisFirst: showCrisisFirst)
        }

        // The reply is a nice-to-have on top of the state: if this second call
        // fails, the relief screen falls back to its usual draw.
        var reliefIndex: Int?
        var passage: OrientationPassage?
        if let variants = MockMood.reliefVariants(for: stateID), variants.count > 1 {
            let criteria = Dictionary(uniqueKeysWithValues: variants.prefix(32).enumerated().map { index, relief in
                (String(index), String("\(relief.title): \(relief.psalmWhy) \(relief.stepBody)".prefix(390)))
            })
            var questions: [String: [String: Any]] = [
                "reply": ["type": "choice",
                          "instructions": "Which of these reflections would help this person most right now?",
                          "criteria": criteria]]
            let (pool, english) = await MainActor.run { (MockWordOfDay.pool, IntentionVerse.englishPool) }
            let candidates = passageCandidates(stateID: stateID, variants: variants, pool: pool, english: english)
            if let candidates {
                questions["passage"] = ["type": "choice",
                                        "instructions": "Which of these Bible passages would speak most to this person right now?",
                                        "criteria": candidates.criteria]
            }
            if let second = try? await MissaleAPI.decide(
                state: text, questions: questions,
                accessToken: token, subscriptionJWS: jws, free: free),
               let choice = (second["reply"] as? [String: Any])?["choice"] as? String {
                reliefIndex = Int(choice)
                if let reliefIndex, variants.indices.contains(reliefIndex) {
                    passage = chosenPassage(from: second["passage"] as? [String: Any],
                                            verses: candidates?.verses ?? [:], variants: variants, replyIndex: reliefIndex)
                }
            }
        }
        return Result(stateID: stateID, reliefIndex: reliefIndex, passage: passage, showCrisisFirst: showCrisisFirst)
    }

    // MARK: - The passage question

    struct PassageCandidates {
        /// Sent as the question's criteria: "p<reflection index>" and "v<word id>".
        let criteria: [String: String]
        /// The Word of the Day behind each "v…" key.
        let verses: [String: WordOfDay]
    }

    /// The psalms of the state's reflections (one per distinct reference) plus
    /// the Word of the Day verses linked to the state. Nil with fewer than two
    /// candidates: there would be nothing to choose between. At most 32, as
    /// the server accepts; verses are the ones cut.
    static func passageCandidates(stateID: String, variants: [ReliefContent],
                                  pool: [WordOfDay], english: [WordOfDay]) -> PassageCandidates? {
        var criteria: [String: String] = [:]
        var seen = Set<String>()
        for (index, relief) in variants.prefix(32).enumerated() where seen.insert(relief.psalmRef).inserted {
            criteria["p\(index)"] = JevPicker.clip("\(relief.psalmRef): \(relief.psalmText)", to: 390)
        }

        // The mapping is keyed by the English reference; the ids are the
        // current language's pool, whose references differ.
        let wanted = Set(MockWordOfDay.moodStatesByEnglishReference
            .filter { $0.value.contains(stateID) }
            .compactMap { IntentionVerse.signature($0.key) })
        let englishBySignature = Dictionary(english.compactMap { word in IntentionVerse.signature(word.reference).map { ($0, word) } },
                                            uniquingKeysWith: { first, _ in first })
        var verses: [String: WordOfDay] = [:]
        for word in pool {
            guard criteria.count < 32, let signature = IntentionVerse.signature(word.reference),
                  wanted.contains(signature) else { continue }
            let described = englishBySignature[signature] ?? word
            criteria["v\(word.id)"] = JevPicker.clip("\(described.reference): \(described.quote)", to: 390)
            verses[word.id] = word
        }
        return criteria.count >= 2 ? PassageCandidates(criteria: criteria, verses: verses) : nil
    }

    /// The passage to show: the verse or psalm Jev chose when it was confident
    /// enough, otherwise the psalm of the reply's own reflection. `verses` is
    /// keyed by word id (the "v" is dropped from the choice).
    static func chosenPassage(from answer: [String: Any]?, verses: [String: WordOfDay],
                              variants: [ReliefContent], replyIndex: Int) -> OrientationPassage? {
        if let choice = answer?["choice"] as? String,
           ((answer?["probabilities"] as? [String: Double])?[choice] ?? 0) >= minimumPassageConfidence {
            if choice.hasPrefix("v"), let word = verses[String(choice.dropFirst())] {
                return OrientationPassage(verse: word)
            }
            if choice.hasPrefix("p"), let index = Int(choice.dropFirst()), variants.indices.contains(index) {
                // Candidates are deduplicated by psalm: when the reply quotes the
                // same one, its own "why" is the one written for this reply.
                let sameAsReply = variants.indices.contains(replyIndex)
                    && variants[replyIndex].psalmRef == variants[index].psalmRef
                return OrientationPassage(psalmOf: variants[sameAsReply ? replyIndex : index])
            }
        }
        return variants.indices.contains(replyIndex) ? OrientationPassage(psalmOf: variants[replyIndex]) : nil
    }

    typealias Reflect = (_ body: [String: Any]) async throws -> String

    /// The short reflection, in the voice of a priest, about the passage shown
    /// (`passage`, else the psalm of `relief`) and the saint of `relief`. Nil —
    /// and nothing sent — when the orientação fell into the crisis flow (that
    /// one has its own, `reflectInCrisis`), and on any failure (offline, 402, 429, 502, 503):
    /// the reflection is an extra, so callers only ever show it or don't. It is
    /// never saved; the screen keeps it in memory while it is open.
    static func reflect(on text: String, relief: ReliefContent, passage: OrientationPassage? = nil,
                        showCrisisFirst: Bool, free: Bool, context: String? = nil,
                        language: AppLanguage = AppLanguagePreference.resolveCurrent(),
                        send: Reflect) async -> String? {
        let state = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !showCrisisFirst, !state.isEmpty else { return nil }
        let shown = passage ?? OrientationPassage(psalmOf: relief)
        let body = MissaleAPI.reflectionBody(
            state: state, reference: shown.reference, passage: shown.text,
            saint: relief.saintName, summary: relief.saintWhy, language: language.rawValue, free: free,
            context: context)
        guard let reflection = try? await send(body) else { return nil }
        let trimmed = reflection.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    /// The same, through the Missale API. Callers only get here outside the
    /// crisis flow.
    static func reflect(on text: String, relief: ReliefContent, passage: OrientationPassage? = nil, free: Bool,
                        context: String? = nil) async -> String? {
#if DEBUG
        if let fake = debugFakeReflection { return fake.isEmpty ? nil : fake }
#endif
        guard let token = try? await AccountStore.shared.validAccessToken() else { return nil }
        let jws = await SubscriptionStore.shared.activeSubscriptionJWS()
        if jws == nil && !free { return nil }
        return await reflect(on: text, relief: relief, passage: passage, showCrisisFirst: false, free: free, context: context) { body in
            try await MissaleAPI.reflect(body: body, accessToken: token, subscriptionJWS: jws)
        }
    }

    /// The reflection of the crisis flow: about God, support and a priest at a
    /// nearby parish. `passage` and `saint` go along only when there are some:
    /// `stateID` and `reliefIndex` (what Jev chose) give the saint and, unless
    /// `passage` is given, the psalm. Nil on any failure or empty answer; the
    /// crisis screen then simply has no card. Never saved.
    static func reflectInCrisis(on text: String, stateID: String? = nil, reliefIndex: Int? = nil,
                                passage: OrientationPassage? = nil, free: Bool, context: String? = nil,
                                language: AppLanguage = AppLanguagePreference.resolveCurrent(),
                                send: Reflect) async -> String? {
        let state = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !state.isEmpty else { return nil }
        let relief = stateID.flatMap { MockMood.reliefVariants(for: $0) }
            .flatMap { variants in reliefIndex.flatMap { variants.indices.contains($0) ? variants[$0] : nil } }
        let shown = passage ?? relief.map { OrientationPassage(psalmOf: $0) }
        let body = MissaleAPI.reflectionBody(
            state: state, reference: shown?.reference, passage: shown?.text,
            saint: relief?.saintName, summary: relief?.saintWhy,
            language: language.rawValue, free: free, context: context, crisis: true)
        guard let reflection = try? await send(body) else { return nil }
        let trimmed = reflection.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    /// The same, through the Missale API.
    static func reflectInCrisis(on text: String, stateID: String?, reliefIndex: Int?, passage: OrientationPassage?,
                                free: Bool, context: String? = nil) async -> String? {
#if DEBUG
        if let fake = debugFakeReflection { return fake.isEmpty ? nil : fake }
#endif
        guard let token = try? await AccountStore.shared.validAccessToken() else { return nil }
        let jws = await SubscriptionStore.shared.activeSubscriptionJWS()
        if jws == nil && !free { return nil }
        return await reflectInCrisis(on: text, stateID: stateID, reliefIndex: reliefIndex, passage: passage,
                                     free: free, context: context) { body in
            try await MissaleAPI.reflect(body: body, accessToken: token, subscriptionJWS: jws)
        }
    }

    /// The risk question as measured in the laya-spike; always asked as is.
    static let riskQuestion = "Does the person express a wish, thought or plan to end their own life or harm themselves?"

    /// Jev reads English instructions best; the reader's text stays as written.
    static let stateCriteria: [String: String] = [
        "peace": "At peace: inner calm, serenity",
        "grateful": "Grateful: thankful for something received",
        "joyful": "Joyful: happy, something good happened",
        "hopeful": "Hopeful: trusting the future will get better",
        "forgiven": "Forgiven: relief after confession or reconciliation",
        "loved": "Loved: feeling loved by God or by people",
        "steadfast": "Steadfast: persevering, firmly deciding to keep the faith",
        "empty": "Empty: no meaning, apathy, nothing is enjoyable",
        "anxious": "Anxious: worry, fear of what will happen",
        "guilty": "Guilty: remorse, weight of a sin or mistake",
        "grief": "Grieving: death or loss of a loved one",
        "lonely": "Lonely: loneliness, isolation, nobody around",
        "angry": "Angry: anger, resentment, hurt by someone",
        "dryness": "Dry in prayer: prayer feels empty, God seems distant",
        "doubtful": "Doubtful: doubts about faith or God",
        "tired": "Tired: exhaustion, overload, no energy",
    ]

#if DEBUG
    /// `-fakeReflection "texto"` answers the reflection without the network;
    /// an empty value behaves as a failure.
    private static var debugFakeReflection: String? {
        UserDefaults.standard.volatileDomain(forName: UserDefaults.argumentDomain)["fakeReflection"] as? String
    }

    /// `-fakeOrientation grief` answers without the network, so the UI suite
    /// can walk the whole flow. `crisis` answers with the risk flag up;
    /// `unsure` with no confident state; `offline` fails like no connection.
    /// `-fakePassage <word id>` also shows that Word of the Day verse.
    private static func debugFakeResult(for text: String) -> Result? {
        guard let fake = UserDefaults.standard
            .volatileDomain(forName: UserDefaults.argumentDomain)["fakeOrientation"] as? String
        else { return nil }
        let verseID = UserDefaults.standard.volatileDomain(forName: UserDefaults.argumentDomain)["fakePassage"] as? String
        let verse = verseID.flatMap { id in MockWordOfDay.pool.first { $0.id == id } }.map(OrientationPassage.init(verse:))
        switch fake {
        case "crisis": return Result(stateID: "grief", reliefIndex: 0, passage: verse, showCrisisFirst: true)
        case "unsure": return Result(stateID: nil, reliefIndex: nil, showCrisisFirst: CrisisPhrases.matches(text))
        default: return Result(stateID: fake, reliefIndex: 0, passage: verse, showCrisisFirst: CrisisPhrases.matches(text))
        }
    }
#endif
}

/// What the red block of the relief shows: a psalm from one of the state's
/// reflections, or a Word of the Day verse. Never saved; it lives as long as
/// the screen (only the reflection's index goes to the mood history).
struct OrientationPassage: Equatable {
    let reference: String
    let text: String
    let why: String

    init(reference: String, text: String, why: String) {
        self.reference = reference; self.text = text; self.why = why
    }

    init(psalmOf relief: ReliefContent) {
        self.init(reference: relief.psalmRef, text: relief.psalmText, why: relief.psalmWhy)
    }

    init(verse: WordOfDay) {
        self.init(reference: verse.reference, text: verse.quote, why: verse.context)
    }
}

/// A reviewed list of expressions that open the crisis guidance by themselves,
/// with or without the network — Jev caught 7 of 8 risk phrases in testing,
/// and 7 of 8 is not enough to be the only net.
///
/// Matching ignores case and accents. A false alarm ("quero morrer de rir")
/// costs one screen the reader can pass; that trade is intended.
enum CrisisPhrases {
    static let phrases = [
        // pt
        "me matar", "suicid", "tirar a minha vida", "tirar minha vida", "tirar a propria vida",
        "acabar com tudo", "acabar com a minha vida", "nao quero mais viver", "nao aguento mais viver",
        "quero morrer", "queria morrer", "dormir e nao acordar", "me cortar", "me corto",
        "sumir para sempre", "ficaria melhor sem mim", "cartas de despedida", "separei os remedios",
        // en
        "kill myself", "end my life", "want to die", "wish i was dead", "cut myself", "self harm",
        "better off without me", "don't want to live", "dont want to live", "do not want to live",
        // es
        "matarme", "quitarme la vida", "no quiero vivir", "quiero morir", "cortarme",
        "mejor sin mi", "acabar con todo",
    ]

    static func matches(_ text: String) -> Bool {
        let normalized = text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .replacingOccurrences(of: "-", with: " ")
        return phrases.contains { normalized.contains($0) }
    }
}
