import SwiftUI

// MARK: - Palette & Tokens

/// The set of colors a ``DSStatusCard`` uses for one appearance.
///
/// A palette bundles every color the card needs — surface, text, and action
/// button — so the card body just reads from it instead of branching on colors
/// inline. Pick one with ``resolve(_:)``.
public struct DSStatusCardPalette {

    /// Fill behind the whole card.
    let background: Color

    /// Color of the title.
    let primary: Color

    /// Color of the eyebrow and detail lines.
    let secondary: Color

    /// Fill behind the action buttons.
    let actionBackground: Color

    /// Color of the action buttons' labels.
    let actionForeground: Color

    /// Whether the background is dark, so the card can force the matching
    /// color scheme for its content.
    let isDark: Bool

    /// The palette for a given card variant and emphasis.
    ///
    /// - Parameters:
    ///   - variant: The card's layout density.
    ///   - emphasis: The card's color emphasis.
    /// - Returns: ``critical`` or ``positive`` when the emphasis asks for it;
    ///   otherwise ``inverse`` for `.expanded` and ``subtle`` for `.compact`.
    static func resolve(_ variant: DSStatusCardVariant,
                        emphasis: DSStatusCardEmphasis = .standard) -> Self {
        switch emphasis {
        case .critical: return .critical
        case .positive: return .positive
        case .muted:    return .subtle
        case .standard:
            switch variant {
            case .expanded: return .inverse
            case .compact:  return .subtle
            }
        }
    }

    /// Dark, brand-colored card — the default expanded appearance.
    static let inverse = Self(
        background: .ink,
        primary: .paper,
        secondary: .blush,
        actionBackground: .blush.opacity(0.15),
        actionForeground: .blush,
        isDark: true
    )

    /// Error / cancellation.
    static let critical = Self(
        background: .terracota,
        primary: .paper,
        secondary: .blush,
        actionBackground: .paper.opacity(0.15),
        actionForeground: .blush,
        isDark: true
    )

    /// Light card highlighting a positive status.
    static let positive = Self(
        background: .confirmed,
        primary: .paper,
        secondary: .blush,
        actionBackground: .paper.opacity(0.15),
        actionForeground: .blush,
        isDark: true
    )

    /// Neutral light card.
    static let subtle = Self(
        background: .paper2,
        primary: .ink,
        secondary: .ink60,
        actionBackground: .enamel,
        actionForeground: .paper,
        isDark: false
    )
}
