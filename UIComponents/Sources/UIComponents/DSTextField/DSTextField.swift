import SwiftUI

/// A text field with a persistent label, optional validation feedback, and
/// behavior configured by ``DSTextFieldKind``.
///
/// `DSTextField` provides a consistent input surface for the design system
/// while allowing the caller to control the field's value and validation state.
///
/// The component does not perform general-purpose validation. When an error is
/// detected, the caller provides the message through `errorMessage`.
///
/// For secure fields, the component also provides a button that toggles between
/// the secure and plain-text representations of the value.
///
/// ## Example
///
/// ```swift
/// @State private var name = ""
///
/// DSTextField(
///     label: "Nome",
///     placeholder: "Digite seu nome",
///     text: $name,
///     kind: .name
/// )
/// ```
///
/// ## Validation
///
/// Validation is owned by the caller. To display an error, provide a non-empty
/// `errorMessage`:
///
/// ```swift
/// DSTextField(
///     label: "E-mail",
///     placeholder: "Digite seu e-mail",
///     text: $email,
///     kind: .email,
///     errorMessage: "Digite um e-mail válido."
/// )
/// ```
///
/// ## Password fields
///
/// When `kind.isSecure` is `true`, the field uses `SecureField` by default and
/// displays a control that allows the person to reveal or hide the password.
///
/// Password fields also provide visual feedback when the component's password
/// requirements are satisfied.
///
/// ## Accessibility
///
/// The visible field label is hidden from the accessibility tree because the
/// input itself exposes the same text as its accessibility label. This avoids
/// announcing the label twice.
///
/// The password reveal control exposes an appropriate localized accessibility
/// label describing whether activating it will show or hide the password.
///
/// ## Focus handling
///
/// `onLostFocus` is called whenever the field transitions from focused to
/// unfocused. This allows the owner to trigger validation or other side effects
/// without coupling validation logic to the component.
///
/// - Important: The component does not own validation errors. The caller is
///   responsible for deciding when an error exists and what message should be
///   displayed.
public struct DSTextField: View {
    @FocusState private var isFocused: Bool
    @State private var isRevealed = false
    @Environment(\.dsTheme) private var theme

    /// Minimum number of characters required by the password rules.
    private static let minPasswordLength: Int = 8

    /// Target number of characters used by the password rules.
    private static let idealPasswordLength: Int = 12

    /// The persistent label displayed above the input.
    let label: String

    /// Placeholder displayed while the field has no value.
    let placeholder: String

    /// The value displayed and edited by the field.
    @Binding var text: String

    /// Defines the input behavior and configuration of the field.
    var kind: DSTextFieldKind = .name

    /// Optional validation message displayed below the field.
    ///
    /// An empty string or `nil` hides the feedback label.
    var errorMessage: String?

    /// Called when the field loses focus.
    ///
    /// This callback can be used by the owner to trigger validation or other
    /// side effects.
    var onLostFocus: () -> Void = {}


    /// Creates a text field configured for a specific input kind.
    ///
    /// - Parameters:
    ///   - label: The persistent label displayed above the input.
    ///   - placeholder: Placeholder text shown while the field is empty.
    ///   - text: A binding to the field's current value.
    ///   - kind: The input configuration, including keyboard, capitalization,
    ///     content type, and secure-entry behavior.
    ///   - errorMessage: An optional validation message displayed below the
    ///     field.
    ///   - onLostFocus: A closure called when the field loses focus.
    public init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        kind: DSTextFieldKind = .name,
        errorMessage: String? = nil,
        onLostFocus: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.kind = kind
        self.errorMessage = errorMessage
        self.onLostFocus = onLostFocus
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                labelView

