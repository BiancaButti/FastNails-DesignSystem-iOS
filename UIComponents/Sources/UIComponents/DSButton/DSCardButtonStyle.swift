import SwiftUI

// MARK: - Card button style

/// A filled, full-width button style for the actions inside a status-style card
/// (e.g. ``DSStatusCard``).
///
/// The colors are supplied by the host card's palette rather than fixed tokens,
/// so the same style adapts to a dark, light, or accent card background. Apply
/// it ergonomically through ``SwiftUI/ButtonStyle/dsStatusCard(background:foreground:)``:
///
/// ```swift
/// HStack { actions }
///     .buttonStyle(.dsStatusCard(background: palette.actionBackground,
///                                foreground: palette.actionForeground))
/// ```
struct DSCardButtonStyle: ButtonStyle {

    /// Fill behind the button.
    let background: Color

    /// Color of the button's label.
    let foreground: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSFont.inputSupportBold)
            .foregroundStyle(foreground)
            .multilineTextAlignment(.center)
            .padding(.vertical, DSPadding.small)
            .padding(.horizontal, DSPadding.medium)
            .frame(maxWidth: .infinity)
            .background(background,
                        in: .rect(cornerRadius: DSRadius.control,
                                  style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

// MARK: - Ergonomic factory

extension ButtonStyle where Self == DSCardButtonStyle {

    /// The filled, full-width action style used inside status-style cards,
    /// tinted with the card palette's colors.
    ///
    /// - Parameters:
    ///   - background: Fill behind the button.
    ///   - foreground: Color of the button's label.
    static func dsStatusCard(background: Color, foreground: Color) -> DSCardButtonStyle {
        DSCardButtonStyle(background: background, foreground: foreground)
    }
}
