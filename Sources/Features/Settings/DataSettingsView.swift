import SwiftUI

/// t5 screen 5 (fIs5) — what the app keeps on this device.
///
/// This screen used to offer four things the app did not do: a sync toggle
/// (there is no sync, and the note under it claimed subscription and progress
/// synced), an "anonymous analytics" toggle with an off switch (there is no
/// analytics and no network request anywhere in the app), PDF/JSON export pills
/// that were plain `Text`, and a "Delete everything" button that cleared the
/// mood log only while telling the reader their Examen notes were gone.
///
/// All four are gone rather than described, because the privacy policy has to
/// match this screen. Export and delete are deliberately deferred, not
/// abandoned: until they exist, deleting the app is what removes the data, and
/// that is what the policy says. The inventory of what is stored stays in
/// LocalData, which the policy and its tests read.
struct DataSettingsView: View {

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your data", tableName: "SettingsDetail")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("What the app keeps, and where it keeps it.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    Text("Nothing here is uploaded. The app makes no network requests, has no account, no third-party trackers, no analytics, and no ads. What you write stays on this device.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.8))

                    Text("Deleting the app from this device removes everything it saved. Exporting a copy, and deleting your records without deleting the app, are not built yet.", tableName: "SettingsDetail")
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
    }
}
