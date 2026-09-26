import Foundation
import StoreKit

/// The app's only contact with the App Store.
///
/// Before this, the subscription screens were drawings: the paywall listed
/// prices written into the source (and a "Lifetime" plan with no product
/// behind it), and Settings reported an active subscription that renewed on a
/// fixed date. Nothing here invents a price or a status — every number comes
/// from StoreKit, which also localizes it into the reader's own currency, and
/// the free trial is read from the product's introductory offer rather than
/// promised in a button.
@MainActor
final class SubscriptionStore: ObservableObject {
    static let shared = SubscriptionStore()

    /// The product identifiers, which must match App Store Connect exactly.
    ///
    /// These are the **Product ID** strings (App Store Connect › Subscriptions
    /// › the subscription › "Product ID"), not the numeric Apple ID shown in
    /// the URL and in the product list — 6814659756 and 6814660801 here.
    /// `Product.products(for:)` matches on these strings and silently returns
    /// nothing when they are wrong, which is why `state` has a `failed` case
    /// the paywall shows instead of prices.
    ///
    /// They are plain words because that is what was registered. App Store
    /// Connect accepts any unique alphanumeric string (periods, underscores and
    /// hyphens allowed) and does not require the reverse-DNS convention — and
    /// it does not allow changing a Product ID once the subscription exists.
    enum ProductID {
        static let monthly = "mensal"
        static let annual = "anual"
        static let all = [monthly, annual]
    }

    enum State: Equatable {
        case idle
        case loading
        /// Loaded, sorted with the monthly plan first.
        case loaded([Product])
        /// The App Store answered with nothing, or could not be reached. The
        /// paywall says so rather than falling back to a written-in price.
        case failed
    }

    @Published private(set) var state: State = .idle

    /// Whether this Apple ID has an active subscription on this device. Read
    /// from `Transaction.currentEntitlements`, never stored: a flag in
    /// UserDefaults is a flag someone can flip.
    @Published private(set) var entitledByStore = false

    /// False until `Transaction.currentEntitlements` has been read once since
    /// launch. Before that, "not entitled" means "not known yet": a subscriber
    /// who reopened the app was shown the locked tabs for the second or two
    /// it took StoreKit to answer.
    @Published private(set) var hasResolvedEntitlement = false

    /// Whether the gates can decide yet. Always true when forced in DEBUG.
    var isEntitlementKnown: Bool {
#if DEBUG
        if debugForcedSubscription { return true }
#endif
        return hasResolvedEntitlement
    }

    var isSubscribed: Bool {
#if DEBUG
        if debugForcedSubscription { return true }
#endif
        return entitledByStore
    }

#if DEBUG
    /// Lets the UI suite exercise the paid screens, which are most of the app.
    /// A simulator has no App Store, so without this every test that opens the
    /// calendar, Formation or the prayers would only ever see the paywall.
    ///
    ///     app.launchArguments = ["-subscribed", "1"]
    ///
    /// Compiled out of release builds, and read from the argument domain
    /// rather than from a stored value, so nothing persists it — the same
    /// reason the entitlement itself is never written to the device.
    private var debugForcedSubscription: Bool {
        UserDefaults.standard
            .volatileDomain(forName: UserDefaults.argumentDomain)["subscribed"] as? String == "1"
    }

    /// Lets the UI suite reach the "couldn't reach the App Store" branch on
    /// purpose. A simulator where the app was once run from Xcode keeps that
    /// run's local StoreKit products, so "no store" can't be left to chance.
    ///
    ///     app.launchArguments = ["-noStore", "1"]
    private var debugNoStore: Bool {
        UserDefaults.standard
            .volatileDomain(forName: UserDefaults.argumentDomain)["noStore"] as? String == "1"
    }
#endif

    private var updates: Task<Void, Never>?

    private init() {
        // Read at launch, not only when the paywall opens — otherwise the gates
        // would wait for `Transaction.updates`, which may never fire.
        Task { [weak self] in await self?.refreshEntitlement() }
        // Purchases made outside the app — a renewal, a refund, a family-sharing
        // change, a purchase begun in the App Store — arrive here.
        updates = Task { [weak self] in
            for await update in Transaction.updates {
                guard let transaction = try? update.payloadValue else { continue }
                await transaction.finish()
                await self?.refreshEntitlement()
            }
        }
    }

