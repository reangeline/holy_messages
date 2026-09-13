import SwiftUI

/// Placeholder for the Formation tab root (t4 screens 18-21) — replaced in a later pass.
struct FormationRootView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            Text("Formação")
                .font(MissaleFont.display(28))
        }
    }
}
