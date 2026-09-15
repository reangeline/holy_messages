import SwiftUI

/// t4 screen 22 — Prayers hub. Hub screen (shows the floating tab bar).
struct PrayersRootView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LiturgicalColor.red.pageBackground
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header
                        rosaryTeaserCard
                        row(title: L.string( "How to pray the Rosary", table: "Prayers"), subtitle: L.string( "The object, the mechanics, what to do with your mind", table: "Prayers"), destination: .howTo)
                        row(title: L.string( "Rosaries prayed", table: "Prayers"), subtitle: L.string( "History and novenas in progress", table: "Prayers"), destination: .log)
                        row(title: L.string( "Other prayers", table: "Prayers"), subtitle: L.string( "Angelus, Divine Mercy, Compline, Examen, litanies", table: "Prayers"), destination: .others)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 110) // room for the floating glass tab bar
                }
            }
            .hubTabBarOverlay()
            .navigationDestination(for: PrayersDestination.self) { destination in
                switch destination {
                case .mysteries:
                    RosaryMysteriesPickerView()
                case .howTo:
                    RosaryHowToView()
                case .log:
                    RosaryLogView()
                case .others:
                    OtherPrayersView()
                case .guided(let mystery, let startDark):
                    if startDark {
                        RosaryDarkModeView(mystery: mystery, startIndex: 0)
                    } else {
                        RosaryGuidedPrayerView(mystery: mystery)
                    }
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Eyebrow(text: L.string( "Prayers", table: "Prayers"))
            Text("Prayers", tableName: "Prayers")
                .font(MissaleFont.display(28))
            Text("Everything works offline. One translation across the whole app.", tableName: "Prayers")
                .font(MissaleFont.body(14))
                .foregroundStyle(Palette.ink.opacity(0.65))
        }
    }

    private var rosaryTeaserCard: some View {
        let todays = MockRosary.todays
        return NavigationLink(value: PrayersDestination.mysteries) {
            LiturgicalGradientCard(color: .red) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(L.string( "TODAY'S ROSARY", table: "Prayers")) · \(todays.dayLabel.uppercased())")
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(Palette.goldBright)
                    Text("\(L.string( "Mysteries", table: "Prayers")) \(todays.mysterySet.rawValue)")
                        .font(MissaleFont.display(21, weight: .medium))
                        .foregroundStyle(.white)
                    Text("Guided, bead by bead · 18 min", tableName: "Prayers")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.88))
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func row(title: String, subtitle: String, destination: PrayersDestination) -> some View {
        NavigationLink(value: destination) {
            GlassCard {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.ink)
                        Text(subtitle)
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.65))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Palette.wine)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

enum PrayersDestination: Hashable {
    case mysteries
    case howTo
    case log
    case others
    case guided(RosaryMystery, startDark: Bool)
}
