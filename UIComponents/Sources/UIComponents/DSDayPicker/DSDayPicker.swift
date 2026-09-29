import SwiftUI

// MARK: - DSDayPicker

/// Displays a horizontal collection of selectable days.
///
/// Use `DSDayPicker` when users need to choose a day from a predefined set of options.
/// Selected days use a highlighted appearance, while full days remain visible but cannot be selected.
///
/// ```swift
/// DSDayPicker(
///     title: "Choose your day",
///     days: [
///         .init(
///             weekday: "Mon",
///             dayNumber: "12",
///             subtitle: "Available"
///         )
///     ]
/// ) { day in
///     selectDay(day)
/// }
/// ```
///
/// ## Accessibility
/// Full days are exposed as disabled controls and cannot trigger `onDaySelected`.
public struct DSDayPicker: View {

    /// Defines the content and selection state of an individual day.
    public struct DayItem: Identifiable {
        /// The unique identifier used to distinguish the day item.
        public let id: String

        /// The abbreviated or localized weekday displayed for the day.
        public let weekday: String

        /// The day number displayed as the main value.
        public let dayNumber: String

        /// The supporting text displayed below the day number.
        public let subtitle: String

        /// A Boolean value indicating whether the day is currently selected.
        public let isSelected: Bool

        /// A Boolean value indicating whether the day is fully booked and unavailable for selection.
        public let isFull: Bool

        /// Creates a `DayItem`.
        /// - Parameters:
        ///   - id: The unique identifier for the day. Defaults to a generated UUID string.
        ///   - weekday: The abbreviated or localized weekday displayed for the day.
        ///   - dayNumber: The day number displayed as the main value.
        ///   - subtitle: The supporting text displayed below the day number.
        ///   - isSelected: Whether the day is currently selected. Defaults to `false`.
        ///   - isFull: Whether the day is fully booked and unavailable for selection. Defaults to `false`.
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

    /// The title displayed above the day options.
    let title: String

    /// The days displayed as selectable options.
    let days: [DayItem]

    /// The closure executed when an available day is selected.
    let onDaySelected: (DayItem) -> Void

    /// Creates a `DSDayPicker`.
    /// - Parameters:
    ///   - title: The title displayed above the day options.
    ///   - days: The list of day items displayed by the picker.
    ///   - onDaySelected: The closure executed when an available day is selected.
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
            Text(title)
                .font(DSFont.sectionHeader)
                .foregroundColor(DSColor.ink)

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
                                .foregroundColor(
                                    day.isSelected
                                        ? DSColor.blush
                                        : DSColor.ink60
                                )

                            Text(day.dayNumber)
                                .font(DSFont.title)
                                .foregroundColor(
                                    day.isSelected
                                        ? DSColor.paper
                                        : DSColor.ink
                                )

                            Text(day.subtitle)
                                .font(DSFont.fieldLabel)
                                .foregroundColor(
                                    subtitleColor(for: day)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DSPadding.regular)
                        .background(
                            day.isSelected
                                ? DSColor.ink
                                : DSColor.paper
                        )
                        .cornerRadius(DSRadius.large)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: DSRadius.large
                            )
                            .stroke(
                                day.isSelected
                                    ? DSColor.clear
                                    : DSColor.line,
                                lineWidth: 1
                            )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(day.isFull)
                }
            }
        }
        .padding(DSPadding.mediumLarge)
        .background(DSColor.paper)
        .cornerRadius(DSRadius.xxlarge)
    }

    /// Resolves the subtitle color from the current day state.
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
