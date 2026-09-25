import SwiftUI

/// A generic price receipt card component for the Fast Nails Design System.
public struct DSPriceReceiptCard: View {
    private let sectionTitle: String
    private let items: [(title: String, price: String)]
    private let totalTitle: String
    private let totalValue: String
    private let totalColor: Color

    /// Public initializer to allow usage outside of the SPM package module.
    /// - Parameters:
    ///   - sectionTitle: The descriptive label text above the card (e.g., "O QUE").
    ///   - items: A list of tuples containing the service title and its pre-formatted price string.
    ///   - totalTitle: The text display for the final line (Default: "Total").
    ///   - totalValue: The pre-formatted total value string passed by the host app.
    ///   - totalColor: The design system token color for the final price value (Default: `DSColor.enamel`).
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
            
            // Inner Card Structure
            VStack(spacing: 0) {
                // Dynamic Items List
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

                // Central Divider Line
                Divider()
                    .background(DSColor.divider)
                    .padding(.bottom, DSPadding.regular)
                
                // Final Total Row
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
