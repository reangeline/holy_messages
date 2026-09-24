import Foundation

/// A whole Bible, bundled as `bible-<id>.json` in Resources/Bibles. Every
/// translation shares this schema, with books keyed by their USFM code (GEN,
/// PSA, JHN…), so a new language is a new file and not new code.
struct Bible: Codable, Identifiable {
    let id, language, name, abbreviation, canon, versification, license, source: String
    let notes: String?
    let missingVerses: Int?
    /// Other public-domain Bibles that fill this one's gaps, by the code a
    /// verse carries in `s` ("RV1909" -> "Reina-Valera 1909").
    let supplements: [String: String]?
    let books: [BibleBook]

    /// The three Bibles planned for the app follow the Vulgate, where the
    /// psalms run one behind the Hebrew numbering most readers know.
    var usesVulgatePsalms: Bool { versification.hasPrefix("vulgate") }
}

struct BibleBook: Codable, Identifiable, Hashable {
    let id, name: String
    let chapters: [BibleChapter]

    /// Matthew opens the New Testament in every Catholic canon.
    static let firstNewTestamentBook = "MAT"

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct BibleChapter: Codable {
    let n: Int
    let verses: [BibleVerse]
}

struct BibleVerse: Codable {
    let n: Int
    let t: String
    /// Set when the verse comes from a supplement, not from this edition.
    let s: String?
}

enum BibleCatalog {
    static let filePrefix = "bible-"

    /// Every Bible in the bundle. Decoding the whole set is several megabytes
    /// of JSON, so it runs once — and should be first touched off the main
    /// thread (see BibleHomeView).
    static let all: [Bible] = (try? loadAll()) ?? []

    static func loadAll(bundle: Bundle = .main) throws -> [Bible] {
        let urls = (bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? [])
            + (bundle.urls(forResourcesWithExtension: "json", subdirectory: "Bibles") ?? [])
        return try urls
            .filter { $0.lastPathComponent.hasPrefix(filePrefix) }
            .map { try JSONDecoder().decode(Bible.self, from: Data(contentsOf: $0)) }
            .sorted { $0.name < $1.name }
    }

    /// The Bible in the reader's language, if the app has one. Never another
    /// language in its place: each language reads its own published translation.
    static func bible(for language: AppLanguage) -> Bible? {
        all.first { $0.language == language.rawValue }
    }
}

/// Vulgate ↔ Hebrew psalm numbers, so a psalm can be shown as "Psalm 22 (23)".
enum PsalmNumbering {
    private struct Table: Decodable {
        struct Row: Decodable {
            let vulgate: Int
            let hebrew: [String]

            /// Whole psalms are numbers (23); the Vulgate's split psalms are
            /// ranges written as text ("116:1-9").
            private enum Keys: String, CodingKey { case vulgate, hebrew }
            private enum Ref: Decodable {
                case number(Int), text(String)
                init(from decoder: Decoder) throws {
                    let c = try decoder.singleValueContainer()
                    if let n = try? c.decode(Int.self) { self = .number(n) } else { self = .text(try c.decode(String.self)) }
                }
                var label: String {
                    switch self {
                    case .number(let n): "\(n)"
                    case .text(let t): t.replacingOccurrences(of: "-", with: "–")
                    }
                }
            }

            init(from decoder: Decoder) throws {
                let c = try decoder.container(keyedBy: Keys.self)
                vulgate = try c.decode(Int.self, forKey: .vulgate)
                hebrew = try c.decode([Ref].self, forKey: .hebrew).map(\.label)
            }
        }
        let psalms: [Row]
    }

    static let vulgateToHebrew: [Int: [String]] = {
        let url = Bundle.main.url(forResource: "psalm-numbering-vulgate-hebrew", withExtension: "json")
            ?? Bundle.main.url(forResource: "psalm-numbering-vulgate-hebrew", withExtension: "json", subdirectory: "Bibles")
        guard let url, let data = try? Data(contentsOf: url),
              let table = try? JSONDecoder().decode(Table.self, from: data) else { return [:] }
        return Dictionary(uniqueKeysWithValues: table.psalms.map { ($0.vulgate, $0.hebrew) })
    }()

    /// "22 (23)", "9 (9–10)", "114 (116:1–9)", or just "1" when both agree.
    static func label(vulgate n: Int) -> String {
        guard let hebrew = vulgateToHebrew[n], hebrew != ["\(n)"] else { return "\(n)" }
        return "\(n) (\(hebrew.joined(separator: "–")))"
    }
}
