import SwiftUI

public extension View {

    /// Sets the ``DSStatusCardVariant`` for every ``DSStatusCard`` in this
    /// view hierarchy.
    func statusCardVariant(_ variant: DSStatusCardVariant) -> some View {
        environment(\.statusCardVariant, variant)
    }

    /// Sets the ``DSStatusCardEmphasis`` for every ``DSStatusCard`` in this
    /// view hierarchy.
    func statusCardEmphasis(_ emphasis: DSStatusCardEmphasis) -> some View {
        environment(\.statusCardEmphasis, emphasis)
    }
    
    /// Presents a automatic disappearing `DSToast` banner anchored to the bottom edge of the screen.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the toast.
    ///   - message: The notification text to be displayed inside the toast.
    ///   - dotColor: The tracking indicator dot color (default `Color.confirmed`).
    ///   - duration: The presentation length in seconds before animating away (default 3.0 seconds).
    func dsToast(
        isPresented: Binding<Bool>,
        message: String,
        dotColor: Color = .confirmed,
        duration: TimeInterval = 3.0
    ) -> some View {
        self.modifier(
            DSToastModifier(
                isPresented: isPresented,
                message: message,
                dotColor: dotColor,
                duration: duration
            )
        )
    }

}
