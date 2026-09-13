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
                        row(title: "Como rezar o Terço", subtitle: "O objeto, a mecânica, o que fazer com a mente", destination: .howTo)
                        row(title: "Terços rezados", subtitle: "Histórico e novenas em curso", destination: .log)
                        row(title: "Outras orações", subtitle: "Angelus, Misericórdia, Completas, Exame, ladainhas", destination: .others)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 110) // room for the floating glass tab bar
                }
            }
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
            Eyebrow(text: "Prayers")
            Text("Orações")
                .font(MissaleFont.display(28))
            Text("Tudo funciona offline. Uma só tradução em todo o app.")
                .font(MissaleFont.body(14))
                .foregroundStyle(Palette.ink.opacity(0.65))
        }
    }

    private var rosaryTeaserCard: some View {
        let todays = MockRosary.todays
        return NavigationLink(value: PrayersDestination.mysteries) {
            LiturgicalGradientCard(color: .red) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("TERÇO DE HOJE · \(todays.dayLabel.uppercased())")
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(Palette.goldBright)
                    Text("Mistérios \(todays.mysterySet.rawValue)")
                        .font(MissaleFont.display(21, weight: .medium))
                        .foregroundStyle(.white)
                    Text("Guiado, conta a conta · 18 min")
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
