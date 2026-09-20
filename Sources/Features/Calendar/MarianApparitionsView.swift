import SwiftUI

/// A compact source-led archive of Marian apparitions. It belongs to Calendar
/// because these are remembered events in the Church's life, while saint
/// profiles remain in the sanctoral archive.
struct MarianApparitionsView: View {
    private let apparitions = MockMarianApparitions.all

    var body: some View {
        ZStack {
            LiturgicalColor.white.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Eyebrow(text: L.string("Marian apparitions", table: "CalendarSaints"))
                    Text("Places of Marian devotion", tableName: "CalendarSaints")
                        .font(MissaleFont.display(29))
                    Text("A small archive sourced from the shrines themselves.", tableName: "CalendarSaints")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.72))

                    ForEach(apparitions) { apparition in
                        NavigationLink {
                            MarianApparitionDetailView(apparition: apparition)
                        } label: {
                            GlassCard {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(Palette.wine)
                                        .frame(width: 24)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(apparition.name)
                                            .font(MissaleFont.body(19, weight: .medium))
                                            .foregroundStyle(Palette.ink)
                                        Text("\(apparition.place) · \(apparition.year)")
                                            .font(MissaleFont.body(14))
                                            .foregroundStyle(Palette.ink.opacity(0.65))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(Palette.wine)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(L.string("Marian apparitions", table: "CalendarSaints"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

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
    NavigationStack { MarianApparitionsView() }
}
