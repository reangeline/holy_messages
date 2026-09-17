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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PALAVRA DE HOJE")
                .font(MissaleFont.body(10, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Palette.goldBright)
            Text(entry.word.quote)
                .font(MissaleFont.display(17, italic: true))
                .foregroundStyle(.white)
                .lineLimit(5)
                .minimumScaleFactor(0.75)
            Spacer(minLength: 0)
            Text(entry.word.reference)
                .font(MissaleFont.body(12))
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
