import CryptoKit
import Foundation
import WidgetKit

/// Brings the content published from the admin page to this device.
///
/// The manifest names every published file with its SHA-256; only files whose
/// hash changed are downloaded, each is checked against its hash before it
/// replaces anything, and the manifest is saved last — so an interrupted
/// update leaves the previous content in place, never a half-written one.
enum RemoteContentUpdater {

    struct Manifest: Codable, Equatable {
        struct File: Codable, Equatable {
            let path: String
            let sha256: String
            let count: Int
        }
        let version: Int
        let files: [String: [String: File]]
    }

    private static var running = false

    /// Called when the app comes to the foreground. Quiet on failure: the app
    /// keeps what it has (downloaded or bundled) and tries again next time.
    @MainActor
    static func refresh() async {
        guard !running, let directory = RemoteContent.directory else { return }
        running = true
        defer { running = false }
        do {
            let remote = try JSONDecoder().decode(Manifest.self, from: await MissaleAPI.contentFile("manifest.json"))
            let manifestURL = directory.appendingPathComponent("manifest.json")
            let local = (try? Data(contentsOf: manifestURL)).flatMap { try? JSONDecoder().decode(Manifest.self, from: $0) }
            guard remote.version != local?.version else { return }

            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            for (collection, languages) in remote.files {
                for (lang, file) in languages where local?.files[collection]?[lang]?.sha256 != file.sha256
                    || !FileManager.default.fileExists(atPath: RemoteContent.fileURL(collection: collection, lang: lang)?.path ?? "") {
                    let data = try await MissaleAPI.contentFile(file.path)
                    guard sha256(data) == file.sha256 else { throw MissaleAPI.Failure.unavailable }
                    guard let url = RemoteContent.fileURL(collection: collection, lang: lang) else { continue }
                    try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
                    try data.write(to: url, options: .atomic)
                }
            }
            // A language no longer published goes back to the bundled list.
            for (collection, languages) in local?.files ?? [:] {
                for lang in languages.keys where remote.files[collection]?[lang] == nil {
                    if let url = RemoteContent.fileURL(collection: collection, lang: lang) {
                        try? FileManager.default.removeItem(at: url)
                    }
                }
            }
            try JSONEncoder().encode(remote).write(to: manifestURL, options: .atomic)
            RemoteContent.invalidate()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            // Offline, CloudFront unreachable, or a file that didn't match its
            // hash: nothing was committed, the current content stays.
        }
    }

    static func sha256(_ data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
}
