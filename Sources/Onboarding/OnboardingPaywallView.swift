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
///
/// The shape is sacred art bled to the top edge, a parchment sheet riding over
/// it, and one decision at the bottom. The two plans start folded away behind
/// "View all plans": showing both side by side made the screen ask which plan
/// before it had said what the subscription is for.
struct OnboardingPaywallView: View {
    let onFinish: () -> Void

    @ObservedObject private var store = SubscriptionStore.shared
    @State private var selectedProductID = SubscriptionStore.ProductID.annual
    @State private var comprando = false
    @State private var restaurando = false
    @State private var resultadoDaRestauracao: SubscriptionStore.RestoreResult?
    @State private var falhaNaCompra = false
    @State private var mostrandoPlanos = false
    /// Guardado para rolar até os planos quando eles aparecem: abertos abaixo
    /// da dobra, o toque em "Ver todos os planos" só trocava o rótulo do botão
    /// e parecia não ter feito nada.
    @State private var rolagem: ScrollViewProxy?

    /// Alta o bastante para a gruta ser quadro e não faixa, baixa o bastante
    /// para a folha inteira caber acima da barra num 6.1".
    private let alturaDoHero: CGFloat = 262
    private let sobreposicaoDaFolha: CGFloat = 28
    private static let ancoraDosPlanos = "planos"

    /// Contados do catálogo, não escritos aqui: a tela já não crava preço nem
    /// dias de teste, e um "7 trilhas" cravado envelheceria na primeira trilha
    /// nova sem ninguém perceber.
    private static var totalDeTrilhas: Int { MockFormation.allTracks.count }
    private static var totalDeLicoes: Int {
        MockFormation.allTracks.reduce(0) { $0 + $1.lessons.count }
    }

