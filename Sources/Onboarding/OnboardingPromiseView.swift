import SwiftUI

/// Bridge between the opening verse and the questions: names the problem and
/// the promise, still on black, so the questions arrive with a reason.
struct OnboardingPromiseView: View {
    let onContinue: () -> Void

    private let lines = OnboardingStory.promiseLines.map(OnboardingStory.text)
    @State private var shown = 0
    @State private var showLead = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 22) {
                    ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                        let isVisible = index < shown
                        Text(line)
                            .font(MissaleFont.display(index == 0 ? 36 : 28))
                            .foregroundStyle(.white.opacity(index == 0 ? 1 : 0.82))
                            .multilineTextAlignment(.center)
                            .opacity(isVisible ? 1 : 0)
                            .blur(radius: isVisible ? 0 : 8)
                            .offset(y: isVisible ? 0 : 6)
                    }
                }
                .padding(.horizontal, 32)
                Spacer()

                ZStack {
                    if showLead {
                        VStack(spacing: 18) {
                            Text(OnboardingStory.text(OnboardingStory.promiseLead))
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.goldBright)
                            Button(action: onContinue) {
                                Text(OnboardingStory.text(OnboardingStory.begin))
                                    .font(MissaleFont.body(17, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .foregroundStyle(.black)
                                    .background(.white, in: Capsule())
                            }
                            .padding(.horizontal, 24)
                        }
                        .transition(.opacity)
                    }
                }
                .frame(height: 110)
                .padding(.bottom, 24)
            }
        }
        .task { await play() }
    }

    private func play() async {
        do {
            try await Task.sleep(for: .milliseconds(500))
            while shown < lines.count {
                withAnimation(.easeOut(duration: 1)) { shown += 1 }
                try await Task.sleep(for: .seconds(1.8))
            }
            withAnimation(.easeIn(duration: 0.8)) { showLead = true }
        } catch {}
    }
}
