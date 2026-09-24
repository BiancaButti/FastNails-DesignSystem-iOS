import SwiftUI

// MARK: - Hexadecimal Converter

public extension Color {
    /// Creates a color from a hexadecimal value in the `0xRRGGBB` format.
    ///
    /// Exists so the tokens can be written with the same values as the
    /// design documentation, without manually converting to RGB components.
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

// MARK: - Design System Tokens

/// Fast Nails palette and semantic color tokens.
///
/// **No dark mode variation.** The app has a single appearance, and each color
/// has one value. Supporting both modes would mean keeping two palettes in
/// sync and checking contrast twice — work that doesn't pay off until the app
/// asks for it.
///
/// The values are the same as the **Design System** documentation page.
/// If they diverge, the design page is the single source of truth.
public enum DSColor {
    
    // MARK: - Structure & Neutrals (Ink & Paper)

    /// Dark brand background. Used in Splash, icons, and booking cards.
    /// Contrast with Blush: 12.8:1. (Deep dark purple/almost black).
    public static let ink = Color(hex: 0x241C2B)

    /// Secondary text over Paper or light backgrounds. Contrast 5.9:1. (Asphalt gray with purple undertones).
    public static let ink60 = Color(hex: 0x6B6371)

    /// Primary body text, descriptions, and structural labels. (Medium-dark graphite gray).
    public static let text = Color(hex: 0x737373)

    /// Primary screen background. (Pure white).
    public static let paper = Color(hex: 0xFFFFFF)

    /// Background for elements resting on Paper — text fields, table cells, chips. (Light rosy gray).
    public static let paper2 = Color(hex: 0xEDE6E8)

    /// Background surface for generic layout cards and containers. (Warm off-white).
    public static let surface = Color(hex: 0xF5F0F2)

    /// Pure white surface background designated strictly for core DS components. (Pure white).
    public static let dsSurface = Color(hex: 0xFFFFFF)

    /// Standard borders and subtle layout dividers. (Neutral light gray).
    public static let line = Color(hex: 0xD9D0D3)

    /// Semi-transparent divider line layout helper. (Black with 8% opacity).
    public static let divider = Color.black.opacity(0.08)

    /// Actionable control border — darker than Line to signal interactivity. Contrast over Paper: ~3.7:1. (Classic medium gray).
    public static let control = Color(hex: 0x878787)

    /// Light text or background accents over Ink. (Very light baby pink / pastel peach).
    public static let blush = Color(hex: 0xFADED3)

    // MARK: - Action & Status

    /// **The primary action color.** Primary buttons, active links, and selections.
    /// Contrast over white: 5.5:1 — passes for small text size. (Deep magenta / dark hot pink).
    public static let enamel = Color(hex: 0xC4265E)

    /// Enamel at 6% opacity, flattened over Paper. Ideal for selection backgrounds that keep dark text legible. (Whitish pastel pink).
    public static let softEnamel = Color(hex: 0xFBF2F5)

    /// Interactive text links, secondary buttons, or inline navigation references. (Light wine / carmine).
    public static let link = Color(hex: 0xC7174F)

    /// Confirmed status, available slots, or successfully completed steps. (Dark teal green).
    public static let confirmed = Color(hex: 0x2F7D74)

    /// Attention states without error blocks. e.g., missing connection, suspended schedules. (Dark gold / amber).
    public static let amber = Color(hex: 0x9A6212)

    /// Error states, validation failures, and critical destructive actions. (Vivid red).
    public static let alert = Color(hex: 0xB3261E)

    // MARK: - Component Specific: Salon Card
    
    /// Outer boundary line for salon items. (Very light blue-gray / ice).
    public static let salonCardBorder = Color(hex: 0xE0E3E8)

    /// Distinct price label aligned to the trailing edge of the card header. (Cherry / raspberry red).
    public static let salonCardPrice = Color(hex: 0xC70F4A)

    /// Tinted background layer placed directly behind placeholder thumbnail icons. (Light burnt pink).
    public static let salonCardThumbnailBackground = Color(hex: 0xF5E6EB)

    /// Placeholder SF Symbol thumbnail foreground icon vector. (Dark gray).
    public static let salonCardThumbnailForeground = Color(hex: 0x6B7380)

    /// Capsule container background for accessibility features inside card footers. (Very light pastel aqua green).
    public static let salonCardFeatureBackground = Color(hex: 0xE0F0ED)

    /// Rounded square backing context icons inside feature tags. (Vivid royal blue).
    public static let salonCardFeatureIconBackground = Color(hex: 0x296BDB)

    /// Label typography color for accessibility feature tags. (Dark lead gray).
    public static let salonCardFeatureForeground = Color(hex: 0x404D54)

    // MARK: - Component Specific: Event Card

    /// Ultra-light warm background surface framing a highlighted ongoing event card. (Almost white cream).
    public static let eventHighlightSurface = Color(hex: 0xFFFDF6)

    /// Decorative boundary border mapping a highlighted ongoing event card. (Golden beige).
    public static let eventHighlightBorder = Color(hex: 0xC5A880)

    // MARK: - Legacy Refactors & Curiosities
    
    /// Legacy brand identifier color token mapping. (Original value ~ #B8144A).
    public static let legacyBrand = Color(hex: 0xB8144A)
    
    /// Legacy tertiary content layout color mapping. (Original value ~ #B5B0B2).
    public static let legacyContentTertiary = Color(hex: 0xB5B0B2)
    
    /// Earthy terracotta contrast token highlight. (Deep terracotta rust red).
    public static let terracotta = Color(hex: 0x7A1B16)
    
    // MARK: - Shadows & Transparencies

    /// A completely transparent color token to be used instead of the native Color.clear.
    public static let clear = Color.clear
    
    // MARK: - Component Highlights

    /// A light blue background accent layer used for info tags or features (Derived blue with 15% opacity).
    public static let infoHighlight = Color(hex: 0x296BDB).opacity(0.15)

    // MARK: - Status Highlights

    /// A light amber/orange background accent layer for warnings or pending states (Amber with 15% opacity).
    public static let warningHighlight = amber.opacity(0.15)


}
