import SwiftUI

/// Lets the user set the name the app greets them by on Today and shows in
/// Settings — the app's one real, user-entered piece of identity.
struct EditNameView: View {
    @AppStorage(UserProfile.nameStorageKey) private var userDisplayName = ""
    @State private var draft: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(alignment: .leading, spacing: 16) {
                Text("Your name", tableName: "SettingsDetail")
                    .font(MissaleFont.display(26))
                Text("Only used to greet you by name on Today and here in Settings.", tableName: "SettingsDetail")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.65))

                GlassCard {
                    TextField("Como podemos te chamar?", text: $draft)
                        .font(MissaleFont.body(17))
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                }

                Button {
                    userDisplayName = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    dismiss()
                } label: {
                    Text("Save", tableName: "SettingsDetail")
                        .font(MissaleFont.body(17, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Palette.wine, in: Capsule())
                        .foregroundStyle(.white)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { draft = userDisplayName }
    }
}

#Preview {
    NavigationStack { EditNameView() }
}