    deinit { updates?.cancel() }

    func load() async {
        state = .loading
#if DEBUG
        if debugNoStore { return state = .failed }
#endif
        do {
            let products = try await Product.products(for: ProductID.all)
            guard !products.isEmpty else { return state = .failed }
            let ordenados = products.sorted { primeiro, segundo in
                (primeiro.id == ProductID.monthly ? 0 : 1) < (segundo.id == ProductID.monthly ? 0 : 1)
            }
            // Antes de publicar `.loaded`, para a tela nunca chegar a desenhar
            // um botão de teste grátis que depois some.
            await refreshTrialEligibility(from: ordenados)
            state = .loaded(ordenados)
        } catch {
            state = .failed
        }
        await refreshEntitlement()
    }

    /// Whether this Apple ID can still receive the introductory offer.
    ///
    /// A product carries the offer it advertises, not the offer this reader is
    /// owed: `introductoryOffer` is the same object for everyone. Someone who
    /// already spent the free trial and let the subscription lapse would have
    /// been shown "try free for 14 days" on a button that charges at once.
    /// Eligibility is granted once per subscription group, so one question
    /// answers for every plan in it.
    @Published private(set) var eligibleForTrial = false

    private func refreshTrialEligibility(from products: [Product]) async {
        guard let subscription = products.first?.subscription else {
            eligibleForTrial = false
            return
        }
        eligibleForTrial = await subscription.isEligibleForIntroOffer
    }

    /// True when the purchase completed. `false` covers the reader cancelling
    /// and the purchase pending approval (Ask to Buy), which are not errors.
    func purchase(_ product: Product) async throws -> Bool {
        switch try await product.purchase() {
        case .success(let verification):
            let transaction = try verification.payloadValue
            await transaction.finish()
            await refreshEntitlement()
            return true
        case .userCancelled, .pending:
            return false
        @unknown default:
            return false
        }
    }

    enum RestoreResult: Equatable {
        case restored
        /// The App Store answered, and this Apple ID has no active subscription.
        case nothingFound
        /// The reader closed the Apple ID password sheet. Not an error.
        case cancelled
        case failed
    }

    /// App Store guideline 3.1.1 requires a restore path in the app itself.
    ///
    /// This used to be `try? await AppStore.sync()` returning nothing: after the
    /// password sheet, a failed sync and an Apple ID with nothing to restore
    /// both ended in silence, and the screen stayed exactly as it was.
    func restore() async -> RestoreResult {
        var erro: Error?
        do { try await AppStore.sync() } catch { erro = error }
        await refreshEntitlement()
        return Self.restoreResult(syncError: erro, entitled: isSubscribed)
    }

    /// Separate from `restore()` so the decision can be tested without an App Store.
    nonisolated static func restoreResult(syncError: Error?, entitled: Bool) -> RestoreResult {
        // A sync that failed can still leave a valid entitlement on the device.
        if entitled { return .restored }
        guard let syncError else { return .nothingFound }
        if case StoreKitError.userCancelled = syncError { return .cancelled }
        if (syncError as? SKError)?.code == .paymentCancelled { return .cancelled }
        return .failed
    }

