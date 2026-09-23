import SwiftUI

// MARK: - Hexadecimal

public extension Color {
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

// MARK: - Design System Tokens

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
    
    // MARK: - Legacy DSColor (Migrated to Hex)
    
    /// Brand color. Original value ~ #B8144A
    static let brand = Color(hex: 0xB8144A)
    
    /// Content Tertiary color. Original value ~ #B5B0B2
    static let contentTertiary = Color(hex: 0xB5B0B2)
    
    /// Divider line with transparency.
    static let divider = Color.black.opacity(0.08)

    // MARK: - Structure

    /// Dark brand background. Splash, icon and booking card.
    /// Contrast with Blush: 12.8:1.
    /// Cor: Roxo-escuro profundo (quase preto)
    static let ink = Color(hex: 0x241C2B)

    /// Secondary text over Paper. Contrast 5.9:1.
    /// Cor: Cinza-asfalto com fundo roxo
    static let ink60 = Color(hex: 0x6B6371)

    /// Screen background.
    /// Cor: Branco puro
    static let paper = Color(hex: 0xFFFFFF)

    /// Background for elements resting on Paper — fields, cells, chips.
    /// Cor: Cinza-claro rosado
    static let paper2 = Color(hex: 0xEDE6E8)

    /// Borders and dividers.
    /// Cor: Cinza-claro neutro
    static let line = Color(hex: 0xD9D0D3)

    /// Actionable control border — darker than Line to signal that there is
    /// something interactive. Contrast over Paper: ~3.7:1.
    /// Cor: Cinza médio clássico
    static let control = Color(hex: 0x878787)

    /// Light text over Ink.
    /// Cor: Rosa-bebê bem claro / Pêssego pastel
    static let blush = Color(hex: 0xFADED3)

    // MARK: - Action and State

    /// **The only action color.** Primary button, link, selection.
    /// Contrast over white: 5.5:1 — passes for small text.
    /// Cor: Magenta fechado / Rosa-choque escuro
    static let enamel = Color(hex: 0xC4265E)

    /// Enamel at 6%, already flattened over Paper. Selection background that
    /// keeps dark text legible on top.
    /// Cor: Rosa pastel esbrançado
    static let softEnamel = Color(hex: 0xFBF2F5)

    /// Confirmed, available, succeeded.
    /// Cor: Verde-petróleo escuro
    static let confirmed = Color(hex: 0x2F7D74)

    /// Attention without error. No connection, suspended schedule.
    /// Cor: Dourado escuro / Âmbar
    static let amber = Color(hex: 0x9A6212)

    /// Error and destructive action.
    /// Cor: Vermelho vivo
    static let alert = Color(hex: 0xB3261E)

    // MARK: - DSSalonCard
    
    /// Cor: Cinza-azulado bem claro (gelo)
    static let salonCardBorder = Color(hex: 0xE0E3E8)

    /// Price label, aligned to the trailing edge of the header.
    /// Cor: Cereja / Vermelho framboesa
    static let salonCardPrice = Color(hex: 0xC70F4A)

    /// Tinted background behind the placeholder thumbnail icon.
    /// Cor: Rosa-claro queimado
    static let salonCardThumbnailBackground = Color(hex: 0xF5E6EB)

    /// Placeholder thumbnail icon (the SF Symbol) shown while there is no photo.
    /// Cor: Cinza-escuro
    static let salonCardThumbnailForeground = Color(hex: 0x6B7380)

    /// Capsule background behind each accessibility feature tag in the footer.
    /// Cor: Verde-água pastel bem claro
    static let salonCardFeatureBackground = Color(hex: 0xE0F0ED)

    /// Rounded square behind the icon inside an accessibility feature tag.
    /// Cor: Azul-bic / Azul-royal vivo
    static let salonCardFeatureIconBackground = Color(hex: 0x296BDB)

    /// Text of an accessibility feature tag.
    /// Cor: Cinza-chumbo
    static let salonCardFeatureForeground = Color(hex: 0x404D54)

    // MARK: - Design System Core

    /// Pure white surface background for Design System components.
    /// Cor: Branco puro
    static let dsSurface = Color(hex: 0xFFFFFF)

    /// Off-white content background with a warm/rosy tint.
    /// Cor: Cinza-claro quente
    static let surface = Color(hex: 0xF5F0F2)

    /// Interactive text, secondary buttons, or inline navigation references.
    /// Cor: Vinho claro / Carmim
    static let link = Color(hex: 0xC7174F)

    /// Primary gray tone for body text, descriptions, and labels.
    /// Cor: Cinza médio-escuro (grafite)
    static let text = Color(hex: 0x737373)
    
    static let terracota = Color(hex: 0x7A1B16)

    // MARK: - DSEventCard highlight

    /// Very light warm surface behind a highlighted (ongoing) event card.
    /// Cor: Creme quase branco
    static let eventHighlightSurface = Color(hex: 0xFFFDF6)

    /// Border of a highlighted (ongoing) event card.
    /// Cor: Bege dourado
    static let eventHighlightBorder = Color(hex: 0xC5A880)
}
