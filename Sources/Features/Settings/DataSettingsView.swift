import SwiftUI

/// t5 screen 5 (fIs5) — sync (off by default, mood/Examen entries never sync even
/// when on), export, and irreversible local delete. "Apagar tudo" really clears
/// MoodHistoryStore, the one piece of real local data this pass has.
struct DataSettingsView: View {
    @State private var syncEnabled = false
    @State private var analyticsEnabled = false
    @State private var showDeleteConfirmation = false
    @State private var didDelete = false
    @ObservedObject private var moodHistory = MoodHistoryStore.shared

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Seus dados")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("Tudo o que está aqui é seu, e sai daqui quando você quiser.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Sincronizar entre aparelhos")
                                        .font(MissaleFont.body(18, weight: .medium))
                                    Text(syncEnabled ? "Ligada" : "Desligada")
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.66))
                                }
                                Spacer()
                                Toggle("", isOn: $syncEnabled).labelsHidden().tint(Palette.wine)
                            }
                            Text(MockSettings.dataSyncNote)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.8))
                                .padding(11)
                                .background(Palette.wine.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Palette.wine.opacity(0.2), lineWidth: 1))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Exportar")
                                .font(MissaleFont.body(18, weight: .medium))
                            Text(MockSettings.dataExportNote)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                            HStack(spacing: 9) {
                                exportPill("PDF")
                                exportPill("JSON")
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Apagar tudo")
                            .font(MissaleFont.body(18, weight: .medium))
                            .foregroundStyle(Palette.wine)
                        Text(MockSettings.dataDeleteNote)
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.8))
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Text(didDelete ? "Dados apagados" : "Apagar tudo deste aparelho")
                                .font(MissaleFont.body(17))
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Palette.wine, in: Capsule())
                                .foregroundStyle(.white)
                        }
                        .disabled(didDelete)
                    }
                    .padding(16)
                    .background(Palette.wine.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Palette.wine.opacity(0.28), lineWidth: 1))

                    Text(MockSettings.dataPrivacyNote)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.58))

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Analítica anônima")
                                .font(MissaleFont.body(17))
                            Text("Só telas abertas, sem conteúdo")
                                .font(MissaleFont.body(14))
                                .foregroundStyle(Palette.ink.opacity(0.64))
                        }
                        Spacer()
                        Toggle("", isOn: $analyticsEnabled).labelsHidden().tint(Palette.wine)
                    }
                    .padding(14)
                    .background(Color.white.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.58), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Apagar tudo deste aparelho?", isPresented: $showDeleteConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Apagar", role: .destructive) {
                moodHistory.deleteAll()
                didDelete = true
            }
        } message: {
            Text("É imediato e não tem volta. Isso apaga \(moodHistory.entries.count) registro(s) de humor guardados neste aparelho.")
        }
    }

    private func exportPill(_ label: String) -> some View {
        Text(label)
            .font(MissaleFont.body(16))
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
    }
}
