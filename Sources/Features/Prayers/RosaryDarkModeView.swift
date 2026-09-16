import SwiftUI

/// t4 screen 26 — dark/pocket rosary mode. Near-black, minimal light, haptic per bead.
struct RosaryDarkModeView: View {
    let mystery: RosaryMystery
    let startIndex: Int
    var beginnerMode: Bool = true
    var intention: String = ""

    @State private var index: Int = 0
    @State private var hasRecorded = false
    @Environment(\.dismiss) private var dismiss
    private let generator = UIImpactFeedbackGenerator(style: .soft)

    private var beads: [RosaryBead] { MockRosary.beads(for: mystery) }
    private var isFinished: Bool { index >= beads.count }

    var body: some View {
        ZStack {
            Color(hex: 0x0D0A0B).ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                if isFinished {
                    VStack(spacing: 14) {
                        CrossGlyph(size: 32, color: Palette.goldBright.opacity(0.6))
                        Text("Terço concluído")
                            .font(MissaleFont.display(26))
                            .foregroundStyle(Palette.goldBright.opacity(0.85))
                        Text("Que a paz desta oração continue com você.")
                            .font(MissaleFont.body(14))
                            .foregroundStyle(.white.opacity(0.4))
                            .multilineTextAlignment(.center)
                    }
                } else {
                    let bead = beads[index]
                    VStack(spacing: 10) {
                        Text(shortLabel(for: bead))
                            .font(MissaleFont.display(24))
                            .foregroundStyle(Palette.goldBright.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        if let (current, total) = decadeCount(for: bead) {
                            Text("\(current) / \(total)")
                                .font(MissaleFont.display(48, weight: .medium))
                                .foregroundStyle(Palette.goldBright.opacity(0.9))
                        }
                    }

                    beadProgress
                }

                Spacer()

                Text("Guarde o telefone no bolso. O toque avança, a vibração confirma, e nada acende até você terminar.")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.32))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !isFinished else { return }
            generator.impactOccurred()
            withAnimation(.easeInOut(duration: 0.15)) {
                index += 1
            }
        }
        .onAppear {
            index = startIndex
            generator.prepare()
        }
        .onChange(of: index, initial: true) { _, _ in
            guard isFinished, !hasRecorded else { return }
            hasRecorded = true
            RosaryHistoryStore.shared.record(mysterySet: mystery.mysterySet, modeLabel: "Tela apagada", intention: intention)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("‹ Sair") { dismiss() }
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.5))
            }
            ToolbarItem(placement: .principal) {
                Text("Tela apagada")
                    .font(MissaleFont.body(12, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
    }

    /// One segment per decade (plus the opening and closing prayers), each
    /// filling as its beads complete — reads clearly at a glance even
    /// half-glimpsed from a pocket, unlike a dot per single bead.
    private var beadProgress: some View {
        let segments = progressSegments
        return HStack(spacing: 5) {
            ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .overlay(alignment: .leading) {
                        GeometryReader { proxy in
                            Capsule()
                                .fill(Palette.goldBright.opacity(0.65))
                                .frame(width: proxy.size.width * segment)
                        }
                    }
                    .frame(height: 3)
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 4)
    }

    /// Fraction complete (0...1) for each segment: opening prayers, one per
    /// decade, then the closing prayer.
    private var progressSegments: [Double] {
        let openingEnd = beads.firstIndex { $0.kind == .announcement } ?? 0
        var ranges: [Range<Int>] = [0..<openingEnd]
        for decade in 0..<mystery.decades.count {
            let decadeBeads = beads.indices.filter { beads[$0].mysteryIndex == decade }
            if let first = decadeBeads.first, let last = decadeBeads.last {
                ranges.append(first..<(last + 1))
            }
        }
        ranges.append((ranges.last?.upperBound ?? 0)..<beads.count)
        return ranges.map { range in
            guard !range.isEmpty else { return 0 }
            let completed = range.filter { $0 <= index }.count
            return Double(completed) / Double(range.count)
        }
    }

    private func shortLabel(for bead: RosaryBead) -> String {
        switch bead.kind {
        case .crucifix: "Sinal da Cruz"
        case .intentions: "Intenções"
        case .offering: "Oferecimento"
        case .creed: "Credo"
        case .ourFather: "Pai-Nosso"
        case .hailMary: "Ave-Maria"
        case .glory: "Glória"
        case .announcement: mystery.decades[bead.mysteryIndex ?? 0].title
        case .hailHolyQueen: "Salve Rainha"
        }
    }

    /// For a Hail Mary bead, returns (position within its decade, 10).
    private func decadeCount(for bead: RosaryBead) -> (Int, Int)? {
        guard bead.kind == .hailMary, let decade = bead.mysteryIndex else { return nil }
        let position = beads
            .filter { $0.kind == .hailMary && $0.mysteryIndex == decade && $0.index <= bead.index }
            .count
        return (position, 10)
    }
}
