import SwiftUI

// MARK: - DSButtonStyle

/// Defines the visual hierarchy and prominence of a design system button.
///
/// Use `DSButtonStyle` to communicate the relative importance of an action through the button's visual treatment.
public enum DSButtonStyle {
    /// A high-prominence button with a solid background, intended for primary actions.
    case primary

    /// A medium-prominence button with a border or lighter background, intended for secondary actions.
    case secondary

    /// A low-prominence text-only button without a background or border, intended for subtle actions.
    case tertiary
}

// MARK: - DSButtonTone

/// Defines the semantic color and intent of a design system button.
///
/// Use `DSButtonTone` to communicate the semantic meaning of an action independently of its visual style.
public enum DSButtonTone {
    /// Represents the main application brand or primary semantic action.
    case brand

    /// Represents a neutral or non-accented action.
    case neutral

    /// Represents an action with potentially destructive or irreversible consequences.
    case destructive
}

// MARK: - DSButtonAppearance

/// Resolves the foundational colors for a button from its style, tone, and active theme.
///
/// This internal configuration translates semantic button tokens into background, text, and border colors before interaction states are applied.
struct DSButtonAppearance {
    /// The baseline background color resolved for the button.
    var background: Color

    /// The baseline text and icon color resolved for the button.
    var textColor: Color

    /// The baseline border color, or `nil` when the button does not render a border.
    var borderColor: Color?

    /// Creates a button appearance from its style, tone, and active theme.
    /// - Parameters:
    ///   - style: The visual style used to determine the button's structural treatment.
    ///   - tone: The semantic tone used to determine the button's color palette.
    ///   - theme: The active design system theme providing the underlying color tokens.
    init(
        style: DSButtonStyle,
        tone: DSButtonTone,
        theme: DSTheme
    ) {
        let accent: Color =
        switch tone {
        case .brand:
            theme.brandColor
        case .neutral:
            theme.titleColor
        case .destructive:
            theme.errorColor
        }

        switch style {
        case .primary:
            background = tone == .destructive ? theme.surfaceColor : accent
            textColor = tone == .destructive ? accent : .white
            borderColor = tone == .destructive ? accent : nil

        case .secondary:
            background = theme.surfaceColor
            textColor = accent
            borderColor = tone == .neutral ? theme.borderColor : accent

        case .tertiary:
            background = .clear
            textColor = tone == .neutral ? theme.secondaryColor : accent
            borderColor = nil
        }
    }
}

// MARK: - DSButtonRenderState

/// Resolves the final button colors after applying enabled and loading states.
///
/// This internal configuration separates state-dependent styling from the SwiftUI view hierarchy, keeping color resolution deterministic and testable.
struct DSButtonRenderState: Equatable {
    /// The final background color after applying the button's interaction state.
    var background: Color

    /// The final border color after applying the button's interaction state, or `nil` when no border is rendered.
    var borderColor: Color?

    /// The final text and foreground color applied to the button.
    var textColor: Color

    /// Creates a render state from the button appearance and interaction state.
    /// - Parameters:
    ///   - appearance: The foundational colors resolved from the button's style and tone.
    ///   - isEnabled: A Boolean value indicating whether the button can be activated. Disabled buttons use muted colors.
    ///   - isLoading: A Boolean value indicating whether the button is processing an action. Loading buttons render reduced background and border opacity.
    ///   - theme: The active design system theme providing disabled-state color tokens.
    init(
        appearance: DSButtonAppearance,
        isEnabled: Bool,
        isLoading: Bool,
        theme: DSTheme
    ) {
        guard isEnabled else {
            background = theme.secondaryColor.opacity(0.35)
            borderColor = nil
            textColor = theme.titleColor.opacity(0.45)
            return
        }

        background = isLoading
            ? appearance.background.opacity(0.6)
            : appearance.background

        borderColor = appearance.borderColor.map {
            isLoading ? $0.opacity(0.6) : $0
        }

        textColor = appearance.textColor
    }
}
