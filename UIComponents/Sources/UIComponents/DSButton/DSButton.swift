import SwiftUI

// MARK: - DSButton

/// A design system button with configurable style, tone, loading, and enabled states.
///
/// Use `DSButton` for actions that should follow the application's design tokens and interaction behavior.
/// The button automatically applies the resolved appearance and disables interaction while loading or disabled.
///
/// ```swift
/// DSButton(
///     title: "Continue",
///     style: .primary,
///     tone: .brand
/// ) {
///     continueAction()
/// }
/// ```
///
/// ## Accessibility
/// Supports an optional accessibility hint and exposes a loading state through `accessibilityValue`.
public struct DSButton: View {
    @Environment(\.dsTheme) private var theme

    /// The text displayed inside the button.
    let title: String

    /// The visual style of the button. Defaults to `.primary`.
    var style: DSButtonStyle = .primary

    /// The semantic color tone applied to the button. Defaults to `.brand`.
    var tone: DSButtonTone = .brand

    /// A Boolean value indicating whether the button is currently loading.
    ///
    /// When `true`, the button displays a progress indicator and does not respond to user interaction.
    /// Defaults to `false`.
    var isLoading: Bool = false

    /// A Boolean value indicating whether the button can be activated.
    ///
    /// When `false`, the button uses its disabled appearance and does not respond to user interaction.
    /// Defaults to `true`.
    var isEnabled: Bool = true

    /// An optional hint providing additional accessibility context for the button's action.
    var accessibilityHint: String?

    /// The closure executed when the button is activated.
    let action: () -> Void

    /// Creates a `DSButton`.
    /// - Parameters:
    ///   - title: The text displayed inside the button.
    ///   - style: The visual style of the button. Defaults to `.primary`.
    ///   - tone: The semantic color tone applied to the button. Defaults to `.brand`.
    ///   - isLoading: Whether the button is currently loading. Defaults to `false`.
    ///   - isEnabled: Whether the button can be activated. Defaults to `true`.
    ///   - accessibilityHint: An optional hint providing additional accessibility context.
    ///   - action: The closure executed when the button is activated.
    public init(
        title: String,
        style: DSButtonStyle = .primary,
        tone: DSButtonTone = .brand,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.tone = tone
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var body: some View {
        let appearance = DSButtonAppearance(
            style: style,
            tone: tone,
            theme: theme
        )

        let render = DSButtonRenderState(
            appearance: appearance,
            isEnabled: isEnabled,
            isLoading: isLoading,
            theme: theme
        )

        let background = render.background
        let borderColor = render.borderColor
        let textColor = render.textColor

        Button(action: action) {
            HStack(spacing: DSSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(textColor)
                }

                Text(title)
                    .font(theme.buttonFont)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(textColor)
            .frame(maxWidth: style == .tertiary ? nil : .infinity)
            .frame(minHeight: DSSize.huge)
            .padding(.horizontal, DSPadding.regular)
            .background(background)
            .overlay {
                if let borderColor {
                    RoundedRectangle(
                        cornerRadius: DSRadius.control
                    )
                    .strokeBorder(
                        borderColor,
                        lineWidth: 1.5
                    )
                }
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.control
                )
            )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isLoading)
        .animation(
            .easeInOut(duration: 0.2),
            value: isEnabled
        )
        .animation(
            .easeInOut(duration: 0.2),
            value: isLoading
        )
        .accessibilityLabel(title)
        .modifier(
            OptionalAccessibilityValue(
                value: isLoading
                    ? String(localized: "buttonLoadingAccessibility", bundle: .module)
                    : nil
            )
        )
        .modifier(
            OptionalAccessibilityHint(
                hint: accessibilityHint
            )
        )
    }
}

// MARK: - Helpers

/// Applies an accessibility value only when one is provided.
private struct OptionalAccessibilityValue: ViewModifier {
    /// The optional accessibility value to apply.
    let value: String?

    /// Applies the accessibility value when available.
    func body(content: Content) -> some View {
        if let value {
            content.accessibilityValue(value)
        } else {
            content
        }
    }
}

/// Applies an accessibility hint only when one is provided.
private struct OptionalAccessibilityHint: ViewModifier {
    /// The optional accessibility hint to apply.
    let hint: String?

    /// Applies the accessibility hint when available.
    func body(content: Content) -> some View {
        if let hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}
