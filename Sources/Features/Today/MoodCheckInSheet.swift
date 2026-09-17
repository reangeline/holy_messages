import SwiftUI

/// Screen 2 (eIs2) — bottom sheet: "Hoje eu estou…" grouped chip picker. Tapping a
/// chip goes to a reflection screen (write about it, optional) before anything
/// else — the Psalm/saint/step response is only picked once that continues, so
/// nothing repetitive shows before the person has had a chance to write.
struct MoodCheckInSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step: Step = .picker
    /// Which way the last step change went, so the slide transition can match:
    /// forward slides in from the trailing edge, back slides in from the leading
    /// edge — a plain conditional swap with no transition at all is what read as
    /// "seco" (abrupt) here.
    @State private var goingForward = true
    @State private var showPastoralCare = false

    private enum Step: Equatable {
        case picker
        case reflection(MoodStateOption)
        case relief(MoodStateOption)
        case scrupulosity
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.parchment.ignoresSafeArea()
                switch step {
                case .picker:
                    pickerBody
                        .transition(transition)
                case .reflection(let option):
                    MoodReflectionView(
                        state: option,
                        onBack: { retreat(to: .picker) },
                        onContinue: { note in finalize(option, note: note) }
                    )
                    .transition(transition)
                case .relief(let option):
                    MoodReliefView(state: option) { dismiss() }
                        .transition(transition)
                case .scrupulosity:
                    // Replaces relief outright once the pattern is established —
                    // the point is to interrupt the cycle, not add another
                    // reassurance on top.
                    ScrupulosityRedirectView()
                        .transition(transition)
                }
            }
        }
    }

    private var transition: AnyTransition { directionalTransition(forward: goingForward) }

    private func advance(to next: Step) {
        goingForward = true
        withAnimation(.easeInOut(duration: 0.3)) { step = next }
    }

    private func retreat(to next: Step) {
        goingForward = false
        withAnimation(.easeInOut(duration: 0.3)) { step = next }
    }

    private func finalize(_ option: MoodStateOption, note: String) {
        let count = MoodHistoryStore.shared.record(state: option, note: note.isEmpty ? nil : note)
        let next: Step = (option.isScrupulosityTrigger && count >= 3) ? .scrupulosity : .relief(option)
        advance(to: next)
    }

    private var pickerBody: some View {
        VStack(alignment: .leading, spacing: 4) {
            Capsule().fill(Palette.ink.opacity(0.2)).frame(width: 38, height: 4).frame(maxWidth: .infinity)
                .padding(.top, 10)
            Text("Hoje eu estou…", tableName: "Today")
                .font(MissaleFont.display(27, weight: .semibold))
                .foregroundStyle(Palette.ink)
                .padding(.top, 14)
            Text("Um toque. Fica no aparelho, e pode ficar em branco.", tableName: "Today")
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.ink.opacity(0.65))
                .padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Static, always here — not gated behind detecting a pattern.
                    Button {
                        showPastoralCare = true
                    } label: {
                        HStack {
                            Text("Precisa de mais do que isto? Padre, diocese, ou uma crise", tableName: "Today")
                                .font(MissaleFont.body(13))
                                .foregroundStyle(Palette.ink.opacity(0.6))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundStyle(Palette.ink.opacity(0.4))
                        }
                    }
                    .buttonStyle(.plain)

                    ForEach(MockMood.stateGroups) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string(group.label, table: "Today"))
                            FlowChips(items: group.items) { option in
                                advance(to: .reflection(option))
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 24)
        .sheet(isPresented: $showPastoralCare) {
            PastoralCareNudgeView()
        }
    }
}

/// Simple wrapping chip layout for the mood options within a group.
private struct FlowChips: View {
    let items: [MoodStateOption]
    let onTap: (MoodStateOption) -> Void

    var body: some View {
        // A basic flow layout via a lazy wrapping HStack-in-VStack approximation.
        let rows = chunk(items, perRow: 3)
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 8) {
                    ForEach(row) { item in
                        Button {
                            onTap(item)
                        } label: {
                            Text(L.string(item.label, table: "Today"))
                                .font(MissaleFont.body(15))
                                .foregroundStyle(item.isCrisisTrigger ? Palette.wine : Palette.ink)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 9)
                                .background(.ultraThinMaterial, in: Capsule())
                                .overlay(Capsule().strokeBorder(item.isCrisisTrigger ? Palette.wine.opacity(0.35) : Color.white.opacity(0.6), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func chunk(_ items: [MoodStateOption], perRow: Int) -> [[MoodStateOption]] {
        stride(from: 0, to: items.count, by: perRow).map { start in
            Array(items[start..<min(start + perRow, items.count)])
        }
    }
}

#Preview {
    MoodCheckInSheet()
}
