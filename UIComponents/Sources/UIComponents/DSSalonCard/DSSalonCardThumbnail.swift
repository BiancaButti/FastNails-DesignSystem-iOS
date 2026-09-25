import SwiftUI

/// A square thumbnail used by the salon card to represent a salon with an SF Symbol.
public struct DSSalonCardThumbnail: View {
    let systemImage: String
    let palette: DSSalonCardPalette

    public init(
        systemImage: String = "storefront",
        palette: DSSalonCardPalette = .default
    ) {
        self.systemImage = systemImage
        self.palette = palette
    }

    public var body: some View {
        RoundedRectangle(
            cornerRadius: DSRadius.control,
            style: .continuous)
            .fill(palette.thumbnailBackground)
            .frame(width: DSSize.jumbo,
                   height: DSSize.jumbo)
            .overlay(
                Image(systemName: systemImage)
                    .font(DSFont.dynamicRegular(scaledFrom: DSSize.jumbo))
                    .foregroundStyle(palette.thumbnailForeground)
            )
            .accessibilityHidden(true)
    }
}
