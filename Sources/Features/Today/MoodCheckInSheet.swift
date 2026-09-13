import SwiftUI

/// Screen 2 (eIs2) — bottom sheet: "Hoje eu estou…" grouped chip picker with an
/// optional one-line note. Tapping a chip proceeds in-place to the relief screen (3).
struct MoodCheckInSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: MoodStateOption?
    @State private var redirectToScrupulosity = false
    @State private var note: String = ""
    @State private var showPastoralCare = false

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.parchment.ignoresSafeArea()
                if redirectToScrupulosity {
                    // Replaces relief outright once the pattern is established — the
                    // point is to interrupt the cycle, not add another reassurance on top.
                    ScrupulosityRedirectView()
                } else if let selected {
                    MoodReliefView(state: selected) { dismiss() }
                } else {
                    pickerBody
                }
            }
        }
    }

    private func select(_ option: MoodStateOption) {
        let count = MoodHistoryStore.shared.record(state: option, note: note.isEmpty ? nil : note)
        redirectToScrupulosity = option.isScrupulosityTrigger && count >= 3
        selected = option
    }

    private var pickerBody: some View {
        VStack(alignment: .leading, spacing: 4) {
            Capsule().fill(Palette.ink.opacity(0.2)).frame(width: 38, height: 4).frame(maxWidth: .infinity)
                .padding(.top, 10)
            Text("Hoje eu estou…")
                .font(MissaleFont.display(27, weight: .semibold))
                .foregroundStyle(Palette.ink)
                .padding(.top, 14)
            Text("Um toque. Fica no aparelho, e pode ficar em branco.")
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
                            Text("Precisa de mais do que isto? Padre, diocese, ou uma crise")
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
                            Eyebrow(text: group.label)
                            FlowChips(items: group.items) { option in
                                select(option)
                            }
                        }
                    }
                    TextField("O que aconteceu? (opcional, uma linha)", text: $note)
                        .font(MissaleFont.body(15))
                        .padding(12)
                        .background(Color.white.opacity(0.45), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
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
                            Text(item.label)
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
