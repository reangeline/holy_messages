import Foundation

struct Saint: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let lifespan: String
    let role: String
    let rank: String // e.g. "Memória", shown as a pill
    let calendarNote: String // e.g. "Calendário próprio · Áustria e Alemanha"
    let bioParagraphs: [String]
    let whyItMattersToday: String
    let prayer: String
}

/// A curated recommendation of saints tied to whatever mood/state the user logged.
struct SaintRecommendation: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let reason: String
}
