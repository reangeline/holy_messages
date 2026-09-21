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

                ShareCardContent(word: word, day: day)
                    .frame(width: 280, height: 350)
                    .shadow(color: Palette.wine.opacity(0.25), radius: 20, x: 0, y: 14)

                if let renderedImage {
                    ShareLink(
                        item: renderedImage,
                        preview: SharePreview("Palavra do dia · Missale", image: renderedImage)
                    ) {
                        Label("Compartilhar", systemImage: "square.and.arrow.up")
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
            .padding(.top, 40)
        }
        .navigationTitle("Compartilhar")
        .navigationBarTitleDisplayMode(.inline)
        .task { renderShareImage() }
    }

    @MainActor
    private func renderShareImage() {
        let renderer = ImageRenderer(content: ShareCardContent(word: word, day: day).frame(width: 560, height: 700))
        renderer.scale = 3
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

    var body: some View {
        ZStack {
            day.color.gradient
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    CrossGlyph(size: 26, color: Palette.goldBright)
                    Spacer()
                }
                Text("\(day.dayMonthLabel) · \(day.feastName)")
                    .font(MissaleFont.body(12, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Palette.goldBright)
                Spacer()
                Text(word.quote)
                    .font(MissaleFont.display(26, italic: true))
                    .foregroundStyle(.white)
                Text(word.reference)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.85))
                Spacer()
                Text(MockWordOfDay.shareCardWatermark.uppercased())
                    .font(MissaleFont.body(11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(28)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    NavigationStack { ShareCardView() }
}
