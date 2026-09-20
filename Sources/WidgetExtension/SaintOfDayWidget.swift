import WidgetKit
import SwiftUI

struct SaintOfDayEntry: TimelineEntry {
    let date: Date
    let saint: Saint
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
                    Text(L.string("TODAY", table: "Widgets"))
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.5)
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 3) {
                Text(L.string("SAINT OF THE DAY", table: "Widgets"))
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.8)
                Text(entry.saint.name)
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .widgetAccentable()
        case .accessoryInline:
            Text(L.string("Today: {name}", table: "Widgets").replacingOccurrences(of: "{name}", with: entry.saint.name))
        default:
            homeScreenCard
        }
    }

    /// See WordOfDayWidgetView.homeScreenCard — same reasoning: no card fill
    /// of our own, semantic text colors over the system's adaptive backdrop.
    private var homeScreenCard: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(L.string("SAINT OF THE DAY", table: "Widgets"))
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.3)
                .foregroundStyle(Palette.goldMuted)

            Text(entry.saint.name)
                .font(MissaleFont.display(nameSize, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(3)
                .minimumScaleFactor(0.6)
                .fixedSize(horizontal: false, vertical: true)

            Text(entry.saint.role)
                .font(MissaleFont.body(13))
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var nameSize: CGFloat {
        switch family {
        case .systemSmall: 18
        case .systemLarge: 32
        default: 24
        }
    }
}

struct SaintOfDayWidget: Widget {
    let kind = "SaintOfDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SaintOfDayProvider()) { entry in
            SaintOfDayWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName(LocalizedStringKey("Saint of the day"))
        .description(LocalizedStringKey("Who the Church celebrates today."))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
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
