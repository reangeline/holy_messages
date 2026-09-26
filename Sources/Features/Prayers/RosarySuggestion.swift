import Foundation

/// From the Rosary intention, Jev suggests a mystery set and, inside it, the one
/// mystery that fits the intention best — one call: risk + set (4) + mystery (20).
/// The text shown is the catalog's (the title, the fruit, the meditation),
/// never generated. The day's set stays the default: this is only a suggestion.
struct RosarySuggestion: Equatable {
    let mysterySet: MysterySet
    /// Index of the highlighted decade within `mysterySet`, when Jev was
    /// confident about the single mystery too.
    let decadeIndex: Int?

    static let setPick = "set"
    static let mysteryPick = "mystery"

    /// Nil: Jev wasn't asked (personalization off, no subscription, no text).
    /// Otherwise the suggestion may be missing (not confident, offline) while
    /// `showCrisisFirst` still holds.
    @MainActor
    static func suggest(for intention: String) async -> (suggestion: RosarySuggestion?, showCrisisFirst: Bool)? {
        guard let result = await JevPicker.pick(from: intention, picks) else { return nil }
        return (from(result), result.showCrisisFirst)
    }

    /// When the set and the mystery disagree, the set (four clear options)
    /// wins and the highlight is dropped.
    static func from(_ result: JevPicker.Result) -> RosarySuggestion? {
        let mystery = result[mysteryPick].flatMap(parseMysteryID)
        let set = result[setPick].flatMap { id in MysterySet.allCases.first { $0.jevID == id } } ?? mystery?.set
        guard let set else { return nil }
        let decade = mystery?.set == set ? mystery?.index : nil
        return RosarySuggestion(mysterySet: set, decadeIndex: decade)
    }

    static var picks: [JevPicker.Pick] {
        [
            .init(key: setPick,
                  instructions: "Which set of Rosary mysteries best fits the intention this person is praying for?",
                  candidates: MysterySet.allCases.map { .init(id: $0.jevID, description: $0.jevDescription) }),
            .init(key: mysteryPick,
                  instructions: "Which single mystery of the Rosary best fits the intention this person is praying for?",
                  candidates: mysteryCandidates,
                  // Twenty options spread the probability thinner than four.
                  minimumConfidence: 0.25),
        ]
    }

    /// Jev reads English best, so the candidates come from the English catalog
    /// whatever the interface language; the ids are language-free.
    static var mysteryCandidates: [JevPicker.Candidate] {
        MockRosary.mysteryCatalog[.en].flatMap { mystery in
            mystery.decades.enumerated().map { index, decade in
                JevPicker.Candidate(id: "\(mystery.mysterySet.jevID).\(index)",
                                    description: "\(decade.title): \(decade.description) Fruit: \(decade.fruit)")
            }
        }
    }

    static func parseMysteryID(_ id: String) -> (set: MysterySet, index: Int)? {
        let parts = id.split(separator: ".")
        guard parts.count == 2, let index = Int(parts[1]), (0..<5).contains(index),
              let set = MysterySet.allCases.first(where: { $0.jevID == parts[0] }) else { return nil }
        return (set, index)
    }
}

extension MysterySet {
    /// Language-free id for Jev (the rawValue is Portuguese).
    var jevID: String { String(describing: self) }

    /// What each set is traditionally prayed for, as Jev's criterion.
    var jevDescription: String {
        switch self {
        case .joyful: "Joyful Mysteries (Annunciation, Visitation, Nativity, Presentation, Finding in the Temple): new life, pregnancy and children, family, waiting on God, humility, joy and gratitude."
        case .luminous: "Luminous Mysteries (Baptism, Wedding at Cana, Proclamation of the Kingdom, Transfiguration, Eucharist): marriage, vocation and discernment, conversion, renewal of faith, the sacraments."
        case .sorrowful: "Sorrowful Mysteries (Agony in the Garden, Scourging, Crowning with Thorns, Carrying of the Cross, Crucifixion): suffering, illness, anguish, a heavy burden, humiliation, forgiveness."
        case .glorious: "Glorious Mysteries (Resurrection, Ascension, Pentecost, Assumption, Coronation of Mary): the dead and eternal life, hope, strength of the Holy Spirit, perseverance, trust in Mary."
        }
    }
}
