import SwiftUI

/// The frosted "glass over the color of the day" card used everywhere in the design:
/// translucent white, blurred, thin light border, soft warm shadow.
struct GlassCard<Content: View>: View {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 18
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .background(Color.white.opacity(0.22))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
            )
            .shadow(color: Palette.wine.opacity(0.1), radius: 14, x: 0, y: 8)
    }
}

/// A card filled with the day's liturgical color gradient (the "hero" card treatment
/// used for the word of the day, psalms, and the Compline reading).
struct LiturgicalGradientCard<Content: View>: View {
    var color: LiturgicalColor
    var padding: CGFloat = 18
    var cornerRadius: CGFloat = 18
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .background(color.gradient)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
            )
            .shadow(color: Palette.wine.opacity(0.22), radius: 16, x: 0, y: 10)
    }
}

/// A flat, dashed-border card used for secondary/utility actions
/// (glossary links, hardship waiver note) — a deliberately quieter affordance.
struct DashedUtilityCard<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .background(Color.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                    .foregroundStyle(Palette.ink.opacity(0.28))
            )
    }
}
