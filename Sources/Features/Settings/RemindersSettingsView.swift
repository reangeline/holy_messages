import SwiftUI

/// t5 screen 3 (fIs3) — daily reading time + per-prayer reminder toggles, plus the
/// quiet-hours guarantee (nothing during Sunday Mass or 22h-6h).
struct RemindersSettingsView: View {
    @State private var selectedHourID = MockSettings.selectedDailyReadingHourID
    @State private var toggles: [String: Bool] = Dictionary(
        uniqueKeysWithValues: MockSettings.reminders.map { ($0.id, $0.reminderEnabled) }
    )

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Schedules and reminders", tableName: "SettingsDetail")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("At the Church's hours. Each one can be turned off.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string( "Daily reading", table: "SettingsDetail"))
                            Text("The word and saint of the day", tableName: "SettingsDetail")
                                .font(MissaleFont.body(18, weight: .medium))
                            HStack(spacing: 8) {
                                ForEach(MockSettings.dailyReadingHours, id: \.id) { hour in
                                    let isSelected = hour.id == selectedHourID
                                    Button {
                                        selectedHourID = hour.id
                                    } label: {
                                        Text(hour.label)
                                            .font(MissaleFont.body(16))
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 10)
                                            .background(isSelected ? AnyShapeStyle(Palette.wine) : AnyShapeStyle(.ultraThinMaterial))
                                            .foregroundStyle(isSelected ? .white : Palette.ink)
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            Text("One notification a day, in your device's time zone. No nagging if you don't open it.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.66))
                        }
                    }

                    ForEach(MockSettings.reminders) { reminder in
                        GlassCard {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(reminder.title)
                                        .font(MissaleFont.body(18, weight: .medium))
                                    Text(reminder.subtitle)
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.66))
                                }
                                Spacer()
                                Text(reminder.timeLabel)
                                    .font(MissaleFont.display(19))
                                    .foregroundStyle(Palette.wine)
                                Toggle("", isOn: Binding(
                                    get: { toggles[reminder.id] ?? false },
                                    set: { toggles[reminder.id] = $0 }
                                ))
                                .labelsHidden()
                                .tint(Palette.wine)
                            }
                        }
                    }

                    DashedUtilityCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: L.string( "Silence", table: "SettingsDetail"))
                            Text(MockSettings.quietHoursNote)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.8))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
