import SwiftUI

/// A saint's portrait: the public-domain artwork when the catalog has one, and
/// the striped placeholder when it doesn't. Most saints have no art yet, and
/// the placeholder says so honestly instead of inventing a face.
struct SaintPortrait: View {
    let artworkName: String?
    var cornerRadius: CGFloat = 12

    var body: some View {
        if let artworkName, !artworkName.isEmpty {
            // Color.clear takes whatever size the parent proposes and the overlay
            // fills it, so the clip happens at the final frame. Clipping the image
            // directly would clip before `.frame` is applied at the call site, and
            // a `.fill` image would spill over its card.
            Color.clear
                .overlay(
                    Image(artworkName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.5), lineWidth: 1)
                )
        } else {
            SaintPortraitPlaceholder(cornerRadius: cornerRadius)
        }
    }
}