    private func refreshEntitlement() async {
        var ativa = false
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? result.payloadValue,
                  ProductID.all.contains(transaction.productID),
                  transaction.revocationDate == nil,
                  !transaction.isUpgraded
            else { continue }
            // No expiry check: `currentEntitlements` already leaves expired
            // subscriptions out, and keeps the ones in a billing grace period,
            // whose `expirationDate` is in the past. Checking it here took the
            // app away from a subscriber whose card was merely being retried.
            ativa = true
        }
        entitledByStore = ativa
        hasResolvedEntitlement = true
    }

    /// The signed StoreKit transaction of the active subscription, which the
    /// Missale API verifies (Apple's signature, bundle, product, expiry) before
    /// running the orientação. Nil when there is no active subscription.
    func activeSubscriptionJWS() async -> String? {
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? result.payloadValue,
                  ProductID.all.contains(transaction.productID),
                  transaction.revocationDate == nil,
                  !transaction.isUpgraded
            else { continue }
            return result.jwsRepresentation
        }
        return nil
    }

    /// What the App Store reports, in plain lines, for the TestFlight-only
    /// diagnostics on the subscription screen. TestFlight renews daily and
    /// stops after six renewals, and never grants a second free trial to an
    /// Apple ID — both look like bugs from inside the app. Nil outside the
    /// sandbox, so App Store customers never see it.
    func sandboxDiagnostics() async -> [String]? {
        guard let app = try? await AppTransaction.shared.payloadValue,
              app.environment != .production
        else { return nil }
        var lines = ["Ambiente: \(app.environment.rawValue)"]
        let date = Date.FormatStyle(date: .abbreviated, time: .shortened)
        for id in ProductID.all {
            guard let latest = await Transaction.latest(for: id) else {
                lines.append("\(id): nenhuma compra")
                continue
            }
            switch latest {
            case .verified(let t):
                var line = "\(id): comprado \(t.purchaseDate.formatted(date))"
                if let expiry = t.expirationDate { line += ", vence \(expiry.formatted(date))" }
                if t.revocationDate != nil { line += ", reembolsado" }
                if t.isUpgraded { line += ", trocado de plano" }
                lines.append(line)
            case .unverified(_, let error):
                lines.append("\(id): transação NÃO verificada (\(error.localizedDescription))")
            }
        }
        if case .loaded(let products) = state, let subscription = products.first?.subscription {
            for status in (try? await subscription.status) ?? [] {
                lines.append("Status do grupo: \(String(describing: status.state))")
            }
            let trial = products.first?.missaleFreeTrialDays.map { "\($0) dias" } ?? "nenhum no produto"
            lines.append("Teste grátis: \(trial); este Apple ID tem direito: \(eligibleForTrial ? "sim" : "não")")
        }
        lines.append("Assinatura ativa no app: \(entitledByStore ? "sim" : "não")")
        return lines
    }

    /// Called when the app returns to the foreground, so a subscription that
    /// lapsed or renewed while it was closed is reflected without a relaunch.
    func refreshOnForeground() async {
        await refreshEntitlement()
    }
}

extension Product {
    /// "R$ 34,90/month", in the reader's currency, from StoreKit — never
    /// written into the source.
    var missalePeriodLabel: String {
        guard let period = subscription?.subscriptionPeriod else { return displayPrice }
        let unidade: String
        switch period.unit {
        case .month: unidade = L.string("month", table: "Onboarding")
        case .year: unidade = L.string("year", table: "Onboarding")
        case .week: unidade = L.string("week", table: "Onboarding")
        case .day: unidade = L.string("day", table: "Onboarding")
        @unknown default: return displayPrice
        }
        return "\(displayPrice)/\(unidade)"
    }

    /// "R$ 10,82" — what a yearly plan works out to per month, so the annual
    /// price can be compared against the monthly one without arithmetic in the
    /// reader's head. Nil for anything that isn't billed by the year; the
    /// division and the currency both come from StoreKit.
    var missaleMonthlyEquivalent: String? {
        guard let period = subscription?.subscriptionPeriod, period.unit == .year else { return nil }
        let meses = Decimal(12 * period.value)
        guard meses > 0 else { return nil }
        return (price / meses).formatted(priceFormatStyle)
    }

    /// The trial the product actually offers, in days, or nil when there is
    /// none. The paywall's button used to promise 30 days regardless.
    ///
    /// This is what the product advertises to everyone. Before showing it to a
    /// reader, gate it on `SubscriptionStore.eligibleForTrial` — an Apple ID
    /// that already spent the trial gets charged immediately.
    var missaleFreeTrialDays: Int? {
        guard let offer = subscription?.introductoryOffer, offer.paymentMode == .freeTrial else { return nil }
        let period = offer.period
        switch period.unit {
        case .day: return period.value
        case .week: return period.value * 7
        case .month: return period.value * 30
        case .year: return period.value * 365
        @unknown default: return nil
        }
    }
}
