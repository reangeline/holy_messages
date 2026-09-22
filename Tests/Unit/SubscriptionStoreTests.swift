import XCTest
import StoreKit
@testable import Missale

/// The subscription screens used to be drawings: prices written into the
/// source, a "Lifetime" plan with no product behind it, a fabricated 4.8-star
/// rating, and a Settings card reporting an active subscription that renewed on
/// a fixed date, on every install, having charged no one.
///
/// These tests pin what replaced them — that nothing about a price, a period,
/// a trial or a status is written in the app any more, and that the product
/// identifiers are the kind StoreKit can actually resolve.
final class SubscriptionStoreTests: XCTestCase {

    /// App Store Connect shows both a numeric Apple ID (6814659756 and
    /// 6814660801 for these two) and a Product ID string.
    /// `Product.products(for:)` matches the string and silently returns
    /// nothing for the number — which would leave the paywall permanently in
    /// its "couldn't load" state.
    ///
    /// The identifiers here are plain words, "mensal" and "anual", because
    /// that is what was registered: App Store Connect accepts any unique
    /// alphanumeric string and does not require the reverse-DNS convention.
    /// This test asserted a dot at first, which was a convention of mine
    /// rather than a rule of Apple's, and would have rejected the real values.
    func testTheProductIdentifiersAreStringsNotAppleIDs() {
        for id in SubscriptionStore.ProductID.all {
            XCTAssertFalse(
                id.allSatisfy(\.isNumber),
                "\(id) parece um Apple ID numérico; o StoreKit precisa do Product ID"
            )
            XCTAssertFalse(id.isEmpty)
            XCTAssertTrue(
                id.allSatisfy { $0.isLetter || $0.isNumber || ".-_".contains($0) },
                "\(id) tem caractere que a App Store Connect não aceita num Product ID"
            )
        }
    }

    func testThereAreExactlyTwoProducts() {
        XCTAssertEqual(SubscriptionStore.ProductID.all.count, 2,
                       "só mensal e anual existem como produto na App Store Connect")
        XCTAssertEqual(Set(SubscriptionStore.ProductID.all).count, 2, "identificadores repetidos")
    }

    /// The whole point: no price, period, or trial length is written in the
    /// app. This reads the sources, because a string constant is exactly what
    /// would come back.
    func testNoPriceOrTrialIsWrittenIntoTheSubscriptionScreens() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let telas = [
            "Sources/Onboarding/OnboardingPaywallView.swift",
            "Sources/Features/Settings/SubscriptionDetailView.swift",
            "Sources/MockData/MockSettings.swift",
        ]
        // Valores que estavam cravados, e a forma geral de um preço.
        // Os valores que estavam cravados, e também os reais: o ponto é que
        // nenhum preço fique no app, nem mesmo o certo — a App Store tem 175
        // regiões e o valor muda em cada uma.
        let proibidos = ["34,90", "199,90", "649,90", "349,90", "39.99", "129.99", "3.33",
                         "19,90", "19.90", "129,90", "129.90", "7.99", "49.99", "6.99", "59.99",
                         "30 dias", "30 days", "4.8", "12,4 mil", "12.4K"]
        for caminho in telas {
            let fonte = try String(contentsOf: raiz.appendingPathComponent(caminho), encoding: .utf8)
            // Só o código, não os comentários que registram o que saiu.
            let codigo = fonte
                .components(separatedBy: .newlines)
                .filter { !$0.trimmingCharacters(in: .whitespaces).hasPrefix("//") }
                .joined(separator: "\n")
            for proibido in proibidos {
                XCTAssertFalse(codigo.contains(proibido),
                               "\(caminho) voltou a cravar \"\(proibido)\" em vez de ler do StoreKit")
            }
        }
    }

    /// The entitlement is never persisted. A stored flag is a flag someone can
    /// flip, so it is read from `Transaction.currentEntitlements` on every
    /// check.
    ///
    /// There is one read of UserDefaults in the file: a DEBUG-only launch
    /// argument that lets the UI suite exercise the paid screens, since a
    /// simulator has no App Store. That is the volatile argument domain — it
    /// never persists, and it is compiled out of release builds. What must not
    /// appear is a *write*, or `@AppStorage`.
    func testTheEntitlementIsNotStoredOnDevice() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let fonte = try String(
            contentsOf: raiz.appendingPathComponent("Sources/Features/Subscription/SubscriptionStore.swift"),
            encoding: .utf8)
        let codigo = fonte
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).hasPrefix("//") }
            .joined(separator: "\n")

        XCTAssertFalse(codigo.contains("@AppStorage"), "a assinatura passou a ser gravada no aparelho")
        for escrita in [".set(", ".setValue(", ".removeObject("] {
            XCTAssertFalse(codigo.contains(escrita),
                           "apareceu uma gravação (\(escrita)) no estado da assinatura")
        }
        XCTAssertTrue(codigo.contains("Transaction.currentEntitlements"),
                      "o direito deixou de ser lido do StoreKit")

        // A única leitura permitida, e só em DEBUG. Percorre as linhas
        // contando o aninhamento: o arquivo tem mais de um bloco #if DEBUG, e
        // comparar com o primeiro #endif dava falso negativo.
        var dentroDeDebug = 0
        for linha in fonte.components(separatedBy: .newlines) {
            let corte = linha.trimmingCharacters(in: .whitespaces)
            if corte.hasPrefix("#if DEBUG") { dentroDeDebug += 1; continue }
            if corte.hasPrefix("#endif") { dentroDeDebug = max(0, dentroDeDebug - 1); continue }
            if corte.hasPrefix("//") { continue }
            if corte.contains("UserDefaults") {
                XCTAssertGreaterThan(
                    dentroDeDebug, 0,
                    "leitura de UserDefaults fora de #if DEBUG, e portanto em produção: \(corte)"
                )
                XCTAssertTrue(
                    fonte.contains("volatileDomain"),
                    "leitura de UserDefaults fora do domínio volátil de argumentos"
                )
            }
        }
    }

    /// Guideline 3.1.1: restoring has to exist inside the app.
    func testRestoreExistsInBothSubscriptionScreens() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        for caminho in ["Sources/Onboarding/OnboardingPaywallView.swift",
                        "Sources/Features/Settings/SubscriptionDetailView.swift"] {
            let fonte = try String(contentsOf: raiz.appendingPathComponent(caminho), encoding: .utf8)
            XCTAssertTrue(fonte.contains("store.restore()"), "\(caminho) não oferece restaurar compras")
        }
    }

    /// The local StoreKit configuration exists and its product identifiers
    /// match the app's — otherwise a test passes and production loads nothing.
    func testTheLocalStoreKitConfigurationMatchesTheApp() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let url = raiz.appendingPathComponent("Tests/Support/Missale.storekit")
        let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any]
        let grupos = json?["subscriptionGroups"] as? [[String: Any]] ?? []
        let ids = grupos
            .flatMap { ($0["subscriptions"] as? [[String: Any]]) ?? [] }
            .compactMap { $0["productID"] as? String }
        XCTAssertEqual(Set(ids), Set(SubscriptionStore.ProductID.all),
                       "a configuração local do StoreKit não bate com os identificadores do app")
    }
}
