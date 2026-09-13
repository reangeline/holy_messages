import SwiftUI

/// Screen 4 (eIs4) — Examen intro, dark themed, four Ignatian steps.
struct ExamenIntroView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var goToCompline = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Button("‹ Voltar") { dismiss() }
                        .foregroundStyle(Palette.goldBright)
                    Spacer()
                    Text("21H30")
                        .font(MissaleFont.body(12, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.top, 8)

                Eyebrow(text: "O Exame", color: Palette.goldBright)
                Text("Como foi o seu dia diante de Deus?")
                    .font(MissaleFont.display(32, weight: .semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Rever o dia, reconhecer onde houve consolação e onde houve desolação, e responder. É a prática inaciana, em quatro toques.")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(.white.opacity(0.7))

                VStack(spacing: 10) {
                    ForEach(MockRosary.examenSteps) { step in
                        HStack(alignment: .top, spacing: 13) {
                            Text("\(step.number)")
                                .font(MissaleFont.display(20))
                                .foregroundStyle(Palette.goldBright)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(step.title).font(MissaleFont.body(17, weight: .medium)).foregroundStyle(.white)
                                Text(step.subtitle)
                                    .font(MissaleFont.body(15))
                                    .foregroundStyle(.white.opacity(0.62))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.16), lineWidth: 1))
                    }
                }

                Spacer()

                Button {
                    goToCompline = true
                } label: {
                    Text("Começar o Exame")
                        .font(MissaleFont.body(18))
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(Palette.goldBright, in: Capsule())
                        .foregroundStyle(Color(hex: 0x2A1A1C))
                }
                Button {
                    goToCompline = true
                } label: {
                    Text("Ir direto às Completas")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToCompline) {
            ComplineView()
        }
    }
}

#Preview {
    NavigationStack { ExamenIntroView() }
}
