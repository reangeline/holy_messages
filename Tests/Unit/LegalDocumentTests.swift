import XCTest
@testable import Missale

/// The Settings screen used to print "This text hasn't been written yet" where
/// the terms and the privacy policy belong. The documents now ship with the app
/// and are read from Markdown; these tests fail if a file stops being bundled,
/// if a language is missing one, or if a document loses the sections the App
/// Store requires next to a subscription.
final class LegalDocumentTests: XCTestCase {

    private let idiomas: [AppLanguage] = [.pt, .en, .es]
    fileprivate var idiomasParaTeste: [AppLanguage] { idiomas }

    fileprivate func markdownParaTeste(_ d: LegalDocument, _ l: AppLanguage) throws -> String { try markdown(d, l) }

    private func markdown(_ document: LegalDocument, _ language: AppLanguage) throws -> String {
        let nome = document.resourceName(for: language)
        let url = try XCTUnwrap(
            Bundle.main.url(forResource: nome, withExtension: "md"),
            "\(nome).md não está no bundle do app"
        )
        return try String(contentsOf: url, encoding: .utf8)
    }

    func testBothDocumentsShipInAllThreeLanguages() throws {
        for document in [LegalDocument.privacy, .terms] {
            for language in idiomas {
                let texto = try markdown(document, language)
                XCTAssertGreaterThan(texto.count, 1500, "\(document)/\(language) é curto demais para um documento legal")
            }
        }
    }

    /// Every file must be its own language: the same text in two of them means
    /// one was never written.
    func testEachLanguageHasItsOwnText() throws {
        for document in [LegalDocument.privacy, .terms] {
            let textos = try idiomas.map { try markdown(document, $0) }
            XCTAssertEqual(Set(textos).count, textos.count, "\(document) tem dois idiomas idênticos")
        }
    }

    /// Apple requires the subscription terms to state the renewal, how to
    /// cancel, and that the price is shown before purchase.
    func testTermsCoverWhatTheAppStoreRequires() throws {
        let exigencias: [AppLanguage: [String]] = [
            .pt: ["renova automaticamente", "cancelar", "App Store", "antes da compra"],
            .en: ["renews automatically", "cancel", "App Store", "before purchase"],
            .es: ["renueva automáticamente", "cancelar", "App Store", "antes de la compra"],
        ]
        for (language, termos) in exigencias {
            let texto = try markdown(.terms, language)
            for termo in termos {
                XCTAssertTrue(texto.localizedCaseInsensitiveContains(termo),
                              "termos/\(language) não falam de \"\(termo)\"")
            }
        }
    }

    /// And the privacy policy must state the claims the app actually backs:
    /// what the reader writes stays on the device (LocalDataTests allows
    /// network only in the account client), the account can be deleted in
    /// the app, and deleting the app removes what it kept.
    func testPrivacyPolicyStatesTheRealClaims() throws {
        let exigencias: [AppLanguage: [String]] = [
            .pt: ["Nada do que você escreve ou registra sai do seu aparelho", "Apagar o aplicativo do aparelho",
                  "Configurações › Conta › Apagar conta", "só se comunica com o servidor do Missale"],
            .en: ["Nothing you write or log leaves your device", "Deleting the app from your device",
                  "Settings › Account › Delete account", "only talks to the Missale server"],
            .es: ["Nada de lo que escribes o registras sale de tu dispositivo", "Borrar la aplicación del dispositivo",
                  "Ajustes › Cuenta › Eliminar cuenta", "solo se comunica con el servidor de Missale"],
        ]
        for (language, termos) in exigencias {
            let texto = try markdown(.privacy, language)
            for termo in termos {
                XCTAssertTrue(texto.localizedCaseInsensitiveContains(termo),
                              "privacidade/\(language) não afirma \"\(termo)\"")
            }
        }
    }

    /// The reader has to be able to see it: the parser must produce headings
    /// and paragraphs, not one undifferentiated blob.
    func testTheMarkdownParsesIntoBlocks() throws {
        for document in [LegalDocument.privacy, .terms] {
            for language in idiomas {
                let blocos = LegalDocumentView.blocks(from: try markdown(document, language))
                let titulos = blocos.filter { if case .title = $0 { return true } else { return false } }
                let secoes = blocos.filter { if case .heading = $0 { return true } else { return false } }
                let paragrafos = blocos.filter { if case .paragraph = $0 { return true } else { return false } }
                XCTAssertEqual(titulos.count, 1, "\(document)/\(language) deveria ter um título")
                XCTAssertGreaterThanOrEqual(secoes.count, 6, "\(document)/\(language) tem poucas seções")
                XCTAssertGreaterThan(paragrafos.count, 5, "\(document)/\(language) tem poucos parágrafos")
            }
        }
    }

    /// The internal import notes must not ship inside the app.
    func testInternalNotesAreNotBundled() {
        XCTAssertNil(Bundle.main.url(forResource: "IMPORTACAO", withExtension: "md"),
                     "IMPORTACAO.md é nota interna e foi para o bundle")
    }
}

extension LegalDocumentTests {
    /// A bullet wrapped across two source lines is one bullet, not a bullet
    /// plus a stray paragraph — which is how the policy first rendered, with
    /// sentences broken in half on screen.
    func testAWrappedBulletStaysOneBullet() {
        let markdown = """
        ## Seção

        - Primeiro item que continua
          na linha seguinte.
        - Segundo item.

        Um parágrafo depois.
        """
        let blocos = LegalDocumentView.blocks(from: markdown)
        XCTAssertEqual(blocos, [
            .heading("Seção"),
            .bullet("Primeiro item que continua na linha seguinte."),
            .bullet("Segundo item."),
            .paragraph("Um parágrafo depois."),
        ])
    }

    /// And no real document may render a paragraph that starts mid-sentence,
    /// which is the symptom that bug produced.
    func testNoParagraphStartsInLowercase() throws {
        for document in [LegalDocument.privacy, .terms] {
            for language in idiomasParaTeste {
                for bloco in LegalDocumentView.blocks(from: try markdownParaTeste(document, language)) {
                    guard case .paragraph(let texto) = bloco, let primeira = texto.first else { continue }
                    // Um endereço sozinho é minúsculo de direito.
                    if !texto.contains(" ") && (texto.contains("@") || texto.hasPrefix("http")) { continue }
                    XCTAssertFalse(
                        primeira.isLowercase,
                        "\(document)/\(language): parágrafo começando no meio da frase — \"\(texto.prefix(48))…\""
                    )
                }
            }
        }
    }
}
