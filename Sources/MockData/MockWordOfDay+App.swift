import Foundation

/// The parts of MockWordOfDay that depend on the rest of the app's mock data.
/// They live apart because MockWordOfDay.swift itself is compiled into the
/// widget extension too, and a widget has no business pulling in the liturgical
/// calendar or the Mass bulletin — see project.yml.
extension MockWordOfDay {
    /// Today's word as the reader sees it: chosen for them, or drawn by date
    /// — see `word(for:)` and PersonalizedWordOfDay.
    static var today: WordOfDay { word(for: MockLiturgical.today.dateKey) }

    static let shareCardWatermark = "Missale"
}
