import SwiftUI

/// t4 screen 26 — dark/pocket rosary mode. Near-black, minimal light, haptic per bead.
struct RosaryDarkModeView: View {
    let mystery: RosaryMystery
    let startIndex: Int
    var beginnerMode: Bool = true
    /// Reads each bead aloud and advances when it finishes — the mode where a
    /// voice matters most, with the phone in a pocket.
    var voiceGuiding: Bool = false
    var intention: String = ""

    @StateObject private var voice = RosaryVoiceGuide()
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
                        Text(L.string("Rosary complete", table: "Prayers"))
                            .font(MissaleFont.display(26))
                            .foregroundStyle(Palette.goldBright.opacity(0.85))
                        Text(L.string("May the peace of this prayer stay with you.", table: "Prayers"))
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

                Text(L.string("Put the phone in your pocket. A tap advances, a vibration confirms, and nothing lights up until you finish.", table: "Prayers"))
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
            speakCurrentBead()
            guard isFinished, !hasRecorded else { return }
            hasRecorded = true
            RosaryHistoryStore.shared.record(mysterySet: mystery.mysterySet, modeLabel: "Tela apagada", intention: intention)
        }
        .onDisappear { voice.finish() }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(L.string("‹ Exit", table: "Prayers")) { dismiss() }
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.5))
            }
            ToolbarItem(placement: .principal) {
                Text(L.string("Screen off", table: "Prayers"))
                    .font(MissaleFont.body(12, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
    }

    private func speakCurrentBead() {
        guard voiceGuiding else { return }
        guard !isFinished else { return voice.finish() }
        let step = MockRosary.step(for: beads[index], mystery: mystery)
        let atual = index
        voice.speak(step.spokenText) {
            guard index == atual, !isFinished else { return }
            generator.impactOccurred()
            withAnimation(.easeInOut(duration: 0.15)) { index += 1 }
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

    /// Bead names come from the rosary's own per-language catalog, not from the
    /// app's string tables: they name parts of the Rosary, so a language with no
    /// rosary catalog shows the whole thing in Portuguese rather than translated
    /// labels wrapped around Portuguese prayers. See RosaryStepLabels.
    private func shortLabel(for bead: RosaryBead) -> String {
        let l = MockRosary.labels
        return switch bead.kind {
        case .crucifix: l.signOfCross
        case .intentions: l.intentions
        case .offering: l.offeringShort
        case .creed: l.creed
        case .ourFather: l.ourFatherShort
        case .hailMary: l.hailMaryKicker
        case .glory: l.gloryShort
        case .announcement: mystery.decades[bead.mysteryIndex ?? 0].title
        case .hailHolyQueen: l.hailHolyQueen
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
