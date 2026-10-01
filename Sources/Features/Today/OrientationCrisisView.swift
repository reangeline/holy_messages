import SwiftUI

/// Shown before the reply when what the reader wrote carries a sign of risk to
/// their life (Jev's risk answer, or a reviewed phrase). Text only, with no
/// number of our own — see CrisisLines. The reply is still one tap away: the
/// reader decides, and a false alarm costs only this screen.
///
/// `reflect` asks for the crisis reflection (about God, support and a priest
/// at a nearby parish): shown in a card below the support, a discreet
/// indicator while it loads, and no card at all if it fails. Asked once, and
/// never saved; nil asks nothing.
struct OrientationCrisisView: View {
    var reflect: (() async -> String?)? = nil
    var onContinue: () -> Void
    @State private var showPastoralCare = false
    @State private var reflection: String?
    @State private var isReflecting = false

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Eyebrow(text: L.string("Antes de tudo", table: "Today"))
                    Text("O que você escreveu pede cuidado", tableName: "Today")
                        .font(MissaleFont.display(28, weight: .semibold))
                        .foregroundStyle(Palette.ink)
                    Text("Você não precisa atravessar isso sozinho. Falar com alguém agora pode ser o passo mais importante do dia.", tableName: "Today")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    LiturgicalGradientCard(color: .red) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(CrisisLines.current.title)
                                .font(MissaleFont.body(18, weight: .medium))
                                .foregroundStyle(.white)
                            Text(CrisisLines.current.message)
                                .font(MissaleFont.body(15))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .accessibilityIdentifier("orientationCrisis")

                    Button {
                        showPastoralCare = true
                    } label: {
                        Text("Padre, diocese e outros caminhos de apoio", tableName: "Today")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.wine)
                            .underline()
                    }
                    .buttonStyle(.plain)

                    // Below the support, never above it: a ~150-word
                    // reflection arriving seconds later must not push the
                    // ways to get help off the screen.
                    reflectionCard

                    Button(action: onContinue) {
                        Text("Continuar para a palavra de hoje", tableName: "Today")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(Palette.wine.opacity(0.3), lineWidth: 1))
                            .foregroundStyle(Palette.ink)
                    }
                    .padding(.top, 8)
                    .accessibilityIdentifier("orientationContinue")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
        }
        .task {
            // Ask once; a later failure never wipes what is already shown.
            guard let reflect, reflection == nil, !isReflecting else { return }
            isReflecting = true
            let result = await reflect()
            if let result { withAnimation(.easeInOut(duration: 0.25)) { reflection = result } }
            isReflecting = false
        }
        .sheet(isPresented: $showPastoralCare) {
            PastoralCareNudgeView()
                .appLanguageLocale()
        }
    }

    /// Absent until the reflection arrives, and for good if it never does.
    @ViewBuilder
    private var reflectionCard: some View {
        if let reflection {
            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text(reflection)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.75))
                    Text("Escrita por IA.", tableName: "Today")
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.45))
                }
            }
            .transition(.opacity)
            .accessibilityIdentifier("orientationCrisisReflection")
        } else if isReflecting {
            ProgressView().tint(Palette.wine)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier("orientationCrisisReflectionLoading")
        }
    }
}

/// The same crisis guidance, as a card inside another screen: what the
/// personalized features (JevPicker) show above their suggestion when what the
/// reader wrote carries a sign of risk. Same copy as the screen above.
struct CrisisSupportCard: View {
    @State private var showPastoralCare = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Eyebrow(text: L.string("Antes de tudo", table: "Today"))
            Text("O que você escreveu pede cuidado", tableName: "Today")
                .font(MissaleFont.display(22, weight: .semibold))
                .foregroundStyle(Palette.ink)
            Text("Você não precisa atravessar isso sozinho. Falar com alguém agora pode ser o passo mais importante do dia.", tableName: "Today")
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.ink.opacity(0.75))
            LiturgicalGradientCard(color: .red) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(CrisisLines.current.title)
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(.white)
                    Text(CrisisLines.current.message)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            Button {
                showPastoralCare = true
            } label: {
                Text("Padre, diocese e outros caminhos de apoio", tableName: "Today")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.wine)
                    .underline()
            }
            .buttonStyle(.plain)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("crisisSupportCard")
        .sheet(isPresented: $showPastoralCare) {
            PastoralCareNudgeView()
                .appLanguageLocale()
        }
    }
}
