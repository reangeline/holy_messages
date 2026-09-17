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

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 2) {
                    Image(systemName: "cross.fill")
                        .font(.system(size: 18, weight: .medium))
                    Text("HOJE")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.5)
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 3) {
                Text("SANTO DO DIA")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.8)
                Text(entry.saint.name)
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .widgetAccentable()
        case .accessoryInline:
            Text("Hoje: \(entry.saint.name)")
        default:
            homeScreenCard
        }
    }

    private var homeScreenCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SANTO DO DIA")
                .font(MissaleFont.body(12, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(Palette.goldBright)

            Rectangle()
                .fill(.white.opacity(0.15))
                .frame(height: 1)

            Spacer(minLength: 0)

            Text(entry.saint.name)
                .font(MissaleFont.display(26, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(3)
                .minimumScaleFactor(0.7)

            Text(entry.saint.role)
                .font(MissaleFont.body(14))
                .foregroundStyle(.white.opacity(0.65))
                .lineLimit(2)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct SaintOfDayWidget: Widget {
    let kind = "SaintOfDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SaintOfDayProvider()) { entry in
            SaintOfDayWidgetView(entry: entry)
                .containerBackground(for: .widget) { WidgetBackground() }
        }
        .configurationDisplayName("Santo do dia")
        .description("Quem a Igreja celebra hoje.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .systemMedium) {
    SaintOfDayWidget()
} timeline: {
    SaintOfDayEntry(date: .now, saint: WidgetContent.saintOfDay)
}

#Preview(as: .accessoryCircular) {
    SaintOfDayWidget()
} timeline: {
    SaintOfDayEntry(date: .now, saint: WidgetContent.saintOfDay)
}
