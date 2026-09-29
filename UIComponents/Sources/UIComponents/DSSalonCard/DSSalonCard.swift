import SwiftUI

// MARK: - DSSalonCard

/// A salon listing card that presents the salon name, service price,
/// distance, availability, and accessibility features.
///
/// `DSSalonCard` is a presentation component designed for salon discovery
/// and search results. It keeps application data and formatting separate from
/// the visual presentation while providing built-in support for Dynamic Type
/// and VoiceOver.
///
/// The card can be interactive when an `action` closure is provided. When no
/// action is supplied, it behaves as a non-interactive presentation card.
///
/// ## Example
///
/// ```swift
/// DSSalonCard(
///     name: "Studio Ana Lima",
///     price: 35,
///     distanceInMeters: 300,
///     availability: "vagas hoje até 19h",
///     accessibilityFeatures: [.semDegrau]
/// ) {
///     openSalon()
/// }
/// ```
///
/// ## Custom Thumbnail
///
/// A custom thumbnail can be supplied through the `thumbnail` view builder:
///
/// ```swift
/// DSSalonCard(
///     name: "Studio Ana Lima",
///     price: 35,
///     distanceInMeters: 300,
///     thumbnail: {
///         Image("salon")
///             .resizable()
///             .scaledToFill()
///     }
/// ) {
///     openSalon()
/// }
/// ```
///
/// ## Accessibility
///
/// The card is exposed as a single accessibility element. Its spoken content
/// follows the product-defined order:
///
/// 1. Salon name
/// 2. Price
/// 3. Distance
/// 4. Availability
/// 5. Accessibility features
///
/// Price and distance are formatted from their numeric values so assistive
/// technologies receive natural localized descriptions rather than the
/// visual representation of the formatted text.
///
/// When Dynamic Type reaches an accessibility size, the price moves below
/// the identity information to prevent the layout from becoming constrained.
///
/// Star ratings are intentionally not part of this component.
public struct DSSalonCard<Thumbnail: View>: View {

    /// The salon or merchant name displayed as the primary title.
    let name: String

    /// The starting service price, represented as a numeric value.
    ///
    /// The value is formatted by the design system using the pt-BR currency
    /// presentation rules.
    let price: Decimal

    /// The distance from the user to the salon, in meters.
    ///
    /// When `nil`, the distance is omitted from the visual subtitle and
    /// accessibility description.
    let distanceInMeters: Int?

    /// Short availability information displayed below the salon name.
    ///
    /// For example, `"vagas hoje até 19h"`.
    ///
    /// When `nil`, no availability information is displayed.
    let availability: String?

    /// Accessibility features available at the salon.
    ///
    /// When the collection is empty, no accessibility feature tags are
    /// displayed.
    let accessibilityFeatures: [DSSalonAccessibilityFeature]

    /// The color palette used by the card.
    let palette: DSSalonCardPalette

    /// The optional action executed when the card is tapped.
    ///
    /// When `nil`, the card is presented as a non-interactive view.
    let action: (() -> Void)?

    /// The custom thumbnail content displayed on the leading edge.
    @ViewBuilder let thumbnail: () -> Thumbnail

    @Environment(\.dsTheme) private var theme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Creates a salon card with a custom thumbnail.
    ///
    /// - Parameters:
    ///   - name: The salon or merchant name.
    ///   - price: The starting service price.
    ///   - distanceInMeters: Optional distance from the user, in meters.
    ///   - availability: Optional short availability description.
    ///   - accessibilityFeatures: Accessibility features available at the salon.
    ///   - palette: The visual color palette. Defaults to `.default`.
    ///   - action: Optional closure executed when the card is tapped.
    ///   - thumbnail: A view builder that supplies the card's thumbnail.
    public init(
        name: String,
        price: Decimal,
        distanceInMeters: Int? = nil,
        availability: String? = nil,
        accessibilityFeatures: [DSSalonAccessibilityFeature] = [],
        palette: DSSalonCardPalette = .default,
        action: (() -> Void)? = nil,
        @ViewBuilder thumbnail: @escaping () -> Thumbnail
    ) {
        self.name = name
        self.price = price
        self.distanceInMeters = distanceInMeters
        self.availability = availability
        self.accessibilityFeatures = accessibilityFeatures
        self.palette = palette
        self.action = action
        self.thumbnail = thumbnail
    }

