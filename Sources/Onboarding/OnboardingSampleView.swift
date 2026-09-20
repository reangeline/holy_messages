import SwiftUI

/// dIs1 — sample article, tabbed. Free to explore before any account/question.
struct OnboardingSampleView: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    @State private var selectedTabID: String = ""

    private var tabs: [SampleTab] { MockOnboarding.sampleTabs(for: AppLanguagePreference.resolveCurrent()) }

    private var selectedTab: SampleTab {
        tabs.first { $0.id == selectedTabID } ?? tabs[0]
    }

    var body: some View {
        ZStack {
            Palette.parchment.ignoresSafeArea()
            VStack(spacing: 0) {
                OnboardingTopBar(onBack: onBack)
                Text("Free to explore", tableName: "Onboarding")
                    .font(MissaleFont.body(13, weight: .semibold))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                    .padding(.top, 6)

                HStack(spacing: 8) {
                    ForEach(tabs) { tab in
                        Button {
                            selectedTabID = tab.id
                        } label: {
                            Text(tab.label)
                                .font(MissaleFont.body(14, weight: .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(tab.id == selectedTabID ? Palette.wine : Color.white)
                                .foregroundStyle(tab.id == selectedTabID ? .white : Palette.ink.opacity(0.7))
                                .clipShape(Capsule())
                                .overlay(Capsule().strokeBorder(Color.black.opacity(0.08)))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 14)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Eyebrow(text: selectedTab.kicker)
                        Text(selectedTab.title)
                            .font(MissaleFont.display(26))
                            .foregroundStyle(Palette.ink)
                        Text(selectedTab.body)
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.78))
                        Text(selectedTab.quote)
                            .font(MissaleFont.body(16, italic: true))
                            .foregroundStyle(Palette.ink.opacity(0.85))
                            .padding(.leading, 12)
                            .overlay(alignment: .leading) {
                                Rectangle().fill(Palette.goldMuted).frame(width: 2)
                            }
                            .padding(.vertical, 4)
                            .background(Palette.goldMuted.opacity(0.08))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }

                OnboardingPrimaryButton(title: L.string("Make this mine", table: "Onboarding"), action: onContinue)
                Text("A few short questions. No account yet.", tableName: "Onboarding")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
        }
    }
}
