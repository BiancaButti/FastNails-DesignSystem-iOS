import SwiftUI

/// `DSEventCard` is a reusable UI component designed for the Design System.
/// It displays scheduling information including dates, times, pricing, and statuses.
///
/// ### Example Usage:
/// ```swift
/// DSEventCard(
///     day: "02",
///     month: "Sep",
///     startTime: "16:00",
///     endTime: "16:30",
///     title: "Studio Ana Lima",
///     serviceDetails: "Mãos · 30 min · no salão",
///     price: "R\$ 35",
///     status: DSStatusBadge(title: "Confirmado", status: .confirmed),
///     hasHighlightBorder: false
/// ) {
///     // Handle tap action here
/// }
/// ```
public struct DSEventCard: View {
    // MARK: - Properties
    
    /// The day of the month (e.g., "02", "04").
    private let day: String
    /// The abbreviated month text (e.g., "Sep", "Set").
    private let month: String
    /// The starting time of the appointment (e.g., "16:00").
    private let startTime: String
    /// The ending time of the appointment (e.g., "16:30").
    private let endTime: String
    /// The main title or venue name (e.g., "Studio Ana Lima").
    private let title: String
    /// Subtitle string detailing services, duration, and venue type.
    private let serviceDetails: String
    /// The formatted currency or price text (e.g., "R$ 35").
    private let price: String
    
    /// The ready-made status badge shown in the footer.
    private let status: DSStatusBadge
    /// Dictates whether an active/ongoing state outline border is rendered around the card.
    private let hasHighlightBorder: Bool
    
    /// Optional closure callback triggered when the user interacts with the card.
    private var onTap: (() -> Void)?

    // MARK: - Initializer
    
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

    // MARK: - Body
    
    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // MARK: Main Content Section
                HStack(alignment: .top, spacing: DSSpacing.lg) {

                    // Calendar Block (Month & Day)
                    VStack(spacing: DSSpacing.xs) {
                        Text(month.uppercased())
                            .font(DSFont.technicalTag)
                            .foregroundStyle(DSColor.ink60)
                        Text(day)
                            .font(DSFont.title)
                            .foregroundStyle(DSColor.ink)
                    }
                    .frame(width: 48, height: 48)
                    .background(hasHighlightBorder ? DSColor.eventHighlightSurface : DSColor.paper)
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                            .stroke(hasHighlightBorder ? DSColor.eventHighlightBorder : DSColor.line, lineWidth: 1)
                    )
                    
                    // Schedule Details and Pricing Area
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        HStack(alignment: .firstTextBaseline, spacing: DSSpacing.xs) {

                            // Time Framework and Location Title
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

                            // Pricing Data
                            Text(price)
                                .font(DSFont.numericValue)
                                .foregroundStyle(DSColor.salonCardPrice)
                        }

                        // Metadata string description
                        Text(serviceDetails)
                            .font(DSFont.inputSupport)
                            .foregroundStyle(DSColor.ink60)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding([.top, .horizontal], DSSpacing.lg)

                Divider()
                    .padding(.top, DSSpacing.lg)
                
                // MARK: Footer Section
                HStack {
                    // Ready-made status badge
                    status

                    Spacer()
                    
                    // Action navigation indicator
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DSColor.ink60)
                }
                .padding(.horizontal, DSSpacing.lg)
                .padding(.vertical, DSSpacing.md)
            }
            .background(hasHighlightBorder ? DSColor.eventHighlightSurface : DSColor.paper)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                    .stroke(
                        hasHighlightBorder ? DSColor.eventHighlightBorder : DSColor.line,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .environment(\.colorScheme, .light)
    }
}
