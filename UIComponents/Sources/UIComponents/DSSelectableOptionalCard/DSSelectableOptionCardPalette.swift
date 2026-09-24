import SwiftUI
// MARK: - Palette per state

/// Surface and content of a card state, together.
///
/// It exists because swapping the background without revisiting the text on top
/// of it is too easy when the two choices live in distant spots of the file —
/// that's how `tinta60` ended up over solid Esmalte, at 1.04:1.
/// Any new state is forced to declare all seven colors at once.
struct DSSelectableOptionCardPalette {
    let surface: Color
    let border: Color
    let borderWidth: CGFloat
    let title: Color
    let subtitle: Color
    let box: Color
    let boxBorder: Color
    let check: Color

    /// Not selected. The box border uses Controle (3.7:1) because it is the
    /// only signal that there is something actionable; Linha (1.5:1) won't do here.
    static let idle = DSSelectableOptionCardPalette(
        surface: DSColor.paper,
        border: DSColor.line,
        borderWidth: 1,
        title: DSColor.ink,
        subtitle: DSColor.ink,
        box: DSColor.paper,
        boxBorder: DSColor.control,
        check: DSColor.clear
    )

    /// Selected. The background is Esmalte at 6%, already flattened — the text
    /// stays dark and keeps the same contrast as the normal state.
    static let selected = DSSelectableOptionCardPalette(
        surface: DSColor.softEnamel,
        border: DSColor.enamel,
        borderWidth: 1.5,
        title: DSColor.ink,
        subtitle: DSColor.ink60,
        box: DSColor.enamel,
        boxBorder: DSColor.enamel,
        check: DSColor.paper
    )

    /// Solid-fill variant, in case the Design System wants that weight.
    /// Title and description both go in Papel: Blush over Esmalte is 4.35:1
    /// and fails AA for small text. Hierarchy here comes from size and weight,
    /// not color.
    static let selectedSolid = DSSelectableOptionCardPalette(
        surface: DSColor.enamel,
        border: DSColor.enamel,
        borderWidth: 1.5,
        title: DSColor.paper,
        subtitle: DSColor.paper,
        box: DSColor.paper,
        boxBorder: DSColor.paper,
        check: DSColor.enamel
    )
}
