import SwiftUI

// MARK: - DSCard

/// A flexible container that presents content inside a styled design system card.
///
/// Use `DSCard` to group related content with configurable alignment, background, border, elevation, and an optional image or SF Symbol.
/// The card automatically uses the active theme's surface color when no custom background is provided.
///
/// ```swift
/// DSCard {
///     Text("Card content")
/// }
/// ```
public struct DSCard<Content: View>: View {
    /// The content displayed inside the card.
    @ViewBuilder let content: () -> Content

    @Environment(\.dsTheme) private var theme

    /// An optional image displayed at the top of the card.
    private let image: Image?

    /// The horizontal alignment applied to the card's content.
    let alignment: HorizontalAlignment

    /// The custom background color, or `nil` to use the active theme's surface color.
    let background: Color?

    /// The optional color used to draw the card's border.
    let borderColor: Color?

    /// The elevation configuration that determines the card's shadow.
    let elevation: DSCardElevation

    /// Creates a `DSCard` with an optional image.
    /// - Parameters:
    ///   - image: An optional image displayed at the top of the card. Defaults to `nil`.
    ///   - alignment: The horizontal alignment applied to the card's content. Defaults to `.center`.
    ///   - background: A custom background color. When `nil`, the active theme's surface color is used. Defaults to `nil`.
    ///   - borderColor: An optional color used to draw the card's border. Defaults to `nil`.
    ///   - elevation: The elevation configuration that determines the card's shadow. Defaults to `.raised`.
    ///   - content: A view builder that produces the content displayed inside the card.
    public init(
        image: Image? = nil,
        alignment: HorizontalAlignment = .center,
        background: Color? = nil,
        borderColor: Color? = nil,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.image = image
        self.alignment = alignment
        self.background = background
        self.borderColor = borderColor
        self.elevation = elevation
        self.content = content
    }

    /// Creates a `DSCard` using an image from the asset catalog.
    /// - Parameters:
    ///   - assetName: The name of the image resource in the asset catalog.
    ///   - alignment: The horizontal alignment applied to the card's content. Defaults to `.center`.
    ///   - background: A custom background color. When `nil`, the active theme's surface color is used. Defaults to `nil`.
    ///   - borderColor: An optional color used to draw the card's border. Defaults to `nil`.
    ///   - elevation: The elevation configuration that determines the card's shadow. Defaults to `.raised`.
    ///   - content: A view builder that produces the content displayed inside the card.
    public init(
        assetName: String,
        alignment: HorizontalAlignment = .center,
        background: Color? = nil,
        borderColor: Color? = nil,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: Image(assetName),
            alignment: alignment,
            background: background,
            borderColor: borderColor,
            elevation: elevation,
            content: content
        )
    }

    /// Creates a `DSCard` using an SF Symbol.
    /// - Parameters:
    ///   - systemIconName: The name of the SF Symbol to display at the top of the card.
    ///   - alignment: The horizontal alignment applied to the card's content. Defaults to `.center`.
    ///   - background: A custom background color. When `nil`, the active theme's surface color is used. Defaults to `nil`.
    ///   - borderColor: An optional color used to draw the card's border. Defaults to `nil`.
    ///   - elevation: The elevation configuration that determines the card's shadow. Defaults to `.raised`.
    ///   - content: A view builder that produces the content displayed inside the card.
    public init(
        systemIconName: String,
        alignment: HorizontalAlignment = .center,
        background: Color? = nil,
        borderColor: Color? = nil,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: Image(systemName: systemIconName),
            alignment: alignment,
            background: background,
            borderColor: borderColor,
            elevation: elevation,
            content: content
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: DSRadius.mediumHuge,
            style: .continuous
        )
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: DSSpacing.lg) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: DSSize.jumbo)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            content()
        }
        .padding(DSPadding.mediumLarge)
        .frame(
            maxWidth: .infinity,
            alignment: Alignment(
                horizontal: alignment,
                vertical: .center
            )
        )
        .background(background ?? theme.surfaceColor)
        .clipShape(shape)
        .overlay(
            Group {
                if let borderColor {
                    shape.strokeBorder(
                        borderColor,
                        lineWidth: DSBorder.thin
                    )
                }
            }
        )
        .shadow(
            color: .black.opacity(elevation.opacity),
            radius: elevation.radius,
            y: elevation.offsetY
        )
    }
}
