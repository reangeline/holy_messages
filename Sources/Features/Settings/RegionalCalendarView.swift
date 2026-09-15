import SwiftUI

/// t5 screen 4 (fIs4) — the regional/national proper calendar picker, plus the rite
/// form note (ordinary / 1962).
struct RegionalCalendarView: View {
    @State private var search = ""
    @State private var selectedID = MockSettings.regions.first { $0.isSelected }?.id ?? ""

    private var selectedName: String {
        MockSettings.regions.first { $0.id == selectedID }?.name ?? ""
    }

    private var filtered: [RegionOption] {
        search.isEmpty ? MockSettings.regions : MockSettings.regions.filter {
            $0.name.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Liturgical calendar", tableName: "SettingsDetail")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("Each country has its own calendar over the general Roman one. This changes the saint of the day and the solemnities.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    TextField(L.string( "Search country or diocese", table: "SettingsDetail"), text: $search)
                        .font(MissaleFont.body(15))
                        .padding(13)
                        .background(Color.white.opacity(0.42), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))

                    ForEach(filtered) { region in
                        let isSelected = region.id == selectedID
                        Button {
                            selectedID = region.id
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(region.name)
                                        .font(MissaleFont.body(17, weight: .medium))
                                    Text(region.subtitle)
                                        .font(MissaleFont.body(14))
                                        .opacity(0.72)
                                }
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .foregroundStyle(isSelected ? .white : Palette.ink)
                            .padding(14)
                            .background(isSelected ? AnyShapeStyle(Palette.wine) : AnyShapeStyle(.ultraThinMaterial))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }

                    DashedUtilityCard {
                        // Note: dropped the bold-name markdown styling to compose this
                        // cleanly as a localized format string + the (not-mine)
                        // regionalEffectNote content — judgment call, flagged in report.
                        Text("\(L.string("With {region} selected:", table: "SettingsDetail").replacingOccurrences(of: "{region}", with: selectedName)) \(MockSettings.regionalEffectNote)")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.8))
                    }

                    Text(MockSettings.riteFormNote)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.58))
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
