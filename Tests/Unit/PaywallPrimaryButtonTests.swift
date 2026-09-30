import Foundation
import XCTest
@testable import Missale

/// O botão principal do paywall decidia pelo produto selecionado, e não pelo
/// estado da loja: sem produto, dizia "Continuar de graça" e fechava a tela.
/// Só que "sem produto" também é o que existe enquanto a App Store ainda não
/// respondeu. Com conexão lenta, a pessoa via um botão ativo oferecendo sair,
/// tocava, e o paywall fechava sem ter mostrado plano nenhum.
///
/// Estes testes prendem a decisão por estado. `Product` do StoreKit não pode
/// ser criado aqui, então o estado carregado entra como `.loaded([])` e o que
/// a view tiraria do produto ("há um selecionado?", "quantos dias de teste?")
/// entra pelos outros dois parâmetros.
final class PaywallPrimaryButtonTests: XCTestCase {

    private let continuarDeGraca = L.string("Continue free", table: "Onboarding")

    func testEnquantoALojaNaoRespondeOBotaoFicaDesabilitadoESemTexto() {
        for estado in [SubscriptionStore.State.idle, .loading] {
            let botao = PaywallPrimaryButton(estado: estado, temProduto: false, diasDeTeste: nil)
            XCTAssertEqual(botao, .carregando, "\(estado)")
            XCTAssertFalse(botao.habilitado, "\(estado): o botão age antes de a loja responder")
            XCTAssertNotEqual(botao, .continuarDeGraca, "\(estado): um toque fecharia o paywall")
            XCTAssertNil(botao.titulo, "\(estado): não há o que prometer antes de a loja responder")
            XCTAssertNotEqual(botao.titulo, continuarDeGraca)
        }
    }

    /// A view só fecha o paywall em `.continuarDeGraca`; se sobrar um dia de
    /// teste de um estado anterior, ele não pode virar promessa.
    func testCarregandoIgnoraODiaDeTesteQueSobrou() {
        let botao = PaywallPrimaryButton(estado: .loading, temProduto: true, diasDeTeste: 14)
        XCTAssertEqual(botao, .carregando)
        XCTAssertFalse(botao.habilitado)
    }

    func testSemLojaOBotaoOfereceContinuarDeGraca() {
        let botao = PaywallPrimaryButton(estado: .failed, temProduto: false, diasDeTeste: nil)
        XCTAssertEqual(botao, .continuarDeGraca)
        XCTAssertTrue(botao.habilitado)
        XCTAssertEqual(botao.titulo, continuarDeGraca)
    }

    func testCarregadoComTesteOBotaoDizOsDiasDoProduto() {
        let botao = PaywallPrimaryButton(estado: .loaded([]), temProduto: true, diasDeTeste: 14)
        XCTAssertEqual(botao, .testarGratis(dias: 14))
        XCTAssertTrue(botao.habilitado)
        XCTAssertEqual(
            botao.titulo,
            L.string("Try free for {n} days", table: "Onboarding").replacingOccurrences(of: "{n}", with: "14")
        )
    }

    /// Quem já gastou o teste chega aqui com `diasDeTeste` nil.
    func testCarregadoSemTesteOBotaoDizAssinar() {
        let botao = PaywallPrimaryButton(estado: .loaded([]), temProduto: true, diasDeTeste: nil)
        XCTAssertEqual(botao, .assinar)
        XCTAssertTrue(botao.habilitado)
        XCTAssertEqual(botao.titulo, L.string("Subscribe", table: "Onboarding"))
    }

    /// `load()` não publica lista vazia, mas se publicar o botão não pode
    /// nem vender o que não existe nem fechar a tela.
    func testCarregadoSemProdutoNaoVendeNemFecha() {
        let botao = PaywallPrimaryButton(estado: .loaded([]), temProduto: false, diasDeTeste: nil)
        XCTAssertFalse(botao.habilitado)
        XCTAssertNotEqual(botao, .continuarDeGraca)
    }

    /// O LocalizationKeyTests cobre as chaves em uso lendo o próprio
    /// `.xcstrings`; este teste confere a mesma coisa para "Loading plans"
    /// especificamente (e que o rótulo de quem usa VoiceOver não é o título
    /// de compra nem o de saída). Sem isso, o teste passaria mesmo que a
    /// chave não existisse em nenhum idioma: `L.string` devolve a própria
    /// chave quando não a encontra, um falso positivo.
    func testORotuloDeCarregamentoNaoEONomeDeNenhumaAcao() throws {
        let porIdioma = try valoresDaChave("Loading plans", tabela: "Onboarding")
        for idioma in ["pt", "en", "es"] {
            XCTAssertNotNil(porIdioma[idioma], "\"Loading plans\" não está em \(idioma) no catálogo de Onboarding")
        }

        let rotulo = L.string("Loading plans", table: "Onboarding")
        XCTAssertFalse(rotulo.isEmpty)
        XCTAssertNotEqual(rotulo, continuarDeGraca)
        XCTAssertNotEqual(rotulo, L.string("Subscribe", table: "Onboarding"))
    }

    /// Lê o `.xcstrings` da mesma forma que `LocalizationKeyTests.catalogos()`
    /// faz, restrito a uma chave e tabela — evita duplicar a leitura de todo
    /// o catálogo só para confirmar uma chave.
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
