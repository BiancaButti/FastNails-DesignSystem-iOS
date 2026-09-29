import SwiftUI

/// A generic price receipt card component for the Fast Nails Design System.
///
/// `DSPriceReceiptCard` presents a list of line items followed by a visually
/// emphasized total row. The component expects prices to be pre-formatted by
/// the consuming application.
public struct DSPriceReceiptCard: View {

    /// The section label displayed above the receipt card.
    private let sectionTitle: String

    /// The receipt line items displayed between the section header and total.
    ///
    /// Each tuple contains the service or item title and its pre-formatted
    /// price string.
    private let items: [(title: String, price: String)]

    /// The label displayed alongside the final total value.
    private let totalTitle: String

    /// The pre-formatted value displayed as the final total.
    private let totalValue: String

    /// The color applied to the final total value.
    private let totalColor: Color

    /// Creates a price receipt card.
    ///
    /// - Parameters:
    ///   - sectionTitle: The descriptive label displayed above the receipt card.
    ///   - items: The collection of receipt line items. Each item contains a
    ///     display title and a pre-formatted price string. Item titles must be
    ///     unique because they are used as the `ForEach` identifier.
    ///   - totalTitle: The label displayed for the final total row.
    ///   - totalValue: The pre-formatted value displayed for the final total.
    ///   - totalColor: The design system color applied to the total value.
    ///     Defaults to `DSColor.enamel`.
    public init(
        sectionTitle: String,
        items: [(title: String, price: String)],
        totalTitle: String,
        totalValue: String,
        totalColor: Color = DSColor.enamel
    ) {
        self.sectionTitle = sectionTitle
        self.items = items
        self.totalTitle = totalTitle
        self.totalValue = totalValue
        self.totalColor = totalColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Section header label
            Text(sectionTitle.uppercased())
                .font(DSFont.captionSemibold)
                .foregroundColor(DSColor.ink60)
                .padding(.leading, DSPadding.small)

            // Receipt content container
            VStack(spacing: 0) {

                // Receipt line items
                VStack(spacing: 16) {
                    ForEach(items, id: \.title) { item in
                        HStack {
                            Text(item.title)
                                .font(DSFont.description)
                                .foregroundColor(DSColor.text)

                            Spacer()

                            Text(item.price)
                                .font(DSFont.description)
                                .foregroundColor(DSColor.ink60)
                        }
                    }
                }
                .padding(.bottom, DSPadding.regular)

                // Divider separating line items from the total
                Divider()
                    .background(DSColor.divider)
                    .padding(.bottom, DSPadding.regular)

                // Final total row
                HStack {
                    Text(totalTitle)
                        .font(DSFont.descriptionBold)
                        .foregroundColor(DSColor.ink)

                    Spacer()

                    Text(totalValue)
                        .font(DSFont.descriptionBold)
                        .foregroundColor(totalColor)
                }
            }
            .padding(DSPadding.mediumLarge)
            .background(DSColor.paper)
            .cornerRadius(DSRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.large)
                    .stroke(DSColor.line, lineWidth: 1)
            )
        }
    }
}
