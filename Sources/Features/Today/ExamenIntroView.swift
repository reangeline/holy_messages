import SwiftUI

/// Screen 4 (eIs4) — Examen intro, dark themed, four Ignatian steps.
struct ExamenIntroView: View {
    var onFinished: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @State private var goToExamenFlow = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Button(L.string("‹ Voltar", table: "Today")) { dismiss() }
                        .foregroundStyle(Palette.goldBright)
                    Spacer()
                    Text(ExamenSchedule.timeLabel)
                        .font(MissaleFont.body(12, weight: .semibold))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.top, 8)

                Eyebrow(text: L.string("O Exame", table: "Today"), color: Palette.goldBright)
                Text("Como foi o seu dia diante de Deus?", tableName: "Today")
                    .font(MissaleFont.display(32, weight: .semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Rever o dia, reconhecer onde houve consolação e onde houve desolação, e responder. É a prática inaciana, em quatro toques.", tableName: "Today")
                    .font(MissaleFont.body(16))
                    .foregroundStyle(.white.opacity(0.7))

                NavigationLink {
                    ExamenHistoryView()
                } label: {
                    Text("Ver Exames anteriores ›", tableName: "Today")
                        .font(MissaleFont.body(14, weight: .medium))
                        .foregroundStyle(Palette.goldBright)
                }

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
                    goToExamenFlow = true
                } label: {
                    Text("Começar o Exame", tableName: "Today")
                        .font(MissaleFont.body(18))
                        .frame(maxWidth: .infinity)
                        .padding(17)
                        .background(Palette.goldBright, in: Capsule())
                        .foregroundStyle(Color(hex: 0x2A1A1C))
                }

                // O cartão do Hoje promete "Exame do dia e Completas", e as
                // Completas ficaram sem porta quando o Exame virou fluxo
                // guiado. Quem só quer a oração da noite entra por aqui.
                NavigationLink {
                    ComplineView()
                } label: {
                    Text("Ir direto às Completas", tableName: "Today")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.goldBright)
                        .padding(.top, 14)
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToExamenFlow) {
            ExamenFlowView(onFinished: onFinished)
        }
    }
}

#Preview {
    NavigationStack { ExamenIntroView() }
}
