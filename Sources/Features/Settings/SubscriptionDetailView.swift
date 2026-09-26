import SwiftUI
import StoreKit

/// t5 screen 2 (fIs2) — subscription status, restore, and the path to
/// cancellation (fIs9).
///
/// The status card used to read "ACTIVE · US$ 39.99/year · Automatically
/// renews on October 14, 2026. Billed through the App Store." on every
/// install, for everyone, having charged no one. A fabricated billing
/// statement in shipped UI is both an App Store rejection and the kind of
/// thing that makes a reader doubt a charge they never made. It now shows what
/// StoreKit reports for this Apple ID, and says plainly when there is no
/// subscription.
struct SubscriptionDetailView: View {
    @ObservedObject private var store = SubscriptionStore.shared
    @State private var restaurando = false
    @State private var resultadoDaRestauracao: SubscriptionStore.RestoreResult?
    @State private var diagnostico: [String]?

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Subscription", tableName: "SettingsDetail")
                        .font(MissaleFont.display(29, weight: .semibold))

                    if store.isSubscribed {
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("ACTIVE", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.4)
                                    .foregroundStyle(Palette.goldBright)
                                Text("Missale Premium", tableName: "SettingsDetail")
                                    .font(MissaleFont.display(21, weight: .medium))
                                    .foregroundStyle(.white)
                                // O valor, a data de renovação e o plano ficam
                                // na App Store, que é quem cobra. Repeti-los
                                // aqui foi o que produziu a declaração falsa.
                                Text("Managed in the App Store, where you can see the renewal date and the amount, and cancel.", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(.white.opacity(0.88))
                            }
                        }
                    } else {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("No subscription on this device", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(18, weight: .medium))
                                Text("Everything in the app is available without one. If you subscribed with another Apple ID, restore below.", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.ink.opacity(0.72))
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 9) {
                            Eyebrow(text: L.string( "What's included", table: "SettingsDetail"))
                            VStack(alignment: .leading, spacing: 8) {
                                Text("All formation tracks, and new ones as they launch", tableName: "SettingsDetail")
                                Text("The complete liturgical calendar, with every feast explained", tableName: "SettingsDetail")
                                Text("Traditional prayers and devotions, offline", tableName: "SettingsDetail")
                                Text("Guided rosary with voice, beginner mode, and dark screen", tableName: "SettingsDetail")
                            }
                            .font(MissaleFont.body(16))

                            Divider().padding(.vertical, 4)

                            Eyebrow(text: L.string( "Free forever, with or without a subscription", table: "SettingsDetail"))
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Word of the day and saint of the day", tableName: "SettingsDetail")
                                Text("The complete Rosary", tableName: "SettingsDetail")
                                Text("Your calendar and everything you've logged", tableName: "SettingsDetail")
                                Text("The pastoral referral network", tableName: "SettingsDetail")
                            }
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.78))
                        }
                    }

                    // Só no TestFlight: o que a App Store responde, para
                    // separar comportamento do sandbox de defeito do app.
                    if let diagnostico {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(verbatim: "TESTFLIGHT · APP STORE")
                                    .font(MissaleFont.body(11, weight: .semibold))
                                    .tracking(1.4)
                                    .foregroundStyle(Palette.wine)
                                ForEach(diagnostico, id: \.self) { linha in
                                    Text(verbatim: linha)
                                        .font(.system(.footnote, design: .monospaced))
                                        .textSelection(.enabled)
                                }
                            }
                        }
                    }

                    Button {
                        restaurando = true
                        Task {
                            let resultado = await store.restore()
                            diagnostico = await store.sandboxDiagnostics()
                            restaurando = false
                            resultadoDaRestauracao = resultado
                        }
                    } label: {
                        Group {
                            if restaurando {
                                ProgressView()
                            } else {
                                Text("Restore Purchases", tableName: "SettingsDetail")
                            }
                        }
                        .font(MissaleFont.body(17))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(Capsule().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                        .foregroundStyle(Palette.ink)
                    }
                    .disabled(restaurando)

                    // A tela de cancelamento explica o que acontece; o
                    // cancelamento em si é da Apple, na folha de assinaturas
                    // que ela abre por cima do app.
                    NavigationLink {
                        SubscriptionCancellationView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Cancel renewal", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(17))
                                    .foregroundStyle(Palette.ink)
                                Text("No questions, no discount offer", tableName: "SettingsDetail")
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(Palette.ink.opacity(0.64))
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(16)
                    .background(Color.white.opacity(0.36))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 4])).foregroundStyle(Palette.ink.opacity(0.22)))

                    HStack(spacing: 16) {
                        NavigationLink(value: SettingsDestination.legal(.terms)) {
                            Text("Terms of Use", tableName: "SettingsDetail")
                        }
                        NavigationLink(value: SettingsDestination.legal(.privacy)) {
                            Text("Privacy Policy", tableName: "SettingsDetail")
                        }
                    }
                    .font(MissaleFont.body(15))
                    .tint(Palette.wine)

                    Text("The subscription renews automatically until canceled. Cancellation happens in your App Store account settings, at least 24 hours before the period ends.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { diagnostico = await store.sandboxDiagnostics() }
        .restoreResultAlert($resultadoDaRestauracao)
    }
}
