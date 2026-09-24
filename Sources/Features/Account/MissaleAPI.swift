import Foundation

/// The app's only network code, and it talks to one host: the Missale API.
///
/// Until the account arrived the app had no network code at all, and
/// `LocalDataTests` enforced that. It now allows this file and no other, so a
/// request can't appear somewhere the privacy policy doesn't describe.
///
/// What goes over the wire: the Apple identity token at sign-in, the session
/// tokens, and nothing the reader wrote.
enum MissaleAPI {
    /// Dev stack for now (TestFlight). Production gets its own URL before the
    /// App Store release.
    static let baseURL = URL(string: "https://ule22ss715.execute-api.us-east-1.amazonaws.com")!

    struct Session: Codable, Equatable {
        let accessToken: String
        let refreshToken: String?
        let expiresIn: Int
    }

    enum Failure: Error, Equatable {
        /// The session is no longer valid; the reader has to sign in again.
        case unauthorized
        case subscriptionRequired
        case dailyLimit
        /// No connection, or the server failed. Worth retrying later.
        case unavailable
    }

    static func signInWithApple(identityToken: String) async throws -> Session {
        try await send("POST", "/v1/auth/apple", body: ["identityToken": identityToken])
    }

    static func refresh(refreshToken: String) async throws -> Session {
        try await send("POST", "/v1/auth/refresh", body: ["refreshToken": refreshToken])
    }

    static func deleteAccount(accessToken: String) async throws {
        let _: Empty = try await send("DELETE", "/v1/account", bearer: accessToken)
    }

    // MARK: - Transport

    private struct Empty: Decodable {}

    private static let session: URLSession = {
        let config = URLSessionConfiguration.ephemeral   // no cookies, no cache on disk
        config.timeoutIntervalForRequest = 20
        return URLSession(configuration: config)
    }()

    private static func send<T: Decodable>(
        _ method: String, _ path: String, body: [String: String]? = nil, bearer: String? = nil
    ) async throws -> T {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = method
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        if let bearer { request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization") }

        let data: Data, response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw Failure.unavailable
        }
        switch (response as? HTTPURLResponse)?.statusCode ?? 0 {
        case 200..<300:
            if T.self == Empty.self || data.isEmpty, let empty = Empty() as? T { return empty }
            do { return try JSONDecoder().decode(T.self, from: data) } catch { throw Failure.unavailable }
        case 401: throw Failure.unauthorized
        case 402: throw Failure.subscriptionRequired
        case 429: throw Failure.dailyLimit
        default: throw Failure.unavailable
        }
    }
}
