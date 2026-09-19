import SwiftUI

/// "Today" as the widgets see it. A widget extension runs in its own process and
/// its own target, so it can't reach the app's full mock-data graph — but the
/// word of the day now comes from the very same `MockWordOfDay` catalog the app
/// reads (the file is listed in the widget's sources in project.yml), instead of
/// a second copy that silently drifted every time the catalog grew.
///
/// The saint still has to be duplicated: `MockSaints` pulls in the region-keyed
/// sanctoral calendar and the full `Saint` record, none of which a widget shows.
enum WidgetContent {
    /// The app's fixed demo day. `MockLiturgical.today` is the app-side source of
    /// truth; this mirrors its `dateKey` because the liturgical calendar itself
    /// isn't compiled into the widget.
    static let todayDateKey = "2026-09-14"
    static let todayColor: LiturgicalColor = .red

    /// Resolves through the shared catalog, so the widget and the app always show
    /// the same verse — including the language the reader chose in Settings.
    static var wordOfDay: WordOfDay { MockWordOfDay.wordOfDay(for: todayDateKey) }

    struct SaintOfDay {
        let name: String
        let role: String
    }

    static let saintOfDay = SaintOfDay(name: "Santa Notburga de Eben", role: "Serva, padroeira dos pobres")
}
