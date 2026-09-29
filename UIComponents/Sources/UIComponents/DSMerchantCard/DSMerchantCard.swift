import SwiftUI

// MARK: - DSMerchantCard

/// A flexible card that presents merchant media, pricing information, and custom tags.
///
/// Use `DSMerchantCard` to display salons, merchants, products, or similar visual listings.
/// It supports a single media view or a paginated horizontal carousel while leaving image loading and tag presentation to the caller.
///
/// ```swift
/// DSMerchantCard(
///     title: "Espaço Camila",
///     subtitle: "A partir de R$ 45",
///     textPrice: "800 m"
/// ) {
///     Image("salon_cover")
///         .resizable()
///         .scaledToFill()
/// } tagsContent: {
///     Text("Premium")
/// }
/// ```
public struct DSMerchantCard<HeaderContent: View, TagsContent: View>: View {
    /// The primary title displayed below the media area.
    private let title: String

    /// The secondary highlighted text displayed below the title, typically used for pricing.
    private let subtitle: String

    /// Optional supporting text displayed below the subtitle, such as distance or availability.
    private let textPrice: String?

    /// The media content displayed at the top of the card, either as a single view or carousel pages.
    private let headerContent: HeaderContent

    /// The custom content displayed below the card's textual information.
    private let tagsContent: TagsContent

    /// A Boolean value that determines whether the media content is presented as a paginated carousel.
    private let isCarousel: Bool

    /// The fixed height of the card's media area.
    private let mediaHeight: CGFloat = 140

    /// Creates a `DSMerchantCard`.
    /// - Parameters:
    ///   - title: The primary title displayed below the media area.
    ///   - subtitle: The secondary highlighted text, typically used for pricing.
    ///   - textPrice: Optional supporting text for auxiliary information such as distance or availability.
    ///   - isCarousel: Whether the media content should be presented as a paginated horizontal carousel. Defaults to `false`.
    ///   - headerContent: A view builder that provides the card's media content. When `isCarousel` is `true`, each child view represents a carousel page.
    ///   - tagsContent: A view builder that provides custom tag or metadata content displayed below the textual information.
    public init(
        title: String,
        subtitle: String,
        textPrice: String? = nil,
        isCarousel: Bool = false,
        @ViewBuilder headerContent: () -> HeaderContent,
        @ViewBuilder tagsContent: () -> TagsContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.textPrice = textPrice
        self.isCarousel = isCarousel
        self.headerContent = headerContent()
        self.tagsContent = tagsContent()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Group {
                if isCarousel {
                    TabView {
                        headerContent
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                } else {
                    headerContent
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: mediaHeight)
            .background(DSColor.surface)
            .clipped()

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSFont.descriptionBold)
                    .foregroundStyle(DSColor.ink)
                    .lineLimit(1)

                Text(subtitle)
                    .font(DSFont.fieldLabel)
                    .foregroundStyle(DSColor.salonCardPrice)

                if let textPrice {
                    Text(textPrice)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.ink60)
                }

                tagsContent
                    .padding(.top, DSPadding.small)
            }
            .padding(DSPadding.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DSColor.paper)
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous
            )
            .stroke(
                DSColor.line,
                lineWidth: 1
            )
        )
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }
}
