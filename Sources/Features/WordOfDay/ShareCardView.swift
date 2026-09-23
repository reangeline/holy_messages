import SwiftUI

/// t4 screen 17 — Share card generator. Renders `ShareCardContent` to a real UIImage
/// via `ImageRenderer` and shares it through `ShareLink` (the system share sheet also
/// offers "Save Image", so no extra photo-library permission is needed for this pass).
struct ShareCardView: View {
    private let word = MockWordOfDay.today
    private let day = MockLiturgical.today
    @State private var renderedImage: Image?

    var body: some View {
        ZStack {
            day.color.pageBackground
            VStack(spacing: 20) {
                Text("The day's liturgical colour is applied", tableName: "FormationWordOfDay")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.55))

                // Mesmo tamanho na tela e na imagem, só a escala muda: antes a
                // tela usava 280×350 com a mesma letra e cortava o versículo.
                ShareCardContent(word: word, day: day)
                    .frame(width: ShareCardContent.size.width, height: ShareCardContent.size.height)
                    .shadow(color: Palette.wine.opacity(0.25), radius: 20, x: 0, y: 14)

                if let renderedImage {
                    ShareLink(
                        item: renderedImage,
                        preview: SharePreview(L.string("Word of the day · Missale", table: "FormationWordOfDay"), image: renderedImage)
                    ) {
                        Label(L.string("Share", table: "FormationWordOfDay"), systemImage: "square.and.arrow.up")
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(Palette.wine, in: Capsule())
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 24)
        }
        .navigationTitle(L.string("Share", table: "FormationWordOfDay"))
        .navigationBarTitleDisplayMode(.inline)
        .task { renderShareImage() }
    }

    @MainActor
    private func renderShareImage() {
        let renderer = ImageRenderer(content: ShareCardContent(word: word, day: day)
            .frame(width: ShareCardContent.size.width, height: ShareCardContent.size.height))
        renderer.scale = 1080 / ShareCardContent.size.width // 1080 × 1350, o retrato do Instagram
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

/// The visual card itself — kept separate so it can be rendered off-screen at full
/// resolution for sharing while also being displayed on-screen at a smaller size.
private struct ShareCardContent: View {
    let word: WordOfDay
    let day: LiturgicalDay

    /// 4:5, the portrait most feeds show uncropped.
    static let size = CGSize(width: 312, height: 390)

    /// Shorter verses get the big italic; long ones step down instead of
    /// being cut off with "…".
    private var quoteSize: CGFloat {
        switch word.quote.count {
        case ..<90: 25
        case ..<160: 21
        case ..<240: 18
        default: 16
        }
    }

    var body: some View {
        ZStack {
            day.color.gradient
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    CrossGlyph(size: 24, color: Palette.goldBright)
                    Spacer()
                }
                Text("\(day.dayMonthLabel) · \(day.feastName)")
                    .font(MissaleFont.body(12, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Palette.goldBright)
                    .lineLimit(2)
                Spacer(minLength: 8)
                Text("\u{201C}\(word.quote)\u{201D}")
                    .font(MissaleFont.display(quoteSize, italic: true))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                Text(word.reference)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.85))
                Spacer(minLength: 8)
                Text(MockWordOfDay.shareCardWatermark.uppercased())
                    .font(MissaleFont.body(11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(26)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    NavigationStack { ShareCardView() }
}
