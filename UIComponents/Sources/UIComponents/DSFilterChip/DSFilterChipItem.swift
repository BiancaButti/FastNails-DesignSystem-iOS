import Foundation

// MARK: - DSFilterChipItem

/// Defines the data and action required to render a filter chip.
///
/// Use `DSFilterChipItem` to provide a stable identity, presentation data, selection state, and tap action for a filter chip.
/// The selected state is controlled externally by the caller.
///
/// ```swift
/// DSFilterChipItem(
///     id: "price",
///     label: "Up to R$ 90",
///     isActive: false
/// ) {
///     togglePriceFilter()
/// }
/// ```
public struct DSFilterChipItem: Identifiable {
    /// A stable identifier used to uniquely identify the filter item.
    public let id: String

    /// The text displayed inside the filter chip.
    public let label: String

    /// A Boolean value indicating whether the filter is currently selected.
    public let isActive: Bool

    /// The optional SF Symbol name displayed before the filter label.
    public let systemImage: String?

    /// The closure executed when the filter chip is tapped.
    public let onTap: () -> Void

    /// Creates a `DSFilterChipItem`.
    /// - Parameters:
    ///   - id: A stable unique identifier for the filter item.
    ///   - label: The text displayed inside the filter chip.
    ///   - isActive: Whether the filter is currently selected.
    ///   - systemImage: An optional SF Symbol name displayed before the label. Defaults to `nil`.
    ///   - onTap: The closure executed when the filter chip is tapped.
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
