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
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            // Main component title
            Text(title)
                .font(DSFont.sectionHeader)
                .foregroundColor(DSColor.ink)
                
            // Scrollable or rigid horizontal row for days
            HStack(spacing: DSSpacing.md) {
                ForEach(days) { day in
                    Button {
                        if !day.isFull {
                            onDaySelected(day)
                        }
                    } label: {
                        VStack(spacing: DSSpacing.sm) {
                            Text(day.weekday.uppercased())
                                .font(DSFont.fieldLabel)
                                .foregroundColor(day.isSelected ? DSColor.blush : DSColor.ink60)
                            
                            Text(day.dayNumber)
                                .font(DSFont.title)
                                .foregroundColor(day.isSelected ? DSColor.paper : DSColor.ink)
                            
                            Text(day.subtitle)
                                .font(DSFont.fieldLabel)
                                .foregroundColor(subtitleColor(for: day))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DSPadding.regular)
                        .background(day.isSelected ? DSColor.ink : DSColor.paper)
                        .cornerRadius(DSRadius.large)
                        .overlay(
                            RoundedRectangle(cornerRadius: DSRadius.large)
                                .stroke(day.isSelected ? DSColor.clear : DSColor.line, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(day.isFull) // Disables interaction if the day is booked out
                }
            }
        }
        .padding(DSPadding.mediumLarge)
        .background(DSColor.paper)
        .cornerRadius(DSRadius.xxlarge)
    }
    
    /// Helper to map subtitles to the appropriate token color based on internal state.
    private func subtitleColor(for day: DayItem) -> Color {
        if day.isSelected {
            return DSColor.blush
        } else if day.isFull {
            return DSColor.ink60
        } else {
            return DSColor.confirmed 
        }
    }
}
