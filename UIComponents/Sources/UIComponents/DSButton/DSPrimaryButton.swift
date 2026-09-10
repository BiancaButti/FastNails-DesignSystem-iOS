import SwiftUI

/// A design system button that provides a consistent appearance and interaction
/// behavior across the application.
///
/// `DSButton` delegates its visual configuration to `DSButtonAppearance`, using
/// the current `DSTheme`, `DSButtonStyle`, and `DSButtonTone`. This view is
/// responsible for applying the resolved appearance to the SwiftUI button
/// hierarchy.
///
/// The button supports enabled, disabled, and loading visual states, as well
/// as optional accessibility hints.
///
/// ## Example
///
/// ```swift
/// DSButton(
///     title: "Continue",
///     style: .primary,
///     tone: .brand,
///     isEnabled: true,
///     accessibilityHint: "Continues to the next step"
/// ) {
///     continueAction()
/// }
/// ```
///
/// - Note: `isEnabled` controls the button's visual state. The button is
///   explicitly disabled by SwiftUI only while `isLoading` is `true`.
public struct DSButton: View {
    @Environment(\.dsTheme) private var theme

    /// The text displayed inside the button.
    let title: String

    /// The visual style of the button.
    ///
    /// Defaults to `.primary`.
    var style: DSButtonStyle = .primary

    /// The semantic color tone applied to the button.
    ///
    /// Defaults to `.brand`.
    var tone: DSButtonTone = .brand

    /// Indicates whether the button is currently loading.
    ///
    /// When loading:
    /// - The button action is disabled.
    /// - The background color is displayed with reduced opacity.
    /// - The border color, when present, is displayed with reduced opacity.
    ///
    /// Defaults to `false`.
    ///
    /// - Note: The current implementation does not display a loading indicator.
    var isLoading: Bool = false

    /// Controls the visual enabled state of the button.
    ///
    /// When `false`, the button uses disabled colors and removes its border.
    ///
    /// Defaults to `false`.
    ///
    /// - Important: This property currently controls the button's appearance
    ///   only. Interaction is disabled when `isLoading` is `true`.
    var isEnabled: Bool = false

    /// An optional accessibility hint that provides additional context about
    /// the button's action.
    ///
    /// When a value is provided, it is exposed through SwiftUI's
    /// `accessibilityHint`.
    var accessibilityHint: String?

    /// The closure executed when the button is activated.
    let action: () -> Void

    /// Creates a design system button.
    ///
    /// - Parameters:
    ///   - title: The text displayed inside the button.
    ///   - style: The visual style of the button. Defaults to `.primary`.
    ///   - tone: The semantic color tone of the button. Defaults to `.brand`.
    ///   - isLoading: Whether the button is currently loading. Defaults to
    ///     `false`.
    ///   - isEnabled: Whether the button should appear enabled. Defaults to
    ///     `false`.
    ///   - accessibilityHint: An optional hint providing additional
    ///     accessibility context.
    ///   - action: The closure to execute when the button is activated.
    public init(
        title: String,
        style: DSButtonStyle = .primary,
        tone: DSButtonTone = .brand,
        isLoading: Bool = false,
        isEnabled: Bool = false,
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

    /// The view hierarchy that renders the button.
    ///
    /// The appearance is resolved from `DSButtonAppearance` using the current
    /// theme, style, and tone.
    ///
    /// The button automatically applies:
    /// - The design system button font.
    /// - Design system spacing.
    /// - Design system corner radius.
    /// - Enabled, disabled, and loading colors.
    /// - Accessibility labels and optional hints.
    public var body: some View {
        let appearance = DSButtonAppearance(
            style: style,
            tone: tone,
            theme: theme
        )

        let disabledFill = theme.secondaryColor.opacity(0.35)

        let background = !isEnabled
            ? disabledFill
            : (isLoading
                ? appearance.background.opacity(0.6)
                : appearance.background)

        let borderColor: Color? = !isEnabled
            ? nil
            : appearance.borderColor.map {
                isLoading ? $0.opacity(0.6) : $0
            }

        let textColor = isEnabled
            ? appearance.textColor
            : theme.titleColor.opacity(0.45)

        Button(action: action) {
            Text(title)
                .font(theme.buttonFont)
                .foregroundStyle(textColor)
                .frame(maxWidth: style == .tertiary ? nil : .infinity)
                .frame(minHeight: 48)
                .padding(.horizontal, DSSpacing.lg)
                .background(background)
                .overlay {
                    if let borderColor {
                        RoundedRectangle(
                            cornerRadius: DSRadius.controle
                        )
                        .strokeBorder(
                            borderColor,
                            lineWidth: 1.5
                        )
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: DSRadius.controle
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .animation(
            .easeInOut(duration: 0.2),
            value: isEnabled
        )
        .accessibilityLabel(title)
        .modifier(
            OptionalAccessibilityHint(
                hint: accessibilityHint
            )
        )
    }
}

// MARK: - Helper

/// A view modifier that conditionally applies an accessibility hint.
///
/// The modifier avoids applying an empty or missing accessibility hint when
/// `hint` is `nil`.
private struct OptionalAccessibilityHint: ViewModifier {
    /// The optional accessibility hint to apply.
    let hint: String?

    /// Applies the accessibility hint when one is available.
    ///
    /// - Parameter content: The view to which the modifier is applied.
    /// - Returns: The original view, optionally configured with an
    ///   accessibility hint.
    func body(content: Content) -> some View {
        if let hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}
