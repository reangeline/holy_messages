import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum Palette {
    static let parchment = Color(hex: 0xF8F3EA)
    static let parchmentDeep = Color(hex: 0xEBE6DC)
    static let ink = Color(hex: 0x221B1C)

    static let wine = Color(hex: 0x7A1F2B)
    static let wineDeep = Color(hex: 0x5E1620)
    static let goldBright = Color(hex: 0xE6C98F)
    static let goldMuted = Color(hex: 0xB3872F)
    static let goldDim = Color(hex: 0x8D6A22)
    static let purple = Color(hex: 0x6B4D8F)
    static let purpleDeep = Color(hex: 0x4A3466)
    static let green = Color(hex: 0x2F4A3C)
    static let night = Color(hex: 0x1C1618)
}

/// A liturgical color assigns the accent/gradient that themes the whole app for a given day.
enum LiturgicalColor: String, Codable, Hashable {
    case red, purple, green, white, rose, black

    /// The Portuguese term is the key, localized through the shared table — the
    /// colour of the day is chrome, so it follows the interface language.
    var name: String {
        let key = switch self {
        case .red: "Vermelho"
        case .purple: "Roxo"
        case .green: "Verde"
        case .white: "Branco"
        case .rose: "Rosa"
        case .black: "Preto"
        }
        return L.string(key)
    }

    var meaning: String {
        switch self {
        case .red: "Cor do sangue e do fogo: mártires, Pentecostes e a Cruz."
        case .purple: "Penitência e preparação: Advento e Quaresma."
        case .green: "Tempo Comum, a vida ordinária da Igreja."
        case .white: "Alegria e pureza: solenidades do Senhor, de Nossa Senhora e dos santos não mártires."
        case .rose: "Alívio breve em meio à penitência: Gaudete e Laetare."
        case .black: "Luto, usado hoje raramente."
        }
    }

    var accent: Color {
        switch self {
        case .red: Palette.wine
        case .purple: Palette.purple
        case .green: Palette.green
        case .white: Palette.goldMuted
        case .rose: Color(hex: 0xB86B7A)
        case .black: Palette.ink
        }
    }

    var gradient: LinearGradient {
        let colors: [Color]
        switch self {
        case .red: colors = [Palette.wine.opacity(0.88), Palette.wineDeep.opacity(0.82)]
        case .purple: colors = [Palette.purple.opacity(0.85), Palette.purpleDeep.opacity(0.82)]
        case .green: colors = [Palette.green.opacity(0.85), Palette.green.opacity(0.7)]
        case .white: colors = [Palette.goldMuted.opacity(0.85), Palette.goldDim.opacity(0.8)]
        case .rose: colors = [Color(hex: 0xB86B7A).opacity(0.85), Color(hex: 0x8C4655).opacity(0.82)]
        case .black: colors = [Palette.ink.opacity(0.9), Color.black.opacity(0.85)]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    /// Soft page background: glass-over-the-color-of-the-day, as used on most app screens.
    var pageBackground: some View {
        ZStack {
            Palette.parchment
            Circle()
                .fill(RadialGradient(colors: [accent.opacity(0.34), accent.opacity(0)], center: .center, startRadius: 0, endRadius: 160))
                .frame(width: 320, height: 320)
                .blur(radius: 14)
                .offset(x: 110, y: -320)
            Circle()
                .fill(RadialGradient(colors: [Palette.goldMuted.opacity(0.3), Palette.goldMuted.opacity(0)], center: .center, startRadius: 0, endRadius: 150))
                .frame(width: 300, height: 300)
                .blur(radius: 14)
                .offset(x: -140, y: -60)
            Circle()
                .fill(RadialGradient(colors: [accent.opacity(0.2), accent.opacity(0)], center: .center, startRadius: 0, endRadius: 140))
                .frame(width: 280, height: 280)
                .blur(radius: 14)
                .offset(x: 120, y: 340)
        }
        .ignoresSafeArea()
    }
}
