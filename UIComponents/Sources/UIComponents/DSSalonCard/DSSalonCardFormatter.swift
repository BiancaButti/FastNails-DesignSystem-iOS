import Foundation

// MARK: - Formatting

/// Provides pure text formatting for ``DSSalonCard``.
///
/// `DSSalonCardFormatter` centralizes the formatting rules used by the salon
/// card for prices, distances, and accessibility labels. Keeping these rules
/// outside the SwiftUI view allows the formatting logic to be unit tested
/// independently from the UI.
///
/// The formatter uses the Brazilian Portuguese locale (`pt_BR`) for numeric
/// and currency representations.
///
/// The type is intentionally implemented as an `enum` because it has no
/// instances or stored state that should be created by consumers.
///
/// - Important: The formatting rules defined here are part of the product's
///   presentation and accessibility behavior. Changes to the output of these
///   methods should be covered by unit tests.
///
/// ## Formatting rules
///
/// - Prices use Brazilian currency formatting (`R$`).
/// - Whole-number prices omit decimal places.
/// - Prices containing cents display two decimal places.
/// - Distances below 1 kilometer are displayed in meters.
/// - Distances of 1 kilometer or more are displayed in kilometers with up to
///   one decimal place.
/// - Optional distance and availability values are omitted when `nil`.
/// - VoiceOver labels follow the product-defined order:
///   name, price, distance, availability, accessibility features.
enum DSSalonCardFormatter {

    // MARK: - Constants

    /// Number of fraction digits used when displaying a whole-number value.
    private static let noFractionDigits: Int = 0

    /// Number of fraction digits used for currency values containing cents.
    private static let currencyFractionDigits: Int = 2

    /// Number of fraction digits used when displaying distances in kilometers.
    private static let distanceFractionDigits: Int = 1

    /// Price at which the singular currency unit (`real`) is used.
    private static let singularPriceThreshold: Decimal = 1

    /// Number of meters in one kilometer.
    private static let metersInKilometer: Int = 1000

    /// Double representation of the number of meters in one kilometer.
    ///
    /// Used when converting an integer distance from meters to kilometers
    /// before passing it to `NumberFormatter`.
    private static let metersInKilometerDouble: Double = 1000.0

    // MARK: - Formatters

    /// Shared currency formatter configured for Brazilian Portuguese.
    ///
    /// The formatter uses the `.currency` number style and the `pt_BR`
    /// locale.
    private static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()

    /// Shared decimal formatter configured for Brazilian Portuguese.
    ///
    /// This formatter is used for spoken prices and distances, ensuring that
    /// decimal separators follow Brazilian Portuguese conventions.
    private static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()

    // MARK: - Price Formatters

    /// Formats a price as Brazilian currency.
    ///
    /// Whole-number prices are displayed without decimal places, while prices
    /// containing cents are displayed with two decimal places.
    ///
    /// For example:
    ///
    /// ```swift
    /// DSSalonCardFormatter.priceText(35)
    /// // "R$ 35"
    ///
    /// DSSalonCardFormatter.priceText(35.50)
    /// // "R$ 35,50"
    /// ```
    ///
    /// - Parameter price: The price to format.
    /// - Returns: A localized Brazilian currency string.
    static func priceText(_ price: Decimal) -> String {
        var roundedPrice = Decimal()
        var value = price

        NSDecimalRound(
            &roundedPrice,
            &value,
            noFractionDigits,
            .plain
        )

        let hasCents = price != roundedPrice

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        formatter.minimumFractionDigits = hasCents
            ? currencyFractionDigits
            : noFractionDigits

        formatter.maximumFractionDigits = hasCents
            ? currencyFractionDigits
            : noFractionDigits

        let number = NSDecimalNumber(decimal: price)

        return formatter.string(from: number) ?? "R$ \(number)"
    }

    /// Formats a price as natural-language text for VoiceOver.
    ///
    /// The currency unit is written out instead of using the currency symbol.
    /// The singular form (`real`) is used only for a value of exactly `1`;
    /// all other values use the plural form (`reais`).
    ///
    /// Examples:
    ///
    /// ```swift
    /// DSSalonCardFormatter.spokenPrice(1)
    /// // "1 real"
    ///
    /// DSSalonCardFormatter.spokenPrice(35)
    /// // "35 reais"
    /// ```
    ///
    /// - Parameter price: The price to format.
    /// - Returns: A localized, human-readable representation intended for
    ///   VoiceOver.
    static func spokenPrice(_ price: Decimal) -> String {
        let number = NSDecimalNumber(decimal: price)

        decimal.maximumFractionDigits = currencyFractionDigits

        let amount = decimal.string(from: number) ?? "\(number)"

        return price == singularPriceThreshold
            ? "\(amount) real"
            : "\(amount) reais"
    }

