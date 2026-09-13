import SwiftUI

/// t4 screen 28 — other prayers list, each with an optional reminder toggle.
struct OtherPrayersView: View {
    @State private var reminders: [String: Bool]

    init() {
        var initial: [String: Bool] = [:]
        for prayer in MockRosary.otherPrayers {
            initial[prayer.id] = prayer.reminderEnabled
        }
        _reminders = State(initialValue: initial)
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Outras orações")
                            .font(MissaleFont.display(28))
                        Text("Nos horários da Igreja. O lembrete é opcional em cada uma.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    VStack(spacing: 10) {
                        ForEach(MockRosary.otherPrayers) { prayer in
                            GlassCard {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(prayer.title)
                                            .font(MissaleFont.body(17, weight: .medium))
                                            .foregroundStyle(Palette.ink)
                                        Text(prayer.subtitle)
                                            .font(MissaleFont.body(14))
                                            .foregroundStyle(Palette.ink.opacity(0.65))
                                        Text(prayer.timeLabel)
                                            .font(MissaleFont.display(15, italic: true))
                                            .foregroundStyle(Palette.wine)
                                    }
                                    Spacer()
                                    Toggle("", isOn: Binding(
                                        get: { reminders[prayer.id] ?? false },
                                        set: { reminders[prayer.id] = $0 }
                                    ))
                                    .labelsHidden()
                                    .tint(Palette.wine)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
