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

    init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
        _answers = State(initialValue: Array(repeating: "", count: MockRosary.examenSteps.count))
    }

    var body: some View {
        ZStack {
            if finished {
                ExamenClosingView(onFinished: onFinished)
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

    private var transition: AnyTransition {
        goingForward
            ? .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity))
            : .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity))
    }

    private func advance() {
        goingForward = true
        if stepIndex < MockRosary.examenSteps.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) { stepIndex += 1 }
        } else {
            ExamenHistoryStore.shared.record(
                gratitude: answers[0],
                lightRequest: answers.count > 1 ? answers[1] : "",
                review: answers.count > 2 ? answers[2] : "",
                response: answers.count > 3 ? answers[3] : ""
            )
            withAnimation(.easeInOut(duration: 0.3)) { finished = true }
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
