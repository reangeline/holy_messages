import SwiftUI

/// "Today" as the widgets see it.
///
/// A widget extension runs in its own process and its own target, so it can only
/// use what project.yml shares with it — but both the word of the day and the
/// saint now come from the very catalogs the app reads, instead of copies that
/// drifted every time content was imported.
///
/// The one thing still mirrored here is the demo day's `dateKey`: the liturgical
/// engine is not compiled into the widget, and a widget does not need it.
enum WidgetContent {
    static let todayDateKey = "2026-09-14"
    static let todayColor: LiturgicalColor = .red

    /// Resolves through the shared catalog, so widget and app always show the
    /// same verse, in the language the reader chose.
    static var wordOfDay: WordOfDay { MockWordOfDay.wordOfDay(for: todayDateKey) }

    /// Likewise the saint — including the per-language record and, where the
    /// sanctoral has none for this date, the same fallback the app uses.
    static var saintOfDay: Saint {
        MockSaints.saint(on: String(todayDateKey.suffix(5))) ?? MockSaints.notburga
    }
}
