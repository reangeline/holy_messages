import SwiftUI
import StoreKit

/// dIs17 — the subscription screen.
///
/// Every price, period and trial here comes from StoreKit, which also gives
/// them in the reader's own currency. It used to be a drawing: three plans with
/// prices written into the source, one of them ("Lifetime") with no product
/// behind it, a fabricated 4.8-star rating, and a button that promised thirty
/// free days and then simply closed onboarding.
///
/// When the App Store answers with nothing — a wrong product identifier, no
/// network, products not yet approved — the screen says so and offers to carry
/// on free. It never falls back to a price of its own.
struct OnboardingPaywallView: View {
    let onFinish: () -> Void

    @ObservedObject private var store = SubscriptionStore.shared
    @State private var selectedProductID = SubscriptionStore.ProductID.annual
    @State private var comprando = false
    @State private var falhaNaCompra = false

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                HStack {
                    Button(action: onFinish) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Palette.ink.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 14) {
                        Eyebrow(text: "Missale Premium")
                        Text("Stay with it through the whole year", tableName: "Onboarding")
                            .font(MissaleFont.display(28))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Palette.ink)

                        // Havia aqui "4.8 ★★★★★ · 12,4 mil avaliações", numa
                        // nota e numa contagem inventadas para um app que nunca
                        // foi publicado. Prova social falsa é rejeição direta na
                        // App Store, e não é o que este app quer ser. Volta
                        // quando houver avaliações de verdade, lidas da App
                        // Store — não cravadas no código.

                        switch store.state {
                        case .idle, .loading:
                            ProgressView().padding(.vertical, 28)

                        case .failed:
                            // Sem produto não há preço. Dizer isso é melhor que
                            // mostrar um valor que não é o que será cobrado.
                            VStack(spacing: 6) {
                                Text("We couldn't reach the App Store to load the plans.", tableName: "Onboarding")
                                    .font(MissaleFont.body(15, weight: .medium))
                                Text("Everything in the app works without a subscription. You can subscribe later, in Settings.", tableName: "Onboarding")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.65))
                            }
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 18)

                        case .loaded(let products):
                            VStack(spacing: 10) {
                                ForEach(products, id: \.id) { product in
                                    Button { selectedProductID = product.id } label: { planRow(product) }
                                        .buttonStyle(.plain)
                                }
                            }
                            .foregroundStyle(Palette.ink)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            featureRow(L.string("The Mass, part by part \u{2014} all 14 parts", table: "Onboarding"))
                            featureRow(L.string("Every season and feast explained as it arrives", table: "Onboarding"))
                            featureRow(L.string("Traditional prayers and Compline for the night", table: "Onboarding"))
                            featureRow(L.string("The daily verse, the saint, and the safety net stay free forever.", table: "Onboarding"), dimmed: true)
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                }

                VStack(spacing: 8) {
                    OnboardingPrimaryButton(title: tituloDoBotao, action: aoTocarNoBotao)
                        .disabled(comprando)

                    if let selecionado {
                        Text(rodape(for: selecionado))
                            .font(MissaleFont.body(12))
                            .foregroundStyle(Palette.ink.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }

                    // Exigido pela diretriz 3.1.1: restaurar tem de existir
                    // dentro do app, não só nos Ajustes do iPhone.
                    Button(action: restaurar) {
                        Text("Restore purchases", tableName: "Onboarding")
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.wine)
                    }
                    .disabled(comprando)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .background(.ultraThinMaterial)
            }
        }
        .task { await store.load() }
        .alert(L.string("The purchase didn't complete", table: "Onboarding"), isPresented: $falhaNaCompra) {
            Button(L.string("OK", table: "Onboarding"), role: .cancel) {}
        } message: {
            Text("Nothing was charged. You can try again, or keep using the app free.", tableName: "Onboarding")
        }
    }

    // MARK: - StoreKit

    private var selecionado: Product? {
        guard case .loaded(let products) = store.state else { return nil }
        return products.first { $0.id == selectedProductID } ?? products.first
    }

    /// Reads the trial from the product instead of promising thirty days.
    private var tituloDoBotao: String {
        guard let selecionado else { return L.string("Continue free", table: "Onboarding") }
        if let dias = selecionado.missaleFreeTrialDays {
            return L.string("Try free for {n} days", table: "Onboarding")
                .replacingOccurrences(of: "{n}", with: "\(dias)")
        }
        return L.string("Subscribe", table: "Onboarding")
    }

    private func rodape(for product: Product) -> String {
        if let dias = product.missaleFreeTrialDays {
            return L.string("{n} days free, then {price}, renewing automatically. Cancel anytime in the App Store.", table: "Onboarding")
                .replacingOccurrences(of: "{n}", with: "\(dias)")
                .replacingOccurrences(of: "{price}", with: product.missalePeriodLabel)
        }
        return L.string("{price}, renewing automatically. Cancel anytime in the App Store.", table: "Onboarding")
            .replacingOccurrences(of: "{price}", with: product.missalePeriodLabel)
    }

    private func aoTocarNoBotao() {
        guard let produto = selecionado else { return onFinish() }
        comprando = true
        Task {
            do {
                let comprou = try await store.purchase(produto)
                comprando = false
                // Cancelar não é erro: a tela fica aberta e a pessoa decide.
                if comprou { onFinish() }
            } catch {
                comprando = false
                falhaNaCompra = true
            }
        }
    }

    private func restaurar() {
        comprando = true
        Task {
            await store.restore()
            comprando = false
            if store.isSubscribed { onFinish() }
        }
    }

    private func planRow(_ product: Product) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(product.displayName)
                    .font(MissaleFont.body(16, weight: .medium))
                if let dias = product.missaleFreeTrialDays {
                    Text(L.string("{n} days free first", table: "Onboarding")
                        .replacingOccurrences(of: "{n}", with: "\(dias)"))
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.6))
                }
            }
            Spacer()
            Text(product.missalePeriodLabel)
                .font(MissaleFont.body(16, weight: .semibold))
        }
        .padding(14)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(selectedProductID == product.id ? Palette.wine : Color.black.opacity(0.08),
                              lineWidth: selectedProductID == product.id ? 2 : 1)
        )
    }

    private func featureRow(_ text: String, dimmed: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(dimmed ? Palette.ink.opacity(0.4) : Palette.wine)
            Text(text)
                .font(MissaleFont.body(14))
                .foregroundStyle(dimmed ? Palette.ink.opacity(0.5) : Palette.ink.opacity(0.85))
        }
    }
}
