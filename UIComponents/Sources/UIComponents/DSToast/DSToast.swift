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
        dotColor: Color = .confirmed
    ) {
        self.message = message
        self.dotColor = dotColor
    }

    public var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
            
            Text(message)
                .font(DSFont.fieldLabel)
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.ink)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
