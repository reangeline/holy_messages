import Foundation

struct Verse: Codable, Identifiable, Hashable {
    let key: String
    let book: Int
    let bookName: String
    let chapter: Int
    let verse: Int
    let verseText: String
    let language: String
    let topics: [String]
    let weight: Int

    var id: String { key }

    var reference: String { "\(bookName) \(chapter):\(verse)" }

    enum CodingKeys: String, CodingKey {
        case key, book
        case bookName = "book_name"
        case chapter, verse, verseText, language, topics, weight
    }
}
