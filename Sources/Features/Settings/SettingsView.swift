import SwiftUI

/// Minimal Settings screen — not part of the original 30-screen spec, added because
/// two things need a permanent (non-conditional) home: pastoral care resources and
/// subscription management. Also houses QA-only previews for screens whose real
/// triggers (pattern detection, scheduling) aren't wired up yet.
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        PastoralCareNudgeView()
                    } label: {
                        Label("Cuidado pastoral", systemImage: "hands.sparkles")
                    }
                } footer: {
                    Text("Padre, diocese, ou uma linha de crise — sempre aqui, não só quando o app percebe um padrão.")
                }

                Section("Assinatura") {
                    NavigationLink {
                        SubscriptionCancellationView()
                    } label: {
                        Label("Gerenciar assinatura", systemImage: "creditcard")
                    }
                }

                Section {
                    NavigationLink {
                        ScrupulosityRedirectView()
                    } label: {
                        Label("Redirecionamento de escrúpulo", systemImage: "arrow.triangle.branch")
                    }
                    NavigationLink {
                        AngelusNudgeView()
                    } label: {
                        Label("Lembrete do Angelus", systemImage: "bell")
                    }
                } header: {
                    Text("Pré-visualizar (QA)")
                } footer: {
                    Text("O escrúpulo dispara de verdade após 3 registros do mesmo estado em 14 dias. O Angelus soa de verdade ao meio-dia e às 18h. Estes links são só para conferir o visual sem esperar.")
                }
            }
            .navigationTitle("Ajustes")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}
