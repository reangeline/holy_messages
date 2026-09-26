import AVFoundation
import SwiftUI

/// Shared small pieces used across many onboarding screens. Kept local to this
/// folder (not promoted to DesignSystem) since they're onboarding-flow-specific
/// chrome (back/skip header, option chips, progress dots/bar).

struct OnboardingTopBar: View {
    var onBack: (() -> Void)? = nil
    var trailingText: String? = nil
    var trailingAction: (() -> Void)? = nil
    var tint: Color = Palette.wine

    var body: some View {
        HStack {
            if let onBack {
                Button(action: onBack) {
                    Text("‹ \(L.string( "Back", table: "Onboarding"))")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(tint)
                }
            } else {
                Spacer().frame(width: 1)
            }
            Spacer()
            if let trailingText, let trailingAction {
                Button(action: trailingAction) {
                    Text(trailingText)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(tint.opacity(0.75))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}

struct OnboardingProgressBar: View {
    var progress: Double // 0...1
    var tint: Color = Palette.wine

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(tint.opacity(0.15))
                Capsule().fill(tint).frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, 24)
    }
}

struct OnboardingOptionChip: View {
    let text: String
    var subtitle: String? = nil
    let isSelected: Bool
    var glass: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(text).font(MissaleFont.body(17, weight: .medium))
                    if let subtitle {
                        Text(subtitle).font(MissaleFont.body(14)).foregroundStyle(Palette.ink.opacity(0.6))
                    }
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Palette.wine : Palette.ink.opacity(0.25))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                Group {
                    if glass {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Palette.wine.opacity(0.6) : Color.black.opacity(0.08), lineWidth: isSelected ? 1.5 : 1)
            )
            .foregroundStyle(Palette.ink)
        }
        .buttonStyle(.plain)
    }
}

struct OnboardingPrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(MissaleFont.body(17, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Palette.wine.opacity(isEnabled ? 1 : 0.4), in: Capsule())
                .foregroundStyle(.white)
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 24)
    }
}

struct OnboardingTextLink: View {
    let title: String
    var tint: Color = Palette.ink.opacity(0.55)
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(MissaleFont.body(15))
                .foregroundStyle(tint)
        }
        .padding(.top, 4)
    }
}

/// Press and hold to confirm: the fill grows while pressed and resets on release,
/// so the commitment is a small deliberate act rather than a tap.
struct OnboardingHoldButton: View {
    let title: String
    var duration: Double = 1.5
    let action: () -> Void

    @State private var progress = 0.0
    @State private var committed = false

    var body: some View {
        Text(title)
            .font(MissaleFont.body(17, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.white)
            .background {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Palette.wine.opacity(0.45)
                        Palette.wine.frame(width: proxy.size.width * progress)
                    }
                }
                .clipShape(Capsule())
            }
            .scaleEffect(progress > 0 && !committed ? 0.97 : 1)
            .padding(.horizontal, 24)
            .onLongPressGesture(minimumDuration: duration) {
                committed = true
                action()
            } onPressingChanged: { pressing in
                guard !committed else { return }
                withAnimation(pressing ? .linear(duration: duration) : .easeOut(duration: 0.25)) {
                    progress = pressing ? 1 : 0
                }
            }
            .sensoryFeedback(.success, trigger: committed)
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { committed = true; action() }
    }
}

// MARK: - Plan video

/// The feature-reel slot on the "short plan" (synthesis) screen. Drop a file
/// named exactly `onboarding-plano.mp4` into `Sources/Resources/` (bundled as
/// a plain resource, same as the Bible JSON files there) and it starts
/// playing automatically — nothing else to wire up. Until that file exists,
/// this shows a tasteful placeholder instead of a broken or blank box.
struct OnboardingPlanVideoSlot: View {
    private static let resourceURL = Bundle.main.url(forResource: "onboarding-plano", withExtension: "mp4")

    var body: some View {
        ZStack {
            if let url = Self.resourceURL {
                LoopingSilentVideo(url: url)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Palette.ink.opacity(0.3))
                    Text("Video coming soon", tableName: "Onboarding")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.45))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .background(Palette.ink.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06))
        )
    }
}

/// Muted, looping, chrome-free video. AVKit's `VideoPlayer` always shows
/// playback controls, so this wraps `AVPlayerLayer` directly instead.
private struct LoopingSilentVideo: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PlayerLayerView {
        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer()
        player.isMuted = true
        context.coordinator.looper = AVPlayerLooper(player: player, templateItem: item)
        let view = PlayerLayerView()
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspectFill
        player.play()
        return view
    }

    func updateUIView(_ uiView: PlayerLayerView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        var looper: AVPlayerLooper?
    }

    final class PlayerLayerView: UIView {
        override static var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }
}
