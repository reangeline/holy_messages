import WidgetKit
import SwiftUI

struct SaintOfDayEntry: TimelineEntry {
    let date: Date
    let saint: WidgetContent.SaintOfDay
}

struct SaintOfDayProvider: TimelineProvider {
    func placeholder(in context: Context) -> SaintOfDayEntry {
        SaintOfDayEntry(date: .now, saint: WidgetContent.saintOfDay)
    }

    func getSnapshot(in context: Context, completion: @escaping (SaintOfDayEntry) -> Void) {
        completion(SaintOfDayEntry(date: .now, saint: WidgetContent.saintOfDay))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SaintOfDayEntry>) -> Void) {
        let entry = SaintOfDayEntry(date: .now, saint: WidgetContent.saintOfDay)
        let midnight = Calendar.current.nextDate(after: .now, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTime) ?? Date().addingTimeInterval(86_400)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

struct SaintOfDayWidgetView: View {
    let entry: SaintOfDayEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SANTO DO DIA")
                .font(MissaleFont.body(10, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Palette.goldBright)
            Spacer(minLength: 0)
            Text(entry.saint.name)
                .font(MissaleFont.display(20, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            Text(entry.saint.role)
                .font(MissaleFont.body(13))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct SaintOfDayWidget: Widget {
    let kind = "SaintOfDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SaintOfDayProvider()) { entry in
            SaintOfDayWidgetView(entry: entry)
                .containerBackground(for: .widget) { WidgetContent.todayColor.gradient }
        }
        .configurationDisplayName("Santo do dia")
        .description("Quem a Igreja celebra hoje, direto na tela de início.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SaintOfDayWidget()
} timeline: {
    SaintOfDayEntry(date: .now, saint: WidgetContent.saintOfDay)
}
