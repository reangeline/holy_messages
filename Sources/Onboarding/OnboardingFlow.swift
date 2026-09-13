import SwiftUI

/// Placeholder root for the onboarding flow (t3/3a, 18 screens) — replaced with the
/// full life-state/spiritual-state/paywall flow in a later pass.
struct OnboardingFlow: View {
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 20) {
                CrossGlyph(size: 36)
                Text("Missale")
                    .font(MissaleFont.display(34))
                Button("Entrar (placeholder)", action: onFinished)
                    .font(MissaleFont.body(17, weight: .medium))
                    .padding()
                    .background(Palette.wine, in: Capsule())
                    .foregroundStyle(.white)
            }
        }
    }
}
