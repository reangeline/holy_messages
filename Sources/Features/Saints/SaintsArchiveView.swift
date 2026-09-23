import SwiftUI

/// t4 screen 14 — searchable saints archive/directory.
struct SaintsArchiveView: View {
    @State private var query = ""
    @State private var selectedTab = 0
    /// The first tab is the real current month — it said "September" for
    /// everyone and filtered nothing; the second is the whole archive.
    private var tabs: [String] {
        [DateKeyLabel.month(fromKey: MockLiturgical.today.dateKey), L.string("Search all", table: "CalendarSaints")]
    }

    private var filtered: [SaintOfDay] {
        let mes = String(MockLiturgical.today.dateKey.dropFirst(5).prefix(2))
        let base = selectedTab == 0 && query.isEmpty
            ? MockSaints.archive.filter { $0.dateKey.hasPrefix(mes) }
            : MockSaints.archive
        guard !query.isEmpty else { return base }
        return base.filter {
            $0.saint.name.localizedCaseInsensitiveContains(query)
            || $0.saint.role.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(alignment: .leading, spacing: 14) {
                Text("Saints Archive", tableName: "CalendarSaints")
                    .font(MissaleFont.display(28))
                    .padding(.horizontal, 20)

                HStack(spacing: 8) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, label in
                        Button {
                            selectedTab = index
                        } label: {
                            Text(label)
                                .font(MissaleFont.body(14, weight: .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedTab == index ? Palette.wine : Color.white.opacity(0.45))
                                .foregroundStyle(selectedTab == index ? .white : Palette.ink)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(Palette.ink.opacity(0.5))
                    TextField(L.string("Search by name, date, or cause", table: "CalendarSaints"), text: $query)
                        .font(MissaleFont.body(16))
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 20)

                HStack {
                    Text(L.string("United States", table: "CalendarSaints"))
                        .font(MissaleFont.body(13, weight: .medium))
                    Text(L.string("general Roman calendar + country's own", table: "CalendarSaints"))
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 20)

                List(filtered) { entry in
                    NavigationLink {
                        SaintDetailView(saint: entry.saint)
                    } label: {
                        archiveRow(entry)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .padding(.top, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func archiveRow(_ entry: SaintOfDay) -> some View {
        HStack(spacing: 12) {
            SaintPortrait(artworkName: entry.saint.artworkName, cornerRadius: 8)
                .frame(width: 42, height: 42)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.saint.name).font(MissaleFont.body(17, weight: .medium)).foregroundStyle(Palette.ink)
                HStack {
                    Text(entry.saint.role).font(MissaleFont.body(14)).foregroundStyle(Palette.ink.opacity(0.6))
                    Spacer()
                    Text(DateKeyLabel.dayMonth(fromKey: "\(MockLiturgical.today.dateKey.prefix(4))-" + entry.dateKey))
                        .font(MissaleFont.body(14)).foregroundStyle(Palette.ink.opacity(0.5))
                }
            }
        }
        .contentShape(Rectangle())
        .listRowBackground(Color.clear)
        .padding(.vertical, 4)
    }
}
