import Foundation

/// The part of MockSaints that needs the mood catalog. It lives apart because
/// MockSaints.swift itself is compiled into the widget extension, and a widget
/// has no business pulling in the Examen's pastoral responses — see project.yml.
extension MockSaints {
    /// Recommendations come from the pastoral responses attached to a state.
    /// Archive resolution removes every name that still lacks a real record and
    /// returns the record in the language currently selected by the person.
    static func saintsForYou(stateID: String, limit: Int = 3) -> [Saint] {
        let candidates = MockMood.saintNames(for: stateID)
        var seen = Set<String>()
        return candidates.compactMap(saint(referencedBy:))
            .filter { seen.insert($0.id).inserted }
            .prefix(limit)
            .map { $0 }
    }
}
