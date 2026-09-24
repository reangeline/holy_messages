import SwiftUI

/// dIs15 — notification times: one or more, each with its hour adjustable.
struct OnboardingNotificationTimeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("When should the day's reading reach you?", tableName: "Onboarding")
                            .font(MissaleFont.display(27))
                            .foregroundStyle(Palette.ink)
                            .padding(.top, 20)
                        Text("Choose one or more. Tap the hour to adjust it.", tableName: "Onboarding")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.65))

                        VStack(spacing: 10) {
                            ForEach(MockOnboarding.notificationTimes(for: AppLanguagePreference.resolveCurrent()), id: \.id) { time in
                                VStack(spacing: 0) {
                                    OnboardingOptionChip(
                                        text: time.title,
                                        subtitle: time.subtitle,
                                        isSelected: viewModel.notificationTimes[time.id] != nil
                                    ) {
                                        viewModel.toggleNotificationTime(id: time.id, defaultMinutes: time.minutes)
                                    }
                                    if let minutes = viewModel.notificationTimes[time.id] {
                                        DatePicker(
                                            L.string("Time", table: "Onboarding"),
                                            selection: hourBinding(id: time.id, minutes: minutes),
                                            displayedComponents: .hourAndMinute
                                        )
                                        .font(MissaleFont.body(15))
                                        .tint(Palette.wine)
                                        .environment(\.locale, AppLanguagePreference.resolveCurrent().locale)
                                        .padding(.horizontal, 18)
                                        .padding(.top, 8)
                                        .transition(.opacity)
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                        .animation(.easeOut(duration: 0.2), value: viewModel.notificationTimes)
                    }
                    .padding(.horizontal, 24)
                }
                OnboardingPrimaryButton(title: L.string("See what it looks like", table: "Onboarding"),
                                        isEnabled: !viewModel.notificationTimes.isEmpty, action: onNext)
                    .padding(.vertical, 20)
            }
        }
    }

    /// The picker works in dates; the choice is kept as minutes after midnight.
    private func hourBinding(id: String, minutes: Int) -> Binding<Date> {
        Binding(
            get: { Calendar.current.date(bySettingHour: minutes / 60, minute: minutes % 60, second: 0, of: Date()) ?? Date() },
            set: { date in
                let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
                viewModel.notificationTimes[id] = (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
            }
        )
    }
}
