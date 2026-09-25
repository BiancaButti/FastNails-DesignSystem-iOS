import SwiftUI

// MARK: - DSInfoCard

/// A structural information card that groups contextual scheduling details — typically split
/// into specific sections like "When", "Who", or "Where" over a clean background.
///
/// The card uses `Color.paper` as its background and `Color.line`
/// as its stroke color by default to subtly elevate relevant transaction tokens.
///
/// ```swift
/// DSInfoCard(title: "When") {
///     Text("Hoje, terça-feira")
///         .font(.headline)
///     Text("16:00 às 16:30")
///         .font(.subheadline)
/// }
/// ```
///
/// ## Accessibility
/// The upper section label is set to mono-spaced tracking to facilitate scanning by assistive tools.
/// VoiceOver reads straight through the inner stack contents dynamically.
public struct DSInfoCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    /// The category descriptor string displayed above the card (e.g., "QUANDO", "QUEM", "ONDE").
    let title: String
    /// Horizontal alignment of the inner content elements.
    let alignment: HorizontalAlignment
    /// Vertical spacing between the items inside the card.
    let spacing: CGFloat
    /// Inner spacing between the content and the card's container edge.
    let padding: CGFloat
    /// Corner radius of the container's rectangle.
    let cornerRadius: CGFloat
    /// Background color. When `nil`, defaults to the theme's `paper` token (#FFFFFF).
    let background: Color?
    /// Border stroke color. When `nil`, defaults to the theme's `line` token (#D9D0D3).
    let borderColor: Color?
    /// Border line width drawn inside the shape radius.
    let borderWidth: CGFloat

    /// Creates a `DSInfoCard`.
    /// - Parameters:
    ///   - title: The localized section text to appear as a small upper tracker header.
    ///   - alignment: Horizontal alignment of inner items (default `.leading`).
    ///   - spacing: Vertical space block between children (default 8 pt).
    ///   - padding: Inner container inset padding (default 16 pt).
    ///   - cornerRadius: Inner stroke continuous clipping radius (default 16 pt).
    ///   - background: Background tint color. Set to `nil` for default white paper token.
    ///   - borderColor: Container stroke border tint. Set to `nil` for default light gray line token.
    ///   - borderWidth: Inner overlay outline thickness (default 1 pt).
    ///   - content: The underlying presentation view content block.
    public init(
        title: String,
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 8,
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 16,
        background: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.alignment = alignment
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.content = content
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(DSFont.badge)
                .foregroundColor(DSColor.ink60)
                .tracking(1.5)
            
            VStack(alignment: alignment, spacing: DSSpacing.sm) {
                content()
            }
            .padding(DSPadding.regular)
            .frame(maxWidth: .infinity,
                   alignment: Alignment(
                    horizontal: alignment,
                    vertical: .center))
            .background(background ?? DSColor.paper)
            .clipShape(shape)
            .overlay(
                shape.strokeBorder(borderColor ?? DSColor.line, lineWidth: borderWidth)
            )
        }
    }
}
