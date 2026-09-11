import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let appGroupID = "group.com.holymessages.app"

    func placeholder(in context: Context) -> DailyEntry {
        DailyEntry(date: Date(), verse: "Carregando versículo...", reference: "Holy Messages")
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyEntry>) -> Void) {
        let entry = currentEntry()
        // Re-check periodically; the app also nudges a reload whenever it recomputes the daily verse.
        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date().addingTimeInterval(6 * 3600)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func currentEntry() -> DailyEntry {
        let sharedDefaults = UserDefaults(suiteName: appGroupID)
        let verse = sharedDefaults?.string(forKey: "daily_verse") ?? "Abra o app para ver o versículo de hoje."
        let reference = sharedDefaults?.string(forKey: "daily_verse_ref") ?? "Holy Messages"
        return DailyEntry(date: Date(), verse: verse, reference: reference)
    }
}

struct DailyEntry: TimelineEntry {
    let date: Date
    let verse: String
    let reference: String
}

struct HolyMessagesWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.95, blue: 0.78),
                    Color.white,
                    Color(red: 0.99, green: 0.84, blue: 0.66)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 12) {
                Text(entry.verse)
                    .font(.system(size: 16, weight: .semibold))
                    .italic()
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    .lineLimit(4)

                Divider()

                Text(entry.reference)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
            }
            .padding(16)
        }
    }
}

@main
struct HolyMessagesWidget: Widget {
    let kind = "HolyMessagesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HolyMessagesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Holy Messages")
        .description("Versículo do dia")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    HolyMessagesWidget()
} timeline: {
    DailyEntry(date: .now, verse: "Porque Deus amou o mundo de tal maneira que deu seu Filho unigênito", reference: "João 3:16")
}