    public var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    card
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Abre os detalhes do salão")
            } else {
                card
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Visual

    /// The main visual structure of the salon card.
    private var card: some View {
        DSCard(
            borderColor: palette.border,
            elevation: .subtle
        ) {
            header

            ForEach(accessibilityFeatures) { feature in
                DSSalonCardAccessibilityTag(
                    feature: feature,
                    palette: palette
                )
            }
        }
    }

    /// Builds the card header according to the current Dynamic Type size.
    ///
    /// At accessibility sizes the price moves below the identity section,
    /// allowing the salon name and supporting information to use the available
    /// horizontal space without compression.
    @ViewBuilder
    private var header: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                HStack(alignment: .top, spacing: DSSpacing.md) {
                    thumbnail()
                    identity
                }

                priceLabel
            }
        } else {
            HStack(alignment: .top, spacing: DSSpacing.md) {
                thumbnail()
                identity

                Spacer(minLength: DSSpacing.sm)

                priceLabel
            }
        }
    }

    /// Displays the salon name and optional metadata.
    private var identity: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(name)
                .font(DSFont.sectionHeader)
                .foregroundStyle(theme.titleColor)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    /// Displays the formatted starting price.
    private var priceLabel: some View {
        Text(priceText)
            .font(DSFont.sectionHeader)
            .foregroundStyle(palette.price)
            .layoutPriority(1)
    }

    // MARK: - Formatted Content

    /// Combines distance and availability into the visual subtitle.
    ///
    /// Example:
    /// `"300 m · vagas hoje até 19h"`.
    private var subtitle: String? {
        let parts = [distanceText, availability].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    /// The localized price representation used by the visual card.
    private var priceText: String {
        DSSalonCardFormatter.priceText(price)
    }

    /// The localized distance representation used by the visual card.
    private var distanceText: String? {
        DSSalonCardFormatter.distanceText(meters: distanceInMeters)
    }

    /// The complete VoiceOver description for the card.
    ///
    /// The reading order is intentionally independent from the visual layout:
    /// name, price, distance, availability, and accessibility features.
    private var accessibilityLabel: String {
        DSSalonCardFormatter.accessibilityLabel(
            name: name,
            price: price,
            meters: distanceInMeters,
            availability: availability,
            features: accessibilityFeatures
        )
    }
}

// MARK: - Default Thumbnail

/// Provides the default thumbnail implementation for `DSSalonCard`.
///
/// The default thumbnail displays an SF Symbol over a tinted background and
/// can be used when the salon does not have a photo.
public extension DSSalonCard where Thumbnail == DSSalonCardThumbnail {

    /// Creates a salon card using the standard design system thumbnail.
    ///
    /// - Parameters:
    ///   - name: The salon or merchant name.
    ///   - price: The starting service price.
    ///   - distanceInMeters: Optional distance from the user, in meters.
    ///   - availability: Optional short availability description.
    ///   - accessibilityFeatures: Accessibility features available at the salon.
    ///   - systemImage: The SF Symbol displayed inside the default thumbnail.
    ///     Defaults to `"storefront"`.
    ///   - palette: The visual color palette. Defaults to `.default`.
    ///   - action: Optional closure executed when the card is tapped.
    public init(
        name: String,
        price: Decimal,
        distanceInMeters: Int? = nil,
        availability: String? = nil,
        accessibilityFeatures: [DSSalonAccessibilityFeature] = [],
        systemImage: String = "storefront",
        palette: DSSalonCardPalette = .default,
        action: (() -> Void)? = nil
    ) {
        self.init(
            name: name,
            price: price,
            distanceInMeters: distanceInMeters,
            availability: availability,
            accessibilityFeatures: accessibilityFeatures,
            palette: palette,
            action: action,
            thumbnail: {
                DSSalonCardThumbnail(
                    systemImage: systemImage,
                    palette: palette
                )
            }
        )
    }
}
