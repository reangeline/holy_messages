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
/// Those four went away rather than being described. Export and delete are
/// back, now for real: both work over LocalData's list, so the file carries
/// and the button removes exactly what the privacy policy names.
///
/// Analytics is coming (anonymous usage only), so the screen no longer
/// promises "no analytics": it says what will be collected and what never is.
/// When the SDK lands, the privacy policy in Legal/ and the App Store privacy
/// answers have to change with it.
struct DataSettingsView: View {
    @State private var confirmingErase = false
    @State private var erased = false

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

                    Text("What you write stays on this device and is never sent anywhere. To keep improving the app, we may collect anonymous usage data — which screens are opened and how often — never what you write, and never linked to you. No account, no ads, no third-party trackers.", tableName: "SettingsDetail")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.8))

                    ShareLink(item: PersonalDataExport(), preview: SharePreview(L.string("My Missale data", table: "SettingsDetail"))) {
                        actionCard(icon: "square.and.arrow.up",
                                   title: L.string("Export my data", table: "SettingsDetail"),
                                   detail: L.string("A file with everything you wrote and recorded, to keep or send wherever you want.", table: "SettingsDetail"),
                                   tint: Palette.wine)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)

                    Button {
                        confirmingErase = true
                    } label: {
                        actionCard(icon: "trash",
                                   title: L.string("Delete my data", table: "SettingsDetail"),
                                   detail: L.string("Removes what you wrote and recorded from this device. Your language and settings stay.", table: "SettingsDetail"),
                                   tint: .red)
                    }
                    .buttonStyle(.plain)

                    if erased {
                        Label(L.string("Your data was deleted.", table: "SettingsDetail"), systemImage: "checkmark.circle")
                            .font(MissaleFont.body(15, weight: .medium))
                            .foregroundStyle(Palette.green)
                    }

                    Text("Deleting the app from this device also removes everything it saved.", tableName: "SettingsDetail")
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
        .confirmationDialog(L.string("Delete everything you wrote and recorded?", table: "SettingsDetail"),
                            isPresented: $confirmingErase, titleVisibility: .visible) {
            Button(L.string("Delete", table: "SettingsDetail"), role: .destructive) {
                LocalData.erasePersonalData()
                erased = true
            }
        } message: {
            Text("Your mood log, Examens, rosaries, Formation progress, the day's routine and what you wrote in the morning, Bible highlights and bookmark, and your name. This cannot be undone.", tableName: "SettingsDetail")
        }
    }

    private func actionCard(icon: String, title: String, detail: String, tint: Color) -> some View {
        GlassCard {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(tint)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(tint == .red ? Color.red : Palette.ink)
                    Text(detail)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(Palette.ink.opacity(0.65))
                }
                Spacer(minLength: 0)
            }
        }
    }
}

/// The export as a file for the share sheet — built only when the reader
/// actually shares, so the file reflects the moment it was asked for.
struct PersonalDataExport: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .json) { _ in
            let day = Date().formatted(.iso8601.year().month().day())
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("Missale-\(day).json")
            try LocalData.exportJSON().write(to: url, options: .atomic)
            return SentTransferredFile(url)
        }
    }
}
