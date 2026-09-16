import SwiftUI

/// Spec §8.3 — "the lock screen is a design surface": what you'd see reaching for
/// the blocked app during one of SocialLockSetupView's windows. A mockup only —
/// see that file for why nothing here actually blocks anything yet. Deliberately
/// reuses AngelusNudgeView's exact grammar (liturgical color, the day, a quiet
/// non-judgmental way through) since that screen already IS this design, just
/// for one specific trigger; this generalizes it to any of them.
struct SocialLockPreviewView: View {
    let trigger: SocialLockRule
    let onDismiss: () -> Void

    private let day = MockLiturgical.today

    var body: some View {
        ZStack {
            LinearGradient(colors: [day.color.accent.opacity(0.94), day.color.accent.opacity(0.7)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()
                CrossGlyph(size: 34, color: .white)
                Eyebrow(text: "\(day.feastName) · \(day.color.name)", color: .white)
                    .multilineTextAlignment(.center)
                Text("Agora é \(trigger.title.lowercased())")
                    .font(MissaleFont.display(28, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text(trigger.detail)
                    .font(MissaleFont.body(16))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    Button {
                        onDismiss()
                    } label: {
                        Text("Abrir o Missale")
                            .font(MissaleFont.body(17))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.white, in: Capsule())
                            .foregroundStyle(day.color.accent)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 8)

                Button {
                    onDismiss()
                } label: {
                    Text("Continuar mesmo assim")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.65))
                }

                Spacer()
                Text("A saída está sempre aqui. Sem cobrança, sem contador de recaída.")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    SocialLockPreviewView(trigger: MockSocialLock.rules[0]) {}
}
