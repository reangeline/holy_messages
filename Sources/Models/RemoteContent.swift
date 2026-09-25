import Foundation

/// Content published from the admin page, read from where the app keeps its
/// downloads: the App Group container, so the widget reads the same files.
///
/// Every catalog asks here first and falls back to what ships in the app, so
/// the app is complete without the network and on first launch; a download
/// only ever replaces a list with a newer one. Downloading lives in
/// `RemoteContentUpdater` (app only); this file is compiled into the widget too.
enum RemoteContent {
    static let appGroup = "group.com.holymessages.app"

    /// `Library/Caches` would be purged by the system under pressure and
    /// silently revert the reader to the bundled text; Application Support
    /// inside the group is kept until the app is deleted.
    ///
    /// Without the App Group (an unsigned build, as on CI) the app's own
    /// Application Support is used: the app still updates, only the widget
    /// keeps the bundled text.
    static var directory: URL? {
        if let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) {
            return group.appendingPathComponent("Library/Application Support/Content", isDirectory: true)
        }
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Content", isDirectory: true)
    }

    static func fileURL(collection: String, lang: String) -> URL? {
        directory?.appendingPathComponent(collection, isDirectory: true)
            .appendingPathComponent("\(lang).json")
    }

    /// The published list for `collection` in `language`, or nil when nothing
    /// was downloaded, or it doesn't decode, or it is empty — every one of
    /// which means "use the bundled list".
    static func items<T: Decodable>(_ collection: String, language: AppLanguage, as type: T.Type) -> [T]? {
        guard let url = fileURL(collection: collection, lang: language.rawValue) else { return nil }
        return cache.value(for: url) {
            guard let data = try? Data(contentsOf: url),
                  let list = try? JSONDecoder().decode([T].self, from: data),
                  !list.isEmpty
            else { return nil }
            return list
        }
    }

    // MARK: - Images uploaded in the admin page

    /// Where downloaded images live, next to the content that references them.
    static var imagesDirectory: URL? { directory?.appendingPathComponent("images", isDirectory: true) }

    /// `artworkName` values that point at a downloaded image rather than an
    /// asset in the app bundle.
    static let localImagePrefix = "remote:"

    /// The downloaded file for an image URL published by the admin page
    /// (".../images/<name>"), or nil while it hasn't been downloaded.
    static func localImageFile(forURL url: String) -> URL? {
        guard let name = url.split(separator: "/").last.map(String.init), !name.isEmpty,
              let file = imagesDirectory?.appendingPathComponent(name),
              FileManager.default.fileExists(atPath: file.path)
        else { return nil }
        return file
    }

    /// The `artworkName` for an uploaded image, once downloaded; nil otherwise,
    /// so the caller keeps its bundled art.
    static func artworkName(forURL url: String?) -> String? {
        guard let url, !url.isEmpty, localImageFile(forURL: url) != nil,
              let name = url.split(separator: "/").last
        else { return nil }
        return localImagePrefix + name
    }

    /// Forgets decoded lists after the updater replaces files.
    static func invalidate() { cache.removeAll() }

    private static let cache = DecodedCache()
}

/// Decoded lists, keyed by file, so a catalog read on every render doesn't
/// decode the JSON again. Thread-safe: the widget and background tasks read too.
private final class DecodedCache: @unchecked Sendable {
    private var storage: [URL: Any] = [:]
    private let lock = NSLock()

    func value<T>(for url: URL, load: () -> [T]?) -> [T]? {
        lock.lock()
        defer { lock.unlock() }
        if let hit = storage[url] { return hit as? [T] }
        let loaded = load()
        storage[url] = loaded as Any
        return loaded
    }

    func removeAll() {
        lock.lock()
        storage.removeAll()
        lock.unlock()
    }
}
