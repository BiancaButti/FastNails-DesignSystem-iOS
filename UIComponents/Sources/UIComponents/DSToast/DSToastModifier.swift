import SwiftUI

/// A view modifier that presents a ``DSToast`` over the current content.
///
/// `DSToastModifier` observes a binding that controls the toast visibility.
/// When presented, the toast is positioned near the bottom of the screen and
/// automatically dismissed after the configured duration.
///
/// The modifier is intended to be applied through a public `View` extension
/// that owns the presentation API, keeping the modifier itself as an internal
/// implementation detail.
///
/// ## Presentation
///
/// The toast is displayed while `isPresented` is `true`. When it appears, the
/// modifier schedules its dismissal and updates the binding back to `false`
/// using an animated transition.
///
/// ## Parameters
///
/// - `isPresented`: A binding that controls whether the toast is visible.
/// - `message`: The message displayed by the toast.
/// - `dotColor`: The color of the toast's leading status indicator.
/// - `duration`: The intended duration of the toast presentation.
///
/// - Important: The actual delay is currently provided by `delayTask`. The
///   modifier's default implementation uses a three-second delay.
struct DSToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let dotColor: Color
    let duration: TimeInterval
    
    var delayTask: (@escaping () -> Void) -> Void = { block in
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run { block() }
        }
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    DSToast(message: message, dotColor: dotColor)
                        .padding(.horizontal, DSPadding.regular)
                        .padding(.bottom, DSPadding.large)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .zIndex(DSLayoutIndex.base)
                .onAppear {
                    delayTask {
                        withAnimation(
                            .spring(response: DSAnimation.response,
                                    dampingFraction: DSAnimation.dampingFraction)) {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}
