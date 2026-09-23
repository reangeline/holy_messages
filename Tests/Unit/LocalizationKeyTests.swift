import XCTest

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
}
