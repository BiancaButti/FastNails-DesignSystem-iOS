import SwiftUI

// MARK: - DSSalonCard

/// A salon listing row: thumbnail, name, price, distance, availability, and
/// accessibility tags.
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
/// ## Accessibility
/// The card is a single element for VoiceOver, with the reading order fixed by
/// the product: **name, price, distance, availability, accessibility**. This
/// decouples the spoken order from the visual layout — the price sits on the
/// trailing edge, but is spoken right after the name, which is what drives the
/// choice.
///
/// Price and distance are formatted from numbers, not strings, so VoiceOver
/// says "35 reais" and "a 300 metros" instead of spelling out symbols.
///
/// From Dynamic Type accessibility sizes on, the price drops below the name
/// instead of squeezing the text into two columns.
///
/// Star ratings are out of scope for the MVP, so they do not exist here.
public struct DSSalonCard<Thumbnail: View>: View {

    let name: String
    let price: Decimal
    let distanceInMeters: Int?
    let availability: String?
    let accessibilityFeatures: [DSSalonAccessibilityFeature]
    let palette: DSSalonCardPalette
    let action: (() -> Void)?
    @ViewBuilder let thumbnail: () -> Thumbnail

    @Environment(\.dsTheme) private var theme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Creates a `DSSalonCard` with a custom thumbnail.
    /// - Parameters:
    ///   - name: The salon's name.
    ///   - price: The service price, formatted as pt-BR currency.
    ///   - distanceInMeters: Distance to the salon. `nil` hides the information.
    ///   - availability: Short availability text, in lowercase — for example,
    ///     "vagas hoje até 19h". `nil` hides the information.
    ///   - accessibilityFeatures: Accessibility tags. Empty hides the footer.
    ///   - palette: The card's colors.
    ///   - action: Tap action. When `nil`, the card is not interactive and does
    ///     not receive the button trait.
    ///   - thumbnail: Thumbnail shown on the leading edge — usually a photo.
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
                Button(action: action) { card }
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

    private var card: some View {
        DSCard(
            alignment: .leading,
            spacing: 12,
            padding: 16,
            cornerRadius: 20,
            borderColor: palette.border,
            elevation: .subtle
        ) {
            header
            ForEach(accessibilityFeatures) { feature in
                DSSalonCardAccessibilityTag(feature: feature, palette: palette)
            }
        }
    }

    @ViewBuilder
    private var header: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    thumbnail()
                    identity
                }
                priceLabel
            }
        } else {
            HStack(alignment: .top, spacing: 12) {
                thumbnail()
                identity
                Spacer(minLength: 8)
                priceLabel
            }
        }
    }

    private var identity: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.headline)
                .foregroundStyle(theme.titleColor)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var priceLabel: some View {
        Text(priceText)
            .font(.headline)
            .foregroundStyle(palette.price)
            .layoutPriority(1)
    }

    // MARK: Formatted content

    /// "300 m · vagas hoje até 19h"
    private var subtitle: String? {
        let parts = [distanceText, availability].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    private var priceText: String {
        DSSalonCardFormatter.priceText(price)
    }

    private var distanceText: String? {
        DSSalonCardFormatter.distanceText(meters: distanceInMeters)
    }

    /// Name, price, distance, availability, accessibility — in that order.
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

// MARK: - Default thumbnail

public extension DSSalonCard where Thumbnail == DSSalonCardThumbnail {
    /// Creates a `DSSalonCard` with the default thumbnail — an icon over a
    /// tinted background, used while the salon has no photo.
    init(
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
            thumbnail: { DSSalonCardThumbnail(systemImage: systemImage, palette: palette) }
        )
    }
}
