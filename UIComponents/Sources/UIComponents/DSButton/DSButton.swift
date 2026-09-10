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
/// - Note: The button stops responding to taps while `isEnabled` is `false`
///   or `isLoading` is `true`.
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
    /// - A circular progress indicator is displayed alongside the title.
    /// - The background color is displayed with reduced opacity.
    /// - The border color, when present, is displayed with reduced opacity.
    ///
    /// Defaults to `false`.
    var isLoading: Bool = false

    /// Controls the enabled state of the button.
    ///
    /// When `false`, the button uses disabled colors, removes its border, and
    /// stops responding to taps.
    ///
    /// Defaults to `true`.
    var isEnabled: Bool = true

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
    ///   - isEnabled: Whether the button is enabled. Defaults to `true`.
    ///   - accessibilityHint: An optional hint providing additional
    ///     accessibility context.
    ///   - action: The closure to execute when the button is activated.
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

// MARK: - Helper

/// A view modifier that conditionally applies an accessibility hint.
///
/// The modifier avoids applying an empty or missing accessibility hint when
/// `hint` is `nil`.
/// A view modifier that conditionally applies an accessibility value.
///
/// The modifier avoids applying an empty or missing accessibility value when
/// `value` is `nil`, which prevents redundant announcements (for example, the
/// native "dimmed" state already conveyed by `disabled`).
private struct OptionalAccessibilityValue: ViewModifier {
    /// The optional accessibility value to apply.
    let value: String?

    /// Applies the accessibility value when one is available.
    ///
    /// - Parameter content: The view to which the modifier is applied.
    /// - Returns: The original view, optionally configured with an
    ///   accessibility value.
    func body(content: Content) -> some View {
        if let value {
            content.accessibilityValue(value)
        } else {
            content
        }
    }
}

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
