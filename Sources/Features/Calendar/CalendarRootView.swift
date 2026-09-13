import SwiftUI

/// Placeholder for the Calendar tab root (t4 screens 8-11) — replaced in a later pass.
struct CalendarRootView: View {
    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            Text("Calendário")
                .font(MissaleFont.display(28))
        }
    }
}
