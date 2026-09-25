import SwiftUI

// MARK: - DSToast

/// A snackbar-style notification banner that appears over the content to communicate
/// real-time state updates, such as successful appointment confirmations.
///
/// It features a rounded container anchored on the theme's `Color.ink` palette, with a leading
/// status dot tracking confirmation indicators.
///
/// ```swift
/// DSToast(message: "O salão confirmou seu horário.")
/// ```
public struct DSToast: View {
    /// The message string to be displayed inside the toast.
    let message: String
    /// The status indicator dot color. Defaults to `Color.confirmed`.
    let dotColor: Color
    
    /// Creates a `DSToast`.
    /// - Parameters:
    ///   - message: The text content conveying the notification message.
    ///   - dotColor: The tracking indicator dot color (default `Color.confirmed`).
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
