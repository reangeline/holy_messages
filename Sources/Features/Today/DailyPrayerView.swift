import SwiftUI

/// The routine's prayer: one prayer from the catalog each day, prayed phrase
/// by phrase with the same guided sequence as the onboarding's first prayer.
struct DailyPrayerView: View {
    private enum Phase { case intro, praying, done }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var routine = DailyRoutineStore.shared
    @State private var phase = Phase.intro
    @State private var checkVisible = false

    private let prayer = DailyPrayer.today()

    var body: some View {
        ZStack {
            Palette.night.ignoresSafeArea()
            if let prayer {
                switch phase {
                case .intro: intro(prayer)
                case .praying:
                    GuidedPrayerSequence(phrases: GuidedPrayerSequence.phrases(from: prayer.fullText)) {
                        routine.markDone(.prayer)
                        phase = .done
                        withAnimation(.spring(duration: 0.8, bounce: 0.3).delay(0.4)) { checkVisible = true }
                    }
                case .done: done
                }
            }
        }
        .animation(.easeInOut(duration: 0.8), value: phase)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar(phase == .praying ? .hidden : .visible, for: .navigationBar)
    }

    private func intro(_ prayer: DevotionalPrayer) -> some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                Eyebrow(text: L.string("Oração do dia", table: "Today"), color: Palette.goldBright)
                Text(prayer.title)
                    .font(MissaleFont.display(34))
                    .foregroundStyle(.white)
                Text(prayer.focus)
                    .font(MissaleFont.body(17))
                    .foregroundStyle(.white.opacity(0.7))
                if let attribution = prayer.attribution {
                    Text(attribution)
                        .font(MissaleFont.body(13, italic: true))
                        .foregroundStyle(.white.opacity(0.45))
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            Spacer()
            lightButton(L.string("Rezar agora", table: "Today")) { phase = .praying }
                .padding(.bottom, 24)
        }
        .transition(.opacity)
    }

    private var done: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Circle().strokeBorder(Palette.goldBright.opacity(0.35), lineWidth: 1).frame(width: 120, height: 120)
                Image(systemName: "checkmark")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(Palette.goldBright)
            }
            .scaleEffect(checkVisible ? 1 : 0.6)
            .opacity(checkVisible ? 1 : 0)
            .padding(.bottom, 28)
            Text(L.string("Oração concluída", table: "Today"))
                .font(MissaleFont.display(32))
                .foregroundStyle(.white)
            Spacer()
            lightButton(L.string("Concluir", table: "Today")) { dismiss() }
                .padding(.bottom, 24)
        }
        .transition(.opacity)
        .sensoryFeedback(.success, trigger: checkVisible)
    }

    private func lightButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(MissaleFont.body(17, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(Palette.night)
                .background(.white, in: Capsule())
        }
        .padding(.horizontal, 24)
    }
}

enum DailyPrayer {
    /// A different catalog prayer each day, in the reader's language. Only
    /// prayers short enough to pray phrase by phrase in a minute or two, and
    /// none of the responsorial ones (the Angelus' V./R.), which are said in
    /// two voices and read oddly one phrase at a time.
    static func today(on date: Date = Date()) -> DevotionalPrayer? {
        var seen = Set<String>()
        let pool = MockDevotionalPrayers.categories
            .flatMap(\.prayers)
            .filter { (80...500).contains($0.fullText.count) }
            .filter { !$0.fullText.contains("V.") && !$0.fullText.contains("R.") && !$0.fullText.contains("℣") }
            .filter { seen.insert($0.id).inserted }
            .sorted { $0.id < $1.id }
        guard !pool.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return pool[day % pool.count]
    }

    /// The guided sequence's own pace: the breath, then each phrase.
    static func minutes(_ prayer: DevotionalPrayer) -> Int {
        let phrases = GuidedPrayerSequence.phrases(from: prayer.fullText)
        let seconds = 10 + phrases.reduce(0.0) { $0 + max(2.5, Double($1.split(separator: " ").count) * 0.45 + 1.5) + 1.2 }
        return max(1, Int((seconds / 60).rounded()))
    }
}
