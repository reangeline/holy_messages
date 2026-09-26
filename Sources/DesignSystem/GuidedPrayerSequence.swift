import SwiftUI

/// One breath, then a prayer phrase by phrase, on a dark background — used by
/// the onboarding's first prayer and by the daily prayer on Today. Calls
/// `onFinished` after the last phrase fades.
struct GuidedPrayerSequence: View {
    let phrases: [String]
    /// Seconds added to how long each phrase stays up — the onboarding's Our
    /// Father holds each one a second less than the daily prayers.
    var holdAdjustment: Double = 0
    let onFinished: () -> Void

    @State private var index: Int? = nil
    @State private var inhale = false
    @State private var phraseVisible = false

    var body: some View {
        ZStack {
            if let index {
                VStack {
                    Spacer()
                    Text(phrases[index])
                        .font(MissaleFont.display(index == phrases.count - 1 && phrases.count > 1 ? 40 : 30, italic: true))
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.25), radius: 12)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(phraseVisible ? 1 : 0)
                        .blur(radius: phraseVisible ? 0 : 6)
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(phrases.indices, id: \.self) { dot in
                            Circle()
                                .fill(dot <= index ? Palette.goldBright : .white.opacity(0.18))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .transition(.opacity)
            } else {
                VStack(spacing: 36) {
                    Circle()
                        .fill(RadialGradient(colors: [Palette.goldBright.opacity(0.55), Palette.goldBright.opacity(0)],
                                             center: .center, startRadius: 0, endRadius: 130))
                        .frame(width: 260, height: 260)
                        .scaleEffect(inhale ? 1 : 0.35)
                    Text(Self.label(inhale ? Self.breatheIn : Self.breatheOut))
                        .font(MissaleFont.display(26, italic: true))
                        .foregroundStyle(.white.opacity(0.85))
                        .contentTransition(.opacity)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.8), value: index)
        .task { await play() }
    }

    private func play() async {
        do {
            try await Task.sleep(for: .milliseconds(600))
            withAnimation(.easeInOut(duration: 4)) { inhale = true }
            try await Task.sleep(for: .seconds(4.2))
            withAnimation(.easeInOut(duration: 4)) { inhale = false }
            try await Task.sleep(for: .seconds(4.4))

            for phrase in phrases.indices {
                phraseVisible = false
                index = phrase
                try await Task.sleep(for: .milliseconds(500))
                withAnimation(.easeOut(duration: 1)) { phraseVisible = true }
                // Roughly reading pace, with room to actually pray it.
                let words = phrases[phrase].split(separator: " ").count
                try await Task.sleep(for: .seconds(max(2.5, Double(words) * 0.45 + 1.5) + holdAdjustment))
                withAnimation(.easeIn(duration: 0.7)) { phraseVisible = false }
                try await Task.sleep(for: .milliseconds(700))
            }
            onFinished()
        } catch {}
    }

    /// Splits a prayer's running text at its pauses (. ; : ! ?), folding
    /// fragments too short to stand alone into the phrase before them.
    static func phrases(from text: String) -> [String] {
        var result: [String] = []
        var current = ""
        for character in text {
            current.append(character)
            if ".;:!?".contains(character) {
                let piece = current.trimmingCharacters(in: .whitespaces)
                current = ""
                guard !piece.isEmpty else { continue }
                if let last = result.last, piece.split(separator: " ").count < 4 || last.split(separator: " ").count < 4 {
                    result[result.count - 1] = last + " " + piece
                } else {
                    result.append(piece)
                }
            }
        }
        let rest = current.trimmingCharacters(in: .whitespaces)
        if !rest.isEmpty {
            if let last = result.last { result[result.count - 1] = last + " " + rest } else { result.append(rest) }
        }
        return result
    }

    private static let breatheIn: [AppLanguage: String] = [.en: "Breathe in", .pt: "Inspire", .es: "Inspira"]
    private static let breatheOut: [AppLanguage: String] = [.en: "Breathe out", .pt: "Expire", .es: "Espira"]

    private static func label(_ byLanguage: [AppLanguage: String]) -> String {
        byLanguage[AppLanguagePreference.resolveCurrent()] ?? byLanguage[.en]!
    }
}
