import SwiftUI

/// dIs16 — notification preview, then a REAL system permission request
/// (UNUserNotificationCenter), not a mocked dialog.
struct OnboardingNotificationPreviewView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onAllow: () -> Void
    let onNotNow: () -> Void
    @Environment(\.locale) private var locale

    private var timeHour: String {
        MockOnboarding.notificationTimes(for: AppLanguage.current(from: locale)).first { $0.id == viewModel.selectedNotificationTimeID }?.hour ?? "7:00 AM"
    }

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("This is what arrives at \(timeHour)")
                            .font(MissaleFont.display(26))
                            .foregroundStyle(Palette.ink)
                            .padding(.top, 20)
                        Text("One notice. No badges, no nudging.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.65))

                        HStack(alignment: .top, spacing: 10) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Palette.wine)
                                .frame(width: 34, height: 34)
                                .overlay(CrossGlyph(size: 16, color: .white, lineWidth: 1.5))
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("MISSALE")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Palette.ink.opacity(0.6))
                                    Spacer()
                                    Text("now")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Palette.ink.opacity(0.4))
                                }
                                Text("Exaltation of the Holy Cross \u{00B7} Red")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Palette.ink)
                                Text("\u{201C}So must the Son of Man be lifted up.\u{201D} John 3:14 \u{2014} and part 1 of The Mass, part by part.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Palette.ink.opacity(0.8))
                            }
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                }
                OnboardingPrimaryButton(title: "Send it to me daily", action: onAllow)
                OnboardingTextLink(title: "Not now", action: onNotNow)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            }
        }
    }
}
