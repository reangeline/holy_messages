import SwiftUI

/// Mantém no telefone o hero compacto de 190 pt e, quando há espaço, cresce na
/// proporção das gravuras do acervo. O limite também evita uma coluna larga
/// demais no iPad em paisagem.
struct SaintDetailHeroLayout: Layout {
    static let maximumWidth: CGFloat = 760
    static let minimumHeight: CGFloat = 190
    static let artworkAspectRatio: CGFloat = 1206.0 / 648.0
    static let artworkContentMode: ContentMode = .fit

    static func frame(availableWidth: CGFloat) -> CGSize {
        let width = min(availableWidth, maximumWidth)
        return CGSize(width: width, height: max(minimumHeight, width / artworkAspectRatio))
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        Self.frame(availableWidth: proposal.width ?? Self.maximumWidth)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard let portrait = subviews.first else { return }
        portrait.place(at: bounds.origin, proposal: ProposedViewSize(bounds.size))
    }
}

/// t4 screen 12 — full saint detail page. Standalone and independently navigable
/// (public initializer) so other feature areas (e.g. Today's saint teaser card) can
/// push it directly once wired up: `SaintDetailView(saint: MockSaints.notburga)`.
struct SaintDetailView: View {
    let saint: Saint
    @AppStorage(ReadingTextSize.storageKey) private var textSize = ReadingTextSize.defaultStep

    private var scale: CGFloat { ReadingTextSize.scale(textSize) }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    SaintDetailHeroLayout {
                        SaintPortrait(
                            artworkName: saint.artworkName,
                            cornerRadius: 18,
                            contentMode: SaintDetailHeroLayout.artworkContentMode
                        )
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityIdentifier("saintDetailHero")
                    .frame(maxWidth: .infinity)

                    HStack(spacing: 8) {
                        pill(saint.displayRank, tinted: true)
                        pill(saint.calendarNote, tinted: false)
                    }

                    Text(saint.name)
                        .font(MissaleFont.display(31))
                    Text(saint.lifespan)
                        .font(MissaleFont.body(14, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(Palette.goldDim)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(saint.bioParagraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(MissaleFont.body(17 * scale))
                                .foregroundStyle(Palette.ink.opacity(0.85))
                        }
                    }

                    if !saint.stories.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Eyebrow(text: L.string("Stories and miracles", table: "CalendarSaints"))
                            ForEach(saint.stories, id: \.self) { story in
                                GlassCard {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(story.title)
                                            .font(MissaleFont.display(20 * scale, weight: .medium))
                                        Text(story.body)
                                            .font(MissaleFont.body(16 * scale))
                                            .foregroundStyle(Palette.ink.opacity(0.82))
                                    }
                                }
                            }
                        }
                    }

                    // Both cards are skipped when the record has nothing for them.
                    // Most saints came in with a factual biography and no authored
                    // "why it matters" or prayer yet, and an empty card reads as a
                    // broken screen rather than as content still to come.
                    if !saint.whyItMattersToday.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: L.string("Why it matters today", table: "CalendarSaints"))
                                Text(saint.whyItMattersToday)
                                    .font(MissaleFont.body(16 * scale))
                                    .foregroundStyle(Palette.ink.opacity(0.78))
                            }
                        }
                    }

                    if !saint.prayer.isEmpty {
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: L.string( "Prayer", table: "CalendarSaints"), color: Palette.goldBright)
                                Text(saint.prayer)
                                    .font(MissaleFont.display(20 * scale, italic: true))
                                    .foregroundStyle(.white)
                            }
                        }
                    }

                    // Since the saint of the day became free, this screen is
                    // reachable without a subscription (from Today) — but
                    // browsing other saints still isn't, so the two links
                    // onward gate here rather than at the entry point.
                    GatedLink {
                        SaintsForYouView()
                    } label: {
                        GlassCard {
                            HStack {
                                Text("Saints for what you carry", tableName: "CalendarSaints")
                                    .font(MissaleFont.body(17))
                                    .foregroundStyle(Palette.ink)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ReadingTextSizeButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                GatedLink {
                    SaintsArchiveView()
                } label: {
                    Text(L.string("Archive ›", table: "CalendarSaints"))
                }
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.wine)
            }
        }
    }

    private func pill(_ text: String, tinted: Bool) -> some View {
        Text(text)
            .font(MissaleFont.body(13))
            .tracking(0.5)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(tinted ? Palette.wine.opacity(0.12) : Color.white.opacity(0.45))
            .foregroundStyle(tinted ? Palette.wine : Palette.ink)
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(tinted ? Palette.wine.opacity(0.25) : Color.white.opacity(0.65), lineWidth: 1))
    }
}

#Preview {
    NavigationStack { SaintDetailView(saint: MockSaints.notburga) }
}
