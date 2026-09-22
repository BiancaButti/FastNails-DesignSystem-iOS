import SwiftUI

/// A grid-based time slot selection component for the Fast Nails Design System.
public struct DSTimeSlotPicker: View {
    
    /// Defines the state and visual content for a single time slot item.
    public struct TimeSlotItem: Identifiable {
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
    
    private let sectionTitle: String
    private let slots: [TimeSlotItem]
    let onSlotSelected: (TimeSlotItem) -> Void
    
    // Defines a clean 3-column grid layout where columns scale equally
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    /// Public initializer structured for the SPM package.
    /// - Parameters:
    ///   - sectionTitle: The descriptive category text above the grid (e.g., "TARDE").
    ///   - slots: The list of `TimeSlotItem` objects to render inside the grid.
    ///   - onSlotSelected: Closure executed when an available time slot is tapped.
    public init(
        sectionTitle: String,
        slots: [TimeSlotItem],
        onSlotSelected: @escaping (TimeSlotItem) -> Void
    ) {
        self.sectionTitle = sectionTitle
        self.slots = slots
        self.onSlotSelected = onSlotSelected
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section categorization title (e.g., TARDE)
            Text(sectionTitle.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.ink60)
                .padding(.leading, 4)
            
            // Time Slots Adaptive Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(slots) { slot in
                    Button {
                        if slot.isAvailable {
                            onSlotSelected(slot)
                        }
                    } label: {
                        Text(slot.time)
                            .font(.system(size: 15, weight: slot.isSelected ? .bold : .regular))
                            .foregroundColor(textColor(for: slot))
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(backgroundColor(for: slot))
                            .cornerRadius(12)
                            .overlay(
                                borderView(for: slot)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!slot.isAvailable)
                }
            }
        }
        .padding(20)
        .background(Color.paper)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.line, lineWidth: 1)
        )
    }
    
    // MARK: - UI Helper Style Mappings
    
    private func textColor(for slot: TimeSlotItem) -> Color {
        if !slot.isAvailable {
            return .line // Faded out text color for disabled slots
        } else if slot.isSelected {
            return .paper // Crisp text color over deep background
        } else {
            return .ink // Standard text color
        }
    }
    
    private func backgroundColor(for slot: TimeSlotItem) -> Color {
        if !slot.isAvailable {
            return .paper2 // Matches the grayish-pink tint background for unavailable items
        } else if slot.isSelected {
            return .ink // Filled selection color matching prior picker behavior
        } else {
            return .paper // Standard flat background resting inside the card
        }
    }
    
    @ViewBuilder
    private func borderView(for slot: TimeSlotItem) -> some View {
        if slot.isAvailable && !slot.isSelected {
            // Outlined gray border for untouched available slots
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.line, lineWidth: 1)
        } else if !slot.isAvailable {
            // Strikethrough line overlay to match the image requirement for locked hours
            LineStrikethrough()
                .stroke(Color.line, lineWidth: 1)
                .padding(.horizontal, 16)
        } else {
            EmptyView()
        }
    }
}

/// Custom shape to draw a neat diagonal strikethrough over unavailable slots.
struct LineStrikethrough: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
