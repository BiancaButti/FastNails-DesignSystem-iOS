import SwiftUI

struct FormTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .words
    var textContentType: UITextContentType? = nil
    var systemStyle: Bool = false
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
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
                    .accessibilityHint(errorMessage ?? String(localized: "accessibilityButtonTouchTwice"))
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
                                errorMessage != nil
                                    ? Color.red.opacity(0.8)
                                    : isFocused ? Color.accentColor.opacity(0.5) : Color.clear,
                                lineWidth: 1.5
                            )
                    }
                    .onChange(of: isFocused) { newValue in
                        if !newValue { onLostFocus() }
                    }
                    .accessibilityHint(errorMessage ?? String(localized: "accessibilityButtonTouchTwice"))
            }

            if let error = errorMessage {
                ErrorLabel(message: error)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
