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
                Text("SANTO DO DIA")
                    .font(MissaleFont.body(isSmall ? 11 : 13, weight: .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Palette.goldBright)
                Spacer(minLength: 0)
                Text(entry.saint.name)
                    .font(MissaleFont.display(isSmall ? 22 : 30, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .minimumScaleFactor(0.6)
                Text(entry.saint.role)
                    .font(MissaleFont.body(isSmall ? 14 : 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
            }
            .padding(isSmall ? 14 : 20)
        }
        .padding(8)
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
