import SwiftUI

/// Puts the paywall in front of a screen when there is no subscription.
///
/// Two shapes: `GatedLink` for one row or card, `GatedTab` for a whole tab.
///
/// What stays free was decided deliberately, and two of the three reasons are
/// not commercial:
///
/// - **The word of the day** — the choice made for this version.
/// - **The mood check-in, the relief it leads to, and the pastoral and crisis
///   screens behind it.** This is the path a reader takes when they log
///   "guilty", "grief" or "lonely", and it ends at a phone number for their
///   country. A paywall between someone in that state and that number is the
///   worst thing this app could do, so it is not gated — and the App Store
///   would be right to reject it if it were.
/// - **Settings, the language picker, and the two legal documents**, which a
///   reader must be able to reach to cancel, to read what is stored, and to
///   delete the app knowing what it kept.
///
/// Everything else — the saint of the day, the calendar, Formation, the
/// Rosary and the prayers, the Examen and Compline — asks for a subscription.
///
/// The gate reads `SubscriptionStore.isSubscribed`, which comes from
/// `Transaction.currentEntitlements` and is never stored on the device.
/// A tap that either opens the screen or the paywall.
///
/// Written as a Button rather than a NavigationLink because the destination
/// depends on the entitlement at the moment of the tap: a reader who
/// subscribes in the sheet should land on the screen they asked for.
struct GatedLink<Label: View, Destination: View>: View {
    @ViewBuilder let destination: () -> Destination
    @ViewBuilder let label: () -> Label

    @ObservedObject private var store = SubscriptionStore.shared
    @State private var showPaywall = false
    @State private var abrirDestino = false

    var body: some View {
        Button {
            if store.isSubscribed {
                abrirDestino = true
            } else {
                showPaywall = true
            }
        } label: {
            label()
        }
        .buttonStyle(.plain)
        .navigationDestination(isPresented: $abrirDestino) { destination() }
        .sheet(isPresented: $showPaywall, onDismiss: {
            // Assinou dentro da folha: abre o que a pessoa foi buscar.
            if store.isSubscribed { abrirDestino = true }
        }) {
            OnboardingPaywallView(onFinish: { showPaywall = false })
                .appLanguageLocale()
        }
    }
}

/// The full-screen version, for a tab whose whole content is gated.
struct GatedTab<Content: View>: View {
    @ViewBuilder let content: () -> Content
    /// What the tab is, so the locked state can name it.
    let title: String
    let explanation: String

    @ObservedObject private var store = SubscriptionStore.shared
    @State private var showPaywall = false

    var body: some View {
        if store.isSubscribed {
            content()
        } else {
            ZStack {
                LiturgicalColor.red.pageBackground
                VStack(spacing: 14) {
                    CrossGlyph(size: 30, color: Palette.wine)
                    Text(title)
                        .font(MissaleFont.display(27))
                        .multilineTextAlignment(.center)
                    Text(explanation)
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.72))
                        .multilineTextAlignment(.center)

                    Button {
                        showPaywall = true
                    } label: {
                        Text("See the plans", tableName: "Onboarding")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Palette.wine, in: Capsule())
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 6)

                    // Sempre visível, assine ou não: é o caminho de apoio.
                    Text("The word of the day, and the support screens if you need them, are free — and always will be.", tableName: "Onboarding")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 90)
            }
            // Sem isto a barra flutuante desaparece e a pessoa fica presa na
            // aba bloqueada, sem caminho de volta para o Hoje — inclusive sem
            // caminho para o apoio em momento de crise, que está lá.
            .hubTabBarOverlay()
            .sheet(isPresented: $showPaywall) {
                OnboardingPaywallView(onFinish: { showPaywall = false })
                    .appLanguageLocale()
            }
        }
    }
}
