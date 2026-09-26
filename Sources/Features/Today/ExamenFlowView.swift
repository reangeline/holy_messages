import SwiftUI

/// The real Examen, one step at a time: Gratidão, Pedido de luz, Revisão,
/// Resposta — each with its own moment to write, before the closing screen.
/// Previously "Começar o Exame" skipped straight to Compline; this is what it
/// now leads to instead.
struct ExamenFlowView: View {
    /// Collapses the whole flow back to Today in one shot, regardless of how
    /// many steps deep it grew — see ExamenClosingView's "Encerrar" button.
    let onFinished: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var stepIndex = 0
    @State private var answers: [String]
    @State private var goingForward = true
    @State private var finished = false
    /// Jev's saint and prayer from the answers, when it answers — the closing
    /// screen shows at once and the card joins it later.
    @State private var suggestion: ExamenSuggestion?
    @State private var showCrisis = false

    init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
        _answers = State(initialValue: Array(repeating: "", count: MockRosary.examenSteps.count))
    }

    var body: some View {
        ZStack {
            if finished {
                ExamenClosingView(onFinished: onFinished, suggestion: suggestion, showCrisis: showCrisis)
                    .transition(transition)
            } else {
                ExamenStepView(
                    step: MockRosary.examenSteps[stepIndex],
                    totalSteps: MockRosary.examenSteps.count,
                    initialText: answers[stepIndex],
                    onBack: back,
                    onContinue: { text in
                        answers[stepIndex] = text
                        advance()
                    }
                )
                .transition(transition)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var transition: AnyTransition { directionalTransition(forward: goingForward) }

    private func advance() {
        goingForward = true
        if stepIndex < MockRosary.examenSteps.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) { stepIndex += 1 }
        } else {
            let entry = ExamenHistoryStore.shared.record(
                gratitude: answers[0],
                lightRequest: answers[1],
                review: answers[2],
                response: answers[3]
            )
            withAnimation(.easeInOut(duration: 0.3)) { finished = true }
            // Not tied to the view: if the person closes first, the choice is
            // still kept with the entry for the history.
            Task {
                guard let outcome = await ExamenSuggestion.suggest(for: entry) else { return }
                withAnimation {
                    suggestion = outcome.suggestion
                    showCrisis = outcome.showCrisisFirst
                }
            }
        }
    }

    private func back() {
        guard stepIndex > 0 else {
            dismiss()
            return
        }
        goingForward = false
        withAnimation(.easeInOut(duration: 0.3)) { stepIndex -= 1 }
    }
}

#Preview {
    NavigationStack { ExamenFlowView(onFinished: {}) }
}
