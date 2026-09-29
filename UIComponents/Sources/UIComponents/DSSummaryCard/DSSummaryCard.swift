import SwiftUI

/// A modular summary card for presenting checkout, booking, or receipt
/// information.
///
/// `DSSummaryCard` provides a consistent card structure while allowing the
/// caller to supply custom content for the icon, header, and transaction
/// details.
///
/// The card is composed of four visual sections:
///
/// 1. An icon or thumbnail alongside the header content.
/// 2. A divider separating the header from the transactional details.
/// 3. A flexible details area for key-value rows or other summary content.
/// 4. A footer containing the total label and highlighted total price.
///
/// The component is intentionally content-agnostic. Consumers can decide how
/// the header and details are represented while the card maintains the
/// spacing, typography, colors, border, and surface tokens defined by the
/// Design System.
///
/// ## Example
///
/// ```swift
/// DSSummaryCard(
///     totalLabel: "Total no salão",
///     totalPrice: "R$ 35"
/// ) {
///     Image(systemName: "building.2.fill")
/// } headerContent: {
///     VStack(alignment: .leading) {
///         Text("Studio Ana Lima")
///             .font(.headline)
///
///         Text("R. Aurora, 120")
///             .font(.subheadline)
///     }
/// } detailsContent: {
///     VStack(spacing: 8) {
///         HStack {
///             Text("Quando")
///             Spacer()
///             Text("Hoje, 02/09")
///         }
///
///         HStack {
///             Text("Serviço")
///             Spacer()
///             Text("Mãos")
///         }
///     }
/// }
/// ```
///
/// ## Content slots
///
/// The component exposes three `@ViewBuilder` slots:
///
/// - `iconContent`: Content displayed inside the card's fixed-size icon area.
/// - `headerContent`: Content displayed alongside the icon, typically a title,
///   address, or other contextual information.
/// - `detailsContent`: Content displayed below the divider, typically as
///   key-value rows describing the transaction or booking.
///
/// The caller controls the semantic content and internal layout of these
/// slots. The card applies its own typography and foreground color to the
/// details container.
///
/// ## Total
///
/// `totalLabel` identifies what the final amount represents, while
/// `totalPrice` is displayed as the highlighted value in the card footer.
///
/// Both values are provided as strings so the component does not impose a
/// currency, locale, or number-formatting strategy on its consumers.
///
/// ## Accessibility
///
/// The card keeps its child views in a contained accessibility hierarchy,
/// allowing VoiceOver to navigate through the supplied icon, header, details,
/// and total content.
///
/// The icon slot is not automatically hidden from accessibility because the
/// caller may provide meaningful content. If the icon is purely decorative,
/// the caller should apply the appropriate accessibility modifier to the
/// supplied view.
///
/// ## Appearance
///
/// The card uses the Design System's light appearance and applies the
/// following visual characteristics:
///
/// - A `paper` surface.
/// - A `line` border.
/// - A large continuous corner radius.
/// - Design System spacing and typography tokens.
/// - A highlighted salon-card color for the total price.
///
/// The component explicitly uses the light color scheme so nested content
/// remains consistent with the Design System's light-only appearance.
///
/// - Note: `DSSummaryCard` does not perform currency or date formatting.
///   Format values before passing them to the component.
public struct DSSummaryCard<
    IconContent: View,
    HeaderContent: View,
    DetailsContent: View
>: View {

    /// The descriptive label displayed next to the total price.
    private let totalLabel: String

    /// The final amount displayed in the card footer.
    ///
    /// The value should already be formatted for presentation, for example
    /// `"R$ 35"` or `"R$ 35,50"`.
    private let totalPrice: String

    /// The content displayed inside the card's icon area.
    private let iconContent: IconContent

    /// The contextual content displayed next to the icon.
    private let headerContent: HeaderContent

    /// The transactional details displayed below the divider.
    private let detailsContent: DetailsContent

    /// Creates a summary card.
    ///
    /// - Parameters:
    ///   - totalLabel: The label describing the final amount.
    ///   - totalPrice: The already-formatted final amount.
    ///   - iconContent: Content displayed inside the fixed-size icon area.
    ///   - headerContent: Content displayed beside the icon, typically
    ///     containing a title and supporting information.
    ///   - detailsContent: Content displayed in the transaction details area,
    ///     typically as key-value rows.
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
        VStack(
            alignment: .leading,
            spacing: .zero
        ) {
            HStack(
                alignment: .center,
                spacing: DSPadding.medium
            ) {
                iconContent
                    .frame(
                        width: DSSize.huge,
                        height: DSSize.huge
                    )
                    .background(DSColor.surface)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: DSRadius.small,
                            style: .continuous
                        )
                    )

                headerContent
            }
            .padding(.bottom, DSPadding.regular)

            DSColor.line
                .frame(height: 1)
                .padding(.bottom, DSPadding.medium)

            detailsContent
                .font(DSFont.fieldLabel)
                .foregroundStyle(DSColor.ink60)
                .padding(.bottom, DSPadding.medium)

            HStack(alignment: .bottom) {
                Text(totalLabel)
                    .font(DSFont.fieldLabel)
                    .foregroundStyle(DSColor.ink60)

                Spacer()

                Text(totalPrice)
                    .font(DSFont.descriptionBold)
                    .foregroundStyle(DSColor.salonCardPrice)
            }
        }
        .padding(DSPadding.medium)
        .background(DSColor.paper)
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
                DSColor.line,
                lineWidth: DSBorder.thin
            )
        )
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }
}
