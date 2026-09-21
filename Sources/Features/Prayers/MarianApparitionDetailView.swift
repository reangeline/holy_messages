import SwiftUI

/// One apparition: where, who saw it, what the shrine records, and how the
/// Church received it — each with its source, which the reader can open.
///
/// Lives under Prayers because that is where it is reached from: the hub's
/// apparitions section is the list, so this file no longer carries one of its
/// own.
struct MarianApparitionDetailView: View {
    let apparition: MarianApparition

    private var sourceURLs: [URL] {
        apparition.source
            .components(separatedBy: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: ";")))
            .compactMap(URL.init(string:))
            .filter { $0.scheme == "https" || $0.scheme == "http" }
    }

    var body: some View {
        ZStack {
            LiturgicalColor.white.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if apparition.artworkName != nil {
                        SaintPortrait(artworkName: apparition.artworkName, cornerRadius: 16)
                            .frame(height: 200)
                    }

                    Eyebrow(text: apparition.year)
                    Text(apparition.name)
                        .font(MissaleFont.display(30))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            detailRow(label: L.string("Place", table: "CalendarSaints"), value: apparition.place)
                            detailRow(label: L.string("Witnesses", table: "CalendarSaints"), value: apparition.visionaries)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 7) {
                            Eyebrow(text: L.string("What the shrine records", table: "CalendarSaints"))
                            Text(apparition.summary)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                                .lineSpacing(3)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 7) {
                            Eyebrow(text: L.string("Ecclesial reception", table: "CalendarSaints"), color: Palette.goldBright)
                            Text(apparition.ecclesialRecognition)
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.82))
                                .lineSpacing(3)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 9) {
                            Eyebrow(text: L.string("Sources", table: "CalendarSaints"))
                            Text(apparition.source)
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.68))
                                .textSelection(.enabled)
                            ForEach(sourceURLs, id: \.absoluteString) { url in
                                Link(destination: url) {
                                    Label(L.string("Open source", table: "CalendarSaints"), systemImage: "arrow.up.right.square")
                                        .font(MissaleFont.body(15, weight: .medium))
                                        .foregroundStyle(Palette.wine)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.1)
                .foregroundStyle(Palette.ink.opacity(0.55))
            Text(value)
                .font(MissaleFont.body(16, weight: .medium))
                .foregroundStyle(Palette.ink)
        }
    }
}

#Preview {
    NavigationStack {
        MarianApparitionDetailView(apparition: MockMarianApparitions.all[0])
    }
}
