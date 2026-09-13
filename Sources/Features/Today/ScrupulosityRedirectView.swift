import SwiftUI

/// Screen 7 (eIs7) — redirects repeated scrupulous questioning to a fixed confessor
/// rather than more app-provided reassurance. In the real product this fires from a
/// repeated-question detector; this pass has no such detector, so it's only
/// reachable from Today's debug menu.
struct ScrupulosityRedirectView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Button("‹ Voltar") { dismiss() }
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.wine)

                    Eyebrow(text: "Você já trouxe isso três vezes")
                    Text("Esta pergunta não é para um app")
                        .font(MissaleFont.display(28, weight: .semibold))
                        .foregroundStyle(Palette.ink)
                    Text("Repetir a mesma dúvida de consciência até vir a resposta certa alimenta o escrúpulo em vez de aliviá-lo. A tradição é clara: isso se resolve com um confessor fixo, alguém que conheça sua história e possa dizer quando parar.")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.75))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Encontrar um confessor fixo").font(MissaleFont.body(18, weight: .medium))
                            Text("Paróquias perto de você com horário regular de confissão e direção espiritual.")
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }

                    Text("Enquanto isso: uma vez confessado, está confessado. Não vamos devolver mais garantias sobre este ponto — e isso é cuidado, não abandono.")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.8))
                        .padding(14)
                        .background(Palette.wine.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Palette.wine.opacity(0.22), lineWidth: 1))

                    Spacer(minLength: 8)

                    Button {
                        dismiss()
                    } label: {
                        Text("Ver paróquias")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Palette.wine, in: Capsule())
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ScrupulosityRedirectView()
}
