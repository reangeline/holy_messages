import SwiftUI

/// t5 screen 5 (fIs5) — what the app keeps on this device, and the button that
/// removes it.
///
/// This screen used to offer three things the app does not do: a sync toggle
/// (there is no sync, and the note under it claimed subscription and progress
/// synced), an "anonymous analytics" toggle with an off switch (there is no
/// analytics and no network request anywhere in the app), and PDF/JSON export
/// pills that were plain `Text`. They are gone rather than described, because
/// the privacy policy has to match this screen.
///
/// "Delete everything" now deletes everything — see LocalData. It used to
/// clear the mood log only, while telling the reader their notes were gone.
struct DataSettingsView: View {
    @State private var showDeleteConfirmation = false
    @State private var didDelete = false

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

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Delete everything", tableName: "SettingsDetail")
                            .font(MissaleFont.body(18, weight: .medium))
                            .foregroundStyle(Palette.wine)
                        Text("Deletes your mood log, your Examen notes, the rosaries you logged, your formation progress, and your name. It's immediate and can't be undone. Your language and calendar choices stay.", tableName: "SettingsDetail")
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

                    Text("Nothing here is uploaded. The app makes no network requests, has no account, no third-party trackers, no analytics, and no ads. What you write stays on this device.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.58))
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
                LocalData.deleteEverything()
                didDelete = true
            }
        } message: {
            Text(L.string("This deletes your mood log, your Examen notes, the rosaries you logged, your formation progress, and your name — {count} record(s) on this device. It is immediate and can't be undone.", table: "SettingsDetail")
                .replacingOccurrences(of: "{count}", with: "\(LocalData.recordCount)"))
        }
    }
}
