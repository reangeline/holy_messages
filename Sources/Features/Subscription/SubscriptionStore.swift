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
    @Published private(set) var isSubscribed = false

    private var updates: Task<Void, Never>?

    private init() {
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
        do {
            let products = try await Product.products(for: ProductID.all)
            guard !products.isEmpty else { return state = .failed }
            state = .loaded(products.sorted { primeiro, segundo in
                (primeiro.id == ProductID.monthly ? 0 : 1) < (segundo.id == ProductID.monthly ? 0 : 1)
            })
        } catch {
            state = .failed
        }
        await refreshEntitlement()
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

    /// App Store guideline 3.1.1 requires a restore path in the app itself.
    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlement()
    }

    private func refreshEntitlement() async {
        var ativa = false
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? result.payloadValue,
                  ProductID.all.contains(transaction.productID),
                  transaction.revocationDate == nil
            else { continue }
            // `expirationDate` is nil only for non-subscriptions; both products
            // here are subscriptions, so an absent date means keep looking.
            if let expiry = transaction.expirationDate, expiry > .now { ativa = true }
        }
        isSubscribed = ativa
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

    /// The trial the product actually offers, in days, or nil when there is
    /// none. The paywall's button used to promise 30 days regardless.
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
