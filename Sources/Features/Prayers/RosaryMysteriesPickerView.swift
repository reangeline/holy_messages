import SwiftUI

/// t4 screen 23 — pick a mystery set, beginner/voice toggles, optional intention, then start.
struct RosaryMysteriesPickerView: View {
    @State private var selected: RosaryMystery = MockRosary.todays
    /// A real preference, not screen state: someone who turns the teaching hints
    /// off expects them to stay off on the next rosary.
    @AppStorage(UserProfile.rosaryBeginnerModeKey) private var beginnerMode = true
    @AppStorage(UserProfile.rosaryVoiceGuideKey) private var voiceGuiding = false
    @State private var intention = ""
    @FocusState private var intentionFocused: Bool
    /// Jev's suggestion from the intention (subscribers with personalization
    /// on). It never replaces the day's set by itself: the reader accepts it.
    @State private var suggestion: RosarySuggestion?
    @State private var acceptedSuggestion = false
    @State private var showCrisis = false
    @State private var requestedIntention = ""

    /// The decade to mark during the prayer: only once the suggestion was
    /// accepted, and only while its set is the one selected.
    private var highlightedDecade: Int? {
        guard acceptedSuggestion, let suggestion, suggestion.mysterySet == selected.mysterySet else { return nil }
        return suggestion.decadeIndex
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Today's Mysteries", tableName: "Prayers")
                            .font(MissaleFont.display(28))
                        Text(L.string("{weekday}: {mysteries}. You can change it if you'd rather pray others.", table: "Prayers")
                            .replacingOccurrences(of: "{weekday}", with: MockLiturgical.today.weekdayLabel)
                            .replacingOccurrences(of: "{mysteries}", with: MockRosary.todays.mysterySet.displayName))
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }

                    VStack(spacing: 10) {
                        ForEach(MockRosary.mysteries) { mystery in
                            mysteryRow(mystery)
                        }
                    }

                    GlassCard {
                        VStack(spacing: 14) {
                            Toggle(L.string( "Beginner mode", table: "Prayers"), isOn: $beginnerMode)
                                .font(MissaleFont.body(16, weight: .medium))
                                .tint(Palette.wine)
                            Divider()
                            Toggle(L.string("Voice reading the prayers", table: "Prayers"), isOn: $voiceGuiding)
                                .font(MissaleFont.body(16, weight: .medium))
                                .tint(Palette.wine)
                        }
                    }

                    GlassCard {
                        TextField(L.string( "Intention for this rosary (optional) — \"I prayed for…\"", table: "Prayers"), text: $intention)
                            .font(MissaleFont.body(16))
                            .focused($intentionFocused)
                            .submitLabel(.done)
                            .onSubmit(requestSuggestion)
                    }

                    if showCrisis {
                        CrisisSupportCard()
                    }
                    if let suggestion {
                        suggestionCard(suggestion)
                    }

                    VStack(spacing: 12) {
                        NavigationLink {
                            RosaryGuidedPrayerView(mystery: selected, beginnerMode: beginnerMode, voiceGuiding: voiceGuiding, intention: intention, highlightedDecade: highlightedDecade)
                        } label: {
                            Text("Start", tableName: "Prayers")
                                .font(MissaleFont.body(17, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Palette.wine, in: Capsule())
                                .foregroundStyle(.white)
                        }
                        NavigationLink {
                            RosaryDarkModeView(mystery: selected, startIndex: 0, voiceGuiding: voiceGuiding, intention: intention)
                        } label: {
                            Text("Start with the screen off", tableName: "Prayers")
                                .font(MissaleFont.body(16))
                                .foregroundStyle(Palette.ink.opacity(0.65))
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: intentionFocused) { _, focused in
            if !focused { requestSuggestion() }
        }
        .onChange(of: intention) { _, text in
            guard text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            requestedIntention = ""
            withAnimation { suggestion = nil; showCrisis = false; acceptedSuggestion = false }
        }
    }

    /// Asks Jev once the reader finishes writing. Nothing waits on it: "Start"
    /// keeps working with the selected set, and the card appears if and when
    /// an answer comes.
    private func requestSuggestion() {
        let text = intention.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, text != requestedIntention else { return }
        requestedIntention = text
        Task {
            guard let outcome = await RosarySuggestion.suggest(for: text), requestedIntention == text else { return }
            withAnimation {
                suggestion = outcome.suggestion
                showCrisis = outcome.showCrisisFirst
                acceptedSuggestion = false
            }
        }
    }

    /// "Para a sua intenção: Mistérios Dolorosos — destaque: A Agonia no
    /// Horto", then that mystery's meditation and fruit from the catalog.
    private func suggestionCard(_ suggestion: RosarySuggestion) -> some View {
        let mystery = MockRosary.mysteries.first { $0.mysterySet == suggestion.mysterySet }
        let decade = suggestion.decadeIndex.flatMap { index in mystery?.decades.indices.contains(index) == true ? mystery?.decades[index] : nil }
        let headline = decade.map {
            L.string("For your intention: {mysteries} — highlight: {mystery}", table: "Prayers")
                .replacingOccurrences(of: "{mysteries}", with: suggestion.mysterySet.displayTitle)
                .replacingOccurrences(of: "{mystery}", with: $0.title)
        } ?? L.string("For your intention: {mysteries}", table: "Prayers")
            .replacingOccurrences(of: "{mysteries}", with: suggestion.mysterySet.displayTitle)

        return GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(L.string("Chosen from your intention", table: "Prayers"))
                    .font(MissaleFont.body(11, weight: .semibold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(Palette.wine)
                Text(headline)
                    .font(MissaleFont.body(17, weight: .medium))
                    .foregroundStyle(Palette.ink)
                if let decade {
                    Text(decade.description)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.75))
                    Text(L.string("Fruit: {fruit}", table: "Prayers").replacingOccurrences(of: "{fruit}", with: decade.fruit))
                        .font(MissaleFont.body(15, weight: .medium))
                        .foregroundStyle(Palette.ink.opacity(0.8))
                }
                if !acceptedSuggestion {
                    HStack(spacing: 16) {
                        Button {
                            if let mystery { selected = mystery }
                            withAnimation { acceptedSuggestion = true }
                        } label: {
                            Text(L.string("Pray these mysteries", table: "Prayers"))
                                .font(MissaleFont.body(15, weight: .medium))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Palette.wine, in: Capsule())
                                .foregroundStyle(.white)
                        }
                        .accessibilityIdentifier("rosarySuggestionAccept")
                        Button {
                            selected = MockRosary.todays
                            withAnimation { self.suggestion = nil }
                        } label: {
                            Text(L.string("Keep today's mysteries", table: "Prayers"))
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.65))
                        }
                        .accessibilityIdentifier("rosarySuggestionKeepToday")
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("rosarySuggestion")
    }

    private func mysteryRow(_ mystery: RosaryMystery) -> some View {
        let isSelected = mystery.id == selected.id
        return Button {
            selected = mystery
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(mystery.mysterySet.displayTitle)
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(isSelected ? .white : Palette.ink)
                    Text(mystery.dayLabel)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(isSelected ? .white.opacity(0.85) : Palette.ink.opacity(0.6))
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.white)
                }
            }
            .padding(16)
            .background(isSelected ? AnyShapeStyle(Palette.wine) : AnyShapeStyle(.ultraThinMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Color.clear : Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
