import SwiftUI

public struct FormTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    var successMessage: String? = nil
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .words
    var textContentType: UITextContentType? = nil
    var systemStyle: Bool = false
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool

    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        successMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .words,
        textContentType: UITextContentType? = nil,
        systemStyle: Bool = false,
        onLostFocus: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.successMessage = successMessage
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textContentType = textContentType
        self.systemStyle = systemStyle
        self.onLostFocus = onLostFocus
    }

    private var feedback: (message: String, tone: FeedbackTone)? {
        if let errorMessage, !errorMessage.isEmpty {
            return (errorMessage, .failure)
        }

        if let successMessage, !successMessage.isEmpty {
            return (successMessage, .success)
        }

        return nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .accessibilityHidden(true)

            if systemStyle {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .textContentType(textContentType)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .accessibilityHint(feedback?.message ?? String(localized: "accessibilityButtonTouchTwice"))
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .textContentType(textContentType)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                feedback?.tone.color.opacity(0.8)
                                    ?? (isFocused ? Color.accentColor.opacity(0.5) : Color.clear),
                                lineWidth: 1.5
                            )
                    }
                    .onChange(of: isFocused) { newValue in
                        if !newValue { onLostFocus() }
                    }
                    .accessibilityHint(feedback?.message ?? String(localized: "accessibilityButtonTouchTwice"))
            }

            if let feedback {
                FeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
