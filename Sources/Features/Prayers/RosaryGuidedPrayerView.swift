import SwiftUI

/// t4 screen 25 — bead-by-bead guided prayer. Tap anywhere to advance.
struct RosaryGuidedPrayerView: View {
    let mystery: RosaryMystery

    @State private var index = 0
    @State private var navigateToDark = false
    @Environment(\.dismiss) private var dismiss

    private var beads: [RosaryBead] { MockRosary.beads(for: mystery) }
    private var isFinished: Bool { index >= beads.count }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground

            VStack(spacing: 0) {
                header
                beadRow
                    .padding(.top, 18)

                Spacer()

                if isFinished {
                    completionCard
                } else {
                    let bead = beads[index]
                    let step = MockRosary.step(for: bead, mystery: mystery)
                    mainCard(step: step)
                }

                Spacer()

                if !isFinished {
                    Text("Toque em qualquer lugar para avançar. Avanço automático está ligado.")
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 30)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !isFinished else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                index += 1
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToDark) {
            RosaryDarkModeView(mystery: mystery, startIndex: index)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("‹ Sair") { dismiss() }
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.wine)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Apagar a tela") { navigateToDark = true }
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.wine)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Eyebrow(text: "Mistérios \(mystery.mysterySet.rawValue)")
        }
        .padding(.top, 12)
    }

    private var beadRow: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(beads) { bead in
                        beadDot(bead)
                            .id(bead.id)
                    }
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 26)
            .onChange(of: index) { _, newValue in
                guard newValue < beads.count else { return }
                withAnimation {
                    proxy.scrollTo(beads[newValue].id, anchor: .center)
                }
            }
        }
    }

    private func beadDot(_ bead: RosaryBead) -> some View {
        let isPast = bead.index <= index
        let size: CGFloat = switch bead.kind {
        case .crucifix: 14
        case .ourFather, .announcement: 10
        case .glory: 9
        case .hailMary: 7
        }
        return Circle()
            .fill(isPast ? Palette.wine : Palette.ink.opacity(0.18))
            .frame(width: size, height: size)
    }

    private func mainCard(step: RosaryPrayerStep) -> some View {
        VStack(spacing: 14) {
            Text(step.kicker)
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(Palette.goldBright)
            Text(step.text)
                .font(MissaleFont.display(23, italic: true))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Text(step.beadLabel)
                .font(MissaleFont.body(13))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(LiturgicalColor.red.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }

    private var completionCard: some View {
        GlassCard {
            VStack(spacing: 10) {
                CrossGlyph(size: 30)
                Text("Terço concluído")
                    .font(MissaleFont.display(24))
                    .foregroundStyle(Palette.ink)
                Text("Que a paz desta oração continue com você.")
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
    }
}