                HStack(spacing: DSSpacing.sm) {
                    inputField

                    if kind.isSecure {
                        revealButton
                    }
                }
            }
            .padding(.horizontal, DSPadding.regular)
            .padding(.vertical, DSPadding.medium)
            .background(
                RoundedRectangle(
                    cornerRadius: DSRadius.control
                )
                .stroke(
                    borderColor,
                    lineWidth: borderWidth
                )
            )

            if let errorMessage, !errorMessage.isEmpty {
                DSFeedbackLabel(
                    message: errorMessage,
                    tone: .failure
                )
            }
        }
    }

    // MARK: - Label

    /// The visible field label.
    ///
    /// The label is hidden from accessibility because the input field exposes
    /// the same value as its accessibility label.
    private var labelView: some View {
        Text(label)
            .font(DSFont.technicalTag)
            .textCase(.uppercase)
            .tracking(DSTracking.upperTag)
            .foregroundStyle(theme.secondaryColor)
            .accessibilityHidden(true)
    }

    // MARK: - Input

    /// The appropriate SwiftUI input control for the configured field kind.
    ///
    /// Secure fields use `SecureField` until the person explicitly reveals
    /// their value.
    @ViewBuilder
    private var inputField: some View {
        Group {
            if kind.isSecure && !isRevealed {
                SecureField(
                    placeholder,
                    text: $text
                )
            } else {
                TextField(
                    placeholder,
                    text: $text
                )
            }
        }
        .font(theme.bodyFont)
        .foregroundStyle(theme.titleColor)
        .keyboardType(kind.keyboardType)
        .textInputAutocapitalization(kind.capitalisation)
        .textContentType(kind.contentType)
        .autocorrectionDisabled(kind.disablesAutocorrection)
        .focused($isFocused)
        .accessibilityLabel(label)
        .onChange(of: isFocused) { focused in
            if !focused {
                onLostFocus()
            }
        }
    }

    // MARK: - Password Reveal

    /// Button used to switch between hidden and visible password text.
    ///
    /// The button's accessibility label changes according to the action that
    /// will be performed.
    private var revealButton: some View {
        Button {
            isRevealed.toggle()
        } label: {
            Image(
                systemName: isRevealed
                    ? "eye.slash"
                    : "eye"
            )
            .foregroundStyle(theme.secondaryColor)
            .frame(
                width: DSSize.large,
                height: DSSize.large
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            isRevealed
                ? String(
                    localized: "textFieldHidePassword",
                    bundle: .module
                )
                : String(
                    localized: "textFieldShowPassword",
                    bundle: .module
                )
        )
    }

    // MARK: - Border

    /// Whether the field currently has a validation error.
    private var hasError: Bool {
        !(errorMessage ?? "").isEmpty
    }

    /// Whether the configured password requirements are satisfied.
    private var passwordRequirementsMet: Bool {
        guard kind.isSecure else { return false }
        return DSTextField.passwordRequirementsMet(for: text)
    }

    /// Returns whether the password satisfies the component's length rules.
    ///
    /// The current implementation requires at least 8 characters and a target
    /// length of at least 12 characters. Because satisfying the 12-character
    /// rule also satisfies the 8-character rule, the resulting condition is
    /// effectively equivalent to requiring at least 12 characters.
    ///
    /// - Parameter text: The password to evaluate.
    /// - Returns: `true` when all password length rules are satisfied.
    static func passwordRequirementsMet(for text: String) -> Bool {
        text.count >= DSTextField.minPasswordLength
            && text.count >= DSTextField.idealPasswordLength
    }

    /// The border color according to the field's current state.
    ///
    /// Errors have the highest priority, followed by satisfied password
    /// requirements, focus, and finally the default border color.
    private var borderColor: Color {
        if hasError {
            return theme.errorColor
        }

        if passwordRequirementsMet {
            return theme.successColor
        }

        if isFocused {
            return theme.brandColor
        }

        return theme.borderColor
    }

    /// The border thickness according to the field's current state.
    ///
    /// The border becomes heavier while the field is focused, has an error, or
    /// has satisfied its password requirements.
    private var borderWidth: CGFloat {
        hasError
            || passwordRequirementsMet
            || isFocused
            ? DSBorder.heavy
            : DSBorder.thin
    }
}
