import Foundation

// MARK: - Formatting

/// Pure text formatting for ``DSSalonCard`` — price, distance and their spoken
/// variants, plus the combined VoiceOver label.
///
/// Extracted from the view so the product-critical string logic can be unit
/// tested without building SwiftUI, and so the `NumberFormatter`s are created
/// once instead of on every render.
enum DSSalonCardFormatter {
    
    // MARK: - Constants
    
    private static let noFractionDigits: Int = 0
    private static let currencyFractionDigits: Int = 2
    private static let distanceFractionDigits: Int = 1
    
    private static let singularPriceThreshold: Decimal = 1
    private static let metersInKilometer: Int = 1000
    private static let metersInKilometerDouble: Double = 1000.0

    // MARK: - Formatters

    private static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()

    private static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()

    // MARK: - Price Formatters

    /// Currency, hiding cents when the price is a whole number: "R\$ 35" / "R\$ 35,50".
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
        
        formatter.minimumFractionDigits = hasCents ? currencyFractionDigits : noFractionDigits
        formatter.maximumFractionDigits = hasCents ? currencyFractionDigits : noFractionDigits

        let number = NSDecimalNumber(decimal: price)
        return formatter.string(from: number) ?? "R$ \(number)"
    }

    /// Price spelled for VoiceOver: "1 real" / "35 reais".
    static func spokenPrice(_ price: Decimal) -> String {
        let number = NSDecimalNumber(decimal: price)
        decimal.maximumFractionDigits = currencyFractionDigits
        let amount = decimal.string(from: number) ?? "\(number)"
        
        return price == singularPriceThreshold ? "\(amount) real" : "\(amount) reais"
    }

    // MARK: - Distance Formatters

    /// Distance shown on the card: "300 m" below 1 km, "1,2 km" at or above.
    /// `nil` hides the information.
    static func distanceText(meters: Int?) -> String? {
        guard let meters else { return nil }
        guard meters >= metersInKilometer else { return "\(meters) m" }
        
        decimal.maximumFractionDigits = distanceFractionDigits
        let km = decimal.string(from: NSNumber(value: Double(meters) / metersInKilometerDouble)) ?? "\(meters / metersInKilometer)"
        return "\(km) km"
    }

    /// Distance spelled for VoiceOver: "a 300 metros" / "a 1,2 quilômetros".
    static func spokenDistance(meters: Int?) -> String? {
        guard let meters, let text = distanceText(meters: meters) else { return nil }
        let isKilometer = meters >= metersInKilometer 
        let unit = isKilometer ? "quilômetros" : "metros"
        let value = text.replacingOccurrences(of: isKilometer ? " km" : " m", with: "")
        return "a \(value) \(unit)"
    }

    // MARK: - Accessibility

    /// Combined VoiceOver label in the product's fixed order:
    /// name, price, distance, availability, accessibility.
    static func accessibilityLabel(
        name: String,
        price: Decimal,
        meters: Int?,
        availability: String?,
        features: [DSSalonAccessibilityFeature]
    ) -> String {
        var parts = [name, spokenPrice(price)]
        if let spoken = spokenDistance(meters: meters) { parts.append(spoken) }
        if let availability { parts.append(availability) }
        parts.append(contentsOf: features.map(\.accessibilityText))
        return parts.joined(separator: ", ")
    }
}
