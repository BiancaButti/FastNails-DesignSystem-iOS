import SwiftUI

// MARK: - OTPField

struct OTPField: View {
    let label: String
    @Binding var code: String
    var errorMessage: String? = nil

    @FocusState private var isFocused: Bool
    private let length = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .accessibilityHidden(true)

            HStack(spacing: 8) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .frame(height: 52)
            .onTapGesture { isFocused = true }
            .overlay {
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .opacity(0)
                    .onChange(of: code) { newValue in
                        let digits = String(newValue.filter(\.isNumber).prefix(length))
                        if code != digits { code = digits }
                    }
            }

            if let error = errorMessage {
                ErrorLabel(message: error)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(
            code.isEmpty
                ? String(localized: "otpFieldAccessibilityEmpty")
                : code.map { String($0) }.joined(separator: " ")
        )
        .accessibilityHint(errorMessage ?? String(localized: "otpFieldAccessibilityHint"))
        .accessibilityAddTraits(.allowsDirectInteraction)
    }

    // MARK: - Digit Box

    @ViewBuilder
    private func digitBox(at index: Int) -> some View {
        let chars = Array(code)
        let char = index < chars.count ? String(chars[index]) : ""
        let isCurrentBox = isFocused && index == min(code.count, length - 1)
        let hasError = errorMessage != nil

        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            hasError
                                ? Color.red.opacity(0.8)
                                : isCurrentBox ? Color.appPink : Color(.systemGray4),
                            lineWidth: hasError || isCurrentBox ? 2 : 1
                        )
                }

            if char.isEmpty && isCurrentBox {
                BlinkingCursor()
            } else {
                Text(char)
                    .font(.title2.bold())
                    .foregroundStyle(hasError ? Color.red.opacity(0.8) : Color.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }
}

// MARK: - BlinkingCursor

private struct BlinkingCursor: View {
    @State private var visible = true

    var body: some View {
        Rectangle()
            .frame(width: 2, height: 24)
            .foregroundStyle(Color.appPink)
            .opacity(visible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    visible = false
                }
            }
    }
}
