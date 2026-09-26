import Foundation

/// Personalization with Jev: from what the reader wrote, choose items from the
/// reviewed collection (a mystery, a reading, a saint). Jev never writes: it
/// only answers "which of these candidates fits this text best".
///
/// Every call carries the risk question, and its answer is combined with the
/// local `CrisisPhrases` into `showCrisisFirst`, as the orientação does.
///
/// Returns nil — and sends nothing — when personalization is off in Settings,
/// when there is no subscription, or when there is no text. On any failure
/// (offline, the server, the daily limit) it returns a result with no choices,
/// so callers only ever fall back to what they did before: never throw, never
/// block the flow waiting on this.
///
/// How the calls are planned, within the server's limits (missale-backend,
/// core/domain/decision.go: ≤ 3 questions, ≤ 32 criteria of ≤ 400 characters,
/// state ≤ 2000, instructions ≤ 300):
/// - each call is the risk question plus at most two picks;
/// - a pick with ≤ 32 candidates is asked directly;
/// - a pick with 33…96 is asked in two rounds: first as two chunk questions,
///   then a final question among the two chunk winners plus the candidates
///   that didn't fit in the chunks (≤ 94), or among three chunk winners (95
///   and 96, whose three chunks take two calls in the first round). Beyond 96
///   the list is cut at 96.
/// - picks that need no chunks fill the free slots, first round first.
/// So one or two picks of ≤ 32 cost one call, and a 65-item pick costs two.
enum JevPicker {

    /// One item Jev may choose. `description` is what Jev reads — English
    /// reads best, as in OrientationService — cut at 400 characters.
    struct Candidate: Equatable {
        let id: String
        let description: String
    }

    /// One question: "which candidate fits the text?". `key` names the answer
    /// in `Result.choices`; it can't be "risk".
    struct Pick: Equatable {
        let key: String
        let instructions: String
        let candidates: [Candidate]
        /// Below this probability the answer is dropped and the caller falls
        /// back. Lower it for long lists, where the probability spreads.
        var minimumConfidence: Double = JevPicker.minimumConfidence
    }

    struct Result: Equatable {
        /// Pick key → chosen candidate id. A pick is missing when Jev wasn't
        /// confident, or its call failed.
        var choices: [String: String]
        var showCrisisFirst: Bool
        /// True once at least one `decide` call actually returned — Jev
        /// answered, confident or not. False when every call failed (offline,
        /// the server, the daily limit): callers that gate on "asked today"
        /// should leave that gate open so the next chance tries again.
        var answered: Bool = true

        subscript(key: String) -> String? { choices[key] }
    }

    /// Same bar as the orientação's state.
    static let minimumConfidence = OrientationService.minimumStateConfidence
    static let riskInstructions = "Does the person express a wish, thought or plan to end their own life or harm themselves?"

    /// The Settings toggle ("Personalizar com o que escrevo"). On by default.
    static let storageKey = "jev_personalization_enabled"

    static var isEnabled: Bool {
        // `bool(forKey:)` also reads "NO"/"0" from a UI test's launch arguments.
        UserDefaults.standard.object(forKey: storageKey) == nil || UserDefaults.standard.bool(forKey: storageKey)
    }

    /// `isEnabled` says the switch is on; this says Jev will actually be asked
    /// — the switch and an active subscription both, the same two things
    /// `pick(from:_:)` requires. Screens on the free support path (the mood
    /// check-in) read this instead of `SubscriptionStore` directly, so their
    /// files stay off `SubscriptionGateTests`' list of files that must never
    /// mention a subscription.
    @MainActor
    static var isActive: Bool { isEnabled && SubscriptionStore.shared.isSubscribed }

    typealias Decide = (_ state: String, _ questions: [String: [String: Any]]) async throws -> [String: Any]

    /// The entry point for features. Nil means "behave as without Jev".
    @MainActor
    static func pick(from text: String, _ picks: [Pick]) async -> Result? {
        guard isEnabled else { return nil }
#if DEBUG
        if let fake = debugFakeResult(for: text, picks) { return fake }
#endif
        guard let jws = await SubscriptionStore.shared.activeSubscriptionJWS() else { return nil }
        return await pick(from: text, picks, enabled: true, subscribed: true) { state, questions in
            let token = try await AccountStore.shared.validAccessToken()
            return try await MissaleAPI.decide(state: state, questions: questions,
                                               accessToken: token, subscriptionJWS: jws)
        }
    }

