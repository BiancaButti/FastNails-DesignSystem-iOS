import SwiftUI

// MARK: - DSOTPField

/// A one-time code field that renders each digit in a separate visual box.
///
/// Use `DSOTPField` for verification codes and other short numeric credentials.
/// Input is captured by a single text field, restricted to digits, limited to `length`, and automatically reported through `onComplete` when the code is complete.
///
/// ```swift
/// @State private var code = ""
///
/// DSOTPField(
///     label: "Código de verificação",
///     code: $code,
///     length: 6,
///     errorMessage: viewModel.codeError,
///     onComplete: { viewModel.verify($0) }
/// )
/// ```
///
/// ## Accessibility
/// The visual digit boxes are hidden from assistive technologies and the underlying text field provides the accessible interaction.
/// The entered code is exposed digit by digit, while validation feedback is exposed as the field's accessibility hint.
public struct DSOTPField: View {
    
    @Environment(\.dsTheme) private var theme
    
    /// The code typed so far. Digits only, at most `length` characters.
    @Binding var code: String

    /// Tracks whether the current code has already triggered `onComplete`.
    ///
    /// Deleting a digit resets the completion state and allows the callback to fire again.
    @State private var completion = DSOTPFieldCompletionTracker()

    /// Controls focus for the underlying text field and determines whether the active digit box is displayed.
    @FocusState private var isFocused: Bool

    /// The label displayed above the code field and exposed as its accessibility label.
    let label: String

    /// An optional validation message displayed below the field using the failure tone.
    ///
    /// When both error and success messages are provided, the error message takes priority.
    var errorMessage: String?

    /// An optional validation message displayed below the field using the success tone.
    ///
    /// This message is ignored when a non-empty `errorMessage` is provided.
    var successMessage: String?

    /// The closure executed once when the code reaches the configured `length`.
    ///
    /// The callback receives the complete numeric code and fires only once for each completed code.
    /// Deleting a digit rearms the callback for the next completion.
    var onComplete: ((String) -> Void)?

    /// The number of digits displayed and accepted by the field.
    ///
    /// Values below `1` are automatically clamped to `1`.
    private let length: Int

    /// Creates a one-time code field.
    /// - Parameters:
    ///   - label: The text displayed above the field and used as its accessibility label.
    ///   - code: A binding containing the entered numeric code. Non-digit characters are filtered out and the value is limited to `length` characters.
    ///   - length: The number of digit boxes displayed and the maximum number of accepted digits. Values below `1` are clamped to `1`. Defaults to `6`.
    ///   - errorMessage: An optional failure message displayed below the field. Takes priority over `successMessage`.
    ///   - successMessage: An optional success message displayed below the field when no error message is present.
    ///   - onComplete: An optional closure called once when the code reaches `length` digits. Deleting a digit allows the callback to fire again for the next completed code.
    public init(
        label: String,
        code: Binding<String>,
        length: Int = 6,
        errorMessage: String? = nil,
        successMessage: String? = nil,
        onComplete: ((String) -> Void)? = nil
    ) {
        self.label = label
        self._code = code
        self.length = max(1, length)
        self.errorMessage = errorMessage
        self.successMessage = successMessage
        self.onComplete = onComplete
    }

    /// Resolves the validation feedback currently displayed by the field.
    ///
    /// A non-empty error message takes precedence over a success message.
    private var feedback: (message: String, tone: DSFeedbackTone)? {
        if let errorMessage, !errorMessage.isEmpty {
            return (errorMessage, .failure)
        }

        if let successMessage, !successMessage.isEmpty {
            return (successMessage, .success)
        }

        return nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(label)
                .font(theme.labelFont)
                .foregroundStyle(theme.secondaryColor)
                .accessibilityHidden(true)

            ZStack {
                HStack(spacing: DSSpacing.sm) {
                    ForEach(0..<length, id: \.self) { index in
                        digitBox(at: index)
                    }
                }
                .accessibilityHidden(true)

                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .frame(height: DSSize.xhuge)
                    .foregroundStyle(.clear)
                    .tint(.clear)
                    .accessibilityLabel(label)
                    .accessibilityValue(spokenValue)
                    .accessibilityHint(
                        feedback?.message
                            ?? String(
                                localized: "otpFieldAccessibilityHint",
                                bundle: .module
                            )
                    )
                    .onChange(of: code) { newValue in
                        handleChange(newValue)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }

            if let feedback {
                DSFeedbackLabel(
                    message: feedback.message,
                    tone: feedback.tone
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    /// Returns the entered code formatted for digit-by-digit VoiceOver announcements.
    private var spokenValue: String {
        code.isEmpty
            ? String(
                localized: "otpFieldAccessibilityEmpty",
                bundle: .module
            )
            : code.map(String.init).joined(separator: " ")
    }

    /// Sanitizes changed input and triggers completion when the code becomes complete.
    /// - Parameter newValue: The latest value reported by the underlying text field.
    private func handleChange(_ newValue: String) {
        let digits = DSOTPFieldInput.sanitize(
            newValue,
            length: length
        )

        if code != digits {
            code = digits
        }

        if completion.shouldComplete(
            digits,
            length: length
        ) {
            onComplete?(digits)
        }
    }

    // MARK: - Digit box

    /// Renders the visual representation of a single code digit.
    /// - Parameter index: The zero-based position of the digit within the code.
    @ViewBuilder
    private func digitBox(at index: Int) -> some View {
        let characters = Array(code)
        let character = index < characters.count
            ? String(characters[index])
            : ""

        let isCurrent =
            isFocused &&
            code.count < length &&
            index == code.count

        let feedbackColor = feedback.map {
            $0.tone.color(for: theme)
        }

        let border: Color =
            feedbackColor
            ?? (isCurrent ? theme.brandColor : theme.borderColor)

        let borderWidth: CGFloat =
            (feedbackColor != nil || isCurrent) ? 2 : 1

        ZStack {
            RoundedRectangle(
                cornerRadius: DSRadius.control
            )
            .fill(theme.surfaceColor)
            .overlay {
                RoundedRectangle(
                    cornerRadius: DSRadius.control
                )
                .stroke(
                    border,
                    lineWidth: borderWidth
                )
            }

            if character.isEmpty && isCurrent {
                DSOTPFieldBlinkingCaret(
                    color: theme.brandColor,
                    height: DSSize.xhuge * 0.45
                )
            } else {
                Text(character)
                    .font(DSFont.codeDigit)
                    .foregroundStyle(
                        feedbackColor ?? theme.titleColor
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DSSize.xhuge)
        .animation(
            .easeInOut(duration: 0.15),
            value: isCurrent
        )
    }
}
