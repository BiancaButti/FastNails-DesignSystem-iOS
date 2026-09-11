// MARK: - DSFilterChipItem

/// The data required to render a filter chip.
///
/// `DSFilterChipItem` keeps the presentation of a filter separate from the
/// application's filter model. The application controls the selected state
/// through `isActive` and handles changes through `onTap`.
///
/// ## Example
///
/// ```swift
/// DSFilterChipItem(
///     id: "price",
///     label: "Até R$ 90",
///     isActive: false,
///     onTap: {
///         viewModel.togglePriceFilter()
///     }
/// )
/// ```
///
/// A system image can optionally be displayed before the label:
///
/// ```swift
/// DSFilterChipItem(
///     id: "accessible",
///     label: "Acessível",
///     systemImage: "accessibility",
///     onTap: {
///         viewModel.toggleAccessibilityFilter()
///     }
/// )
/// ```
///
/// - Note: `isActive` is a value supplied by the caller. The item itself does
///   not manage its state.
public struct DSFilterChipItem: Identifiable {

    /// A stable identifier used by SwiftUI's `ForEach`.
    public let id: String

    /// The text displayed inside the chip.
    public let label: String

    /// Whether the filter is currently selected.
    public let isActive: Bool

    /// An optional SF Symbol displayed before the label.
    ///
    /// For example, `"accessibility"` can be used to represent an
    /// accessibility-related filter.
    public let systemImage: String?

    /// The action executed when the chip is tapped.
    public let onTap: () -> Void

    /// Creates a filter chip item.
    ///
    /// - Parameters:
    ///   - id: A stable unique identifier for the filter.
    ///   - label: The text displayed inside the chip.
    ///   - isActive: Whether the filter is currently selected.
    ///   - systemImage: An optional SF Symbol name displayed before the label.
    ///   - onTap: The action executed when the chip is tapped.
    public init(
        id: String,
        label: String,
        isActive: Bool,
        systemImage: String? = nil,
        onTap: @escaping () -> Void
    ) {
        self.id = id
        self.label = label
        self.isActive = isActive
        self.systemImage = systemImage
        self.onTap = onTap
    }
}
