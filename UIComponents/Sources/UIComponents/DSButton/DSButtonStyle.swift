import SwiftUI

public enum DSButtonStyle {
    case primary
    case secondary
    case tertiary
}

public enum DSButtonTone {
    case brand
    case neutral
    case destructive
}

struct DSButtonAppearance {
    var background: Color
    var textColor: Color
    var borderColor: Color?

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

/// The final colors applied to a `DSButton` once its interaction state
/// (enabled, disabled, loading) is taken into account.
///
/// This separates the state-dependent color logic from the SwiftUI view so it
/// can be verified in isolation.
struct DSButtonRenderState: Equatable {
    var background: Color
    var borderColor: Color?
    var textColor: Color

    /// Resolves the render colors for a button.
    ///
    /// - When disabled: a dimmed fill, no border, and dimmed text.
    /// - When loading (and enabled): the base colors displayed at reduced
    ///   opacity.
    /// - Otherwise: the base appearance colors unchanged.
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

        background = isLoading ? appearance.background.opacity(0.6) : appearance.background
        borderColor = appearance.borderColor.map { isLoading ? $0.opacity(0.6) : $0 }
        textColor = appearance.textColor
    }
}
