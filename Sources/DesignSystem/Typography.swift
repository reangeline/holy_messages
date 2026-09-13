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
