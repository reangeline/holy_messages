import SwiftUI

/// t4 screen 23 — pick a mystery set, beginner/voice toggles, optional intention, then start.
struct RosaryMysteriesPickerView: View {
    @State private var selected: RosaryMystery = MockRosary.todays
    @State private var beginnerMode = true
    @State private var voiceGuiding = false
    @State private var intention = ""

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Today's Mysteries", tableName: "Prayers")
                            .font(MissaleFont.display(28))
                        // Kept as-is (not localized): mixes today's specific day+mystery
                        // names (content) with an instruction in one hardcoded sentence
                        // that isn't cleanly separable without restructuring into a
                        // dynamic template — judgment call, flagged in my report.
                        Text("Segunda-feira: Gozosos. Pode trocar, se quiser rezar outros.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    VStack(spacing: 10) {
                        ForEach(MockRosary.mysteries) { mystery in
                            mysteryRow(mystery)
                        }
                    }

                    GlassCard {
                        VStack(spacing: 14) {
                            Toggle(L.string( "Beginner mode", table: "Prayers"), isOn: $beginnerMode)
                                .font(MissaleFont.body(16, weight: .medium))
                                .tint(Palette.wine)
                            Divider()
                            Toggle(L.string( "Human voice guiding", table: "Prayers"), isOn: $voiceGuiding)
                                .font(MissaleFont.body(16, weight: .medium))
                                .tint(Palette.wine)
                        }
                    }

                    GlassCard {
                        TextField(L.string( "Intention for this rosary (optional) — \"I prayed for…\"", table: "Prayers"), text: $intention)
                            .font(MissaleFont.body(16))
                    }

                    VStack(spacing: 12) {
                        NavigationLink {
                            RosaryGuidedPrayerView(mystery: selected)
                        } label: {
                            Text("Start", tableName: "Prayers")
                                .font(MissaleFont.body(17, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Palette.wine, in: Capsule())
                                .foregroundStyle(.white)
                        }
                        NavigationLink {
                            RosaryDarkModeView(mystery: selected, startIndex: 0)
                        } label: {
                            Text("Start with the screen off", tableName: "Prayers")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.65))
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func mysteryRow(_ mystery: RosaryMystery) -> some View {
        let isSelected = mystery.id == selected.id
        return Button {
            selected = mystery
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(L.string( "Mysteries", table: "Prayers")) \(mystery.mysterySet.rawValue)")
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(isSelected ? .white : Palette.ink)
                    Text(mystery.dayLabel)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(isSelected ? .white.opacity(0.85) : Palette.ink.opacity(0.6))
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.white)
                }
            }
            .padding(16)
            .background(isSelected ? AnyShapeStyle(Palette.wine) : AnyShapeStyle(.ultraThinMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Color.clear : Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
