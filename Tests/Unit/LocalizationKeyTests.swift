import AVFoundation
import XCTest
@testable import Missale

/// A key passed to `Text(_:tableName:)` with no entry in its table does not
/// fail the build and does not fall back to Portuguese by design — SwiftUI
/// renders the key itself. Every key in this app is written in Portuguese, so
/// the screen silently shows Portuguese to an English or Spanish reader. That
/// is how the rewritten Examen flow shipped: six keys (the closing screen, the
/// history screen, the link to past Examens) were never added to
/// Today.xcstrings, and nothing caught it.
///
/// These tests read the `.xcstrings` sources themselves, located from
/// `#filePath`, because that is where the gap lives — the compiled bundle just
/// mirrors whatever the catalogs say.
final class LocalizationKeyTests: XCTestCase {

    private let idiomas = ["pt", "en", "es"]

    private var raiz: URL {
        URL(fileURLWithPath: #filePath)     // Tests/Unit/LocalizationKeyTests.swift
            .deletingLastPathComponent()    // Tests/Unit
            .deletingLastPathComponent()    // Tests
            .deletingLastPathComponent()    // repo
    }

    /// table name -> key -> language -> value
    private func catalogos() throws -> [String: [String: [String: String]]] {
        let fm = FileManager.default
        var saida: [String: [String: [String: String]]] = [:]
        guard let caminhos = fm.enumerator(at: raiz.appendingPathComponent("Sources"),
                                           includingPropertiesForKeys: nil) else { return saida }
        for caso in caminhos {
            guard let url = caso as? URL, url.pathExtension == "xcstrings" else { continue }
            let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any]
            let strings = json?["strings"] as? [String: Any] ?? [:]
            var tabela: [String: [String: String]] = [:]
            for (chave, bruto) in strings {
                let loc = (bruto as? [String: Any])?["localizations"] as? [String: Any] ?? [:]
                var porIdioma: [String: String] = [:]
                for (lang, unidade) in loc {
                    if let valor = ((unidade as? [String: Any])?["stringUnit"] as? [String: Any])?["value"] as? String {
                        porIdioma[lang] = valor
                    }
                }
                tabela[chave] = porIdioma
            }
            saida[url.deletingPathExtension().lastPathComponent] = tabela
        }
        return saida
    }

    /// Guards the two tests below from passing because they read nothing.
    func testTheCatalogsWereActuallyRead() throws {
        let tabelas = try catalogos()
        XCTAssertGreaterThanOrEqual(tabelas.count, 7, "não achei os .xcstrings em \(raiz.path)")
        let chaves = tabelas.values.reduce(0) { $0 + $1.count }
        XCTAssertGreaterThan(chaves, 400, "li \(chaves) chaves, muito menos do que o app tem")
    }

    /// Every key present in any language must be present in all three.
    func testEveryKeyIsTranslatedIntoAllThreeLanguages() throws {
        var falhas: [String] = []
        for (tabela, chaves) in try catalogos() {
            for (chave, porIdioma) in chaves {
                let ausentes = idiomas.filter { porIdioma[$0] == nil }
                if !ausentes.isEmpty {
                    falhas.append("\(tabela): \(chave.prefix(50))… sem \(ausentes.sorted().joined(separator: ", "))")
                }
            }
        }
        XCTAssertTrue(falhas.isEmpty, "\(falhas.count) chaves incompletas:\n" + falhas.sorted().joined(separator: "\n"))
    }

    /// Entries that really do read the same in Portuguese and Spanish. Each was
    /// read and confirmed; anything else identical is an entry that reached the
    /// table without being translated.
    private let identicasPorDireito: Set<String> = [
        "part {n} of {total}",          // "parte {n} de {total}" nos dois
        "Missale Premium · yearly",     // "Missale Premium · anual" nos dois
        "Sunday · Cycle {c}",           // "Domingo · Ciclo {c}" nos dois
    ]

