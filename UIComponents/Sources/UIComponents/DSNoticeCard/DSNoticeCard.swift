import SwiftUI

// MARK: - DSNoticeCard

/// A notice card that presents a title followed by an ordered list of informational items.
///
/// Use `DSNoticeCard` for transactional guidelines, warnings, booking prerequisites, or other contextual information.
/// Each item displays a semantic SF Symbol alongside its descriptive text.
///
/// ```swift
/// DSNoticeCard(
///     title: "Antes de continuar",
///     items: [
///         DSNoticeItem(
///             systemIconName: "creditcard.fill",
///             iconColor: DSColor.amber,
///             title: "O pagamento é combinado..."
///         ),
///         DSNoticeItem(
///             systemIconName: "clock.fill",
///             iconColor: DSColor.ink60,
///             title: "Cancelamento gratuito..."
///         )
///     ]
/// )
/// ```
public struct DSNoticeCard: View {
    /// The headline displayed at the top of the notice card.
    let title: String

    /// The ordered collection of informational items displayed below the title.
    let items: [DSNoticeItem]

    /// Creates a `DSNoticeCard`.
    /// - Parameters:
    ///   - title: The headline displayed at the top of the card.
    ///   - items: The ordered collection of informational items to display.
    public init(
        title: String,
        items: [DSNoticeItem]
    ) {
        self.title = title
        self.items = items
    }

    /// The rounded rectangle shape used for the card's clipping and border.
    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: DSRadius.xlarge,
            style: .continuous
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DSColor.ink)

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                ForEach(items) { item in
                    HStack(
                        alignment: .top,
                        spacing: DSSpacing.md
                    ) {
                        Image(systemName: item.systemIconName)
                            .font(DSFont.fieldLabel)
                            .foregroundColor(item.iconColor)
                            .frame(
                                width: DSSize.medium,
                                height: DSSize.medium,
                                alignment: .center
                            )

                        Text(item.title)
                            .font(.subheadline)
                            .foregroundColor(DSColor.ink60)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                }
            }
        }
        .padding(DSPadding.regular)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(DSColor.paper)
        .clipShape(shape)
        .overlay(
            shape.strokeBorder(
                DSColor.line,
                lineWidth: DSBorder.thin
            )
        )
    }
}
