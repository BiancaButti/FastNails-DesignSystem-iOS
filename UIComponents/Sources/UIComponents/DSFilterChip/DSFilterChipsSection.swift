import SwiftUI

/// A horizontal collection of filter chips.
///
/// Use `DSFilterChipsSection` to display a group of related filters at the
/// top of a list or search results screen. Each chip can independently expose
/// its selected state and an action to update the corresponding filter.
///
/// The section can optionally display a title and supporting description.
/// The chips are horizontally scrollable when they do not fit the available
/// width.
///
/// ## Example
///
/// ```swift
/// DSFilterChipsSection(
///     title: "Filtros",
///     description: "Edite os filtros usados para personalizar os resultados.",
///     items: [
///         DSFilterChipItem(
///             id: "hands",
///             label: "Mãos",
///             isActive: true,
///             onTap: {
///                 // Toggle hands filter
///             }
///         ),
///         DSFilterChipItem(
///             id: "salon",
///             label: "Salão",
///             onTap: {
///                 // Toggle salon filter
///             }
///         ),
///         DSFilterChipItem(
///             id: "price",
///             label: "Até R$ 90",
///             onTap: {
///                 // Toggle price filter
///             }
///         ),
///         DSFilterChipItem(
///             id: "accessible",
///             label: "Acessível",
///             systemImage: "accessibility",
///             onTap: {
///                 // Toggle accessibility filter
///             }
///         )
///     ]
/// )
/// ```
///
/// ## Using an enum as the source
///
/// For applications where filters are represented by an enum, map the enum
/// cases into `DSFilterChipItem` values:
///
/// ```swift
/// let chips = SearchFilter.allCases.map { filter in
///     DSFilterChipItem(
///         id: filter.rawValue,
///         label: filter.label,
///         isActive: viewModel.isActive(filter),
///         onTap: {
///             viewModel.toggleFilter(filter)
///         }
///     )
/// }
///
/// DSFilterChipsSection(
///     title: "Filtros",
///     items: chips
/// )
/// ```
///
/// ## Accessibility
///
/// Each filter is exposed as an independent button. The selected state of an
/// active chip is exposed to assistive technologies through the
/// `.isSelected` accessibility trait.
///
/// The horizontal scroll container does not provide a separate semantic
/// element; users navigate through the individual filter buttons.
///
/// - Note: The section does not manage filter state itself. The caller is
///   responsible for maintaining `isActive` and implementing `onTap`.
///
/// - SeeAlso: `DSFilterChipView`
/// - SeeAlso: `DSFilterChipItem`
public struct DSFilterChipsSection: View {

    /// The title displayed above the filter chips.
    let title: String

    /// Optional supporting text displayed below the filter chips.
    let description: String?

    /// The ordered collection of filters displayed by the section.
    let items: [DSFilterChipItem]

    /// Creates a filter chips section.
    ///
    /// - Parameters:
    ///   - title: The title displayed above the chips.
    ///     Defaults to an empty string.
    ///   - description: Optional supporting text displayed below the chips.
    ///   - items: The ordered collection of filter chips to display.
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
                .font(DSFont.etiqueta)
                .textCase(.uppercase)
                .tracking(1.2)

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
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(DSSpacing.lg)
        .overlay {
            RoundedRectangle(cornerRadius: 0)
                .stroke(
                    Color.secondary.opacity(0.25),
                    lineWidth: 1
                )
        }
    }
}
