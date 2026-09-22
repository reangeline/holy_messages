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

    /// App Store Connect shows both a numeric Apple ID (6814659756) and a
    /// Product ID string. `Product.products(for:)` matches the string and
    /// silently returns nothing for the number — which would leave the paywall
    /// permanently in its "couldn't load" state.
    func testTheProductIdentifiersAreStringsNotAppleIDs() {
        for id in SubscriptionStore.ProductID.all {
            XCTAssertFalse(
                id.allSatisfy(\.isNumber),
                "\(id) parece um Apple ID numérico; o StoreKit precisa do Product ID"
            )
            XCTAssertTrue(id.contains("."), "\(id) não tem a forma de um Product ID")
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
        let proibidos = ["34,90", "199,90", "649,90", "349,90", "39.99", "129.99", "6.99", "3.33",
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

    /// And the entitlement is never persisted: a flag in UserDefaults is a flag
    /// someone can flip.
    func testTheEntitlementIsNotStoredOnDevice() throws {
        let raiz = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let fonte = try String(
            contentsOf: raiz.appendingPathComponent("Sources/Features/Subscription/SubscriptionStore.swift"),
            encoding: .utf8)
        // Só o código: o próprio comentário do arquivo cita UserDefaults para
        // dizer por que não o usa.
        let codigo = fonte
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).hasPrefix("//") }
            .joined(separator: "\n")
        XCTAssertFalse(codigo.contains("UserDefaults"), "a assinatura passou a ser gravada no aparelho")
        XCTAssertFalse(codigo.contains("@AppStorage"), "a assinatura passou a ser gravada no aparelho")
        XCTAssertTrue(fonte.contains("Transaction.currentEntitlements"),
                      "o direito deixou de ser lido do StoreKit")
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
