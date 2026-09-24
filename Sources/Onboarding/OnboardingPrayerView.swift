import SwiftUI

/// The climax: after reading the relief, the reader actually prays — one breath,
/// then the Our Father phrase by phrase — and lands on a first milestone.
struct OnboardingPrayerView: View {
    let onNext: () -> Void

    private enum Phase: Equatable { case intro, praying, prayed }

    @State private var phase = Phase.intro
    @State private var checkVisible = false

    private let phrases = OnboardingStory.ourFather[AppLanguagePreference.resolveCurrent()] ?? OnboardingStory.ourFather[.en]!

    var body: some View {
        ZStack {
            Palette.night.ignoresSafeArea()

            switch phase {
            case .intro: intro
            case .praying:
                GuidedPrayerSequence(phrases: phrases) {
                    phase = .prayed
                    withAnimation(.spring(duration: 0.8, bounce: 0.3).delay(0.4)) { checkVisible = true }
                }
            case .prayed: prayed
            }
        }
        .animation(.easeInOut(duration: 0.8), value: phase)
    }

    private var intro: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                Eyebrow(text: OnboardingStory.text(OnboardingStory.prayerEyebrow), color: Palette.goldBright)
                Text(OnboardingStory.text(OnboardingStory.prayerTitle))
                    .font(MissaleFont.display(34))
                    .foregroundStyle(.white)
                Text(OnboardingStory.text(OnboardingStory.prayerBody))
                    .font(MissaleFont.body(17))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            Spacer()
            lightButton(OnboardingStory.text(OnboardingStory.prayerStart)) {
                phase = .praying
            }
            Button(action: onNext) {
                Text(OnboardingStory.text(OnboardingStory.prayerSkip))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.vertical, 14)
            }
            .padding(.bottom, 10)
        }
        .transition(.opacity)
    }

    private var prayed: some View {
        let day = MockLiturgical.today
        return VStack(spacing: 0) {
            Spacer()
            ZStack {
                Circle().strokeBorder(Palette.goldBright.opacity(0.35), lineWidth: 1).frame(width: 120, height: 120)
                Image(systemName: "checkmark")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(Palette.goldBright)
            }
            .scaleEffect(checkVisible ? 1 : 0.6)
            .opacity(checkVisible ? 1 : 0)
            .padding(.bottom, 28)

            Text(OnboardingStory.text(OnboardingStory.prayedTitle))
                .font(MissaleFont.display(32))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Text("\(day.weekdayLabel), \(day.dayMonthLabel)".uppercased())
                .font(MissaleFont.body(12, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Palette.goldBright)
                .padding(.top, 12)
            Text(OnboardingStory.text(OnboardingStory.prayedBody))
                .font(MissaleFont.body(17))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.top, 10)
            Spacer()
            lightButton(OnboardingStory.text(OnboardingStory.continueLabel), action: onNext)
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .transition(.opacity)
        .sensoryFeedback(.success, trigger: checkVisible)
    }

    private func lightButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(MissaleFont.body(17, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(Palette.night)
                .background(.white, in: Capsule())
        }
        .padding(.horizontal, 24)
    }
}
