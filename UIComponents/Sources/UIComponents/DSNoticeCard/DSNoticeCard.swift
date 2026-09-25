import SwiftUI

// MARK: - DSNoticeCard

/// A card layout containing a header title followed by an ordered list of transactional guidelines,
/// warnings, or booking prerequisites with semantic icons.
///
/// It utilizes `Color.paper` as its inner surface container and `Color.line` for the subtle outer border.
///
/// ```swift
/// DSNoticeCard(
///     title: "Antes de continuar",
///     items: [
///         DSNoticeItem(systemIconName: "creditcard.fill", iconColor: .amber, title: "O pagamento é combinado..."),
///         DSNoticeItem(systemIconName: "clock.fill", iconColor: .contentTertiary, title: "Cancelamento gratuito...")
///     ]
/// )
/// ```
public struct DSNoticeCard: View {
    let title: String
    let items: [DSNoticeItem]
    let cornerRadius: CGFloat
    let padding: CGFloat
    let spacing: CGFloat
    
    /// Creates a `DSNoticeCard`.
    /// - Parameters:
    ///   - title: The header headline anchoring the warning section.
    ///   - items: The list array containing structural row tokens to parse.
    ///   - cornerRadius: Inner stroke clipping boundary (default 20 pt).
    ///   - padding: Internal perimeter margins (default 16 pt).
    ///   - spacing: Row stacking item intervals (default 14 pt).
    public init(
        title: String,
        items: [DSNoticeItem],
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 16,
        spacing: CGFloat = 14
    ) {
        self.title = title
        self.items = items
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.spacing = spacing
    }
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DSColor.ink)
            
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                ForEach(items) { item in
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        Image(systemName: item.systemIconName)
                            .font(DSFont.fieldLabel)
                            .foregroundColor(item.iconColor)
                            .frame(width: 18, height: 18, alignment: .center)
                        
                        Text(item.title)
                            .font(.subheadline)
                            .foregroundColor(DSColor.ink60)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(DSPadding.regular)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DSColor.paper)
        .clipShape(shape)
        .overlay(
            shape.strokeBorder(DSColor.line, lineWidth: 1)
        )
    }
}
