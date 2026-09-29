import SwiftUI

/// A square visual thumbnail used by ``DSSalonCard`` to represent a salon
/// using an SF Symbol.
///
/// `DSSalonCardThumbnail` provides a consistent visual treatment for the
/// salon card thumbnail, including its rounded shape, background color,
/// symbol, and symbol color.
///
/// The thumbnail is intentionally hidden from accessibility technologies.
/// It provides decorative context only; the salon's meaningful information
/// is exposed by the containing ``DSSalonCard``.
///
/// The thumbnail uses Design System sizing, typography, radius, and color
/// tokens to remain visually consistent with the rest of the component.
///
/// Example:
///
/// ```swift
/// DSSalonCardThumbnail()
/// ```
///
/// A custom SF Symbol and palette can also be provided:
///
/// ```swift
/// DSSalonCardThumbnail(
///     systemImage: "scissors",
///     palette: customPalette
/// )
/// ```
///
/// - Important: Keep `.accessibilityHidden(true)` unless the accessibility
///   implementation of ``DSSalonCard`` is changed to expose the thumbnail
///   as meaningful content.
public struct DSSalonCardThumbnail: View {

    /// The name of the SF Symbol displayed in the thumbnail.
    ///
    /// The value must correspond to an SF Symbol available on the target
    /// operating system.
    let systemImage: String

    /// The color palette used to style the thumbnail.
    ///
    /// The palette provides the thumbnail background and foreground colors.
    let palette: DSSalonCardPalette

    /// Creates a salon card thumbnail.
    ///
    /// - Parameters:
    ///   - systemImage: The SF Symbol displayed in the thumbnail.
    ///     Defaults to `"storefront"`.
    ///   - palette: The color palette used to style the thumbnail.
    ///     Defaults to ``DSSalonCardPalette/default``.
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
            style: .continuous
        )
        .fill(palette.thumbnailBackground)
        .frame(
            width: DSSize.jumbo,
            height: DSSize.jumbo
        )
        .overlay(
            Image(systemName: systemImage)
                .font(
                    DSFont.dynamicRegular(
                        scaledFrom: DSSize.jumbo
                    )
                )
                .foregroundStyle(palette.thumbnailForeground)
        )
        .accessibilityHidden(true)
    }
}
