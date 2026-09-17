import WidgetKit
import SwiftUI

@main
struct MissaleWidgetsBundle: WidgetBundle {
    var body: some Widget {
        WordOfDayWidget()
        SaintOfDayWidget()
    }
}
