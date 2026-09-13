import SwiftUI

/// Placeholder for the Today tab root (t4 screens 1-7) — replaced in a later pass.
struct TodayRootView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            Text("Today")
                .font(MissaleFont.display(28))
        }
    }
}
