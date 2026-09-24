import Foundation
import Security

/// The signed-in session, in the Keychain rather than UserDefaults: it holds
/// tokens that act for the reader, so it stays encrypted, on this device only
/// (never in a backup or iCloud Keychain), and readable after the first unlock
/// so a background refresh still works.
struct StoredSession: Codable, Equatable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Date
    /// Apple's user identifier, to ask Apple whether the sign-in was revoked.
    var appleUserID: String
}

enum SessionKeychain {
    private static let service = "com.holymessages.app.session"
    private static let account = "missale-api"

    static func load() -> StoredSession? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data
        else { return nil }
        return try? JSONDecoder().decode(StoredSession.self, from: data)
    }

    static func save(_ session: StoredSession) {
        guard let data = try? JSONEncoder().encode(session) else { return }
        let update = [kSecValueData as String: data]
        if SecItemUpdate(baseQuery as CFDictionary, update as CFDictionary) == errSecItemNotFound {
            var add = baseQuery
            add[kSecValueData as String] = data
            add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            SecItemAdd(add as CFDictionary, nil)
        }
    }

    static func clear() {
        SecItemDelete(baseQuery as CFDictionary)
    }

    private static var baseQuery: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: account]
    }
}
