import SwiftUI

/// The forward/back slide-and-fade used when stepping through a sequence of
/// screens in place (mood check-in, the nightly Examen): forward slides in
/// from the trailing edge, back slides in from the leading edge.
func directionalTransition(forward: Bool) -> AnyTransition {
    forward
        ? .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity))
        : .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity))
}
