import SwiftUI

/// First screen: a Gospel verse drawn at random, revealed word by word on black.
/// The verse holds for a few seconds, then fades back to black and moves on.
struct OnboardingVerseIntroView: View {
    let onContinue: () -> Void

    private let language = AppLanguagePreference.resolveCurrent()
    @State private var verse = OnboardingIntroVerse.random()
    @State private var revealed = 0
    @State private var showReference = false
    @State private var isLeaving = false

    private var words: [String] { verse.text(language).split(separator: " ").map(String.init) }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 28) {
                WordFlow(spacing: 9, lineSpacing: 6) {
                    ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                        let isVisible = index < revealed
                        Text(word)
                            .font(MissaleFont.display(34))
                            .foregroundStyle(.white)
                            .shadow(color: .white.opacity(isVisible ? 0.35 : 0), radius: 12)
                            .opacity(isVisible ? 1 : 0)
                            .blur(radius: isVisible ? 0 : 8)
                            .offset(y: isVisible ? 0 : 6)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(verse.text(language))
                .opacity(isLeaving ? 0 : 1)

                Text(verse.reference(language).uppercased())
                    .font(MissaleFont.body(13, weight: .semibold))
                    .tracking(2.4)
                    .foregroundStyle(Palette.goldBright)
                    .opacity(showReference && !isLeaving ? 1 : 0)
            }
            .padding(.horizontal, 32)
        }
        .task { await play() }
    }

    private func play() async {
        do {
            try await Task.sleep(for: .seconds(1))
            while revealed < words.count {
                withAnimation(.easeOut(duration: 0.7)) { revealed += 1 }
                try await Task.sleep(for: .milliseconds(280))
            }
            withAnimation(.easeIn(duration: 1.2).delay(0.3)) { showReference = true }
            try await Task.sleep(for: .seconds(4.5))
            withAnimation(.easeInOut(duration: 1.2)) { isLeaving = true }
            try await Task.sleep(for: .seconds(1.4))
            onContinue()
        } catch {}
    }
}

/// Centers words line by line, wrapping like text, so each word can animate on its own.
private struct WordFlow: Layout {
    var spacing: CGFloat
    var lineSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let lines = lines(for: subviews, width: proposal.width ?? .infinity)
        let height = lines.map(\.height).reduce(0, +) + lineSpacing * CGFloat(max(lines.count - 1, 0))
        return CGSize(width: proposal.width ?? lines.map(\.width).max() ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for line in lines(for: subviews, width: bounds.width) {
            var x = bounds.midX - line.width / 2
            for index in line.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += size.width + spacing
            }
            y += line.height + lineSpacing
        }
    }

    private struct Line { var indices: [Int] = []; var width: CGFloat = 0; var height: CGFloat = 0 }

    private func lines(for subviews: Subviews, width: CGFloat) -> [Line] {
        var lines = [Line()]
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            let extra = lines[lines.count - 1].indices.isEmpty ? size.width : spacing + size.width
            if lines[lines.count - 1].width + extra > width, !lines[lines.count - 1].indices.isEmpty {
                lines.append(Line())
                lines[lines.count - 1].width = size.width
            } else {
                lines[lines.count - 1].width += extra
            }
            lines[lines.count - 1].indices.append(index)
            lines[lines.count - 1].height = max(lines[lines.count - 1].height, size.height)
        }
        return lines
    }
}

/// English follows Douay-Rheims, like the rest of the app's English Scripture.
struct OnboardingIntroVerse {
    let texts: [AppLanguage: (text: String, reference: String)]

    func text(_ language: AppLanguage) -> String { (texts[language] ?? texts[.en]!).text }
    func reference(_ language: AppLanguage) -> String { (texts[language] ?? texts[.en]!).reference }

    static func random() -> OnboardingIntroVerse { all.randomElement()! }

    static let all: [OnboardingIntroVerse] = [
        .init(texts: [
            .en: ("And the light shineth in darkness, and the darkness did not comprehend it.", "John 1:5"),
            .pt: ("A luz resplandece nas trevas, e as trevas não prevaleceram contra ela.", "João 1, 5"),
            .es: ("La luz brilla en las tinieblas, y las tinieblas no la vencieron.", "Juan 1, 5"),
        ]),
        .init(texts: [
            .en: ("In the beginning was the Word, and the Word was with God, and the Word was God.", "John 1:1"),
            .pt: ("No princípio era o Verbo, e o Verbo estava com Deus, e o Verbo era Deus.", "João 1, 1"),
            .es: ("En el principio existía el Verbo, y el Verbo estaba junto a Dios, y el Verbo era Dios.", "Juan 1, 1"),
        ]),
        .init(texts: [
            .en: ("I am the light of the world: he that followeth me, walketh not in darkness.", "John 8:12"),
            .pt: ("Eu sou a luz do mundo; quem me segue não andará em trevas.", "João 8, 12"),
            .es: ("Yo soy la luz del mundo; el que me sigue no caminará en tinieblas.", "Juan 8, 12"),
        ]),
        .init(texts: [
            .en: ("Come to me, all you that labour, and are burdened, and I will refresh you.", "Matthew 11:28"),
            .pt: ("Vinde a mim, todos os que estais cansados e sobrecarregados, e eu vos aliviarei.", "Mateus 11, 28"),
            .es: ("Venid a mí todos los que estáis cansados y agobiados, y yo os aliviaré.", "Mateo 11, 28"),
        ]),
        .init(texts: [
            .en: ("I am the way, and the truth, and the life.", "John 14:6"),
            .pt: ("Eu sou o caminho, a verdade e a vida.", "João 14, 6"),
            .es: ("Yo soy el camino, la verdad y la vida.", "Juan 14, 6"),
        ]),
    ]
}
