import SwiftUI

// MARK: - DSInlineMessageStyle

/// Defines the semantic appearance of an inline message card.
///
/// Use `DSInlineMessageStyle` to communicate the context of a message through its background, border, title, and action colors.
public enum DSInlineMessageStyle {
    /// A neutral informational message that uses the standard design system colors.
    case info

    /// A cautionary message that uses the warning color treatment.
    case warning

    /// A critical message that uses the error color treatment.
    case error

    /// The background color associated with the message style.
    var backgroundColor: Color {
        switch self {
        case .info:
            return DSColor.paper
        case .warning:
            return DSColor.amber.opacity(0.06)
        case .error:
            return DSColor.alert.opacity(0.06)
        }
    }

    /// The border color associated with the message style.
    var borderColor: Color {
        switch self {
        case .info:
            return DSColor.line
        case .warning:
            return DSColor.amber.opacity(0.2)
        case .error:
            return DSColor.alert.opacity(0.2)
        }
    }

    /// The color applied to the optional message action.
    var actionColor: Color {
        switch self {
        case .info:
            return DSColor.enamel
        case .warning:
            return DSColor.amber
        case .error:
            return DSColor.terracotta
        }
    }

    /// The color applied to the message title.
    var titleColor: Color {
        switch self {
        case .info, .warning:
            return DSColor.ink
        case .error:
            return DSColor.terracotta
        }
    }
}
