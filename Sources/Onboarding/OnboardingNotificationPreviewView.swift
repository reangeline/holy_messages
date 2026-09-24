import SwiftUI

/// dIs16 — notification preview, then a REAL system permission request
/// (UNUserNotificationCenter), not a mocked dialog.
struct OnboardingNotificationPreviewView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onAllow: () -> Void
    let onNotNow: () -> Void

    private var timeHour: String {
        ReadingReminderScheduler.label(Array(viewModel.notificationTimes.values))
    }

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(L.string("This is what arrives at {time}", table: "Onboarding")
                            .replacingOccurrences(of: "{time}", with: timeHour))
                            .font(MissaleFont.display(26))
                            .foregroundStyle(Palette.ink)
                            .padding(.top, 20)
                        Text("No badges, no nudging.", tableName: "Onboarding")
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
                                    Text("now", tableName: "Onboarding")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Palette.ink.opacity(0.4))
                                }
                                // Exactly what ReadingReminderScheduler sends: the
                                // preview used to promise a feast and a formation part
                                // that the notice never carried.
                                Text(L.string("Palavra de hoje", table: "Today"))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Palette.ink)
                                Text("\u{201C}\(MockWordOfDay.today.quote)\u{201D} \(MockWordOfDay.today.reference)")
                                    .lineLimit(3)
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
                OnboardingPrimaryButton(title: L.string("Send it to me daily", table: "Onboarding"), action: onAllow)
                OnboardingTextLink(title: L.string("Not now", table: "Onboarding"), action: onNotNow)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            }
        }
    }
}
