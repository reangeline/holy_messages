import WidgetKit
import SwiftUI

struct WordOfDayEntry: TimelineEntry {
    let date: Date
    let word: WidgetContent.WordOfDay
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
                    Text("HOJE")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.5)
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 3) {
                Text("PALAVRA DE HOJE")
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
            Text("Palavra de hoje: \(entry.word.reference)")
        default:
            homeScreenCard
        }
    }

    private var homeScreenCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PALAVRA DE HOJE")
                .font(MissaleFont.body(12, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(Palette.goldBright)

            Rectangle()
                .fill(.white.opacity(0.15))
                .frame(height: 1)

            Text(entry.word.quote)
                .font(MissaleFont.display(22, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(4)
                .minimumScaleFactor(0.7)

            Spacer(minLength: 0)

            Text(entry.word.reference)
                .font(MissaleFont.body(14))
                .foregroundStyle(.white.opacity(0.65))
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct WordOfDayWidget: Widget {
    let kind = "WordOfDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordOfDayProvider()) { entry in
            WordOfDayWidgetView(entry: entry)
                .containerBackground(for: .widget) { WidgetBackground() }
        }
        .configurationDisplayName("Palavra do dia")
        .description("A citação bíblica do dia.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

/// Card fill on the home screen; transparent on the lock screen, where the
/// system already supplies its own vibrancy/blur behind accessory widgets.
struct WidgetBackground: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryCircular, .accessoryRectangular, .accessoryInline:
            Color.clear
        default:
            WidgetContent.cardBackground
        }
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
