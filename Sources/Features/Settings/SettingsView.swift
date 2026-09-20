import SwiftUI

/// t5 screen 1 (fIs1) — Settings index. Fixed pastoral-note card up top (no
/// conditional trigger), then grouped rows, per the design's "Ajustes · 10 telas".
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AppLanguagePreference.storageKey) private var languageOverride = AppLanguagePreference.systemValue
    @AppStorage(UserProfile.nameStorageKey) private var userDisplayName = ""
    @AppStorage(UserProfile.calendarRegionKey) private var storedRegionID = ""
    private let day = MockLiturgical.today

    private var resolvedLanguageName: String {
        AppLanguagePreference.resolve(override: languageOverride).displayName
    }

    var body: some View {
        NavigationStack {
            ZStack {
                day.color.pageBackground
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        header
                        pastoralNoteCard
                        ForEach(MockSettings.groups) { group in
                            groupSection(group)
                        }
                        Text(L.string(MockSettings.buildLine, table: "SettingsDetail"))
                            .font(MissaleFont.body(13))
                            .foregroundStyle(Palette.ink.opacity(0.55))
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(L.string("Ajustes", table: "SettingsDetail"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SettingsDestination.self) { destination in
                switch destination {
                case .subscription: SubscriptionDetailView()
                case .editName: EditNameView()
                case .regionalCalendar: RegionalCalendarView()
                case .language: LanguageSettingsView()
                case .data: DataSettingsView()
                case .support: SupportView()
                case .faq: FAQView()
                case .termsPlaceholder(let title): TermsPlaceholderView(title: title)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Eyebrow(text: L.string("Ajustes", table: "SettingsDetail"))
            NavigationLink(value: SettingsDestination.editName) {
                HStack(spacing: 6) {
                    Text(userDisplayName.isEmpty ? L.string("Adicionar seu nome", table: "SettingsDetail") : userDisplayName)
                        .font(MissaleFont.display(29, weight: .semibold))
                        .foregroundStyle(userDisplayName.isEmpty ? Palette.wine : Palette.ink)
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundStyle(Palette.ink.opacity(0.35))
                }
            }
            .buttonStyle(.plain)
            Text(L.string(MockSettings.subscriptionStatusLine, table: "SettingsDetail"))
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.ink.opacity(0.68))
        }
    }

    private var pastoralNoteCard: some View {
        NavigationLink {
            PastoralNoteDetailView()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.string("SEMPRE AQUI", table: "SettingsDetail"))
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(Palette.wine)
                    Text(L.string("Nota pastoral", table: "SettingsDetail"))
                        .font(MissaleFont.body(18, weight: .medium))
                        .foregroundStyle(Palette.ink)
                    Text(L.string("Não é confissão, direção espiritual nem terapia", table: "SettingsDetail"))
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.72))
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
            }
            .padding(17)
            .background(Palette.wine.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Palette.wine.opacity(0.24), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    /// Rows whose trailing value is a live preference rather than mock copy. A
    /// fixed string here is what made the list show the previous calendar after
    /// coming back from the picker: the picker wrote, the list never read.
    private func liveValue(for destination: SettingsDestination) -> String? {
        switch destination {
        case .language:
            resolvedLanguageName
        case .regionalCalendar:
            MockSettings.selectedRegion(
                stored: storedRegionID,
                language: AppLanguagePreference.resolve(override: languageOverride)
            )?.name
        default:
            nil
        }
    }

    private func groupSection(_ group: SettingsGroup) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Eyebrow(text: L.string(group.label, table: "SettingsDetail"))
            VStack(spacing: 0) {
                ForEach(Array(group.items.enumerated()), id: \.element.id) { index, item in
                    if index > 0 {
                        Divider().opacity(0.5)
                    }
                    NavigationLink(value: item.destination) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(L.string(item.title, table: "SettingsDetail"))
                                    .font(MissaleFont.body(17))
                                    .foregroundStyle(Palette.ink)
                                if !item.subtitle.isEmpty {
                                    Text(L.string(item.subtitle, table: "SettingsDetail"))
                                        .font(MissaleFont.body(14))
                                        .foregroundStyle(Palette.ink.opacity(0.64))
                                }
                            }
                            Spacer(minLength: 8)
                            if let live = liveValue(for: item.destination) {
                                Text(live)
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.wine)
                            } else if let value = item.value {
                                Text(L.string(value, table: "SettingsDetail"))
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(Palette.wine)
                            }
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                                .foregroundStyle(Palette.ink.opacity(0.35))
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        // Sem isto, só os glifos aceitam o toque: o vão entre o
                        // título e o valor à direita é área morta, e a linha
                        // parece não responder a quem toca no meio dela.
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .background(Color.white.opacity(0.22), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
        }
    }
}

/// Termos de uso / Política de privacidade — required by the App Store next to
/// subscription status, mocked here as a placeholder since there's no real legal
/// text for this pass.
private struct TermsPlaceholderView: View {
    let title: String
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 12) {
                Text(title)
                    .font(MissaleFont.display(24))
                Text("Texto legal ainda não escrito para esta pré-visualização.")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.6))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
