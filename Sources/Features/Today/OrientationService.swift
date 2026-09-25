import Foundation

/// The orientação: what the reader wrote goes to Jev (through the Missale API)
/// and comes back as a choice from the reviewed collection — never generated
/// text. Two questions, as measured in the laya-spike (47/48 states right,
/// 7/8 risk phrases caught, with English instructions over Portuguese text):
///
/// 1. which mood state the text describes, and whether it signals a risk to
///    the reader's life;
/// 2. which of that state's reviewed replies fits the text best.
enum OrientationService {

    struct Result: Equatable {
        /// Nil when Jev wasn't confident: the reader picks the state.
        let stateID: String?
        let reliefIndex: Int?
        let showCrisisFirst: Bool
    }

    /// Below this, the state is the reader's call, not Jev's.
    static let minimumStateConfidence = 0.35
    /// Deliberately low: a false alarm costs one extra screen the reader can
    /// pass; a missed one could cost much more. None of the 48 ordinary test
    /// phrases reached it.
    static let riskThreshold = 0.3

    /// `free`: the onboarding's orientação, which runs on the account's
    /// lifetime allowance when there is no subscription.
    static func orient(_ text: String, free: Bool = false) async throws -> Result {
#if DEBUG
        if let fake = debugFakeResult(for: text) { return fake }
#endif
        let token = try await AccountStore.shared.validAccessToken()
        let jws = await SubscriptionStore.shared.activeSubscriptionJWS()
        if jws == nil && !free { throw MissaleAPI.Failure.subscriptionRequired }
        let localRisk = CrisisPhrases.matches(text)

        let first = try await MissaleAPI.decide(
            state: text,
            questions: [
                "state": ["type": "choice", "instructions": "Which spiritual and emotional state does the person describe?",
                          "criteria": stateCriteria],
                "risk": ["type": "noul", "instructions": "Does the person express a wish, thought or plan to end their own life or harm themselves?"],
            ],
            accessToken: token, subscriptionJWS: jws)

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
        if let variants = MockMood.reliefVariants(for: stateID), variants.count > 1 {
            let criteria = Dictionary(uniqueKeysWithValues: variants.prefix(32).enumerated().map { index, relief in
                (String(index), String("\(relief.title): \(relief.psalmWhy) \(relief.stepBody)".prefix(390)))
            })
            if let second = try? await MissaleAPI.decide(
                state: text,
                questions: ["reply": ["type": "choice",
                                      "instructions": "Which of these reflections would help this person most right now?",
                                      "criteria": criteria]],
                accessToken: token, subscriptionJWS: jws),
               let choice = (second["reply"] as? [String: Any])?["choice"] as? String {
                reliefIndex = Int(choice)
            }
        }
        return Result(stateID: stateID, reliefIndex: reliefIndex, showCrisisFirst: showCrisisFirst)
    }

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
    /// `-fakeOrientation grief` answers without the network, so the UI suite
    /// can walk the whole flow. `crisis` answers with the risk flag up;
    /// `unsure` with no confident state; `offline` fails like no connection.
    private static func debugFakeResult(for text: String) -> Result? {
        guard let fake = UserDefaults.standard
            .volatileDomain(forName: UserDefaults.argumentDomain)["fakeOrientation"] as? String
        else { return nil }
        switch fake {
        case "crisis": return Result(stateID: "grief", reliefIndex: 0, showCrisisFirst: true)
        case "unsure": return Result(stateID: nil, reliefIndex: nil, showCrisisFirst: CrisisPhrases.matches(text))
        default: return Result(stateID: fake, reliefIndex: 0, showCrisisFirst: CrisisPhrases.matches(text))
        }
    }
#endif
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
