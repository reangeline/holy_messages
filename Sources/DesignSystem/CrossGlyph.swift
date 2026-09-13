import SwiftUI

/// The simple line-drawn cross motif reused across prayer/formation screens.
struct CrossGlyph: View {
    var size: CGFloat = 28
    var color: Color = Palette.goldMuted
    var lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: lineWidth / 2)
                .fill(color)
                .frame(width: lineWidth, height: size)
            RoundedRectangle(cornerRadius: lineWidth / 2)
                .fill(color)
                .frame(width: size * 0.62, height: lineWidth)
                .offset(y: -size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

/// Diagonal-stripe placeholder used wherever real saint iconography isn't available yet.
struct SaintPortraitPlaceholder: View {
    var cornerRadius: CGFloat = 12

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                let stripe = size.height / 8
                var y: CGFloat = -size.height
                while y < size.width + size.height {
                    var path = Path()
                    path.move(to: CGPoint(x: y, y: 0))
                    path.addLine(to: CGPoint(x: y + size.height, y: size.height))
                    path.addLine(to: CGPoint(x: y + size.height + stripe, y: size.height))
                    path.addLine(to: CGPoint(x: y + stripe, y: 0))
                    path.closeSubpath()
                    context.fill(path, with: .color(Palette.parchmentDeep.opacity(0.9)))
                    y += stripe * 2
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .background(Palette.parchment.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}
