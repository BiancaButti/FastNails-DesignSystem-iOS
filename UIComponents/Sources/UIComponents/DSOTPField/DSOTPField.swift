import SwiftUI

// MARK: - DSOTPField

/// One-time code field, rendered as separate boxes per digit.
///
/// Draws `length` boxes side by side and captures input through a single
/// hidden `TextField` behind them. Only digits are accepted, and the value
/// is clamped to `length`.
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
/// ## Behaviour
/// - Tapping any box focuses the hidden field and raises the numeric keyboard
/// - A blinking caret marks the active box
/// - Non-digit characters are filtered out as they arrive
/// - `onComplete` fires once per completed code, not on every keystroke
///
/// ## Accessibility
/// **The boxes are decoration.** The real control is the hidden text field,
/// which stays reachable by VoiceOver — it already knows how to be a text
/// field, announce insertions and raise the keyboard.
///
/// The value is read digit by digit ("1 2 3 4 5 6") so it is not spoken as
/// one large number.
public struct DSOTPField: View {
    
    @Environment(\.dsTheme) private var theme
    
    /// The code typed so far. Digits only, at most `length` characters.
    @Binding var code: String
    
    /// Fires `onComplete` exactly once per completed code.
    @State private var completion = DSOTPFieldCompletionTracker()
    
    @FocusState private var isFocused: Bool

    /// Label shown above the boxes.
    let label: String

    /// Error message shown below the field. Takes priority over `successMessage`.
    var errorMessage: String?

    /// Success message shown below the field.
    var successMessage: String?

    /// Called once the code reaches `length` digits, so the caller can verify
    /// without waiting for a button tap.
    var onComplete: ((String) -> Void)?

    /// Number of digits. Clamped to at least 1. Defaults to 6.
    private let length: Int

    /// Creates a one-time code field.
    ///
    /// - Parameters:
    ///   - label: Text shown above the boxes and used as the field's
    ///     accessibility label.
    ///   - code: Binding to the entered code. Kept digits-only and clamped to
    ///     `length`; non-digit input is filtered out as it arrives.
    ///   - length: Number of digit boxes. Clamped to at least 1. Defaults to 6.
    ///   - errorMessage: Message shown below the field in the failure tone.
    ///     Takes priority over `successMessage`.
    ///   - successMessage: Message shown below the field in the success tone.
    ///   - onComplete: Called once with the full code the moment it reaches
    ///     `length` digits, so the caller can verify without a button tap. Fires
    ///     once per completed code; deleting a digit rearms it.
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
                // Decoration. The boxes show the value; they do not hold it.
                HStack(spacing: DSSpacing.sm) {
                    ForEach(0..<length, id: \.self) { index in
                        digitBox(at: index)
                    }
                }
                .accessibilityHidden(true)

                // The real control. Invisible, but reachable: it already
                // behaves like a text field for VoiceOver and raises the
                // keyboard on its own.
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .frame(height: DSSize.xhuge)
                    .foregroundStyle(.clear)
                    .tint(.clear)
                    .accessibilityLabel(label)
                    .accessibilityValue(spokenValue)
                    .accessibilityHint(feedback?.message ?? String(localized: "otpFieldAccessibilityHint", bundle: .module))
                    .onChange(of: code) { newValue in
                        handleChange(newValue)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }

            if let feedback {
                DSFeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Digit by digit, so it is not read as one large number.
    private var spokenValue: String {
        code.isEmpty
            ? String(localized: "otpFieldAccessibilityEmpty", bundle: .module)
            : code.map(String.init).joined(separator: " ")
    }

    private func handleChange(_ newValue: String) {
        let digits = DSOTPFieldInput.sanitize(newValue, length: length)
        if code != digits { code = digits }

        if completion.shouldComplete(digits, length: length) {
            onComplete?(digits)
        }
    }

    // MARK: - Digit box

    @ViewBuilder
    private func digitBox(at index: Int) -> some View {
        let characters = Array(code)
        let character = index < characters.count ? String(characters[index]) : ""
        // Only the next empty box is active. A full code has no active box.
        let isCurrent = isFocused && code.count < length && index == code.count
        let feedbackColor = feedback.map { $0.tone.color(for: theme) }

        let border: Color = feedbackColor ?? (isCurrent ? theme.brandColor : theme.borderColor)
        let borderWidth: CGFloat = (feedbackColor != nil || isCurrent) ? 2 : 1

        ZStack {
            RoundedRectangle(cornerRadius: DSRadius.control)
                .fill(theme.surfaceColor)
                .overlay {
                    RoundedRectangle(cornerRadius: DSRadius.control)
                        .stroke(border, lineWidth: borderWidth)
                }

            if character.isEmpty && isCurrent {
                DSOTPFieldBlinkingCaret(
                    color: theme.brandColor,
                    height: DSSize.xhuge * 0.45)
            } else {
                Text(character)
                    .font(DSFont.codeDigit)
                    .foregroundStyle(feedbackColor ?? theme.titleColor)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DSSize.xhuge)
        .animation(.easeInOut(duration: 0.15), value: isCurrent)
    }
}


