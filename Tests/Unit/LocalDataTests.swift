import XCTest
@testable import Missale

/// The privacy policy describes this app from `LocalData`, so the list there
/// has to be the truth. These tests fail when a new persisted key appears
/// without being listed, and when "Delete everything" stops deleting
/// everything — which is how it shipped before: it cleared the mood log only,
/// while the screen told the reader their Examen notes were gone.
@MainActor
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

    /// The point of the whole file: the button empties every store.
    func testDeleteEverythingEmptiesEveryStore() {
        let estado = MockMood.stateGroups.flatMap(\.items).first!
        _ = MoodHistoryStore.shared.record(state: estado, note: "uma nota privada")
        ExamenHistoryStore.shared.list.append(
            ExamenEntry(id: UUID(), date: Date(), gratitude: "g", lightRequest: "l", review: "r", response: "p"))
        FormationProgressStore.shared.markCompleted("sacraments-1-pt")
        UserDefaults.standard.set("Reangeline", forKey: "userDisplayName")

        XCTAssertGreaterThan(LocalData.recordCount, 0, "não consegui criar dados para apagar")

        LocalData.deleteEverything()

        XCTAssertEqual(MoodHistoryStore.shared.entries.count, 0, "o registro de humor sobreviveu")
        XCTAssertEqual(ExamenHistoryStore.shared.list.items.count, 0, "as notas do Exame sobreviveram")
        XCTAssertEqual(RosaryHistoryStore.shared.list.items.count, 0, "o histórico do terço sobreviveu")
        XCTAssertEqual(FormationProgressStore.shared.completedLessonIDs.count, 0, "o progresso sobreviveu")
        // Afirma o que o app controla: o valor que ele gravou saiu. Num
        // simulador o `UserDefaults.standard` do processo de teste ainda pode
        // resolver um valor de um plist de nível de dispositivo, uma camada
        // abaixo do container do app — que o app não escreve nem apaga, e que
        // não existe num aparelho real.
        XCTAssertNotEqual(UserDefaults.standard.string(forKey: "userDisplayName"), "Reangeline",
                          "o nome gravado pelo app sobreviveu ao apagamento")
        XCTAssertEqual(LocalData.recordCount, 0)
    }

    /// Preferences are kept on purpose: wiping the language would restart the
    /// app in one the reader never chose.
    func testDeleteEverythingKeepsPreferences() {
        UserDefaults.standard.set("BR-general", forKey: "liturgicalCalendarRegionID")
        LocalData.deleteEverything()
        XCTAssertEqual(UserDefaults.standard.string(forKey: "liturgicalCalendarRegionID"), "BR-general")
        UserDefaults.standard.removeObject(forKey: "liturgicalCalendarRegionID")
    }

    /// The claim the policy rests on: the app has no network code.
    func testTheAppMakesNoNetworkRequests() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        var ofensores: [String] = []
        guard let caminhos = FileManager.default.enumerator(
            at: raiz.appendingPathComponent("Sources"), includingPropertiesForKeys: nil) else { return }
        for caso in caminhos {
            guard let url = caso as? URL, url.pathExtension == "swift" else { continue }
            let fonte = try String(contentsOf: url, encoding: .utf8)
            for api in ["URLSession", "URLRequest", "NWConnection", "CFNetwork", "Network.framework"] {
                if fonte.contains(api) { ofensores.append("\(url.lastPathComponent): \(api)") }
            }
        }
        XCTAssertTrue(
            ofensores.isEmpty,
            "a política diz que o app não faz requisições de rede, e apareceu: \(ofensores)"
        )
    }
}

