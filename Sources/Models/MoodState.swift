import Foundation

/// One tappable "Hoje eu estou…" chip. `isCrisisTrigger` marks the states that
/// should surface the pastoral safety-net screen instead of just relief content
/// (per the design spec: grief/loss, anger/resentment, guilt).
struct MoodStateOption: Identifiable, Codable, Hashable {
    let id: String
    let label: String
    let isCrisisTrigger: Bool

    init(id: String, label: String, isCrisisTrigger: Bool = false) {
        self.id = id
        self.label = label
        self.isCrisisTrigger = isCrisisTrigger
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
    let saintName: String
    let saintWhy: String
    let stepTitle: String
    let stepBody: String
}
