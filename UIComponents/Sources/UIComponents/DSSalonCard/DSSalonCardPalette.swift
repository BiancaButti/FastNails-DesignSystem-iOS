import SwiftUI

// MARK: - Paleta

/// Defines the color palette used by ``DSSalonCard``.
///
/// `DSSalonCardPalette` centralizes the colors required to render the salon
/// card, including its border, price, thumbnail, and accessibility feature
/// elements.
///
/// The default values are provided by the Design System's `DSColor` tokens.
/// Consumers can override individual colors when a different visual context
/// or theme is required.
///
/// Keeping the card colors in a dedicated palette makes it possible to
/// migrate the component to `DSTheme` in the future without changing the
/// rendering code throughout the card.
///
/// Example:
///
/// ```swift
/// let palette = DSSalonCardPalette(
///     price: .red,
///     featureBackground: .blue.opacity(0.1)
/// )
/// ```
///
/// - Note: The default palette should be preferred whenever the salon card is
///   rendered as part of the standard Design System.
public struct DSSalonCardPalette {

    /// The color used for the salon card border.
    ///
    /// Defaults to the `DSColor.salonCardBorder` Design System token.
    public var border: Color

    /// The color used to display price information.
    ///
    /// Defaults to the `DSColor.salonCardPrice` Design System token.
    public var price: Color

    /// The background color of the salon thumbnail.
    ///
    /// Defaults to the
    /// `DSColor.salonCardThumbnailBackground` Design System token.
    public var thumbnailBackground: Color

    /// The foreground color used by the salon thumbnail.
    ///
    /// This color is typically used for content displayed over the thumbnail
    /// background, such as placeholder icons or text.
    ///
    /// Defaults to the
    /// `DSColor.salonCardThumbnailForeground` Design System token.
    public var thumbnailForeground: Color

    /// The background color of accessibility feature tags.
    ///
    /// Defaults to the
    /// `DSColor.salonCardFeatureBackground` Design System token.
    public var featureBackground: Color

    /// The background color behind the icon displayed in an accessibility
    /// feature tag.
    ///
    /// Defaults to the
    /// `DSColor.salonCardFeatureIconBackground` Design System token.
    public var featureIconBackground: Color

    /// The foreground color used by accessibility feature tags.
    ///
    /// This color is applied to the text displayed alongside the feature icon.
    ///
    /// Defaults to the
    /// `DSColor.salonCardFeatureForeground` Design System token.
    public var featureForeground: Color

    /// Creates a salon card color palette.
    ///
    /// Each color defaults to the corresponding Design System `DSColor`
    /// token. Individual values can be overridden when the card needs to be
    /// displayed using a custom palette.
    ///
    /// - Parameters:
    ///   - border: The card border color.
    ///   - price: The price text color.
    ///   - thumbnailBackground: The thumbnail background color.
    ///   - thumbnailForeground: The thumbnail foreground color.
    ///   - featureBackground: The accessibility feature tag background color.
    ///   - featureIconBackground: The accessibility feature icon background
    ///     color.
    ///   - featureForeground: The accessibility feature text color.
    public init(
        border: Color = DSColor.salonCardBorder,
        price: Color = DSColor.salonCardPrice,
        thumbnailBackground: Color = DSColor.salonCardThumbnailBackground,
        thumbnailForeground: Color = DSColor.salonCardThumbnailForeground,
        featureBackground: Color = DSColor.salonCardFeatureBackground,
        featureIconBackground: Color = DSColor.salonCardFeatureIconBackground,
        featureForeground: Color = DSColor.salonCardFeatureForeground
    ) {
        self.border = border
        self.price = price
        self.thumbnailBackground = thumbnailBackground
        self.thumbnailForeground = thumbnailForeground
        self.featureBackground = featureBackground
        self.featureIconBackground = featureIconBackground
        self.featureForeground = featureForeground
    }

    /// The standard palette used by ``DSSalonCard``.
    ///
    /// This palette uses the default Design System color tokens defined by
    /// `DSColor`.
    ///
    /// Use ``default`` when no custom color configuration is required.
    public static let `default` = DSSalonCardPalette()
}
