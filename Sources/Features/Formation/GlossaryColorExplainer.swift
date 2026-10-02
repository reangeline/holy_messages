import Foundation

/// The glossary's "Why is today <color>?" copy, one pair per liturgical colour.
/// Keys live in FormationWordOfDay.xcstrings; the colour comes from the day
/// the rest of the app already uses, never a fixed one.
enum GlossaryColorExplainer {
    static func titleKey(for color: LiturgicalColor) -> String {
        switch color {
        case .red: "Why is today red?"
        case .purple: "Why is today purple?"
        case .green: "Why is today green?"
        case .white: "Why is today white?"
        case .rose: "Why is today rose?"
        case .black: "Why is today black?"
        }
    }

    static func explanationKey(for color: LiturgicalColor) -> String {
        switch color {
        case .red: "Red day explanation"
        case .purple: "Purple day explanation"
        case .green: "Green day explanation"
        case .white: "White day explanation"
        case .rose: "Rose day explanation"
        case .black: "Black day explanation"
        }
    }

    static func title(for color: LiturgicalColor) -> String {
        L.string(titleKey(for: color), table: "FormationWordOfDay")
    }

    static func explanation(for color: LiturgicalColor) -> String {
        L.string(explanationKey(for: color), table: "FormationWordOfDay")
    }
}
