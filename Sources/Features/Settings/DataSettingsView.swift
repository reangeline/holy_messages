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
                        Text("Your data", tableName: "SettingsDetail")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("Everything here is yours, and leaves whenever you want.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Sync across devices", tableName: "SettingsDetail")
                                        .font(MissaleFont.body(18, weight: .medium))
                                    Text(syncEnabled ? L.string( "On", table: "SettingsDetail") : L.string( "Off", table: "SettingsDetail"))
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.66))
                                }
                                Spacer()
                                Toggle("", isOn: $syncEnabled).labelsHidden().tint(Palette.wine)
                            }
                            // Original copy lives in MockSettings.dataSyncNote (not mine to
                            // edit); translated it here under a new key with the same
                            // meaning rather than leaving it Portuguese-only, per the
                            // "policy/chrome, not devotional" guidance for this screen.
                            Text("Even when on, your mood log and Examen notes never upload: they never leave this device. Your subscription, track progress, and rosaries prayed do sync.", tableName: "SettingsDetail")
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
                            Text("Export", tableName: "SettingsDetail")
                                .font(MissaleFont.body(18, weight: .medium))
                            Text("Your calendar, logs, intentions, and progress, in a readable file. No account and no cloud in between.", tableName: "SettingsDetail")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                            HStack(spacing: 9) {
                                exportPill("PDF")
                                exportPill("JSON")
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Delete everything", tableName: "SettingsDetail")
                            .font(MissaleFont.body(18, weight: .medium))
                            .foregroundStyle(Palette.wine)
                        Text("Deletes your calendar, logs, notes, and progress on this device. It's immediate and can't be undone — export first if you want to keep a copy.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.8))
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Text(didDelete ? L.string( "Data deleted", table: "SettingsDetail") : L.string( "Delete everything on this device", table: "SettingsDetail"))
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

                    Text("We don't sell data, there are no third-party trackers, and there are no ads. Analytics are anonymous and can be turned off below.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.58))

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Anonymous analytics", tableName: "SettingsDetail")
                                .font(MissaleFont.body(17))
                            Text("Screen views only, no content", tableName: "SettingsDetail")
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
        .alert(L.string( "Delete everything on this device?", table: "SettingsDetail"), isPresented: $showDeleteConfirmation) {
            Button(L.string( "Cancel", table: "SettingsDetail"), role: .cancel) {}
            Button(L.string( "Delete", table: "SettingsDetail"), role: .destructive) {
                moodHistory.deleteAll()
                didDelete = true
            }
        } message: {
            Text(L.string("This deletes {count} mood entry(ies) saved on this device. This is immediate and can't be undone.", table: "SettingsDetail")
                .replacingOccurrences(of: "{count}", with: "\(moodHistory.entries.count)"))
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
