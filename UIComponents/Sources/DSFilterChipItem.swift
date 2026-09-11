import SwiftUI

// MARK: - DSFilterChipItem

/// Describes the content and behavior of a filter chip.
///
/// Use `DSFilterChipItem` to define the appearance and interaction of each
/// chip displayed by `DSFilterChipsSection`.
///
/// ```swift
/// let chips = SearchFilter.allCases.map { filter in
///     DSFilterChipItem(
///         id: filter.rawValue,
///         label: filter.label,
///         isActive: viewModel.isActive(filter),
///         onTap: { viewModel.toggleFilter(filter) }
///     )
/// }
/// ```
public struct DSFilterChipItem: Identifiable {
    public let id: String

    /// The text displayed by the chip.
    public let label: String

    /// Indicates whether the chip is currently selected.
    public let isActive: Bool

    /// The action performed when the chip is tapped.
    public let onTap: () -> Void

    public init(id: String, label: String, isActive: Bool, onTap: @escaping () -> Void) {
        self.id = id
        self.label = label
        self.isActive = isActive
        self.onTap = onTap
    }
}


