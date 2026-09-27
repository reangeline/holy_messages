import XCTest
@testable import Missale

/// The privacy policy describes this app from `LocalData`, so the list there
/// has to be the truth: these tests fail when a new persisted key appears
/// without being listed, when a listed key disappears from the code, and when
/// networking shows up anywhere but the Missale API client.
///
/// There is nothing here about a wipe: the delete button and the export beside
/// it are deferred, and the policy says deleting the app is what removes the
/// data. When the button returns, its test belongs here.
final class LocalDataTests: XCTestCase {

    /// Every key the app writes, found by reading the sources rather than by
    /// remembering them.
    private func chavesNoCodigo() throws -> Set<String> {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        var encontradas: Set<String> = []
        let padroes = [
            #"@AppStorage\("([^"]+)"\)"#,
            #"storageKey:\s*"([^"]+)""#,
            #"(?:storageKey|orderKey|lastReliefIndexKey)\s*=\s*"([^"]+)""#,
            // Exclui valores em forma de data: `WidgetContent.todayDateKey`
            // é o dia de demonstração do widget, não uma chave de gravação.
            #"static let \w*[Kk]ey\s*=\s*"(?!\d{4}-\d{2}-\d{2}")([^"]+)""#,
        ]
        guard let caminhos = FileManager.default.enumerator(
            at: raiz.appendingPathComponent("Sources"), includingPropertiesForKeys: nil) else { return [] }
        for caso in caminhos {
            guard let url = caso as? URL, url.pathExtension == "swift" else { continue }
            let fonte = try String(contentsOf: url, encoding: .utf8)
            for padrao in padroes {
                let re = try NSRegularExpression(pattern: padrao)
                let ns = fonte as NSString
                for m in re.matches(in: fonte, range: NSRange(location: 0, length: ns.length)) {
                    encontradas.insert(ns.substring(with: m.range(at: 1)))
                }
            }
        }
        return encontradas
    }

    /// Keys that are deliberately outside both lists.
    private let foraDeEscopo: Set<String> = [
        "openScreen",   // só em DEBUG, argumento de lançamento dos testes de UI
        "settings",     // o valor que openScreen aceita, não uma chave
    ]

    func testEveryPersistedKeyIsAccountedFor() throws {
        let noCodigo = try chavesNoCodigo()
        XCTAssertGreaterThan(noCodigo.count, 8, "não achei as chaves em \(noCodigo)")

        let listadas = Set(LocalData.personalKeys + LocalData.preferenceKeys).union(foraDeEscopo)
        let naoListadas = noCodigo.subtracting(listadas)
        XCTAssertTrue(
            naoListadas.isEmpty,
            "chave persistida fora de LocalData (e portanto fora da política de privacidade): \(naoListadas.sorted())"
        )
    }

    /// And nothing listed may have disappeared from the code, or the policy
    /// describes storage the app no longer has.
    func testNothingListedIsGone() throws {
        let noCodigo = try chavesNoCodigo()
        let sobrando = Set(LocalData.personalKeys + LocalData.preferenceKeys).subtracting(noCodigo)
        XCTAssertTrue(sobrando.isEmpty, "listada em LocalData mas ausente do código: \(sobrando.sorted())")
    }



    /// The claim the policy rests on: the only network code is the Missale API
    /// client (account and orientação), and it talks to one host. Anything
    /// that reaches the network from another file is outside the policy.
    func testOnlyTheMissaleAPIClientUsesTheNetwork() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        var ofensores: [String] = []
        guard let caminhos = FileManager.default.enumerator(
            at: raiz.appendingPathComponent("Sources"), includingPropertiesForKeys: nil) else { return }
        for caso in caminhos {
            guard let url = caso as? URL, url.pathExtension == "swift",
                  url.lastPathComponent != "MissaleAPI.swift"
            else { continue }
            let fonte = try String(contentsOf: url, encoding: .utf8)
            for api in ["URLSession", "URLRequest", "NWConnection", "CFNetwork", "Network.framework"] {
                if fonte.contains(api) { ofensores.append("\(url.lastPathComponent): \(api)") }
            }
        }
        XCTAssertTrue(
            ofensores.isEmpty,
            "a política diz que só a API do Missale usa a rede, e apareceu: \(ofensores)"
        )
    }

    /// `MissaleAPI` hardcodes a dev pair (`#if DEBUG`) and a prod pair
    /// (`#else`) of hosts. Both are read straight from the file — the whole
    /// point is to catch a stray third host, whichever branch the compiler
    /// took — and whichever pair this test binary actually compiled with
    /// (Debug → dev, Release → prod) must match its own constants exactly.
    func testTheAPIClientTalksToOneHost() throws {
        let fonte = try String(contentsOf: URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("Sources/Features/Account/MissaleAPI.swift"), encoding: .utf8)
        let hosts = try NSRegularExpression(pattern: #"https://[^"/]+"#)
            .matches(in: fonte, range: NSRange(fonte.startIndex..., in: fonte))
            .map { (fonte as NSString).substring(with: $0.range) }
        let dev = Set(["https://ule22ss715.execute-api.us-east-1.amazonaws.com",
                       "https://dbwbh4btw116j.cloudfront.net"])
        let prod = Set(["https://d64r4fekcj.execute-api.us-east-1.amazonaws.com",
                        "https://d1fie9m5bh3i4a.cloudfront.net"])
        XCTAssertEqual(Set(hosts), dev.union(prod),
                       "o cliente da API só pode falar com a API do Missale e com os arquivos de conteúdo, em dev e em produção")

        let compilados = Set([MissaleAPI.baseURL, MissaleAPI.contentBaseURL]
            .map { $0.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")) })
#if DEBUG
        XCTAssertEqual(compilados, dev, "build Debug deve falar com o stack de dev")
#else
        XCTAssertEqual(compilados, prod, "build Release deve falar com produção")
#endif
    }
}

