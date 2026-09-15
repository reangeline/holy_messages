import SwiftUI

/// dIs15 — notification time picker.
struct OnboardingNotificationTimeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onNext: () -> Void
    @Environment(\.locale) private var locale

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("When should the day's reading reach you?")
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)
                            .padding(.top, 20)
                        Text("One notice a day. Choose the hour that already belongs to prayer.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.65))

                        VStack(spacing: 10) {
                            ForEach(Array(MockOnboarding.notificationTimes(for: AppLanguage.current(from: locale)).enumerated()), id: \.offset) { _, time in
                                OnboardingOptionChip(
                                    text: time.title,
                                    subtitle: time.subtitle,
                                    isSelected: viewModel.selectedNotificationTimeID == time.id
                                ) {
                                    viewModel.selectedNotificationTimeID = time.id
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                }
                OnboardingPrimaryButton(title: "See what it looks like", action: onNext)
                    .padding(.vertical, 20)
            }
        }
    }
}
