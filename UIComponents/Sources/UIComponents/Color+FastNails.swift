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
    static let tinta = Color(hex: 0x241C2B)

    /// Secondary text over Papel. Contrast 5.9:1.
    static let tinta60 = Color(hex: 0x6B6371)

    /// Screen background.
    static let papel = Color(hex: 0xFFFFFF)

    /// Background for elements resting on Papel — fields, cells, chips.
    static let papel2 = Color(hex: 0xEDE6E8)

    /// Borders and dividers.
    static let linha = Color(hex: 0xD9D0D3)

    /// Actionable control border — darker than Linha to signal that there is
    /// something interactive. Contrast over Papel: ~3.7:1.
    static let control = Color(hex: 0x878787)

    /// Light text over Tinta.
    static let blush = Color(hex: 0xFADED3)

    // MARK: Action and state

    /// **The only action color.** Primary button, link, selection.
    /// Contrast over white: 5.5:1 — passes for small text.
    static let esmalte = Color(hex: 0xC4265E)

    /// Esmalte at 6%, already flattened over Papel. Selection background that
    /// keeps dark text legible on top.
    static let softEnamel = Color(hex: 0xFBF2F5)

    /// Confirmed, available, succeeded.
    static let confirmed = Color(hex: 0x2F7D74)

    /// Attention without error. No connection, suspended schedule.
    static let ambar = Color(hex: 0x9A6212)

    /// Error and destructive action.
    static let alerta = Color(hex: 0xB3261E)
}


// MARK: - Surfaces

extension Color {
    /// Card and field background. Pure white over Papel.
    public static let dsSurface = Color.white
}