    var body: some View {
        // O fechar mora à esquerda, não no canto habitual: na gruta a figura
        // ocupa a direita, e o botão caía em cima dela. A esquerda é céu escuro.
        ZStack(alignment: .topLeading) {
            Palette.parchment.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        hero
                        folha
                    }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .top)
                .onAppear { rolagem = proxy }
            }

            botaoFechar
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
        .safeAreaInset(edge: .bottom) { barraDeDecisao }
        .task { await store.load() }
        .alert(L.string("The purchase didn't complete", table: "Onboarding"), isPresented: $falhaNaCompra) {
            Button(L.string("OK", table: "Onboarding"), role: .cancel) {}
        } message: {
            Text("Nothing was charged. You can try again, or keep using the app free.", tableName: "Onboarding")
        }
        .restoreResultAlert($resultadoDaRestauracao)
    }

    // MARK: - Topo

    private var hero: some View {
        // A moldura vem de um Color.clear, não da própria imagem: com
        // `aspectRatio(.fill)` a arte reporta a largura que o recorte pede
        // (558pt para 300 de altura) e, dentro de um ScrollView, essa largura
        // vira a da coluna inteira — o texto saía cortado nas duas margens.
        Color.clear
            .frame(height: alturaDoHero)
            .frame(maxWidth: .infinity)
            .overlay {
                Image("PaywallHero")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .clipped()
            // Sem isto a borda da folha corta a pintura em seco; o degradê
            // entrega a arte ao pergaminho antes de o corte acontecer.
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [Palette.parchment.opacity(0), Palette.parchment.opacity(0.95)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 130)
            }
            .accessibilityHidden(true)
    }

    private var botaoFechar: some View {
        Button(action: onFinish) {
            Image(systemName: "xmark")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Color.black.opacity(0.3), in: Circle())
        }
        .accessibilityLabel(L.string("Close", table: "Onboarding"))
    }

    // MARK: - Folha

    private var folha: some View {
        VStack(spacing: 22) {
            titulo
            beneficios
            planos.id(Self.ancoraDosPlanos)
        }
        .padding(.horizontal, 24)
        .padding(.top, 30)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(
            Palette.parchment,
            in: UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28, style: .continuous)
        )
        // Padding negativo, não `offset`: offset desenha deslocado mas continua
        // ocupando a altura toda, e sobravam 28pt fantasma no fim da rolagem.
        .padding(.top, -sobreposicaoDaFolha)
    }

    private var titulo: some View {
        VStack(spacing: 2) {
            Text("Unlock all content", tableName: "Onboarding")
                .foregroundStyle(Palette.ink)
            Text("with Missale Premium", tableName: "Onboarding")
                .foregroundStyle(Palette.wine)
        }
        .font(MissaleFont.display(33))
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var beneficios: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("What you get with Missale Premium", tableName: "Onboarding")
                .font(MissaleFont.display(21))
                .foregroundStyle(Palette.ink)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)

            beneficio(
                icone: "books.vertical",
                titulo: L.string("{n} paths of formation", table: "Onboarding")
                    .replacingOccurrences(of: "{n}", with: "\(Self.totalDeTrilhas)"),
                detalhe: L.string("The Mass, the sacraments, the Rosary, confession — {n} lessons in all.", table: "Onboarding")
                    .replacingOccurrences(of: "{n}", with: "\(Self.totalDeLicoes)")
            )
            beneficio(
                icone: "calendar",
                titulo: L.string("Every season and feast", table: "Onboarding"),
                detalhe: L.string("Explained as it arrives.", table: "Onboarding")
            )
            beneficio(
                icone: "moon.stars",
                titulo: L.string("Traditional prayers", table: "Onboarding"),
                detalhe: L.string("And Compline for the night.", table: "Onboarding")
            )

            // Fica por último e em voz baixa de propósito: é a promessa de que
            // a parte gratuita não está sendo levada embora por esta tela.
            Text("The daily verse, the saint, and the safety net stay free forever.", tableName: "Onboarding")
                .font(MissaleFont.body(14))
                .foregroundStyle(Palette.ink.opacity(0.55))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
        }
    }

    private func beneficio(icone: String, titulo: String, detalhe: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icone)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Palette.wine)
                .frame(width: 26, alignment: .center)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 1) {
                Text(titulo)
                    .font(MissaleFont.body(18, weight: .semibold))
                    .foregroundStyle(Palette.ink)
                Text(detalhe)
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.ink.opacity(0.65))
            }
            Spacer(minLength: 0)
        }
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Planos

    /// O estado de falha fica fora do "Ver todos os planos" de propósito: um
    /// erro escondido atrás de um disclosure é um erro que ninguém lê, e o
    /// PaywallUITests cobre exatamente isso. Só as linhas de plano carregadas
    /// se dobram.
    @ViewBuilder
    private var planos: some View {
        switch store.state {
        case .idle, .loading:
            if mostrandoPlanos { ProgressView().padding(.vertical, 20) }

        case .failed:
            // Sem produto não há preço. Dizer isso é melhor que mostrar um
            // valor que não é o que será cobrado.
            VStack(spacing: 6) {
                Text("We couldn't reach the App Store to load the plans.", tableName: "Onboarding")
                    .font(MissaleFont.body(15, weight: .medium))
                Text("Everything in the app works without a subscription. You can subscribe later, in Settings.", tableName: "Onboarding")
                    .font(MissaleFont.body(14))
                    .foregroundStyle(Palette.ink.opacity(0.65))
            }
            .multilineTextAlignment(.center)
            .padding(.vertical, 14)

        case .loaded(let products):
            if mostrandoPlanos {
                VStack(spacing: 10) {
                    ForEach(products, id: \.id) { product in
                        Button { selectedProductID = product.id } label: { linhaDePlano(product) }
                            .buttonStyle(.plain)
                    }
                }
                .foregroundStyle(Palette.ink)
            }
        }
    }

    /// Sem planos para listar, o botão que os revela não tem o que revelar.
    private var podeEscolherPlano: Bool {
        if case .loaded = store.state { return true }
        return false
    }

    private func linhaDePlano(_ product: Product) -> some View {
        let escolhido = selectedProductID == product.id
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(product.displayName)
                    .font(MissaleFont.body(17, weight: .medium))
                if let dias = diasDeTeste(product) {
                    Text(L.string("{n} days free first", table: "Onboarding")
                        .replacingOccurrences(of: "{n}", with: "\(dias)"))
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.6))
                }
            }
            Spacer()
            Text(product.missalePeriodLabel)
                .font(MissaleFont.body(17, weight: .semibold))
        }
        .padding(15)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(escolhido ? Palette.wine : Color.black.opacity(0.08),
                              lineWidth: escolhido ? 2 : 1)
        )
    }

    // MARK: - Decisão

    private var barraDeDecisao: some View {
        VStack(spacing: 10) {
            Button(action: aoTocarNoBotao) {
                Text(tituloDoBotao)
                    .font(MissaleFont.body(16, weight: .semibold))
                    .tracking(1.1)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(Palette.wine.opacity(comprando || restaurando ? 0.4 : 1), in: Capsule())
                    .foregroundStyle(.white)
            }
            .disabled(comprando || restaurando)

            if let selecionado {
                Text(rodape(for: selecionado))
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 22) {
                if podeEscolherPlano {
                    Button {
                        withAnimation(.snappy(duration: 0.25)) { mostrandoPlanos.toggle() }
                        // Num passo à parte: rolar para uma âncora no mesmo
                        // ciclo em que ela ganha conteúdo mira a altura antiga.
                        guard mostrandoPlanos else { return }
                        DispatchQueue.main.async {
                            withAnimation(.snappy(duration: 0.3)) {
                                rolagem?.scrollTo(Self.ancoraDosPlanos, anchor: .bottom)
                            }
                        }
                    } label: {
                        Text(mostrandoPlanos
                             ? L.string("Hide plans", table: "Onboarding")
                             : L.string("View all plans", table: "Onboarding"))
                            .font(MissaleFont.body(14, weight: .medium))
                            .foregroundStyle(Palette.wine)
                    }
                }

                // Exigido pela diretriz 3.1.1: restaurar tem de existir dentro
                // do app, não só nos Ajustes do iPhone.
                Button(action: restaurar) {
                    if restaurando {
                        ProgressView()
                    } else {
                        Text("Restore purchases", tableName: "Onboarding")
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                    }
                }
                .disabled(comprando || restaurando)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }

    // MARK: - StoreKit

    /// Os dias de teste que *esta pessoa* ainda pode receber, e não os que o
    /// produto anuncia: quem já gastou o seu vê o preço direto, sem promessa.
    private func diasDeTeste(_ product: Product) -> Int? {
        store.eligibleForTrial ? product.missaleFreeTrialDays : nil
    }

    private var selecionado: Product? {
        guard case .loaded(let products) = store.state else { return nil }
        return products.first { $0.id == selectedProductID } ?? products.first
    }

    /// Reads the trial from the product instead of promising thirty days.
    private var tituloDoBotao: String {
        guard let selecionado else { return L.string("Continue free", table: "Onboarding") }
        if let dias = diasDeTeste(selecionado) {
            return L.string("Try free for {n} days", table: "Onboarding")
                .replacingOccurrences(of: "{n}", with: "\(dias)")
        }
        return L.string("Subscribe", table: "Onboarding")
    }

    private func rodape(for product: Product) -> String {
        var texto: String
        if let dias = diasDeTeste(product) {
            texto = L.string("{n} days free, then {price}, renewing automatically. Cancel anytime in the App Store.", table: "Onboarding")
                .replacingOccurrences(of: "{n}", with: "\(dias)")
                .replacingOccurrences(of: "{price}", with: product.missalePeriodLabel)
        } else {
            texto = L.string("{price}, renewing automatically. Cancel anytime in the App Store.", table: "Onboarding")
                .replacingOccurrences(of: "{price}", with: product.missalePeriodLabel)
        }
        // Um ano custa um número grande; sem o equivalente mensal ao lado, a
        // comparação com o plano mensal fica por conta da cabeça de quem lê.
        if let mensal = product.missaleMonthlyEquivalent {
            texto += " " + L.string("({price} per month)", table: "Onboarding")
                .replacingOccurrences(of: "{price}", with: mensal)
        }
        return texto
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
        restaurando = true
        Task {
            let resultado = await store.restore()
            restaurando = false
            // Restaurado, a tela some e o app já abre liberado; os outros
            // casos precisam ser ditos, senão parece que nada aconteceu.
            if resultado == .restored { onFinish() } else { resultadoDaRestauracao = resultado }
        }
    }
}
