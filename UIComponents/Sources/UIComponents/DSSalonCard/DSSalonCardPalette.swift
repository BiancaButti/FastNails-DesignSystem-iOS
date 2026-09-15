import SwiftUI

// MARK: - Paleta

/// Cores do cartão de salão. Ficam reunidas aqui para que a migração para os
/// tokens do `DSTheme` seja feita em um lugar só.
public struct DSSalonCardPalette {
    public var border: Color
    public var price: Color
    public var thumbnailBackground: Color
    public var thumbnailForeground: Color
    public var featureBackground: Color
    public var featureIconBackground: Color
    public var featureForeground: Color

    public init(
        border: Color = .salonCardBorder,
        price: Color = .salonCardPrice,
        thumbnailBackground: Color = .salonCardThumbnailBackground,
        thumbnailForeground: Color = .salonCardThumbnailForeground,
        featureBackground: Color = .salonCardFeatureBackground,
        featureIconBackground: Color = .salonCardFeatureIconBackground,
        featureForeground: Color = .salonCardFeatureForeground
    ) {
        self.border = border
        self.price = price
        self.thumbnailBackground = thumbnailBackground
        self.thumbnailForeground = thumbnailForeground
        self.featureBackground = featureBackground
        self.featureIconBackground = featureIconBackground
        self.featureForeground = featureForeground
    }

    public static let `default` = DSSalonCardPalette()
}
