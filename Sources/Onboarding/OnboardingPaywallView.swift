import SwiftUI

/// dIs17 — paywall. UI-only, no real StoreKit purchase; both close and CTA finish onboarding.
struct OnboardingPaywallView: View {
    let onFinish: () -> Void

    @State private var selectedPlanID = OnboardingPaywallContent.plans[1].id

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            VStack(spacing: 0) {
                HStack {
                    Button(action: onFinish) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Palette.ink.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 14) {
                        Eyebrow(text: "Missale Premium")
                        Text("Stay with it through the whole year")
                            .font(MissaleFont.display(28))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Palette.ink)

                        HStack(spacing: 6) {
                            Text("4.8")
                                .font(MissaleFont.body(15, weight: .semibold))
                            Text("\u{2605}\u{2605}\u{2605}\u{2605}\u{2605}")
                                .foregroundStyle(Palette.goldMuted)
                            Text("12.4K App Ratings")
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.55))
                        }

                        VStack(spacing: 10) {
                            ForEach(OnboardingPaywallContent.plans) { plan in
                                Button {
                                    selectedPlanID = plan.id
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack(spacing: 6) {
                                                Text(plan.title).font(MissaleFont.body(16, weight: .medium))
                                                if let badge = plan.badge {
                                                    Text(badge.uppercased())
                                                        .font(.system(size: 10, weight: .bold))
                                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                                        .background(Palette.goldMuted, in: Capsule())
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                            Text(plan.subtitle).font(MissaleFont.body(13)).foregroundStyle(Palette.ink.opacity(0.6))
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(plan.rate).font(MissaleFont.body(16, weight: .semibold))
                                            Text(plan.total).font(MissaleFont.body(12)).foregroundStyle(Palette.ink.opacity(0.5))
                                        }
                                    }
                                    .padding(14)
                                    .background(Color.white.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .strokeBorder(selectedPlanID == plan.id ? Palette.wine : Color.black.opacity(0.08), lineWidth: selectedPlanID == plan.id ? 2 : 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .foregroundStyle(Palette.ink)

                        VStack(alignment: .leading, spacing: 8) {
                            featureRow("The Mass, part by part \u{2014} all 14 parts")
                            featureRow("Every season and feast explained as it arrives")
                            featureRow("Traditional prayers and Compline for the night")
                            featureRow("The daily verse, the saint, and the safety net stay free forever.", dimmed: true)
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                }

                VStack(spacing: 8) {
                    OnboardingPrimaryButton(title: "Try free for 30 days", action: onFinish)
                    Text("First 30 days free, then \(OnboardingPaywallContent.planPrice). Cancel anytime. T&C")
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.5))
                }
                .padding(.bottom, 24)
                .background(.ultraThinMaterial)
            }
        }
    }

    private func featureRow(_ text: String, dimmed: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(dimmed ? Palette.ink.opacity(0.4) : Palette.wine)
            Text(text)
                .font(MissaleFont.body(14))
                .foregroundStyle(dimmed ? Palette.ink.opacity(0.5) : Palette.ink.opacity(0.85))
        }
    }
}
