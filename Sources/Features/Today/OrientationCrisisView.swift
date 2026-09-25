import SwiftUI

/// Shown before the reply when what the reader wrote carries a sign of risk to
/// their life (Jev's risk answer, or a reviewed phrase). Text only, with no
/// number of our own — see CrisisLines. The reply is still one tap away: the
/// reader decides, and a false alarm costs only this screen.
struct OrientationCrisisView: View {
    var onContinue: () -> Void
    @State private var showPastoralCare = false

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
        .sheet(isPresented: $showPastoralCare) {
            PastoralCareNudgeView()
                .appLanguageLocale()
        }
    }
}
