import SwiftUI

/// "Today" as the widgets see it.
///
/// A widget extension runs in its own process and its own target, so it can only
/// use what project.yml shares with it — but both the word of the day and the
/// saint now come from the very catalogs the app reads, instead of copies that
/// drifted every time content was imported.
///
/// The liturgical engine is not compiled into the widget, so it keys only on
/// the civil date — which is all the word and the saint need.
enum WidgetContent {
    static var todayDateKey: String {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }
    static let todayColor: LiturgicalColor = .red

    /// Resolves through the shared catalog, so widget and app always show the
    /// same verse, in the language the reader chose.
    static var wordOfDay: WordOfDay { MockWordOfDay.wordOfDay(for: todayDateKey) }

    /// Likewise the saint — including the per-language record and, where the
    /// sanctoral has none for this date, the same fallback the app uses.
    static var saintOfDay: Saint {
        MockSaints.saintOfDay(on: String(todayDateKey.suffix(5))).saint
    }
}
