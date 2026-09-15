import SwiftUI

/// t4 screen 14 — searchable saints archive/directory.
struct SaintsArchiveView: View {
    @State private var query = ""
    @State private var selectedTab = 0
    private let tabs = [L.string( "September", table: "CalendarSaints"), L.string( "Search all", table: "CalendarSaints")]

    private var filtered: [(name: String, subtitle: String, date: String)] {
        guard !query.isEmpty else { return MockSaints.archiveList }
        return MockSaints.archiveList.filter { $0.name.localizedCaseInsensitiveContains(query) }
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
                    TextField("Buscar por nome, data ou causa", text: $query)
                        .font(MissaleFont.body(16))
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 20)

                HStack {
                    Text("Estados Unidos")
                        .font(MissaleFont.body(13, weight: .medium))
                    Text("calendário romano geral + próprio do país")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 20)

                List(filtered, id: \.name) { entry in
                    if entry.name == MockSaints.notburga.name {
                        NavigationLink {
                            SaintDetailView(saint: MockSaints.notburga)
                        } label: {
                            archiveRow(entry)
                        }
                    } else {
                        archiveRow(entry)
                            .opacity(0.6)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .padding(.top, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func archiveRow(_ entry: (name: String, subtitle: String, date: String)) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.name).font(MissaleFont.body(17, weight: .medium)).foregroundStyle(Palette.ink)
            HStack {
                Text(entry.subtitle).font(MissaleFont.body(14)).foregroundStyle(Palette.ink.opacity(0.6))
                Spacer()
                Text(entry.date).font(MissaleFont.body(14)).foregroundStyle(Palette.ink.opacity(0.5))
            }
        }
        .listRowBackground(Color.clear)
        .padding(.vertical, 4)
    }
}
