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

    private var isSmall: Bool { family == .systemSmall }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(.white.opacity(0.4), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: isSmall ? 6 : 10) {
                Text("PALAVRA DE HOJE")
                    .font(MissaleFont.body(isSmall ? 11 : 13, weight: .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Palette.goldBright)
                Text(entry.word.quote)
                    .font(MissaleFont.display(isSmall ? 20 : 27, italic: true))
                    .foregroundStyle(.white)
                    .lineLimit(isSmall ? 5 : 4)
                    .minimumScaleFactor(0.6)
                Spacer(minLength: 0)
                Text(entry.word.reference)
                    .font(MissaleFont.body(isSmall ? 14 : 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(isSmall ? 14 : 20)
        }
        .padding(8)
    }
}

struct WordOfDayWidget: Widget {
    let kind = "WordOfDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordOfDayProvider()) { entry in
            WordOfDayWidgetView(entry: entry)
                .containerBackground(for: .widget) { WidgetContent.todayColor.gradient }
        }
        .configurationDisplayName("Palavra do dia")
        .description("A citação bíblica do dia, direto na tela de início.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    WordOfDayWidget()
} timeline: {
    WordOfDayEntry(date: .now, word: WidgetContent.wordOfDay)
}
