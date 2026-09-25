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
    static var directory: URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent("Library/Application Support/Content", isDirectory: true)
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
