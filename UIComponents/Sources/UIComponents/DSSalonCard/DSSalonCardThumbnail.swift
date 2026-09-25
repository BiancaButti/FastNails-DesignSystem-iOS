import SwiftUI

/// A square thumbnail used by the salon card to represent a salon with an SF Symbol.
public struct DSSalonCardThumbnail: View {
    let systemImage: String
    let palette: DSSalonCardPalette
    let size: CGFloat

    public init(
        systemImage: String = "storefront",
        palette: DSSalonCardPalette = .default,
        size: CGFloat = 56
    ) {
        self.systemImage = systemImage
        self.palette = palette
        self.size = size
    }

    public var body: some View {
        RoundedRectangle(
            cornerRadius: DSRadius.control,
            style: .continuous)
            .fill(palette.thumbnailBackground)
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: systemImage)
                    .font(DSFont.dynamicRegular(scaledFrom: size))
                    .foregroundStyle(palette.thumbnailForeground)
            )
            .accessibilityHidden(true)
    }
}
