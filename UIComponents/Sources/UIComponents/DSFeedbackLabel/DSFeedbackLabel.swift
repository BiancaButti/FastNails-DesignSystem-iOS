import SwiftUI

/// Defines the semantic tone used by a ``DSFeedbackLabel``.
///
/// The tone determines the color and SF Symbol displayed alongside the
/// feedback message.
public enum DSFeedbackTone: CaseIterable {
    /// Indicates a positive result, valid field, or successful action.
    case success

    /// Indicates an error, invalid field, or failed action.
    case failure

    /// The default semantic color associated with the tone.
    ///
    /// This property uses the design system's static color tokens. Components
    /// that support ``DSTheme`` should use ``color(for:)`` to resolve the color
    /// from the active theme.
    public var color: Color {
        switch self {
        case .success:
            return DSColor.confirmed
        case .failure:
            return DSColor.alert
        }
    }

    /// Resolves the semantic color for the given design system theme.
    ///
    /// - Parameter theme: The active ``DSTheme`` used to resolve the color.
    /// - Returns: The color associated with this feedback tone.
    public func color(for theme: DSTheme) -> Color {
        switch self {
        case .success: return theme.successColor
        case .failure: return theme.errorColor
        }
    }

    /// The SF Symbol name used to represent this feedback tone.
    public var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .failure:
            return "exclamationmark.circle.fill"
        }
    }

    /// The localized accessibility prefix announced before the feedback
    /// message.
    var accessibilityPrefix: String {
        switch self {
        case .success:
            return String(localized: "accessibilitySuccess", bundle: .module)
        case .failure:
            return String(localized: "accessibilityError", bundle: .module)
        }
    }
}

/// A semantic feedback label with a colored icon and descriptive message.
///
/// `DSFeedbackLabel` communicates the result of an action or validation using
/// both an icon and text. It is primarily intended for use below form fields,
/// but can also be used wherever inline success or error feedback is needed.
///
/// The component resolves its colors from the active ``DSTheme``.
///
/// ## Example
///
/// ```swift
/// DSFeedbackLabel(
///     message: "E-mail inválido.",
///     tone: .failure
/// )
///
/// DSFeedbackLabel(
///     message: "Dados salvos com sucesso.",
///     tone: .success
/// )
/// ```
///
/// ## Accessibility
///
/// The decorative icon is hidden from accessibility. The feedback tone is
/// announced together with the message using a localized accessibility prefix.
///
/// - SeeAlso: ``DSSuccessLabel``
/// - SeeAlso: ``DSFeedbackTone``
public struct DSFeedbackLabel: View {
    /// The descriptive feedback message displayed to the user.
    let message: String

    /// The semantic tone that determines the label's color and icon.
    let tone: DSFeedbackTone

    @Environment(\.dsTheme) private var theme

    /// Creates a feedback label.
    ///
    /// - Parameters:
    ///   - message: The descriptive feedback message.
    ///   - tone: The semantic tone of the feedback.
    public init(message: String, tone: DSFeedbackTone) {
        self.message = message
        self.tone = tone
    }

    public var body: some View {
        Label {
            Text(message)
        } icon: {
            Image(systemName: tone.iconName)
                .accessibilityHidden(true)
        }
        .font(theme.feedbackFont)
        .foregroundStyle(tone.color(for: theme))
        .accessibilityLabel("\(tone.accessibilityPrefix): \(message)")
    }
}

/// A convenience view for displaying successful feedback.
///
/// This is equivalent to creating a ``DSFeedbackLabel`` with
/// ``DSFeedbackTone/success``.
///
/// ## Example
///
/// ```swift
/// DSSuccessLabel(
///     message: "Nome preenchido corretamente."
/// )
/// ```
///
/// - SeeAlso: ``DSFeedbackLabel``
/// - SeeAlso: ``DSFeedbackTone/success``
public struct DSSuccessLabel: View {
    /// The successful feedback message displayed to the user.
    let message: String

    /// Creates a success feedback label.
    ///
    /// - Parameter message: The successful feedback message.
    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        DSFeedbackLabel(message: message, tone: .success)
    }
}