    /// The same, with the network injected — what the tests drive.
    static func pick(from text: String, _ picks: [Pick], enabled: Bool, subscribed: Bool,
                     decide: Decide) async -> Result? {
        let state = clip(text.trimmingCharacters(in: .whitespacesAndNewlines), to: maxStateChars)
        guard enabled, subscribed, !state.isEmpty else { return nil }
        let picks = picks.map(normalized)
        var risk = CrisisPhrases.matches(text)
        var choices: [String: String] = [:]
        var answered = false

        let rounds = plan(picks.map(\.candidates.count))
        var chunkWinners: [Int: [(id: String, probability: Double)]] = [:]

        for (roundIndex, calls) in rounds.enumerated() {
            for call in calls {
                var questions: [String: [String: Any]] = ["risk": ["type": "noul", "instructions": riskInstructions]]
                var asked: [String: (slot: Slot, criteria: [String: String])] = [:]
                for slot in call {
                    let pick = picks[slot.pick]
                    let criteria = self.criteria(for: slot, pick: pick, chunkWinners: chunkWinners[slot.pick] ?? [])
                    guard criteria.count >= 2 else { continue }
                    let key = slot.questionKey(pick.key)
                    questions[key] = ["type": "choice", "instructions": pick.instructions, "criteria": criteria]
                    asked[key] = (slot, criteria)
                }
                // A final whose finalists shrank to one needs no question.
                if roundIndex > 0 {
                    for slot in call where asked[slot.questionKey(picks[slot.pick].key)] == nil {
                        if let only = chunkWinners[slot.pick]?.first, chunkWinners[slot.pick]?.count == 1,
                           only.probability >= picks[slot.pick].minimumConfidence {
                            choices[picks[slot.pick].key] = only.id
                        }
                    }
                }
                guard !asked.isEmpty, let answers = try? await decide(state, questions) else { continue }
                answered = true

                let riskProbability = ((answers["risk"] as? [String: Any])?["noul"] as? Double) ?? 0
                if riskProbability >= OrientationService.riskThreshold { risk = true }

                for (key, question) in asked {
                    let answer = answers[key] as? [String: Any]
                    guard let id = answer?["choice"] as? String, question.criteria[id] != nil else { continue }
                    let probability = (answer?["probabilities"] as? [String: Double])?[id] ?? 0
                    let pick = picks[question.slot.pick]
                    switch question.slot.kind {
                    case .chunk:
                        chunkWinners[question.slot.pick, default: []].append((id, probability))
                    case .direct, .final:
                        if probability >= pick.minimumConfidence { choices[pick.key] = id }
                    }
                }
            }
        }
        return Result(choices: choices, showCrisisFirst: risk, answered: answered)
    }

    // MARK: - Planning

    static let maxStateChars = 2000
    static let maxCriterionChars = 400
    static let maxCriteria = 32
    static let maxCandidates = 96
    /// Besides the risk question, which every call carries.
    static let picksPerCall = 2

    struct Slot: Equatable {
        enum Kind: Equatable {
            case direct
            /// Candidates `range` of the pick, in the first round.
            case chunk(Range<Int>)
            /// The chunk winners plus candidates `leftover`, in the second.
            case final(leftover: Range<Int>)
        }
        let pick: Int
        let kind: Kind

        func questionKey(_ pickKey: String) -> String {
            switch kind {
            case .direct, .final: pickKey
            case .chunk(let range): "\(pickKey)_\(range.lowerBound)"
            }
        }
    }

