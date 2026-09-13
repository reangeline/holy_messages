import SwiftUI

/// t4 screen 26 — dark/pocket rosary mode. Near-black, minimal light, haptic per bead.
struct RosaryDarkModeView: View {
    let mystery: RosaryMystery
    let startIndex: Int

    @State private var index: Int = 0
    @Environment(\.dismiss) private var dismiss
    private let generator = UIImpactFeedbackGenerator(style: .soft)

    private var beads: [RosaryBead] { MockRosary.beads(for: mystery) }
    private var isFinished: Bool { index >= beads.count }

    var body: some View {
        ZStack {
            Color(hex: 0x0D0A0B).ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer()

                if isFinished {
                    Text("✝")
                        .font(.system(size: 30))
                        .foregroundStyle(Palette.goldBright.opacity(0.5))
                    Text("Terço concluído")
                        .font(MissaleFont.display(24))
                        .foregroundStyle(Palette.goldBright.opacity(0.8))
                } else {
                    let bead = beads[index]
                    Text(shortLabel(for: bead))
                        .font(MissaleFont.display(24))
                        .foregroundStyle(Palette.goldBright.opacity(0.75))

                    if let (current, total) = decadeCount(for: bead) {
                        Text("\(current) / \(total)")
                            .font(MissaleFont.display(46, weight: .medium))
                            .foregroundStyle(Palette.goldBright.opacity(0.9))
                    }

                    beadDots
                }

                Spacer()

                Text("Guarde o telefone no bolso. O toque avança, a vibração confirma, e nada acende até você terminar.")
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.32))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
            }

            VStack {
                HStack {
                    Text("Tela apagada · haptic a cada conta")
                        .font(MissaleFont.body(11, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.35))
                        .padding(.top, 12)
                        .padding(.leading, 24)
                    Spacer()
                }
                Spacer()
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("‹ Sair") { dismiss() }
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    private var beadDots: some View {
        HStack(spacing: 4) {
            ForEach(beads) { bead in
                Circle()
                    .fill(bead.index <= index ? Palette.goldBright.opacity(0.6) : Color.white.opacity(0.08))
                    .frame(width: bead.index == index ? 6 : 4, height: bead.index == index ? 6 : 4)
            }
        }
        .padding(.top, 6)
    }

    private func shortLabel(for bead: RosaryBead) -> String {
        switch bead.kind {
        case .crucifix: "Sinal da Cruz"
        case .ourFather: "Pai-Nosso"
        case .hailMary: "Ave-Maria"
        case .glory: "Glória"
        case .announcement: mystery.decades[bead.mysteryIndex ?? 0]
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
