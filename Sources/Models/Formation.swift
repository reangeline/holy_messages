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
