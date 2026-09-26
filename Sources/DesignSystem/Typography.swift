import SwiftUI

/// Font.custom wrappers around the two embedded serif families.
/// Falls back to the system serif design if a font fails to register (e.g. Xcode previews).
enum MissaleFont {
    static func display(_ size: CGFloat, weight: DisplayWeight = .semibold, italic: Bool = false) -> Font {
        let name: String
        switch (weight, italic) {
        case (.regular, false): name = "CormorantGaramond-Regular"
        case (.medium, false): name = "CormorantGaramond-Medium"
        case (.semibold, false): name = "CormorantGaramond-SemiBold"
        case (.medium, true): name = "CormorantGaramondItalic-MediumItalic"
        default: name = italic ? "CormorantGaramondItalic-Italic" : "CormorantGaramond-SemiBold"
        }
        return .custom(name, size: size)
    }

    static func body(_ size: CGFloat, weight: BodyWeight = .regular, italic: Bool = false) -> Font {
        let name: String
        switch (weight, italic) {
        case (.regular, false): name = "EBGaramond-Regular"
        case (.regular, true): name = "EBGaramondItalic-Italic"
        case (.medium, false): name = "EBGaramond-Medium"
        case (.medium, true): name = "EBGaramondItalic-MediumItalic"
        case (.semibold, false): name = "EBGaramond-SemiBold"
        case (.semibold, true): name = "EBGaramondItalic-Italic"
        }
        return .custom(name, size: size)
    }

    enum DisplayWeight { case regular, medium, semibold }
    enum BodyWeight { case regular, medium, semibold }
}

/// The reader's size for long reading text — the Bible, the saints and the
/// formation lessons share one. It multiplies the design's sizes, and the
/// custom fonts still follow Dynamic Type on top of that.
enum ReadingTextSize {
    static let storageKey = "reading_text_size"
    static let steps: [CGFloat] = [0.9, 1, 1.15, 1.3, 1.5]
    static let defaultStep = 1

    static func scale(_ step: Int) -> CGFloat {
        steps[min(max(step, 0), steps.count - 1)]
    }
}

/// A− / A+ for `ReadingTextSize`, in a small popover from the toolbar.
struct ReadingTextSizeButton: View {
    @AppStorage(ReadingTextSize.storageKey) private var step = ReadingTextSize.defaultStep
    @State private var showing = false

    var body: some View {
        Button {
            showing = true
        } label: {
            Image(systemName: "textformat.size")
                .foregroundStyle(Palette.wine)
        }
        .accessibilityLabel(L.string("Tamanho do texto"))
        .popover(isPresented: $showing) {
            HStack(spacing: 20) {
                Button {
                    step = max(step - 1, 0)
                } label: {
                    Image(systemName: "textformat.size.smaller")
                }
                .disabled(step <= 0)
                .accessibilityLabel(L.string("Diminuir o texto"))

                HStack(spacing: 6) {
                    ForEach(ReadingTextSize.steps.indices, id: \.self) { dot in
                        Circle()
                            .fill(dot <= step ? Palette.wine : Palette.wine.opacity(0.2))
                            .frame(width: 6, height: 6)
                    }
                }
                .accessibilityHidden(true)

                Button {
                    step = min(step + 1, ReadingTextSize.steps.count - 1)
                } label: {
                    Image(systemName: "textformat.size.larger")
                }
                .disabled(step >= ReadingTextSize.steps.count - 1)
                .accessibilityLabel(L.string("Aumentar o texto"))
            }
            .font(.system(size: 20))
            .foregroundStyle(Palette.wine)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .presentationCompactAdaptation(.popover)
        }
    }
}

/// Small uppercase letter-spaced "eyebrow" label used throughout the design
/// (e.g. "PALAVRA DE HOJE", "SANTO DO DIA").
struct Eyebrow: View {
    let text: String
    var color: Color = Palette.goldDim

    var body: some View {
        Text(text.uppercased())
            .font(MissaleFont.body(11, weight: .semibold))
            .tracking(1.6)
            .foregroundStyle(color)
    }
}
