import SwiftUI

/// A saint's portrait: the public-domain artwork when the catalog has one, and
/// the striped placeholder when it doesn't. Most saints have no art yet, and
/// the placeholder says so honestly instead of inventing a face.
struct SaintPortrait: View {
    let artworkName: String?
    var cornerRadius: CGFloat = 12

    var body: some View {
        if let artworkName, artworkName.hasPrefix(RemoteContent.localImagePrefix),
           let image = DownloadedImages.image(named: String(artworkName.dropFirst(RemoteContent.localImagePrefix.count))) {
            framed(Image(uiImage: image))
        } else if let artworkName, !artworkName.isEmpty, !artworkName.hasPrefix(RemoteContent.localImagePrefix) {
            framed(Image(artworkName))
        } else {
            SaintPortraitPlaceholder(cornerRadius: cornerRadius)
        }
    }

    private func framed(_ image: Image) -> some View {
        Group {
            // Color.clear takes whatever size the parent proposes and the overlay
            // fills it, so the clip happens at the final frame. Clipping the image
            // directly would clip before `.frame` is applied at the call site, and
            // a `.fill` image would spill over its card.
            Color.clear
                .overlay(
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.5), lineWidth: 1)
                )
        }
    }
}

/// Images downloaded from the admin page, decoded once and kept in memory
/// (the saint of the day shows on several screens).
enum DownloadedImages {
    private static let cache = NSCache<NSString, UIImage>()

    static func image(named name: String) -> UIImage? {
        if let hit = cache.object(forKey: name as NSString) { return hit }
        guard let file = RemoteContent.imagesDirectory?.appendingPathComponent(name),
              let image = UIImage(contentsOfFile: file.path)
        else { return nil }
        cache.setObject(image, forKey: name as NSString)
        return image
    }
}
