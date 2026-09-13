import SwiftUI

/// Placeholder for the Prayers tab root (t4 screens 22-28) — replaced in a later pass.
struct PrayersRootView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            Text("Orações")
                .font(MissaleFont.display(28))
        }
    }
}