    /// And a long text identical in Portuguese and Spanish is an entry that was
    /// added to the table without being translated.
    func testNoLongEntryLeavesPortugueseInTheSpanishColumn() throws {
        var suspeitas: [String] = []
        for (tabela, chaves) in try catalogos() {
            for (chave, porIdioma) in chaves where !identicasPorDireito.contains(chave) {
                guard let pt = porIdioma["pt"], let es = porIdioma["es"], pt == es else { continue }
                // Palavras iguais nos dois idiomas existem ("Continuar",
                // "Amén"): só o texto longo torna a coincidência implausível.
                if pt.split(separator: " ").count >= 4 {
                    suspeitas.append("\(tabela): \(chave.prefix(50))…")
                }
            }
        }
        XCTAssertTrue(suspeitas.isEmpty, "\(suspeitas.count) entradas com pt e es idênticos:\n" + suspeitas.sorted().joined(separator: "\n"))
    }

    func testPresentationVideoIsPortraitAndUsesAPortraitCard() async throws {
        let componente = try String(contentsOf: raiz.appendingPathComponent("Sources/Onboarding/OnboardingComponents.swift"))
        XCTAssertTrue(componente.contains(".frame(width: 220, height: 391)"), "o vídeo precisa ficar em um card estreito de proporção 9:16")

        let asset = AVURLAsset(url: raiz.appendingPathComponent("Sources/Resources/onboarding-plano.mp4"))
        let trilhas = try await asset.loadTracks(withMediaType: .video)
        guard let trilha = trilhas.first else {
            return XCTFail("não encontrei a trilha de vídeo da apresentação")
        }
        let tamanho = try await trilha.load(.naturalSize)
        XCTAssertGreaterThan(tamanho.height, tamanho.width, "a filmagem de apresentação precisa ser vertical")
    }

    func testLifeStateDistinguishesCivilAndReligiousMarriageInEveryLanguage() {
        let esperados: [AppLanguage: [String]] = [
            .pt: ["Casamento civil", "Casamento religioso"],
            .en: ["Civil marriage", "Religious marriage"],
            .es: ["Matrimonio civil", "Matrimonio religioso"],
        ]

        for (idioma, opcoesEsperadas) in esperados {
            let opcoes = MockOnboarding.lifeQuestions(for: idioma)[3].options
                .filter { ["civil-marriage", "religious-marriage"].contains($0.id) }
                .map(\.text)
            XCTAssertEqual(opcoes, opcoesEsperadas, "estado de vida em \(idioma)")
        }
    }

    func testLifeStateDoesNotOfferConsecratedReligiousLifeInAnyLanguage() {
        for idioma in AppLanguage.allCases {
            let opcoes = MockOnboarding.lifeQuestions(for: idioma)[3].options
            XCTAssertFalse(opcoes.contains { $0.id == "religious" }, "estado de vida ainda oferece vida consagrada em \(idioma)")
        }
    }

    func testPrayerFromTheHeartIsLocalizedInEveryLanguage() {
        let esperados: [AppLanguage: String] = [
            .pt: "Eu oro com o coração",
            .en: "I pray from the heart",
            .es: "Rezo con el corazón",
        ]

        for (idioma, esperado) in esperados {
            let opcao = MockOnboarding.spiritualQuestions(for: idioma)[0].options.first { $0.id == "alive" }
            XCTAssertEqual(opcao?.text, esperado, "oração viva em \(idioma)")
        }
    }

    func testPrayerInvitationInvitesAnAttentiveMeditatedOurFatherInEveryLanguage() {
        let ctas: [AppLanguage: String] = [
            .pt: "Vamos rezar juntos",
            .en: "Let's pray together",
            .es: "Recemos juntos",
        ]
        let convites: [AppLanguage: String] = [
            .pt: "Vamos rezar o Pai-Nosso devagar, com atenção, meditando cada palavra.",
            .en: "Let's pray the Our Father slowly, with attention, meditating on each word.",
            .es: "Recemos el Padre Nuestro despacio, con atención, meditando cada palabra.",
        ]

        for idioma in AppLanguage.allCases {
            XCTAssertEqual(OnboardingStory.prayerStart[idioma], ctas[idioma], "CTA de oração em \(idioma)")
            XCTAssertEqual(OnboardingStory.prayerBody[idioma], convites[idioma], "convite de oração em \(idioma)")
        }
    }
}