    /// Rounds → calls → slots, from each pick's candidate count. The calls of
    /// a round don't depend on each other; the second round needs the first's
    /// chunk winners.
    static func plan(_ counts: [Int]) -> [[[Slot]]] {
        var first: [Slot] = []
        var second: [Slot] = []
        var direct: [Slot] = []
        for (pick, rawCount) in counts.enumerated() {
            let n = min(rawCount, maxCandidates)
            if n < 2 { continue }
            if n <= maxCriteria {
                direct.append(Slot(pick: pick, kind: .direct))
            } else if n <= maxCriteria - 2 + 2 * maxCriteria {
                // Two chunks; what they leave out goes straight to the final,
                // next to the two winners, so it must fit in 30.
                let size = min(maxCriteria, max((n + 2) / 3, (n - (maxCriteria - 2) + 1) / 2))
                first.append(Slot(pick: pick, kind: .chunk(0..<size)))
                first.append(Slot(pick: pick, kind: .chunk(size..<2 * size)))
                second.append(Slot(pick: pick, kind: .final(leftover: 2 * size..<n)))
            } else {
                let size = (n + 2) / 3
                first.append(Slot(pick: pick, kind: .chunk(0..<size)))
                first.append(Slot(pick: pick, kind: .chunk(size..<2 * size)))
                first.append(Slot(pick: pick, kind: .chunk(2 * size..<n)))
                second.append(Slot(pick: pick, kind: .final(leftover: n..<n)))
            }
        }
        // Direct picks fill the free slots — first round, then second — and
        // only then open new calls.
        for slot in direct {
            if first.count % picksPerCall == 0 && second.count % picksPerCall != 0 {
                second.append(slot)
            } else {
                first.append(slot)
            }
        }
        return [first, second].filter { !$0.isEmpty }.map(calls)
    }

    private static func calls(_ slots: [Slot]) -> [[Slot]] {
        stride(from: 0, to: slots.count, by: picksPerCall).map { Array(slots[$0..<min($0 + picksPerCall, slots.count)]) }
    }

    private static func criteria(for slot: Slot, pick: Pick,
                                 chunkWinners: [(id: String, probability: Double)]) -> [String: String] {
        let items: [Candidate]
        switch slot.kind {
        case .direct: items = pick.candidates
        case .chunk(let range): items = Array(pick.candidates[range])
        case .final(let leftover):
            let winners = chunkWinners.compactMap { winner in pick.candidates.first { $0.id == winner.id } }
            items = winners + pick.candidates[leftover]
        }
        return Dictionary(items.map { ($0.id, $0.description) }, uniquingKeysWith: { first, _ in first })
    }

    private static func normalized(_ pick: Pick) -> Pick {
        let candidates = pick.candidates.prefix(maxCandidates).map { candidate in
            let description = clip(candidate.description, to: maxCriterionChars)
            return Candidate(id: candidate.id, description: description.isEmpty ? candidate.id : description)
        }
        return Pick(key: pick.key, instructions: clip(pick.instructions, to: 300),
                    candidates: candidates, minimumConfidence: pick.minimumConfidence)
    }

    /// The server counts Unicode scalars (Go runes), not the characters Swift
    /// counts, so the cut is by scalar.
    static func clip(_ text: String, to limit: Int) -> String {
        guard text.unicodeScalars.count > limit else { return text }
        var scalars = String.UnicodeScalarView()
        scalars.append(contentsOf: text.unicodeScalars.prefix(limit))
        return String(scalars)
    }

#if DEBUG
    /// `-fakeJevPick sorrowful,sorrowful.0` answers without the network, so UI
    /// tests and previews work offline: each pick chooses the first candidate
    /// whose id is in the list, or its first candidate. `crisis` adds the risk
    /// flag; `unsure` answers with no choices (still `answered`); `fail`
    /// simulates every call failing (`answered` false, as offline); `off`
    /// behaves as unsubscribed.
    private static func debugFakeResult(for text: String, _ picks: [Pick]) -> Result? {
        guard let fake = UserDefaults.standard
            .volatileDomain(forName: UserDefaults.argumentDomain)["fakeJevPick"] as? String
        else { return nil }
        let wanted = Set(fake.split(separator: ",").map(String.init))
        if wanted.contains("off") { return nil }
        let risk = wanted.contains("crisis") || CrisisPhrases.matches(text)
        if wanted.contains("fail") { return Result(choices: [:], showCrisisFirst: risk, answered: false) }
        if wanted.contains("unsure") { return Result(choices: [:], showCrisisFirst: risk) }
        var choices: [String: String] = [:]
        for pick in picks {
            choices[pick.key] = pick.candidates.first { wanted.contains($0.id) }?.id ?? pick.candidates.first?.id
        }
        return Result(choices: choices, showCrisisFirst: risk)
    }
#endif
}
