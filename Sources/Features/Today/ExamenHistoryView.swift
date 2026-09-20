import SwiftUI

/// What you actually wrote in past Exames — reads ExamenHistoryStore, newest
/// first. A record, not a scoreboard, matching the tone of the app's other
/// history screens.
struct ExamenHistoryView: View {
    @ObservedObject private var history = ExamenHistoryStore.shared.list

    private var entries: [ExamenEntry] {
        history.items.sorted { $0.date > $1.date }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1C1618).opacity(0.92), Color(hex: 0x2C1A1E).opacity(0.92)],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Eyebrow(text: "Exames anteriores", color: Palette.goldBright)
                Text("O que você já escreveu", tableName: "Today")
                    .font(MissaleFont.display(28, weight: .semibold))
                    .foregroundStyle(.white)

                if entries.isEmpty {
                    Text("Nenhum Exame registrado ainda. Ele aparece aqui assim que você concluir um.", tableName: "Today")
                        .font(MissaleFont.body(15))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.top, 8)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            ForEach(entries) { entry in
                                entryCard(entry)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func entryCard(_ entry: ExamenEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.dateLabel)
                .font(MissaleFont.body(13, weight: .semibold))
                .tracking(1.1)
                .foregroundStyle(Palette.goldBright)

            // Step titles come from the content catalog, the same source the
            // flow itself uses — they name the parts of the Ignatian Examen, so
            // they are content, not chrome, and repeating them here would let
            // the history drift from the flow.
            let steps = MockRosary.examenSteps
            ForEach(Array(zip(steps, [entry.gratitude, entry.lightRequest, entry.review, entry.response])), id: \.0.id) { step, answer in
                answerBlock(title: step.title, text: answer)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.14), lineWidth: 1))
    }

    private func answerBlock(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.0)
                .foregroundStyle(.white.opacity(0.45))
            if text.isEmpty {
                Text(L.string("Nada escrito neste passo.", table: "Today"))
                    .font(MissaleFont.body(15))
                    .italic()
                    .foregroundStyle(.white.opacity(0.4))
            } else {
                Text(text)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
    }
}

#Preview {
    NavigationStack { ExamenHistoryView() }
}
