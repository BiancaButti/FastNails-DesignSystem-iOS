import SwiftUI

// MARK: - DSAlertModifier

/// Presents a `DSAlert` as an animated overlay above the modified content.
///
/// Use this modifier to control alert presentation through a Boolean binding.
/// It dims the underlying content, intercepts background taps to dismiss the alert, and animates the alert's appearance.
struct DSAlertModifier: ViewModifier {
    /// A binding that determines whether the alert is presented.
    @Binding var isPresented: Bool

    /// A closure that creates the alert displayed by the modifier.
    let alert: () -> DSAlert

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                DSColor.ink.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }

                alert()
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
}
