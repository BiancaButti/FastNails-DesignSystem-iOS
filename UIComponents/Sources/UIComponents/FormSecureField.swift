import SwiftUI

public struct FormSecureField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    var errorMessage: String? = nil
    var successMessage: String? = nil
    var systemStyle: Bool = false
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool

    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>,
        errorMessage: String? = nil,
        successMessage: String? = nil,
        systemStyle: Bool = false,
        onLostFocus: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self._isVisible = isVisible
        self.errorMessage = errorMessage
        self.successMessage = successMessage
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
                HStack(spacing: 8) {
                    Group {
                        if isVisible {
                            TextField(placeholder, text: $text)
                        } else {
                            SecureField(placeholder, text: $text)
                        }
                    }
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .accessibilityHint(feedback?.message ?? String(localized: "accessibilityButtonTouchTwice"))
                    .onChange(of: isFocused) { newValue in
                        if !newValue { onLostFocus() }
                    }

                    Button {
                        isVisible.toggle()
                    } label: {
                        Image(systemName: isVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel(isVisible ? String(localized: "commonPasswordHide") :
                                                    String(localized: "commonPasswordShow"))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 7)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            feedback?.tone.color.opacity(0.8)
                                ?? (isFocused ? Color.accentColor.opacity(0.5) : Color(.systemGray4)),
                            lineWidth: feedback != nil || isFocused ? 1.5 : 0.5
                        )
                }
            } else {
                HStack(spacing: 8) {
                    Group {
                        if isVisible {
                            TextField(placeholder, text: $text)
                        } else {
                            SecureField(placeholder, text: $text)
                        }
                    }
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .accessibilityHint(feedback?.message ?? String(localized: "accessibilityButtonTouchTwice"))
                    .onChange(of: isFocused) { newValue in
                        if !newValue { onLostFocus() }
                    }

                    Button {
                        isVisible.toggle()
                    } label: {
                        Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.secondary)
                            .frame(width: 24, height: 24)
                    }
                    .accessibilityLabel(isVisible ? String(localized: "commonPasswordHide") :
                                                    String(localized: "commonPasswordShow"))
                }
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
            }

            if let feedback {
                FeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
