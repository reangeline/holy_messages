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
                    Text("‹ Back")
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
        .padding(.top, 60)
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
