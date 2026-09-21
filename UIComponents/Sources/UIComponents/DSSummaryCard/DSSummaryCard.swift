import SwiftUI

/// A modular summary card component used to display checkout details, bookings, or receipts.
///
/// `DSSummaryCard` features a dedicated top slot for metadata/addresses and a flexible layout
/// container for listing transactional key-value pairs (e.g., date, services, professionals).
///
/// ### Usage Example
/// ```swift
/// DSSummaryCard(
///     totalLabel: "Total no salão",
///     totalPrice: "R$ 35"
/// ) {
///     Image(systemName: "building.2.fill")
/// } headerContent: {
///     VStack(alignment: .leading) {
///         Text("Studio Ana Lima").font(.headline)
///         Text("R. Aurora, 120").font(.subheadline)
///     }
/// } detailsContent: {
///     VStack(spacing: 8) {
///         HStack { Text("Quando"); Spacer(); Text("Hoje, 02/09") }
///         HStack { Text("Serviço"); Spacer(); Text("Mãos") }
///     }
/// }
/// ```
public struct DSSummaryCard<IconContent: View, HeaderContent: View, DetailsContent: View>: View {
    private let totalLabel: String
    private let totalPrice: String
    private let iconContent: IconContent
    private let headerContent: HeaderContent
    private let detailsContent: DetailsContent
    
    /// Initializes a new `DSSummaryCard`.
    /// - Parameters:
    ///   - totalLabel: The footer descriptor string (e.g., "Total no atendimento" or "Total no salão").
    ///   - totalPrice: The highlighted final cost string.
    ///   - iconContent: A `@ViewBuilder` slot for an asset or system icon inside the rounded thumb.
    ///   - headerContent: A `@ViewBuilder` slot for flexible title and address texts.
    ///   - detailsContent: A `@ViewBuilder` slot to receive clean key-value grid or rows.
    public init(
        totalLabel: String,
        totalPrice: String,
        @ViewBuilder iconContent: () -> IconContent,
        @ViewBuilder headerContent: () -> HeaderContent,
        @ViewBuilder detailsContent: () -> DetailsContent
    ) {
        self.totalLabel = totalLabel
        self.totalPrice = totalPrice
        self.iconContent = iconContent()
        self.headerContent = headerContent()
        self.detailsContent = detailsContent()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                iconContent
                    .frame(width: 44, height: 44)
                    .background(Color.surface)
                    .cornerRadius(10)
                
                headerContent
            }
            .padding(.bottom, 16)
            
            Color.line
                .frame(height: 1)
                .padding(.bottom, 14)
            
            detailsContent
                .font(.system(size: 14))
                .foregroundColor(Color.ink60)
                .padding(.bottom, 14)
            
            HStack(alignment: .bottom) {
                Text(totalLabel)
                    .font(.system(size: 14))
                    .foregroundColor(Color.ink60)
                
                Spacer()
                
                Text(totalPrice)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.salonCardPrice)
            }
        }
        .padding(16)
        .background(Color.paper)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.line, lineWidth: 1)
        )
    }
}
