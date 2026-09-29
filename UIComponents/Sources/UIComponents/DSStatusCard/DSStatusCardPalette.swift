import SwiftUI

// MARK: - Palette & Tokens

/// Defines the complete color configuration used by a ``DSStatusCard``
/// appearance.
///
/// `DSStatusCardPalette` groups the colors required by the card into a single
/// value. This keeps color selection separate from the view layout and avoids
/// conditional color logic inside the card's body.
///
/// Each palette defines the card surface, its textual content, and the
/// appearance of its action buttons.
///
/// - Note: The palette properties are intentionally kept together so that
///   changes to an appearance can be made without updating multiple
///   independent color declarations in the view.
public struct DSStatusCardPalette {

    /// The background color of the entire card.
    let background: Color

    /// The color used by the eyebrow, title, and supporting detail text.
    let secondary: Color

    /// The background color of action buttons inside the card.
    let actionBackground: Color

    /// The foreground color of action button labels.
    let actionForeground: Color

    /// Resolves the palette for a card's layout variant and visual emphasis.
    ///
    /// An explicit semantic emphasis takes precedence over the layout variant:
    ///
    /// - `.critical` uses ``critical``.
    /// - `.positive` uses ``positive``.
    /// - `.muted` uses ``subtle``.
    ///
    /// When the emphasis is `.standard`, the layout variant determines the
    /// default appearance:
    ///
    /// - `.expanded` uses ``inverse``.
    /// - `.compact` uses ``subtle``.
    ///
    /// - Parameters:
    ///   - variant: The layout density of the card.
    ///   - emphasis: The semantic visual emphasis of the card.
    ///
    /// - Returns: The palette corresponding to the supplied variant and
    ///   emphasis.
    static func resolve(
        _ variant: DSStatusCardVariant,
        emphasis: DSStatusCardEmphasis = .standard
    ) -> Self {
        switch emphasis {
        case .critical:
            return .critical

        case .positive:
            return .positive

        case .muted:
            return .subtle

        case .standard:
            switch variant {
            case .expanded:
                return .inverse

            case .compact:
                return .subtle
            }
        }
    }

    /// The dark, brand-colored appearance used by the default expanded card.
    ///
    /// This appearance provides a high-emphasis surface for the standard
    /// expanded variant.
    static let inverse = Self(
        background: DSColor.ink,
        secondary: DSColor.blush,
        actionBackground: DSColor.blush.opacity(0.15),
        actionForeground: DSColor.blush
    )

    /// The appearance used for critical states such as errors or
    /// cancellations.
    ///
    /// The card uses the terracotta surface with the brand foreground and a
    /// translucent action-button background.
    static let critical = Self(
        background: DSColor.terracotta,
        secondary: DSColor.blush,
        actionBackground: DSColor.paper.opacity(0.15),
        actionForeground: DSColor.blush
    )

    /// The appearance used to highlight a positive status.
    ///
    /// The card uses the confirmed surface while preserving the brand
    /// foreground for its content and actions.
    static let positive = Self(
        background: DSColor.confirmed,
        secondary: DSColor.blush,
        actionBackground: DSColor.paper.opacity(0.15),
        actionForeground: DSColor.blush
    )

    /// The neutral, low-emphasis appearance used by compact cards and muted
    /// states.
    ///
    /// This palette uses a light surface, subdued content, and a filled action
    /// button treatment.
    static let subtle = Self(
        background: DSColor.paper2,
        secondary: DSColor.ink60,
        actionBackground: DSColor.enamel,
        actionForeground: DSColor.paper
    )
}
