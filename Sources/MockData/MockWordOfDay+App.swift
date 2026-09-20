import Foundation

/// The parts of MockWordOfDay that depend on the rest of the app's mock data.
/// They live apart because MockWordOfDay.swift itself is compiled into the
/// widget extension too, and a widget has no business pulling in the liturgical
/// calendar or the Mass bulletin — see project.yml.
extension MockWordOfDay {
    static var today: WordOfDay { wordOfDay(for: MockLiturgical.today.dateKey) }

    static let shareCardWatermark = "Missale"
}
