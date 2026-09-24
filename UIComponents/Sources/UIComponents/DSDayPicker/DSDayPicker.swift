import SwiftUI

/// A horizontal date selection component for the Fast Nails Design System.
public struct DSDayPicker: View {
    
    /// Defines the state and visual content for a single day item.
    public struct DayItem: Identifiable {
        public let id: String
        public let weekday: String
        public let dayNumber: String
        public let subtitle: String
        public let isSelected: Bool
        public let isFull: Bool
        
        public init(
            id: String = UUID().uuidString,
            weekday: String,
            dayNumber: String,
            subtitle: String,
            isSelected: Bool = false,
            isFull: Bool = false
        ) {
            self.id = id
            self.weekday = weekday
            self.dayNumber = dayNumber
            self.subtitle = subtitle
            self.isSelected = isSelected
            self.isFull = isFull
        }
    }
    
    let title: String
    let days: [DayItem]
    let onDaySelected: (DayItem) -> Void 

    
    /// Public initializer structured for the SPM package.
    /// - Parameters:
    ///   - title: The main header text (e.g., "Escolha seu dia").
    ///   - days: The list of `DayItem` objects to render horizontally.
    ///   - onDaySelected: Closure executed when a non-full day card is tapped.
    public init(
        title: String,
        days: [DayItem],
        onDaySelected: @escaping (DayItem) -> Void
    ) {
        self.title = title
        self.days = days
        self.onDaySelected = onDaySelected
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Main component title
            Text(title)
                .font(DSFont.sectionHeader)
                .foregroundColor(.ink)
                
            // Scrollable or rigid horizontal row for days
            HStack(spacing: 12) {
                ForEach(days) { day in
                    Button {
                        if !day.isFull {
                            onDaySelected(day)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Text(day.weekday.uppercased())
                                .font(DSFont.fieldLabel)
                                .foregroundColor(day.isSelected ? .blush : .ink60)
                            
                            Text(day.dayNumber)
                                .font(DSFont.title)
                                .foregroundColor(day.isSelected ? .paper : .ink)
                            
                            Text(day.subtitle)
                                .font(DSFont.fieldLabel)
                                .foregroundColor(subtitleColor(for: day))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(day.isSelected ? Color.ink : Color.paper)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(day.isSelected ? Color.clear : Color.line, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(day.isFull) // Disables interaction if the day is booked out
                }
            }
        }
        .padding(20)
        .background(Color.paper)
        .cornerRadius(20)
    }
    
    /// Helper to map subtitles to the appropriate token color based on internal state.
    private func subtitleColor(for day: DayItem) -> Color {
        if day.isSelected {
            return .blush
        } else if day.isFull {
            return .ink60
        } else {
            return .confirmed // Matches the teal/green indicator color for available spots
        }
    }
}
