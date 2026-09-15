import Foundation

// MARK: - Formatting

/// Pure text formatting for ``DSSalonCard`` — price, distance and their spoken
/// variants, plus the combined VoiceOver label.
///
/// Extracted from the view so the product-critical string logic can be unit
/// tested without building SwiftUI, and so the `NumberFormatter`s are created
/// once instead of on every render.
enum DSSalonCardFormatter {

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

    /// Currency, hiding cents when the price is a whole number: "R$ 35" / "R$ 35,50".
    static func priceText(_ price: Decimal) -> String {
        let number = NSDecimalNumber(decimal: price)
        let hasCents = number.doubleValue.truncatingRemainder(dividingBy: 1) != 0
        currency.minimumFractionDigits = hasCents ? 2 : 0
        currency.maximumFractionDigits = hasCents ? 2 : 0
        return currency.string(from: number) ?? "R$ \(number)"
    }

    /// Price spelled for VoiceOver: "1 real" / "35 reais".
    static func spokenPrice(_ price: Decimal) -> String {
        let number = NSDecimalNumber(decimal: price)
        decimal.maximumFractionDigits = 2
        let amount = decimal.string(from: number) ?? "\(number)"
        return number == 1 ? "\(amount) real" : "\(amount) reais"
    }

    /// Distance shown on the card: "300 m" below 1 km, "1,2 km" at or above.
    /// `nil` hides the information.
    static func distanceText(meters: Int?) -> String? {
        guard let meters else { return nil }
        guard meters >= 1000 else { return "\(meters) m" }
        decimal.maximumFractionDigits = 1
        let km = decimal.string(from: NSNumber(value: Double(meters) / 1000)) ?? "\(meters / 1000)"
        return "\(km) km"
    }

    /// Distance spelled for VoiceOver: "a 300 metros" / "a 1,2 quilômetros".
    static func spokenDistance(meters: Int?) -> String? {
        guard let meters, let text = distanceText(meters: meters) else { return nil }
        let unit = meters >= 1000 ? "quilômetros" : "metros"
        let value = text.replacingOccurrences(of: meters >= 1000 ? " km" : " m", with: "")
        return "a \(value) \(unit)"
    }

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