    // MARK: - Distance Formatters

    /// Formats a distance for visual display on the salon card.
    ///
    /// Distances below one kilometer are displayed in meters. Distances of
    /// one kilometer or more are converted to kilometers and displayed with
    /// up to one decimal place.
    ///
    /// Examples:
    ///
    /// ```swift
    /// DSSalonCardFormatter.distanceText(meters: 300)
    /// // "300 m"
    ///
    /// DSSalonCardFormatter.distanceText(meters: 1200)
    /// // "1,2 km"
    /// ```
    ///
    /// If `meters` is `nil`, no distance information is available and the
    /// method returns `nil`.
    ///
    /// - Parameter meters: The distance from the salon in meters.
    /// - Returns: A formatted distance string, or `nil` when no distance is
    ///   available.
    static func distanceText(meters: Int?) -> String? {
        guard let meters else { return nil }

        guard meters >= metersInKilometer else {
            return "\(meters) m"
        }

        decimal.maximumFractionDigits = distanceFractionDigits

        let kilometers = decimal.string(
            from: NSNumber(
                value: Double(meters) / metersInKilometerDouble
            )
        ) ?? "\(meters / metersInKilometer)"

        return "\(kilometers) km"
    }

    /// Formats a distance as natural-language text for VoiceOver.
    ///
    /// The numeric value follows the same formatting rules as
    /// ``distanceText(meters:)``, but the unit is written out in full.
    ///
    /// Examples:
    ///
    /// ```swift
    /// DSSalonCardFormatter.spokenDistance(meters: 300)
    /// // "a 300 metros"
    ///
    /// DSSalonCardFormatter.spokenDistance(meters: 1200)
    /// // "a 1,2 quilômetros"
    /// ```
    ///
    /// If `meters` is `nil`, the method returns `nil`.
    ///
    /// - Parameter meters: The distance from the salon in meters.
    /// - Returns: A human-readable distance intended for VoiceOver, or `nil`
    ///   when no distance is available.
    static func spokenDistance(meters: Int?) -> String? {
        guard let meters,
              let text = distanceText(meters: meters)
        else {
            return nil
        }

        let isKilometer = meters >= metersInKilometer
        let unit = isKilometer ? "quilômetros" : "metros"
        let value = text.replacingOccurrences(
            of: isKilometer ? " km" : " m",
            with: ""
        )

        return "a \(value) \(unit)"
    }

    // MARK: - Accessibility

    /// Builds the combined VoiceOver label for a salon card.
    ///
    /// The returned label follows the product's fixed accessibility reading
    /// order:
    ///
    /// 1. Salon name
    /// 2. Price
    /// 3. Distance, when available
    /// 4. Availability, when available
    /// 5. Accessibility features
    ///
    /// Individual accessibility features are appended in the same order in
    /// which they are provided by `features`.
    ///
    /// Components are separated by commas to provide a natural pause when
    /// announced by VoiceOver.
    ///
    /// Example:
    ///
    /// ```swift
    /// let label = DSSalonCardFormatter.accessibilityLabel(
    ///     name: "Studio Bella",
    ///     price: 35,
    ///     meters: 1200,
    ///     availability: "Disponível hoje",
    ///     features: [.semDegrau, .banheiroAdaptado]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - name: The salon's display name.
    ///   - price: The salon service price.
    ///   - meters: The distance to the salon in meters. When `nil`, distance
    ///     is omitted from the label.
    ///   - availability: The salon's availability description. When `nil`,
    ///     availability is omitted from the label.
    ///   - features: The accessibility features available at the salon.
    ///     Features are announced in the order provided.
    /// - Returns: A combined VoiceOver label containing the salon information
    ///   in the product-defined reading order.
    static func accessibilityLabel(
        name: String,
        price: Decimal,
        meters: Int?,
        availability: String?,
        features: [DSSalonAccessibilityFeature]
    ) -> String {
        var parts = [name, spokenPrice(price)]

        if let spoken = spokenDistance(meters: meters) {
            parts.append(spoken)
        }

        if let availability {
            parts.append(availability)
        }

        parts.append(contentsOf: features.map(\.accessibilityText))

        return parts.joined(separator: ", ")
    }
}
