import Foundation
import XCTest
@testable import Missale

/// `OnboardingOrientationView.send()` turned every failure into the same
/// "connection" wording, including `subscriptionRequired` (402) and
/// `dailyLimit` (429) — the account's free orientação spent, not a network
/// problem. Retrying never works there, so the notice has to say something
/// else: go choose the state in "Hoje eu estou…".
///
/// These tests pin the mapping from error to message without a network
/// call, the same way `PaywallPrimaryButtonTests` pins the paywall button's
/// state decision.
final class OrientationFailureMessageTests: XCTestCase {

    private let limiteAtingido = L.string(
        "Written guidance isn't available on this account right now. In the app, \"Today I am…\" lets you choose how you are with one tap.",
        table: "Onboarding")
    private let semConexao = L.string(
        "I couldn't get the guidance right now. You'll find it in the app, in \"Today I am…\".",
        table: "Onboarding")

    func testAssinaturaExigidaMostraAMensagemDeLimite() {
        let mensagem = OrientationFailureMessage(MissaleAPI.Failure.subscriptionRequired)
        XCTAssertEqual(mensagem, .limitReached)
        XCTAssertEqual(mensagem.text, limiteAtingido)
        XCTAssertNotEqual(mensagem.text, semConexao)
    }

    func testLimiteDiarioMostraAMesmaMensagemDeLimite() {
        let mensagem = OrientationFailureMessage(MissaleAPI.Failure.dailyLimit)
        XCTAssertEqual(mensagem, .limitReached)
        XCTAssertEqual(mensagem.text, limiteAtingido)
    }

    func testFalhaDeRedeMostraAMensagemDeConexao() {
        let mensagem = OrientationFailureMessage(URLError(.notConnectedToInternet))
        XCTAssertEqual(mensagem, .unavailable)
        XCTAssertEqual(mensagem.text, semConexao)
    }

    func testServidorIndisponivelMostraAMensagemDeConexao() {
        let mensagem = OrientationFailureMessage(MissaleAPI.Failure.unavailable)
        XCTAssertEqual(mensagem, .unavailable)
        XCTAssertEqual(mensagem.text, semConexao)
    }

    /// Não é este enum que decide: sessão inválida obriga a pessoa a entrar
    /// de novo, então cai na mensagem genérica em vez de prometer algo que
    /// "Hoje eu estou…" também não resolveria sem sessão.
    func testSessaoInvalidaNaoViraMensagemDeLimite() {
        let mensagem = OrientationFailureMessage(MissaleAPI.Failure.unauthorized)
        XCTAssertEqual(mensagem, .unavailable)
    }

    /// `LocalizationKeyTests` cobre as chaves em uso lendo o `.xcstrings`
    /// inteiro; este teste confere que a chave nova existe nos três idiomas
    /// especificamente, como `PaywallPrimaryButtonTests` faz com "Loading
    /// plans" — sem isso, `L.string` devolveria a própria chave em silêncio.
    func testAMensagemDeLimiteExisteNosTresIdiomas() throws {
        let porIdioma = try valoresDaChave(
            "Written guidance isn't available on this account right now. In the app, \"Today I am…\" lets you choose how you are with one tap.",
            tabela: "Onboarding")
        for idioma in ["pt", "en", "es"] {
            XCTAssertNotNil(porIdioma[idioma], "mensagem de limite não está em \(idioma) no catálogo de Onboarding")
        }
    }

    private func valoresDaChave(_ chave: String, tabela: String) throws -> [String: String] {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()    // Tests/Unit
            .deletingLastPathComponent()    // Tests
            .deletingLastPathComponent()    // repo
        let url = raiz.appendingPathComponent("Sources/Onboarding/\(tabela).xcstrings")
        let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any]
        let strings = json?["strings"] as? [String: Any] ?? [:]
        let localizacoes = (strings[chave] as? [String: Any])?["localizations"] as? [String: Any] ?? [:]
        var porIdioma: [String: String] = [:]
        for (lang, unidade) in localizacoes {
            if let valor = ((unidade as? [String: Any])?["stringUnit"] as? [String: Any])?["value"] as? String {
                porIdioma[lang] = valor
            }
        }
        return porIdioma
    }
}
