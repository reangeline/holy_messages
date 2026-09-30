import SwiftUI

/// The climax: after reading the relief, the reader actually prays — one breath,
/// then the Our Father phrase by phrase — and lands on a first milestone.
struct OnboardingPrayerView: View {
    let onNext: () -> Void

    private enum Phase: Equatable { case intro, praying, prayed }

    @State private var phase = Phase.intro
    @State private var checkVisible = false
    /// True once the prayer-start button is pressed: the intro chrome fades
    /// out and the prayer body grows to a larger point size, reflowing in
    /// place, before `.praying` begins.
    @State private var isEmphasizing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    /// Shared exit for the intro chrome (eyebrow, title, prayer-start and
    /// skip buttons): fades out over the same 0.4 s wherever it's used.
    private let chromeExitTransition: AnyTransition = .opacity.animation(.easeInOut(duration: 0.4))

    private let phrases = OnboardingStory.ourFather[AppLanguagePreference.resolveCurrent()] ?? OnboardingStory.ourFather[.en]!
    /// Final point size of the zoomed prayer body: at least 1.5x the resting
    /// size (17), picked to still fit in 3 lines on the smallest simulator.
    private let emphasisFontSize: CGFloat = 27
    /// How long the zoomed body holds on screen before `.praying` begins.
    private let emphasisHoldDuration: Duration = .seconds(4.5)

    var body: some View {
        ZStack {
            Palette.night.ignoresSafeArea()

            switch phase {
            case .intro: intro
            case .praying:
                GuidedPrayerSequence(phrases: phrases, holdAdjustment: -1) {
                    phase = .prayed
                    withAnimation(.spring(duration: 0.8, bounce: 0.3).delay(0.4)) { checkVisible = true }
                }
            case .prayed: prayed
            }
        }
        .animation(.easeInOut(duration: 0.8), value: phase)
    }

    private var intro: some View {
        // The body text grows by a real point-size change when isEmphasizing
        // flips, reflowing from ~2 lines to ~3 inside the existing horizontal
        // padding — no GeometryReader or layout change needed.
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                if !isEmphasizing {
                    Eyebrow(text: OnboardingStory.text(OnboardingStory.prayerEyebrow), color: Palette.goldBright)
                        .transition(chromeExitTransition)
                    Text(OnboardingStory.text(OnboardingStory.prayerTitle))
                        .font(MissaleFont.display(34))
                        .foregroundStyle(.white)
                        .transition(chromeExitTransition)
                }
                Text(OnboardingStory.text(OnboardingStory.prayerBody))
                    .animatableFont(size: isEmphasizing ? emphasisFontSize : 17) { MissaleFont.body($0) }
                    .foregroundStyle(.white.opacity(0.7))
                    .accessibilityIdentifier("onboardingPrayerEmphasis")
                    .animation(reduceMotion ? nil : .spring(duration: 0.9, bounce: 0), value: isEmphasizing)
                    // Caps Dynamic Type so the zoomed ~27pt phrase doesn't
                    // balloon toward ~84pt at the largest accessibility sizes
                    // and truncate; minimumScaleFactor is the safety net that
                    // shrinks it instead of clipping the tail of the sentence,
                    // the same pattern used for tight text elsewhere in the
                    // app (WordOfDayWidget, SaintOfDayWidget, ShareCardView).
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    .minimumScaleFactor(0.5)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            Spacer()
            if !isEmphasizing {
                lightButton(OnboardingStory.text(OnboardingStory.prayerStart)) {
                    isEmphasizing = true
                    Task {
                        do {
                            try await Task.sleep(for: emphasisHoldDuration)
                            phase = .praying
                        } catch {}
                    }
                }
                .transition(chromeExitTransition)
                Button(action: onNext) {
                    Text(OnboardingStory.text(OnboardingStory.prayerSkip))
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.vertical, 14)
                }
                .padding(.bottom, 10)
                .transition(chromeExitTransition)
            }
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

/// Grows text through a real point-size change instead of `scaleEffect`, so a
/// longer, larger phrase gets the chance to reflow onto a new line as it
/// animates rather than being stretched past the screen edges.
private struct AnimatableFontSize: Animatable, ViewModifier {
    var size: CGFloat
    let font: (CGFloat) -> Font

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content.font(font(size))
    }
}

private extension View {
    func animatableFont(size: CGFloat, _ font: @escaping (CGFloat) -> Font) -> some View {
        modifier(AnimatableFontSize(size: size, font: font))
    }
}
