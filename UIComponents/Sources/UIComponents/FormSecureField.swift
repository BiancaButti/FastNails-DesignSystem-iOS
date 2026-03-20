import SwiftUI

struct FormSecureField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    var errorMessage: String? = nil
    var systemStyle: Bool = false
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
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
                    .accessibilityHint(errorMessage ?? String(localized: "accessibilityButtonTouchTwice"))
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
                            errorMessage != nil
                                ? Color.red.opacity(0.8)
                                : isFocused ? Color.accentColor.opacity(0.5) : Color(.systemGray4),
                            lineWidth: errorMessage != nil || isFocused ? 1.5 : 0.5
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
                    .accessibilityHint(errorMessage ?? String(localized: "accessibilityButtonTouchTwice"))
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
                            errorMessage != nil
                                ? Color.red.opacity(0.8)
                                : isFocused ? Color.accentColor.opacity(0.5) : Color.clear,
                            lineWidth: 1.5
                        )
                }
            }

            if let error = errorMessage {
                ErrorLabel(message: error)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
