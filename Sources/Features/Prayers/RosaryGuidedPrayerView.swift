import SwiftUI

/// t4 screen 25 — bead-by-bead guided prayer. Tap anywhere to advance.
struct RosaryGuidedPrayerView: View {
    let mystery: RosaryMystery
    var beginnerMode: Bool = true
    var intention: String = ""

    @State private var index = 0
    @State private var navigateToDark = false
    @State private var hasRecorded = false
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
                    Text(L.string("Tap anywhere to advance. Auto-advance is on.", table: "Prayers"))
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
        .onChange(of: index, initial: true) { _, _ in
            guard isFinished, !hasRecorded else { return }
            hasRecorded = true
            RosaryHistoryStore.shared.record(
                mysterySet: mystery.mysterySet,
                modeLabel: beginnerMode ? "Modo iniciante" : "Guiado",
                intention: intention
            )
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToDark) {
            RosaryDarkModeView(mystery: mystery, startIndex: index, beginnerMode: beginnerMode, intention: intention)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(L.string("‹ Exit", table: "Prayers")) { dismiss() }
                    .font(MissaleFont.body(16))
                    .foregroundStyle(Palette.wine)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(L.string("Turn off the screen", table: "Prayers")) { navigateToDark = true }
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.wine)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Eyebrow(text: mystery.mysterySet.displayTitle)
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
        case .hailHolyQueen: 12
        case .intentions, .offering: 11
        case .ourFather, .announcement, .creed: 10
        case .glory: 9
        case .hailMary: 7
        }
        return Circle()
            .fill(isPast ? Palette.wine : Palette.ink.opacity(0.18))
            .frame(width: size, height: size)
    }

    @ViewBuilder
    private func mainCard(step: RosaryPrayerStep) -> some View {
        if let items = step.promptItems {
            promptCard(step: step, items: items)
        } else {
            prayerCard(step: step)
        }
    }

    /// Guidance to think about, not a prayer to recite — deliberately styled
    /// like the app's ordinary info cards (upright, non-italic, a glass
    /// background) instead of the gradient "prayer card" below, so it doesn't
    /// read as liturgical text.
    private func promptCard(step: RosaryPrayerStep, items: [RosaryPromptItem]) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(step.kicker)
                        .font(MissaleFont.display(24, weight: .medium))
                        .foregroundStyle(Palette.ink)
                    Text(step.text)
                        .font(MissaleFont.body(17))
                        .foregroundStyle(Palette.ink.opacity(0.75))
                }
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(items, id: \.label) { item in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.label)
                                .font(MissaleFont.body(14, weight: .semibold))
                                .foregroundStyle(Palette.wine)
                            Text(item.detail)
                                .font(MissaleFont.body(17))
                                .foregroundStyle(Palette.ink.opacity(0.85))
                        }
                    }
                }
                if beginnerMode {
                    Text(step.hint)
                        .font(MissaleFont.body(15))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                        .italic()
                }
                Text(L.string("Optional", table: "Prayers"))
                    .font(MissaleFont.body(13, weight: .semibold))
                    .foregroundStyle(Palette.ink.opacity(0.4))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
    }

    private func prayerCard(step: RosaryPrayerStep) -> some View {
        VStack(spacing: 14) {
            Text(step.kicker)
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(Palette.goldBright)
            // On an announcement step, the mystery itself is the headline —
            // bigger and bolder than the meditation text below it, not buried
            // in a small caption underneath.
            if let mysteryTitleLine = step.mysteryTitleLine {
                Text(mysteryTitleLine)
                    .font(MissaleFont.display(27, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            Text(step.text)
                .font(MissaleFont.display(step.mysteryTitleLine != nil ? 19 : 23, italic: true))
                .foregroundStyle(.white.opacity(step.mysteryTitleLine != nil ? 0.9 : 1))
                .multilineTextAlignment(.center)
            if step.mysteryTitleLine == nil {
                Text(step.beadLabel)
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.7))
            }
            // Fruit + citation are core content on an announcement step, not a
            // dismissible tip — shown regardless of beginner mode.
            if let fruit = step.fruit, let scriptureRef = step.scriptureRef {
                VStack(spacing: 5) {
                    Text(L.string("Fruit: {fruit}", table: "Prayers").replacingOccurrences(of: "{fruit}", with: fruit))
                        .font(MissaleFont.body(16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                    Text(scriptureRef)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .multilineTextAlignment(.center)
                .padding(.top, 2)
            }
            // Beginner mode surfaces the per-bead teaching hint that MockRosary
            // already authors for every step; turning it off is what makes
            // non-beginner mode leaner — see MockRosary.step(for:mystery:).
            if beginnerMode {
                Text(step.hint)
                    .font(MissaleFont.body(13))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
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
                Text(L.string("Rosary complete", table: "Prayers"))
                    .font(MissaleFont.display(24))
                    .foregroundStyle(Palette.ink)
                Text(L.string("May the peace of this prayer stay with you.", table: "Prayers"))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
    }
}
