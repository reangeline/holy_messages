import SwiftUI

/// The climax: after reading the relief, the reader actually prays — one breath,
/// then the Our Father phrase by phrase — and lands on a first milestone.
struct OnboardingPrayerView: View {
    let onNext: () -> Void

    private enum Phase: Equatable { case intro, praying, prayed }

    @State private var phase = Phase.intro
    @State private var checkVisible = false
    /// True once the prayer-start button is pressed: the intro chrome fades
    /// out in place and, a beat later, the prayer body grows to its
    /// emphasized size — two separate, sequenced movements instead of one.
    @State private var isEmphasizing = false
    /// True during the short fade that closes the emphasized body before
    /// `.praying` begins, so the handoff to the breathing circle isn't a
    /// cross-dissolve straight from the giant text — the screen goes quiet
    /// first.
    @State private var isEmphasisExiting = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let phrases = OnboardingStory.ourFather[AppLanguagePreference.resolveCurrent()] ?? OnboardingStory.ourFather[.en]!
    /// Final point size of the emphasized prayer body: at least 1.5x the
    /// resting size (17), picked to still fit in 3 lines on the smallest
    /// simulator.
    private let emphasisFontSize: CGFloat = 27
    /// How long the emphasized body holds on screen, fully grown, before it
    /// starts fading out toward `.praying`.
    private let emphasisHoldDuration: Duration = .seconds(4.5)
    /// How long the intro chrome (eyebrow, title, buttons) takes to fade out
    /// in place once "Rezar agora" is tapped — it runs before the body text
    /// starts growing, so the two movements read as separate beats.
    private let chromeFadeDuration: Double = 1.1
    /// How long the body text waits, after the tap, before it starts
    /// growing — long enough for the chrome fade to already be underway.
    private let bodyGrowDelay: Double = 0.35
    /// How long the body text's grow (point-size change from 17 to
    /// `emphasisFontSize`) takes to settle.
    private let bodyGrowDuration: Double = 1.15
    /// How long the emphasized text takes to fade out before `.praying`
    /// begins.
    private let emphasisExitDuration: Double = 0.6

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
        // Chrome elements stay in the hierarchy and just fade to 0 in place
        // (instead of being removed with `if`), so their layout space stays
        // reserved and the body text below never gets recentred mid-growth —
        // that recentring, happening at the same time as the font grew, was
        // what made the old transition feel abrupt.
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                Eyebrow(text: OnboardingStory.text(OnboardingStory.prayerEyebrow), color: Palette.goldBright)
                    .chromeFade(hidden: isEmphasizing, duration: chromeFadeDuration)
                Text(OnboardingStory.text(OnboardingStory.prayerTitle))
                    .font(MissaleFont.display(34))
                    .foregroundStyle(.white)
                    .chromeFade(hidden: isEmphasizing, duration: chromeFadeDuration)
                emphasizedBody
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            Spacer()
            lightButton(OnboardingStory.text(OnboardingStory.prayerStart)) {
                beginEmphasis()
            }
            .chromeFade(hidden: isEmphasizing, duration: chromeFadeDuration)
            Button(action: onNext) {
                Text(OnboardingStory.text(OnboardingStory.prayerSkip))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.vertical, 14)
            }
            .padding(.bottom, 10)
            .chromeFade(hidden: isEmphasizing, duration: chromeFadeDuration)
        }
        .transition(.opacity)
    }

    /// The prayer body grows by a real point-size change (not `scaleEffect`),
    /// so the longer, larger phrase gets to reflow onto a third line as it
    /// animates rather than being stretched past the screen edges. The grow
    /// itself is delayed (`bodyGrowDelay`) until the chrome fade above is
    /// already underway, and slowed down (`bodyGrowDuration`), so growing
    /// reads as its own deliberate beat instead of happening at the same
    /// moment as — and competing with — the chrome disappearing.
    private var emphasizedBody: some View {
        Text(OnboardingStory.text(OnboardingStory.prayerBody))
            .animatableFont(size: isEmphasizing ? emphasisFontSize : 17) { MissaleFont.body($0) }
            .foregroundStyle(.white.opacity(0.7))
            .opacity(isEmphasisExiting ? 0 : 1)
            .accessibilityIdentifier("onboardingPrayerEmphasis")
            .animation(
                reduceMotion ? nil : .spring(duration: bodyGrowDuration, bounce: 0).delay(bodyGrowDelay),
                value: isEmphasizing
            )
            .animation(.easeInOut(duration: emphasisExitDuration), value: isEmphasisExiting)
            // Caps Dynamic Type so the emphasized ~27pt phrase doesn't
            // balloon toward ~84pt at the largest accessibility sizes
            // and truncate; minimumScaleFactor is the safety net that
            // shrinks it instead of clipping the tail of the sentence,
            // the same pattern used for tight text elsewhere in the
            // app (WordOfDayWidget, SaintOfDayWidget, ShareCardView).
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            .minimumScaleFactor(0.5)
    }

    private func beginEmphasis() {
        isEmphasizing = true
        Task {
            do {
                try await Task.sleep(for: emphasisHoldDuration)
                isEmphasisExiting = true
                try await Task.sleep(for: .seconds(emphasisExitDuration))
                phase = .praying
            } catch {}
        }
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

    /// Fades a chrome element (eyebrow, title, prayer-start/skip buttons)
    /// out in place — opacity only, staying in the hierarchy — so its
    /// layout space stays reserved and nothing around it (namely the
    /// emphasized body text) gets recentred when it disappears.
    func chromeFade(hidden: Bool, duration: Double) -> some View {
        self
            .opacity(hidden ? 0 : 1)
            .allowsHitTesting(!hidden)
            .accessibilityHidden(hidden)
            .animation(.easeInOut(duration: duration), value: hidden)
    }
}
