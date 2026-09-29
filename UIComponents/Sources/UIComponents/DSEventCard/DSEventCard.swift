import SwiftUI

// MARK: - DSEventCard

/// Displays appointment information in a compact, interactive card.
///
/// Use `DSEventCard` to present an event's date, schedule, service details, price, and status in a single tappable container.
/// The card can optionally highlight the event with a distinct border and background treatment.
///
/// ```swift
/// DSEventCard(
///     day: "02",
///     month: "Sep",
///     startTime: "16:00",
///     endTime: "16:30",
///     title: "Studio Ana Lima",
///     serviceDetails: "Mãos · 30 min · no salão",
///     price: "R$ 35",
///     status: DSStatusBadge(
///         title: "Confirmado",
///         status: .confirmed
///     ),
///     hasHighlightBorder: false
/// ) {
///     openEvent()
/// }
/// ```
///
/// ## Accessibility
/// The entire card is exposed as a single button and activates `onTap` when selected.
public struct DSEventCard: View {
    /// The day of the month displayed in the calendar block.
    private let day: String

    /// The abbreviated month displayed above the day number.
    private let month: String

    /// The starting time of the event.
    private let startTime: String

    /// The ending time of the event.
    private let endTime: String

    /// The main title or venue name associated with the event.
    private let title: String

    /// The descriptive metadata containing service, duration, and venue information.
    private let serviceDetails: String

    /// The formatted price displayed in the event details.
    private let price: String

    /// The status badge displayed in the card footer.
    private let status: DSStatusBadge

    /// A Boolean value indicating whether the card uses its highlighted border and background treatment.
    private let hasHighlightBorder: Bool

    /// An optional closure executed when the card is tapped.
    private var onTap: (() -> Void)?

    /// Creates a `DSEventCard`.
    /// - Parameters:
    ///   - day: The day of the month displayed in the calendar block.
    ///   - month: The abbreviated month displayed above the day number.
    ///   - startTime: The starting time of the event.
    ///   - endTime: The ending time of the event.
    ///   - title: The main title or venue name associated with the event.
    ///   - serviceDetails: The descriptive metadata containing service, duration, and venue information.
    ///   - price: The formatted price displayed in the event details.
    ///   - status: The status badge displayed in the card footer.
    ///   - hasHighlightBorder: Whether the card uses its highlighted border and background treatment.
    ///   - onTap: An optional closure executed when the card is tapped. Defaults to `nil`.
    public init(
        day: String,
        month: String,
        startTime: String,
        endTime: String,
        title: String,
        serviceDetails: String,
        price: String,
        status: DSStatusBadge,
        hasHighlightBorder: Bool,
        onTap: (() -> Void)? = nil
    ) {
        self.day = day
        self.month = month
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.serviceDetails = serviceDetails
        self.price = price
        self.status = status
        self.hasHighlightBorder = hasHighlightBorder
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .top, spacing: DSSpacing.lg) {
                    VStack(spacing: DSSpacing.xs) {
                        Text(month.uppercased())
                            .font(DSFont.technicalTag)
                            .foregroundStyle(DSColor.ink60)

                        Text(day)
                            .font(DSFont.title)
                            .foregroundStyle(DSColor.ink)
                    }
                    .frame(
                        width: DSSize.huge,
                        height: DSSize.huge
                    )
                    .background(
                        hasHighlightBorder
                            ? DSColor.eventHighlightSurface
                            : DSColor.paper
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: DSRadius.small,
                            style: .continuous
                        )
                        .stroke(
                            hasHighlightBorder
                                ? DSColor.eventHighlightBorder
                                : DSColor.line,
                            lineWidth: 1
                        )
                    )

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        HStack(
                            alignment: .firstTextBaseline,
                            spacing: DSSpacing.xs
                        ) {
                            Group {
                                Text("\(startTime) às \(endTime) ")
                                    .font(DSFont.descriptionBold)
                                    .foregroundColor(DSColor.ink) +
                                Text(title)
                                    .font(DSFont.fieldLabel)
                                    .foregroundColor(DSColor.ink60)
                            }
                            .multilineTextAlignment(.leading)

                            Spacer()

                            Text(price)
                                .font(DSFont.numericValue)
                                .foregroundStyle(DSColor.salonCardPrice)
                        }

                        Text(serviceDetails)
                            .font(DSFont.inputSupport)
                            .foregroundStyle(DSColor.ink60)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding([.top, .horizontal], DSPadding.regular)

                Divider()
                    .padding(.top, DSPadding.regular)

                HStack {
                    status

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(DSFont.captionSemibold)
                        .foregroundStyle(DSColor.ink60)
                }
                .padding(.horizontal, DSPadding.regular)
                .padding(.vertical, DSPadding.medium)
            }
            .background(
                hasHighlightBorder
                    ? DSColor.eventHighlightSurface
                    : DSColor.paper
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.large,
                    style: .continuous
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: DSRadius.large,
                    style: .continuous
                )
                .stroke(
                    hasHighlightBorder
                        ? DSColor.eventHighlightBorder
                        : DSColor.line,
                    lineWidth: 1
                )
            )
        }
        .buttonStyle(.plain)
        .environment(\.colorScheme, .light)
    }
}
