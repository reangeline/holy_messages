import SwiftUI

/// t4 screen 13 — saints curated from whatever the user recently logged.
struct SaintsForYouView: View {
    @ObservedObject private var moodHistory = MoodHistoryStore.shared

    private var latestEntry: MoodEntry? {
        moodHistory.entries.max { $0.date < $1.date }
    }

    private var recommendedSaints: [Saint] {
        guard let latestEntry else { return [] }
        return MockSaints.saintsForYou(stateID: latestEntry.stateID)
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Saints for what you carry", tableName: "CalendarSaints")
                        .font(MissaleFont.display(29))
                    if let latestEntry {
                        Text("Based on your latest check-in", tableName: "CalendarSaints")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                        Text(MockMood.stateLabel(for: latestEntry.stateID) ?? latestEntry.stateLabel)
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.wine)

                        ForEach(recommendedSaints) { saint in
                            NavigationLink {
                                SaintDetailView(saint: saint)
                            } label: {
                                GlassCard {
                                    HStack(alignment: .top, spacing: 13) {
                                        SaintPortrait(artworkName: saint.artworkName, cornerRadius: 10)
                                            .frame(width: 48, height: 48)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(saint.name)
                                                .font(MissaleFont.body(17, weight: .medium))
                                            Text(saint.bioParagraphs.first ?? saint.role)
                                                .font(MissaleFont.body(15))
                                                .foregroundStyle(Palette.ink.opacity(0.74))
                                        }
                                        Spacer(minLength: 0)
                                        Image(systemName: "chevron.right")
                                            .font(.footnote.weight(.semibold))
                                            .foregroundStyle(Palette.wine)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    } else {
                        Text("No check-in has been recorded yet.", tableName: "CalendarSaints")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }
                }
                .padding(20)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
