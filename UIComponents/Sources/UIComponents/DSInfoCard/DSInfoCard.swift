import SwiftUI

// MARK: - DSInfoCard

/// Groups contextual information inside a styled container with a section label.
///
/// Use `DSInfoCard` to organize related details such as scheduling, customer, or location information.
/// The card supports custom alignment, background, border color, and arbitrary SwiftUI content.
///
/// ```swift
/// DSInfoCard(title: "When") {
///     Text("Today, Tuesday")
///     Text("16:00 to 16:30")
/// }
/// ```
///
/// ## Accessibility
/// The title and card content remain available to assistive technologies as separate text elements.
public struct DSInfoCard<Content: View>: View {
    /// The view content displayed inside the card.
    @ViewBuilder let content: () -> Content

    /// The section title displayed above the card content.
    let title: String

    /// The horizontal alignment applied to the card's content.
    let alignment: HorizontalAlignment

    /// The custom background color applied to the card.
    ///
    /// When `nil`, the card uses `DSColor.paper`.
    let background: Color?

    /// The custom border color applied to the card.
    ///
    /// When `nil`, the card uses `DSColor.line`.
    let borderColor: Color?

    /// Creates a `DSInfoCard`.
    /// - Parameters:
    ///   - title: The section title displayed above the card content.
    ///   - alignment: The horizontal alignment applied to the card's content. Defaults to `.leading`.
    ///   - background: The custom background color applied to the card. Defaults to `nil`, which uses `DSColor.paper`.
    ///   - borderColor: The custom border color applied to the card. Defaults to `nil`, which uses `DSColor.line`.
    ///   - content: The view builder that provides the content displayed inside the card.
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
        RoundedRectangle(
            cornerRadius: DSRadius.large,
            style: .continuous
        )
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
            .frame(
                maxWidth: .infinity,
                alignment: Alignment(
                    horizontal: alignment,
                    vertical: .center
                )
            )
            .background(background ?? DSColor.paper)
            .clipShape(shape)
            .overlay(
                shape.strokeBorder(
                    borderColor ?? DSColor.line,
                    lineWidth: DSBorder.thin
                )
            )
        }
    }
}
