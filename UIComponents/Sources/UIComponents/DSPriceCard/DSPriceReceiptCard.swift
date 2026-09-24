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
    ///   - totalColor: The design system token color for the final price value (Default: `.enamel`).
    public init(
        sectionTitle: String,
        items: [(title: String, price: String)],
        totalTitle: String,
        totalValue: String,
        totalColor: Color = .enamel
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
                .foregroundColor(.ink60)
                .padding(.leading, 8)
            
            // Inner Card Structure
            VStack(spacing: 0) {
                // Dynamic Items List
                VStack(spacing: 16) {
                    ForEach(0..<items.count, id: \.self) { index in
                        let item = items[index]
                        HStack {
                            Text(item.title)
                                .font(.system(size: 14))
                                .foregroundColor(.text)
                            Spacer()
                            Text(item.price)
                                .font(.system(size: 14))
                                .foregroundColor(.ink60)
                        }
                    }
                }
                .padding(.bottom, 16)

                
                // Central Divider Line
                Divider()
                    .background(Color.divider)
                    .padding(.bottom, 16)
                
                // Final Total Row
                HStack {
                    Text(totalTitle)
                        .font(DSFont.descriptionBold)
                        .foregroundColor(.ink)
                    Spacer()
                    Text(totalValue)
                        .font(DSFont.descriptionBold)
                        .foregroundColor(totalColor)
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
    }
}
