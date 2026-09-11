import SwiftUI

/// Reusable text field with label, placeholder, validation, and visual feedback.
///
/// Validation feedback is displayed below the field as a `DSFeedbackLabel`. When
/// `errorMessage` is set, it is shown as failure feedback.
///
/// ```swift
/// @State private var name = ""
/// @State private var error: String? = nil
///
/// DSTextField(
///     label: "Name",
///     placeholder: "Enter your full name",
///     text: $name,
///     errorMessage: error,
///     onLostFocus: {
///         error = name.isEmpty ? "Please fill in the name." : nil
///     }
/// )
/// ```
///
/// ## Accessibility
/// The `label` is used as the field's `accessibilityLabel` so that VoiceOver keeps
/// announcing the context even after the placeholder disappears.
/// Validation feedback is exposed through `accessibilityValue`.
public struct DSTextField: View {
    /// Label text displayed above the field.
    let label: String
    /// Placeholder text shown while the field is empty.
    let placeholder: String
    /// Two-way binding to the typed text.
    @Binding var text: String
    /// Error message shown below the field.
    var errorMessage: String? = nil
    ///
    var kind: DSTextFieldStyle = .name
    /// Keyboard type to present. Default: `.default`.
    var keyboardType: UIKeyboardType = .default
    /// Autocapitalization policy. Default: `.words`.
    var autocapitalization: TextInputAutocapitalization = .words
    /// Content type for iOS autofill (e.g. `.name`, `.emailAddress`).
    var textContentType: UITextContentType? = nil
    /// Callback fired when the field loses focus. Ideal for validation on blur.
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool
    @Environment(\.dsTheme) private var theme

    /// Creates a `DSTextField`.
    /// - Parameters:
    ///   - label: Visible label above the field.
    ///   - placeholder: Hint text inside the field.
    ///   - text: Binding to the typed value.
    ///   - kind:
    ///   - errorMessage: Error message to display below the field.
    ///   - keyboardType: Keyboard type (default `.default`).
    ///   - autocapitalization: Capitalization policy (default `.words`).
    ///   - textContentType: Type for autofill (optional).
    ///   - onLostFocus: Closure called when focus is lost.
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        kind: DSTextFieldStyle = .name,
        errorMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .words,
        textContentType: UITextContentType? = nil,
        onLostFocus: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.kind = kind
        self.errorMessage = errorMessage
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textContentType = textContentType
        self.onLostFocus = onLostFocus
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            headerLabel
            systemTextField
            
            if let feedback {
                DSFeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        ).padding()
    }
}

extension DSTextField {
   private var headerLabel: some View {
        Text(label)
           .font(DSFont.etiqueta)
           .textCase(.uppercase)
           .tracking(1.2)
           .foregroundStyle(theme.secondaryColor)
    }

    private var systemTextField: some View {
        TextField(placeholder, text: $text)
            .keyboardType(kind.keyboardType)
            .textInputAutocapitalization(autocapitalization)
            .textContentType(textContentType)
            .autocorrectionDisabled()
            .font(DSFont.etiqueta)
            .textCase(.uppercase)
            .tracking(1.2)
            .focused($isFocused)
            .accessibilityLabel(label)
            .accessibilityValue(feedback?.message ?? "")
            .onChange(of: isFocused) { newValue in
                if !newValue { onLostFocus() }
            }
    }

    private var feedback: (message: String, tone: DSFeedbackTone)? {
        if let errorMessage, !errorMessage.isEmpty {
            return (errorMessage, .failure)
        }
        return nil
    }
}
