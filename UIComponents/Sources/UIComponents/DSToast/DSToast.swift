import SwiftUI

// MARK: - DSToast

/// A transient notification banner used to communicate short-lived updates
/// or feedback over the current content.
///
/// `DSToast` displays a message inside a rounded dark container with a leading
/// status indicator. The indicator color can be customized to match the type
/// of feedback being presented.
///
/// The toast is presentation-only: it does not manage its own visibility or
/// dismissal. The caller is responsible for deciding when it should be shown
/// and removed from the view hierarchy.
///
/// ## Example
///
/// ```swift
/// DSToast(message: "O salão confirmou seu horário.")
/// ```
///
/// ## Custom indicator
///
/// The status indicator uses `DSColor.confirmed` by default, but a custom color
/// can be provided when the notification represents a different state.
///
/// ```swift
/// DSToast(
///     message: "Seu horário foi atualizado.",
///     dotColor: DSColor.warning
/// )
/// ```
public struct DSToast: View {
    /// The message displayed by the toast.
    let message: String

    /// The color of the leading status indicator.
    ///
    /// Defaults to `DSColor.confirmed`.
    let dotColor: Color
    
    /// Creates a toast notification.
    ///
    /// - Parameters:
    ///   - message: The message displayed to the user.
    ///   - dotColor: The color of the leading status indicator.
    ///     Defaults to `DSColor.confirmed`.
    public init(
        message: String,
        dotColor: Color = DSColor.confirmed
    ) {
        self.message = message
        self.dotColor = dotColor
    }

    public var body: some View {
        HStack(spacing: DSSpacing.md) {
            Circle()
                .fill(dotColor)
                .frame(width: DSSize.small,
                       height: DSSize.small)
            
            Text(message)
                .font(DSFont.fieldLabel)
                .foregroundColor(.white)
                .lineLimit(DSTextLimit.description)
            
            Spacer()
        }
        .padding(.horizontal, DSPadding.regular)
        .padding(.vertical, DSPadding.regular)
        .background(DSColor.ink)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous))
        .shadow(color: .black.opacity(0.12),
                radius: DSRadius.small,
                x: .zero,
                y: 4)
    }
}
