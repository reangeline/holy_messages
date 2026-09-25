import Foundation

/// One tappable "Hoje eu estou…" chip.
/// - `isCrisisTrigger` marks states that pair with the onboarding crisis safety net
///   (grief/loss, anger/resentment, guilt).
/// - `isScrupulosityTrigger` marks states that feed the repeated-question counter:
///   the 1st-2nd time within 14 days, relief content runs with a discreet nudge
///   toward a confessor; the 3rd time within 14 days, the scrupulosity redirect
///   replaces relief outright (see MoodHistoryStore.scrupulosityShouldRedirect).
struct MoodStateOption: Identifiable, Codable, Hashable {
    let id: String
    let label: String
    let isCrisisTrigger: Bool
    let isScrupulosityTrigger: Bool

    init(id: String, label: String, isCrisisTrigger: Bool = false, isScrupulosityTrigger: Bool = false) {
        self.id = id
        self.label = label
        self.isCrisisTrigger = isCrisisTrigger
        self.isScrupulosityTrigger = isScrupulosityTrigger
    }
}

struct MoodStateGroup: Identifiable, Codable, Hashable {
    let id: String
    let label: String
    let items: [MoodStateOption]
}

/// A local-only, optional log entry — never leaves the device.
struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let stateID: String
    let stateLabel: String
    let note: String?
    let date: Date

    init(id: UUID = UUID(), stateID: String, stateLabel: String, note: String? = nil, date: Date = Date()) {
        self.id = id
        self.stateID = stateID
        self.stateLabel = stateLabel
        self.note = note
        self.date = date
    }
}

/// The tailored response shown right after logging a state: a psalm, a saint who
/// carried something similar, and one concrete step. Keyed by MoodStateOption.id.
struct ReliefContent: Codable {
    let title: String
    let psalmRef: String
    let psalmText: String
    let psalmWhy: String
    /// Stable archive identity. Older reviewed entries resolve through
    /// `saintName`; new imported entries should provide this directly.
    var saintID: String? = nil
    let saintName: String
    let saintWhy: String
    let stepTitle: String
    let stepBody: String
}

/// A check-in reply as the admin page publishes it: flat, with the state it
/// answers. The app regroups the list by state, keeping the admin's order —
/// the order matters, since "don't repeat the last one" and the orientação's
/// choice both refer to a reply by its position within its state.
struct PublishedRelief: Codable, Hashable {
    let id: String
    let stateID: String
    let title: String
    let psalmRef: String
    let psalmText: String
    let psalmWhy: String
    var saintID: String? = nil
    let saintName: String
    let saintWhy: String
    let stepTitle: String
    let stepBody: String

    init(id: String, stateID: String, _ r: ReliefContent) {
        self.id = id
        self.stateID = stateID
        title = r.title
        psalmRef = r.psalmRef
        psalmText = r.psalmText
        psalmWhy = r.psalmWhy
        saintID = r.saintID
        saintName = r.saintName
        saintWhy = r.saintWhy
        stepTitle = r.stepTitle
        stepBody = r.stepBody
    }

    var relief: ReliefContent {
        ReliefContent(title: title, psalmRef: psalmRef, psalmText: psalmText, psalmWhy: psalmWhy,
                      saintID: (saintID?.isEmpty ?? true) ? nil : saintID, saintName: saintName,
                      saintWhy: saintWhy, stepTitle: stepTitle, stepBody: stepBody)
    }

    /// Flattens a catalog in the check-in's own state order, numbering each
    /// reply within its state ("grief-01"…), as the admin page's ids.
    static func flatten(_ byState: [String: [ReliefContent]]) -> [PublishedRelief] {
        let order = MockMood.stateGroups.flatMap(\.items).map(\.id)
        let states = order.filter { byState[$0] != nil } + byState.keys.filter { !order.contains($0) }.sorted()
        return states.flatMap { state in
            (byState[state] ?? []).enumerated().map { index, relief in
                PublishedRelief(id: String(format: "%@-%02d", state, index + 1), stateID: state, relief)
            }
        }
    }
}
