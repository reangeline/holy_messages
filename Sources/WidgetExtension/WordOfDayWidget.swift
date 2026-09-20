import WidgetKit
import SwiftUI

struct WordOfDayEntry: TimelineEntry {
    let date: Date
    let word: WordOfDay
}

struct WordOfDayProvider: TimelineProvider {
    func placeholder(in context: Context) -> WordOfDayEntry {
        WordOfDayEntry(date: .now, word: WidgetContent.wordOfDay)
    }

    func getSnapshot(in context: Context, completion: @escaping (WordOfDayEntry) -> Void) {
        completion(WordOfDayEntry(date: .now, word: WidgetContent.wordOfDay))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WordOfDayEntry>) -> Void) {
        let entry = WordOfDayEntry(date: .now, word: WidgetContent.wordOfDay)
        let midnight = Calendar.current.nextDate(after: .now, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTime) ?? Date().addingTimeInterval(86_400)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

struct WordOfDayWidgetView: View {
    let entry: WordOfDayEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 2) {
                    Image(systemName: "text.quote")
                        .font(.system(size: 16, weight: .medium))
                    Text(L.string("TODAY", table: "Widgets"))
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.5)
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 3) {
                Text(L.string("WORD OF THE DAY", table: "Widgets"))
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.8)
                Text("\u{201C}\(entry.word.quote)\u{201D}")
                    .font(.system(size: 14, weight: .regular, design: .serif))
                    .italic()
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .widgetAccentable()
        case .accessoryInline:
            Text(L.string("Word of the day: {reference}", table: "Widgets").replacingOccurrences(of: "{reference}", with: entry.word.reference))
        default:
            homeScreenCard
        }
    }

    /// No card fill of our own: iOS 17+ always draws its own widget backdrop,
    /// so a "transparent" widget means letting that adaptive system material
    /// show and using semantic text colors, which stay readable in light and
    /// dark mode alike. Gold stays as the one brand accent — goldMuted, not
    /// goldBright, because bright gold disappears on a white backdrop.
    private var homeScreenCard: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(L.string("WORD OF THE DAY", table: "Widgets"))
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.3)
                .foregroundStyle(Palette.goldMuted)

            Text(entry.word.quote)
                .font(MissaleFont.display(quoteSize, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(quoteLines)
                .minimumScaleFactor(0.6)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            Text(entry.word.reference)
                .font(MissaleFont.body(13))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var quoteSize: CGFloat {
        switch family {
        case .systemSmall: 15
        case .systemLarge: 27
        default: 18
        }
    }

    private var quoteLines: Int {
        switch family {
        case .systemSmall: 7
        case .systemLarge: 12
        default: 5
        }
    }
}

struct WordOfDayWidget: Widget {
    let kind = "WordOfDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordOfDayProvider()) { entry in
            WordOfDayWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName(LocalizedStringKey("Word of the day"))
        .description(LocalizedStringKey("The day's Scripture quotation."))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .systemMedium) {
    WordOfDayWidget()
} timeline: {
    WordOfDayEntry(date: .now, word: WidgetContent.wordOfDay)
}

#Preview(as: .accessoryRectangular) {
    WordOfDayWidget()
} timeline: {
    WordOfDayEntry(date: .now, word: WidgetContent.wordOfDay)
}
