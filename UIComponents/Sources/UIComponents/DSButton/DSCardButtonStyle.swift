import SwiftUI

// MARK: - DSCardButtonStyle

/// Defines a filled, full-width button style for actions displayed inside status-style cards.
///
/// Use `DSCardButtonStyle` when the button's colors should be inherited from its host container.
/// The style adapts its foreground and background colors to the provided card palette and reduces opacity while pressed.
///
/// ```swift
/// Button("Action") {
///     performAction()
/// }
/// .buttonStyle(
///     .dsStatusCard(
///         background: palette.actionBackground,
///         foreground: palette.actionForeground
///     )
/// )
/// ```
struct DSCardButtonStyle: ButtonStyle {
    /// The background color applied to the button.
    let background: Color

    /// The foreground color applied to the button's label and icons.
    let foreground: Color

    /// Creates a `DSCardButtonStyle`.
    /// - Parameters:
    ///   - background: The background color applied to the button.
    ///   - foreground: The foreground color applied to the button's label and icons.
    init(
        background: Color,
        foreground: Color
    ) {
        self.background = background
        self.foreground = foreground
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSFont.inputSupportBold)
            .foregroundStyle(foreground)
            .multilineTextAlignment(.center)
            .padding(.vertical, DSPadding.small)
            .padding(.horizontal, DSPadding.medium)
            .frame(maxWidth: .infinity)
            .background(
                background,
                in: .rect(
                    cornerRadius: DSRadius.control,
                    style: .continuous
                )
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

// MARK: - Ergonomic Factory

extension ButtonStyle where Self == DSCardButtonStyle {
    /// Creates a card button style using the provided container colors.
    /// - Parameters:
    ///   - background: The background color applied to the button.
    ///   - foreground: The foreground color applied to the button's label and icons.
    /// - Returns: A `DSCardButtonStyle` configured with the provided colors.
    static func dsStatusCard(
        background: Color,
        foreground: Color
    ) -> DSCardButtonStyle {
        DSCardButtonStyle(
            background: background,
            foreground: foreground
        )
    }
}
