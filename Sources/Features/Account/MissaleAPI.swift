import Foundation

/// The app's only network code, and it talks to two hosts: the Missale API,
/// and the content files the admin page publishes (download only).
///
/// Until the account arrived the app had no network code at all, and
/// `LocalDataTests` enforced that. It now allows this file and no other, so a
/// request can't appear somewhere the privacy policy doesn't describe.
///
/// What goes over the wire: the Apple identity token at sign-in, the session
/// tokens, and — only when the reader taps "Receber orientação" — the text
/// they wrote in that box, which the server passes to Jev and does not keep.
enum MissaleAPI {
    // Debug (local runs, unit and UI tests) talks to the dev stack; Release
    // (TestFlight and the App Store, see .github/workflows/testflight.yml)
    // talks to production. This is the one place to change either URL —
    // there's no scheme or Info.plist setting involved, just this flag.
#if DEBUG
    static let baseURL = URL(string: "https://ule22ss715.execute-api.us-east-1.amazonaws.com")!
    static let contentBaseURL = URL(string: "https://dbwbh4btw116j.cloudfront.net")!
#else
    static let baseURL = URL(string: "https://d64r4fekcj.execute-api.us-east-1.amazonaws.com")!

    /// Where the admin page publishes the app's content (CloudFront). Only
    /// files are fetched from here, never anything of the reader's sent.
    static let contentBaseURL = URL(string: "https://d1fie9m5bh3i4a.cloudfront.net")!
#endif

    /// A published content file (`manifest.json`, `v3/word_of_day/pt.json`…).
    static func contentFile(_ path: String) async throws -> Data {
        let data: Data, response: URLResponse
        do {
            (data, response) = try await session.data(from: contentBaseURL.appending(path: path))
        } catch {
            throw Failure.unavailable
        }
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw Failure.unavailable }
        return data
    }

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

    /// `authorizationCode`, when present, is a fresh Sign in with Apple code
    /// (asked for right before this call) the server exchanges to revoke the
    /// Apple token (guideline 5.1.1(v)). `nil` deletes without it, as before.
    static func deleteAccount(accessToken: String, authorizationCode: String? = nil) async throws {
        let _: Empty = try await send("DELETE", "/v1/account", body: deleteAccountBody(authorizationCode: authorizationCode), bearer: accessToken)
    }

    /// The body `deleteAccount` sends — split out so a unit test can check it
    /// without a network call.
    static func deleteAccountBody(authorizationCode: String?) -> [String: String]? {
        authorizationCode.map { ["authorizationCode": $0] }
    }

    /// Asks Jev, through the Missale API, typed questions about `state` (what
    /// the reader wrote). Returns Jev's answers object, keyed like `questions`.
    /// `questions` values are `["type": ..., "instructions": ..., "criteria": ...]`.
    ///
    /// `free`: only the onboarding's orientação is allowed to spend the
    /// account's lifetime free allowance. No default, so every call site has
    /// to decide — see `decideBody`.
    static func decide(
        state: String, questions: [String: [String: Any]], accessToken: String, subscriptionJWS: String?, free: Bool
    ) async throws -> [String: Any] {
        let body = try JSONSerialization.data(withJSONObject: decideBody(state: state, questions: questions, free: free))
        // Without a subscription, `free: true` spends the account's free
        // allowance (the onboarding's orientação); `free: false` answers 402
        // without spending anything.
        let data = try await sendRaw("POST", "/v1/decisions", body: body, bearer: accessToken,
                                     headers: subscriptionJWS.map { ["X-Subscription": $0] } ?? [:])
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let answers = json["answers"] as? [String: Any]
        else { throw Failure.unavailable }
        return answers
    }

    /// The body `decide` sends — split out so a unit test can check `free`
    /// reaches it without a network call.
    static func decideBody(state: String, questions: [String: [String: Any]], free: Bool) -> [String: Any] {
        ["state": state, "questions": questions, "free": free]
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
        let data = try await sendRaw(method, path, body: body.map { try JSONEncoder().encode($0) }, bearer: bearer)
        if T.self == Empty.self || data.isEmpty, let empty = Empty() as? T { return empty }
        do { return try JSONDecoder().decode(T.self, from: data) } catch { throw Failure.unavailable }
    }

    private static func sendRaw(
        _ method: String, _ path: String, body: Data?, bearer: String?, headers: [String: String] = [:]
    ) async throws -> Data {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = method
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        if let bearer { request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization") }
        for (name, value) in headers { request.setValue(value, forHTTPHeaderField: name) }

        let data: Data, response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw Failure.unavailable
        }
        switch (response as? HTTPURLResponse)?.statusCode ?? 0 {
        case 200..<300: return data
        case 401: throw Failure.unauthorized
        case 402: throw Failure.subscriptionRequired
        case 429: throw Failure.dailyLimit
        default: throw Failure.unavailable
        }
    }
}
