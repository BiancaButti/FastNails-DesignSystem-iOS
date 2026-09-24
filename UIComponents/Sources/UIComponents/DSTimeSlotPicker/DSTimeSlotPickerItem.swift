import SwiftUI

/// Defines the state and visual content for a single time slot item.
public struct DSTimeSlotPickerItem: Identifiable {
    public let id: String
    public let time: String
    public let isSelected: Bool
    public let isAvailable: Bool
    
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
