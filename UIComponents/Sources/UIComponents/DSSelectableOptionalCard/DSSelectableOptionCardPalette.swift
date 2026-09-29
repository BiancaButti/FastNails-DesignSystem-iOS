import SwiftUI

// MARK: - Palette per state

/// Defines the complete visual appearance of a selectable option card state.
///
/// `DSSelectableOptionCardPalette` groups the surface, border, typography,
/// checkbox, and checkmark colors that must be used together for a given card
/// state.
///
/// Keeping these values together prevents an individual color from being
/// changed without considering its visual relationship with the other elements
/// in the same state.
///
/// Every predefined state declares the complete visual configuration required
/// by ``DSSelectableCheckboxCard``.
///
/// ## Accessibility
///
/// The predefined palettes are designed to maintain appropriate contrast
/// between text, controls, and their backgrounds.
///
/// - Important: When adding a new state, define all palette properties
///   together and verify the resulting contrast before using it in a
///   production component.
struct DSSelectableOptionCardPalette {

    /// The card's background color.
    let surface: Color

    /// The color of the card's border.
    let border: Color

    /// The width of the card's border.
    let borderWidth: CGFloat

    /// The primary text color used for the option title.
    let title: Color

    /// The secondary text color used for the option description.
    let subtitle: Color

    /// The background color of the checkbox.
    let box: Color

    /// The border color of the checkbox.
    let boxBorder: Color

    /// The color of the checkmark displayed when the option is selected.
    let check: Color

    /// The default appearance for an unselected option.
    ///
    /// The card uses the standard surface and border tokens, while the
    /// checkbox uses the control token to provide a clear actionable
    /// affordance.
    static let idle = DSSelectableOptionCardPalette(
        surface: DSColor.paper,
        border: DSColor.line,
        borderWidth: DSBorder.thin,
        title: DSColor.ink,
        subtitle: DSColor.ink,
        box: DSColor.paper,
        boxBorder: DSColor.control,
        check: DSColor.clear
    )

    /// The default appearance for a selected option.
    ///
    /// Uses a subtle selected-state surface while preserving readable text.
    /// The checkbox uses the enamel color and displays a contrasting
    /// checkmark.
    static let selected = DSSelectableOptionCardPalette(
        surface: DSColor.softEnamel,
        border: DSColor.enamel,
        borderWidth: DSBorder.thin,
        title: DSColor.ink,
        subtitle: DSColor.ink60,
        box: DSColor.enamel,
        boxBorder: DSColor.enamel,
        check: DSColor.paper
    )

    /// A solid-fill variant for the selected state.
    ///
    /// This variant uses the enamel color as the card surface and the paper
    /// color for both title and description text.
    ///
    /// Selection hierarchy is communicated through the selected surface and
    /// typography rather than relying on a lower-contrast text color.
    static let selectedSolid = DSSelectableOptionCardPalette(
        surface: DSColor.enamel,
        border: DSColor.enamel,
        borderWidth: DSBorder.thin,
        title: DSColor.paper,
        subtitle: DSColor.paper,
        box: DSColor.paper,
        boxBorder: DSColor.paper,
        check: DSColor.enamel
    )
}
