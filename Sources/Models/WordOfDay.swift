import Foundation

/// Own file because the widget extension compiles this type too — see the
/// MissaleWidgetsExtension sources in project.yml.
struct WordOfDay: Identifiable, Codable, Hashable {
    let id: String
    let quote: String
    let reference: String
    let translationNote: String // e.g. "Douay-Rheims, domínio público"
    let context: String
}
