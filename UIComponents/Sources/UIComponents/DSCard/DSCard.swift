import SwiftUI

// MARK: - DSCard

/// An elevated card that groups a block of content — typically the fields of a
/// form over a colored background, or a listing row like ``DSSalonCard``.
///
/// The color comes from `DSTheme` (`surfaceColor`), so switching the theme
/// reskins every card at once.
///
/// ```swift
/// DSCard {
///     DSTextField(label: "E-mail", placeholder: "seu@email.com", text: $email)
///     DSPrimaryButton(title: "Entrar") { }
/// }
/// ```
///
/// Listing rows call for a more discreet presence — a thin border instead of a
/// shadow, and content pinned to the leading edge:
///
/// ```swift
/// DSCard(
///     alignment: .leading,
///     spacing: 12,
///     padding: 16,
///     cornerRadius: 20,
///     borderColor: theme.separatorColor,
///     elevation: .subtle
/// ) { ... }
/// ```
///
/// ## Accessibility
/// The card is purely visual and does not interfere with reading — VoiceOver
/// navigates straight through the inner content.
public struct DSCard<Content: View>: View {

    /// Intensity of the shadow cast beneath the card.
    public enum Elevation {
        /// No shadow. Use with `borderColor` in dense lists.
        case none
        /// A barely perceptible shadow, for cards that repeat on screen.
        case subtle
        /// The default shadow, for cards floating over a colored background.
        case raised

        var radius: CGFloat {
            switch self {
            case .none: return 0
            case .subtle: return 8
            case .raised: return 18
            }
        }

        var opacity: Double {
            switch self {
            case .none: return 0
            case .subtle: return 0.04
            case .raised: return 0.06
            }
        }

        var offsetY: CGFloat {
            switch self {
            case .none: return 0
            case .subtle: return 3
            case .raised: return 10
            }
        }
    }

    /// Horizontal alignment of the items inside the card.
    let alignment: HorizontalAlignment
    /// Vertical spacing between the items inside the card.
    let spacing: CGFloat
    /// Inner spacing between the content and the card's edge.
    let padding: CGFloat
    /// Corner radius.
    let cornerRadius: CGFloat
    /// Background color. When `nil`, uses the theme's `surfaceColor`.
    let background: Color?
    /// Border color. When `nil`, the card has no border.
    let borderColor: Color?
    /// Border width, drawn inside the radius.
    let borderWidth: CGFloat
    /// Shadow intensity.
    let elevation: Elevation
    @ViewBuilder let content: () -> Content

    @Environment(\.dsTheme) private var theme

    /// Creates a `DSCard`.
    /// - Parameters:
    ///   - alignment: Horizontal alignment of the items (default `.center`).
    ///     Use `.leading` in content cards, where centered text hurts visual
    ///     scanning.
    ///   - spacing: Spacing between the items (default `DSSpacing.lg`, 16 pt).
    ///   - padding: Inner spacing (default 20 pt).
    ///   - cornerRadius: Corner radius (default 24 pt — more pronounced than
    ///     `DSRadius.folha`, which is for sheets and modals).
    ///   - background: Background color. When `nil`, uses the theme's
    ///     `surfaceColor`. Provide it to set a card apart from the rest of the
    ///     screen — for example, the next appointment filled with the brand color.
    ///   - borderColor: Border color. When `nil`, the card has no border.
    ///   - borderWidth: Border width (default 1 pt).
    ///   - elevation: Shadow intensity (default `.raised`).
    ///   - content: The card's content.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = DSSpacing.lg,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        background: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        elevation: Elevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.elevation = elevation
        self.content = content
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .center))
        .background(background ?? theme.surfaceColor)
        .clipShape(shape)
        .overlay(
            Group {
                if let borderColor {
                    shape.strokeBorder(borderColor, lineWidth: borderWidth)
                }
            }
        )
        .shadow(
            color: .black.opacity(elevation.opacity),
            radius: elevation.radius,
            y: elevation.offsetY
        )
    }
}
