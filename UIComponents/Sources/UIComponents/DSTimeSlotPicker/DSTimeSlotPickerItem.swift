import SwiftUI

/// Defines the state and display value of a single time slot used by
/// ``DSTimeSlotPicker``.
///
/// `DSTimeSlotPickerItem` is a value type that describes how a time slot should
/// be presented and whether it can currently be selected.
///
/// The picker does not mutate the item. The caller is responsible for updating
/// `isSelected` and `isAvailable` when the underlying state changes.
///
/// ## Example
///
/// ```swift
/// let slot = DSTimeSlotPickerItem(
///     id: "14:00",
///     time: "14:00",
///     isSelected: false,
///     isAvailable: true
/// )
/// ```
///
/// ## Identity
///
/// The `id` identifies the slot within the picker. When creating items from a
/// data source, prefer a stable identifier that remains consistent across
/// updates so SwiftUI can correctly track the slot.
///
/// - SeeAlso: ``DSTimeSlotPicker``
public struct DSTimeSlotPickerItem: Identifiable {

    /// A unique identifier used by SwiftUI to track the time slot.
    public let id: String

    /// The formatted time displayed to the user.
    public let time: String

    /// Whether the time slot is currently selected.
    ///
    /// The picker uses this value to determine the selected appearance. The
    /// value is owned and updated by the caller.
    public let isSelected: Bool

    /// Whether the time slot is currently available for selection.
    ///
    /// Unavailable slots are displayed as disabled and cannot trigger the
    /// picker's selection action.
    public let isAvailable: Bool
    
    /// Creates a time slot item.
    ///
    /// - Parameters:
    ///   - id: The identifier used to track the slot. Defaults to a generated
    ///     UUID string.
    ///   - time: The formatted time displayed to the user.
    ///   - isSelected: Whether the slot starts in the selected state.
    ///     Defaults to `false`.
    ///   - isAvailable: Whether the slot can be selected. Defaults to `true`.
    public init(
        id: String = UUID().uuidString,
        time: String,
        isSelected: Bool = false,
        isAvailable: Bool = true
    ) {
        self.id = id
        self.time = time
        self.isSelected = isSelected
        self.isAvailable = isAvailable
    }
}
