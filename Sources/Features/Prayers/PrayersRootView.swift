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
                        sectionHeader(L.string("Rosary", table: "Prayers"),
                                      subtitle: L.string("Today's mystery, guided", table: "Prayers"))
                        rosaryTeaserCard
                        row(title: L.string( "How to pray the Rosary", table: "Prayers"), subtitle: L.string( "The object, the mechanics, what to do with your mind", table: "Prayers"), destination: .howTo)
                        bibleSection
                        devotionsSection
                        apparitionsSection
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
                case .guided(let mystery, let startDark):
                    if startDark {
                        RosaryDarkModeView(mystery: mystery, startIndex: 0)
                    } else {
                        RosaryGuidedPrayerView(mystery: mystery)
                    }
                case .prayerCategory(let category):
                    PrayerCategoryDetailView(category: category)
                case .apparition(let apparition):
                    MarianApparitionDetailView(apparition: apparition)
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
                    Text(todays.mysterySet.displayTitle)
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

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(MissaleFont.display(21))
            Text(subtitle)
                .font(MissaleFont.body(14))
                .foregroundStyle(Palette.ink.opacity(0.65))
        }
        .padding(.top, 8)
    }

    private var bibleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(L.string("Holy Bible", table: "Bible"),
                          subtitle: L.string("The whole Bible, offline", table: "Bible"))
            NavigationLink {
                BibleHomeView()
            } label: {
                GlassCard {
                    HStack {
                        Image(systemName: "book")
                            .foregroundStyle(Palette.wine)
                        Text("Read the Bible", tableName: "Bible")
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.ink)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Palette.wine)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var devotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(L.string("Devotions", table: "Prayers"),
                          subtitle: L.string("By theme, beyond the Rosary", table: "Prayers"))

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible())], spacing: 10) {
                ForEach(MockDevotionalPrayers.categories) { category in
                    NavigationLink(value: PrayersDestination.prayerCategory(category)) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(category.title)
                                    .font(MissaleFont.body(15, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                                Text(category.prayers.count == 1
                                     ? L.string("one prayer", table: "Prayers")
                                     : L.string("{n} prayers", table: "Prayers")
                                         .replacingOccurrences(of: "{n}", with: "\(category.prayers.count)"))
                                    .font(MissaleFont.body(13))
                                    .foregroundStyle(Palette.ink.opacity(0.55))
                            }
                            // Every card the same height regardless of how many
                            // lines its title wraps to — otherwise the grid
                            // reads as uneven tiles rather than a matched set.
                            .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    /// Marian apparitions, after the Rosary and the devotions. They lived in
    /// Calendar before, on the grounds that they are remembered events; but
    /// what a reader does with a shrine is pray there, so this is where they
    /// are looked for.
    private var apparitionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(L.string("Marian apparitions", table: "Prayers"),
                          subtitle: L.string("Shrines, and how the Church received them", table: "Prayers"))

            ForEach(MockMarianApparitions.all) { apparition in
                NavigationLink(value: PrayersDestination.apparition(apparition)) {
                    GlassCard {
                        HStack(spacing: 12) {
                            SaintPortrait(artworkName: apparition.artworkName, cornerRadius: 10)
                                .frame(width: 54, height: 54)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(apparition.name)
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .foregroundStyle(Palette.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("\(apparition.place) · \(apparition.year)")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.65))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Palette.wine)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
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
    case guided(RosaryMystery, startDark: Bool)
    case prayerCategory(PrayerCategory)
    case apparition(MarianApparition)
}
