import SwiftUI

/// Text field with a permanent label, feedback and per-kind configuration.
///
/// The component does not perform validation. Errors are supplied by the caller.
public struct DSTextField: View {
    private static let minPasswordLength: Int = 8
    private static let idealPasswordLength: Int = 12

    let label: String
    let placeholder: String

    @Binding var text: String

    var kind: DSTextFieldKind = .name
    var errorMessage: String?
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool
    @State private var isRevealed = false

    @Environment(\.dsTheme) private var theme

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
                    cornerRadius: DSRadius.control)
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

    private var labelView: some View {
        Text(label)
            .font(DSFont.technicalTag)
            .textCase(.uppercase)
            .tracking(DSTracking.upperTag)
            .foregroundStyle(theme.secondaryColor)
            .accessibilityHidden(true)
    }

    // MARK: - Input

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
            .frame(width: DSSize.touchTarget,
                   height: DSSize.touchTarget)
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

    private var hasError: Bool {
        !(errorMessage ?? "").isEmpty
    }

    private var passwordRequirementsMet: Bool {
        guard kind.isSecure else { return false }
        return DSTextField.passwordRequirementsMet(for: text)
    }

    /// Both password rules satisfied: at least 8 characters, and 12 or more.
    static func passwordRequirementsMet(for text: String) -> Bool {
        text.count >= DSTextField.minPasswordLength && text.count >= DSTextField.idealPasswordLength
    }

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

    private var borderWidth: CGFloat {
        hasError || passwordRequirementsMet || isFocused ? DSBorder.heavy : DSBorder.thin
    }
}
