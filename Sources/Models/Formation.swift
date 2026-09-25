import Foundation

struct GlossaryTerm: Codable, Hashable {
    let term: String
    let definition: String
}

struct FormationLesson: Identifiable, Codable, Hashable {
    let id: String
    let trackID: String
    let partNumber: Int
    let partsTotal: Int
    let kicker: String
    let title: String
    let bodyParagraphs: [String]
    let quoteText: String?
    let quoteAttribution: String?
    let glossaryTerms: [GlossaryTerm]
}

struct FormationTrack: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let meta: String
    let progress: Double // 0...1
    let nextUp: String
    let lessons: [FormationLesson]
}

struct LiturgicalColorInfo: Identifiable, Codable, Hashable {
    var id: String { color.rawValue }
    let color: LiturgicalColor
}

/// A formation track as the admin page publishes it (without its lessons,
/// which are their own collection).
struct PublishedFormationTrack: Codable, Hashable {
    let id: String
    let title: String
    let meta: String
}

/// A lesson as the admin page publishes it. Its part number and the track's
/// total aren't stored: they come from the lesson's position in the list, so
/// reordering in the admin page renumbers the track.
struct PublishedFormationLesson: Codable, Hashable {
    let id: String
    let trackID: String
    let kicker: String
    let title: String
    let bodyParagraphs: [String]
    var quoteText: String? = nil
    var quoteAttribution: String? = nil
    let glossaryTerms: [GlossaryTerm]

    init(_ lesson: FormationLesson) {
        id = lesson.id
        trackID = lesson.trackID
        kicker = lesson.kicker
        title = lesson.title
        bodyParagraphs = lesson.bodyParagraphs
        quoteText = lesson.quoteText
        quoteAttribution = lesson.quoteAttribution
        glossaryTerms = lesson.glossaryTerms
    }

    /// Rebuilds the tracks the app shows, in the published order. Tracks with
    /// no lessons are left out: a card that opens onto nothing is worse than
    /// no card.
    static func assemble(tracks: [PublishedFormationTrack], lessons: [PublishedFormationLesson]) -> [FormationTrack] {
        tracks.compactMap { track in
            let own = lessons.filter { $0.trackID == track.id }
            guard !own.isEmpty else { return nil }
            return FormationTrack(
                id: track.id, title: track.title, meta: track.meta, progress: 0,
                nextUp: own[0].title,
                lessons: own.enumerated().map { index, l in
                    FormationLesson(
                        id: l.id, trackID: l.trackID, partNumber: index + 1, partsTotal: own.count,
                        kicker: l.kicker, title: l.title, bodyParagraphs: l.bodyParagraphs,
                        quoteText: (l.quoteText?.isEmpty ?? true) ? nil : l.quoteText,
                        quoteAttribution: (l.quoteAttribution?.isEmpty ?? true) ? nil : l.quoteAttribution,
                        glossaryTerms: l.glossaryTerms)
                })
        }
    }
}
