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
    /// Background color. When `nil`, defaults to the theme's `paper` token (#FFFFFF).
    let background: Color?
    /// Border stroke color. When `nil`, defaults to the theme's `line` token (#D9D0D3).
    let borderColor: Color?

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
        background: Color? = nil,
        borderColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.alignment = alignment
        self.background = background
        self.borderColor = borderColor
        self.content = content
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(title.uppercased())
                .font(DSFont.badge)
                .foregroundColor(DSColor.ink60)
                .tracking(DSTracking.upperTag)
            
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
                shape.strokeBorder(borderColor ?? DSColor.line, lineWidth: DSBorder.thin)
            )
        }
    }
}
