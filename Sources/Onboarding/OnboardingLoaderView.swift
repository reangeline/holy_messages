import SwiftUI

/// dIs13 — loader. Sequentially-revealing messages, auto-advances.
struct OnboardingLoaderView: View {
    let onFinished: () -> Void

    private let messages = [
        "Reading today's calendar…",
        "Matching what you shared…",
        "Building your first track…",
    ]
    @State private var visibleCount = 0

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 14) {
                CrossGlyph(size: 30)
                ForEach(0..<messages.count, id: \.self) { i in
                    Text(L.string(messages[i], table: "Onboarding"))
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.7))
                        .opacity(i < visibleCount ? 1 : 0)
                }
            }
        }
        .onAppear { reveal() }
    }

    private func reveal() {
        for i in 0..<messages.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                withAnimation { visibleCount = i + 1 }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(messages.count) * 0.5 + 0.5) {
            onFinished()
        }
    }
}
