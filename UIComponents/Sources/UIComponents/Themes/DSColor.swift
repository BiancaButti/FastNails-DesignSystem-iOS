import SwiftUI

// MARK: - Hexadecimal

extension Color {
    /// Creates a color from a hexadecimal value in the `0xRRGGBB` format.
    ///
    /// Exists so the tokens below can be written with the same values as the
    /// documentation, without manually converting to components.
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

// MARK: - Tokens

/// Fast Nails colors.
///
/// **No dark mode variation.** The app has a single appearance, and each color
/// has one value. Supporting both modes would mean keeping two palettes in
/// sync and checking contrast twice — work that doesn't pay off until the app
/// asks for it.
///
/// The values are the same as the **Design System** page. If they diverge,
/// the page is the source of truth.
public extension Color {

    // MARK: Structure

    /// Dark brand background. Splash, icon and booking card.
    /// Contrast with Blush: 12.8:1.
    static let ink = Color(hex: 0x241C2B)

    /// Secondary text over Paper. Contrast 5.9:1.
    static let ink60 = Color(hex: 0x6B6371)

    /// Screen background.
    static let paper = Color(hex: 0xFFFFFF)

    /// Background for elements resting on Paper — fields, cells, chips.
    static let paper2 = Color(hex: 0xEDE6E8)

    /// Borders and dividers.
    static let line = Color(hex: 0xD9D0D3)

    /// Actionable control border — darker than Line to signal that there is
    /// something interactive. Contrast over Paper: ~3.7:1.
    static let control = Color(hex: 0x878787)

    /// Light text over Ink.
    static let blush = Color(hex: 0xFADED3)

    // MARK: Action and state

    /// **The only action color.** Primary button, link, selection.
    /// Contrast over white: 5.5:1 — passes for small text.
    static let enamel = Color(hex: 0xC4265E)

    /// Enamel at 6%, already flattened over Paper. Selection background that
    /// keeps dark text legible on top.
    static let softEnamel = Color(hex: 0xFBF2F5)

    /// Confirmed, available, succeeded.
    static let confirmed = Color(hex: 0x2F7D74)

    /// Attention without error. No connection, suspended schedule.
    static let amber = Color(hex: 0x9A6212)

    /// Error and destructive action.
    static let alert = Color(hex: 0xB3261E)

    // MARK: DSSalonCard

    /// Default colors backing ``DSSalonCardPalette``. Kept here so the palette
    /// reads as a list of tokens instead of raw color literals, and so the
    /// eventual migration to shared tokens happens in one place.
    /// Thin outline around the card, in place of a shadow in dense lists.
    static let salonCardBorder = Color(hex: 0xE0E3E8)

    /// Price label, aligned to the trailing edge of the header.
    static let salonCardPrice = Color(hex: 0xC70F4A)

    /// Tinted background behind the placeholder thumbnail icon.
    static let salonCardThumbnailBackground = Color(hex: 0xF5E6EB)

    /// Placeholder thumbnail icon (the SF Symbol) shown while there is no photo.
    static let salonCardThumbnailForeground = Color(hex: 0x6B7380)

    /// Capsule background behind each accessibility feature tag in the footer.
    static let salonCardFeatureBackground = Color(hex: 0xE0F0ED)

    /// Rounded square behind the icon inside an accessibility feature tag.
    static let salonCardFeatureIconBackground = Color(hex: 0x296BDB)

    /// Text of an accessibility feature tag.
    static let salonCardFeatureForeground = Color(hex: 0x404D54)
}


// MARK: - Surfaces

extension Color {
    /// Card and field background. Pure white over Paper.
    public static let dsSurface = Color.white
}
