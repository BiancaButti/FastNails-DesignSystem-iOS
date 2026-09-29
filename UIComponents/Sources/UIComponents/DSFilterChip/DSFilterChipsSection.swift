import SwiftUI

// MARK: - DSFilterChipsSection

/// Displays a horizontally scrollable collection of related filter chips.
///
/// Use `DSFilterChipsSection` to group filters above a list or search results.
/// The caller controls each filter's selected state and action through `DSFilterChipItem`.
///
/// ```swift
/// DSFilterChipsSection(
///     title: "Filters",
///     items: [
///         DSFilterChipItem(
///             id: "hands",
///             label: "Hands",
///             isActive: true
///         ) {
///             toggleHandsFilter()
///         }
///     ]
/// )
/// ```
///
/// ## Accessibility
/// Each filter is exposed as an independent button, with the selected state communicated through the `.isSelected` trait.
public struct DSFilterChipsSection: View {
    /// The title displayed above the filter chips.
    let title: String

    /// Optional supporting text displayed below the filter chips.
    let description: String?

    /// The ordered collection of filter items displayed by the section.
    let items: [DSFilterChipItem]

    /// Creates a `DSFilterChipsSection`.
    /// - Parameters:
    ///   - title: The title displayed above the filter chips. Defaults to an empty string.
    ///   - description: Optional supporting text displayed below the filter chips. Defaults to `nil`.
    ///   - items: The ordered collection of filter items to display.
    public init(
        title: String = "",
        description: String? = nil,
        items: [DSFilterChipItem]
    ) {
        self.title = title
        self.description = description
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(DSFont.technicalTag)
                .textCase(.uppercase)
                .tracking(DSTracking.upperTag)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.sm) {
                    ForEach(items) { item in
                        DSFilterChipView(
                            label: item.label,
                            isActive: item.isActive,
                            systemImage: item.systemImage,
                            action: item.onTap
                        )
                    }
                }
            }

            if let description {
                Text(description)
                    .font(DSFont.inputSupport)
                    .foregroundStyle(Color.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(DSSpacing.lg)
        .overlay {
            RoundedRectangle(cornerRadius: .zero)
                .stroke(
                    Color.secondary.opacity(0.25),
                    lineWidth: 1
                )
        }
    }
}
