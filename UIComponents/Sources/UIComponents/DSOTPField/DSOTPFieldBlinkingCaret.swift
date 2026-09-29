import SwiftUI

// MARK: - Caret

/// A blinking caret that marks the active digit box in ``DSOTPField``.
///
/// The caret is a visual decoration that indicates where the next digit will
/// be entered. The actual text cursor is managed by the hidden `TextField`
/// owned by ``DSOTPField``.
///
/// This view is an internal implementation detail and is not part of the
/// package's public API.
///
/// When Reduce Motion is enabled, the caret remains continuously visible
/// instead of performing its blinking animation.
struct DSOTPFieldBlinkingCaret: View {

    /// The color applied to the caret.
    ///
    /// ``DSOTPField`` provides the active brand color from the current theme.
    let color: Color

    /// The vertical height of the caret in points.
    ///
    /// The parent ``DSOTPField`` calculates this value relative to the
    /// height of the digit box.
    let height: CGFloat

    /// Whether the caret is currently visible.
    ///
    /// This state is toggled by the repeating blink animation. It starts
    /// visible so the active input position is immediately apparent.
    @State private var visible = true

    /// Whether the user has enabled Reduce Motion.
    ///
    /// When enabled, the blinking animation is skipped and the caret remains
    /// continuously visible.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Rectangle()
            .frame(
                width: DSSize.xsmall,
                height: height
            )
            .foregroundStyle(color)
            .opacity(visible ? 1 : .zero)
            .task {
                // Reduce Motion keeps the caret continuously visible.
                guard !reduceMotion else { return }

                withAnimation(
                    .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                ) {
                    visible = false
                }
            }
    }
}
