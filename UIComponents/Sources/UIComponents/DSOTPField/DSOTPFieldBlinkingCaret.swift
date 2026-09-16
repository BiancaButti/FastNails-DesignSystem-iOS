import SwiftUI

// MARK: - Caret

/// Blinking caret that marks the active digit box in ``DSOTPField``.
///
/// A thin vertical bar that fades in and out forever to signal where the next
/// digit will land. It is a pure decoration: the real cursor lives in the
/// hidden text field behind the boxes, so this view is marked
/// `accessibilityHidden` by its parent.
///
/// The caret is an implementation detail of ``DSOTPField`` and is not part of
/// the package's public API.
///
/// ## Reduce Motion
/// When **Reduce Motion** is enabled the caret stops blinking and stays solid,
/// still marking the active box without any animation.
struct DSOTPFieldBlinkingCaret: View {

    /// Fill color of the bar. ``DSOTPField`` passes the theme's brand color.
    let color: Color

    /// Height of the bar in points, sized relative to the box height.
    let height: CGFloat

    /// Drives the blink. Toggled inside an autoreversing, repeating animation.
    @State private var visible = true

    /// When on, the caret stays solid instead of blinking.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Rectangle()
            .frame(width: 2, height: height)
            .foregroundStyle(color)
            .opacity(visible ? 1 : 0)
            .task {
                // With reduce motion on, the caret stays put.
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    visible = false
                }
            }
    }
}
