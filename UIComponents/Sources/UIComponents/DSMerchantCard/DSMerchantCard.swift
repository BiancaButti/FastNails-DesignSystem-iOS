import SwiftUI

/// A highly flexible, decoupled card component designed for Design Systems.
///
/// `DSMerchantCard` acts as a purely visual container for merchants, salons, or products.
/// It delegates data modeling, image fetching, and tag rendering architectures to the client application
/// while natively handling a paginated horizontal photo carousel.
///
/// ### Usage Example (Single Image)
/// ```swift
/// DSMerchantCard(
///     title: "Espaço Camila",
///     subtitle: "A partir de R$ 45",
///     textPrice: "800 m"
/// ) {
///     Image("salon_cover").resizable().scaledToFill()
/// } tagsContent: {
///     Text("Espaço dela").font(.caption).background(Color.gray)
/// }
/// ```
///
/// ### Usage Example (Carousel Mode)
/// ```swift
/// DSMerchantCard(
///     title: "Studio Ana Lima",
///     subtitle: "A partir de R$ 35",
///     textPrice: "Available today",
///     isCarousel: true
/// ) {
///     Image("photo_1").resizable().scaledToFill()
///     Image("photo_2").resizable().scaledToFill()
///     Image("photo_3").resizable().scaledToFill()
/// } tagsContent: {
///     Text("Premium").font(.caption)
/// }
/// ```
public struct DSMerchantCard<HeaderContent: View, TagsContent: View>: View {
    private let title: String
    private let subtitle: String
    private let textPrice: String?
    private let headerContent: HeaderContent
    private let tagsContent: TagsContent
    private let isCarousel: Bool
    
    /// Initializes a new `DSMerchantCard`.
    ///
    /// - Parameters:
    ///   - title: The bold primary header text (capped to 1 line).
    ///   - subtitle: The secondary highlighted text (renders in branding pink color).
    ///   - textPrice: Optional tertiary label for auxiliary data (e.g., distance or dynamic availability).
    ///   - isCarousel: When `true`, embeds header elements into a horizontal `TabView` with page indicators. Default is `false`.
    ///   - headerContent: A `@ViewBuilder` closure supplying the card media layout (single image or multiple page elements).
    ///   - tagsContent: A `@ViewBuilder` closure injecting the local tag elements.
    public init(
        title: String,
        subtitle: String,
        textPrice: String? = nil,
        isCarousel: Bool = false,
        @ViewBuilder headerContent: () -> HeaderContent,
        @ViewBuilder tagsContent: () -> TagsContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.textPrice = textPrice
        self.isCarousel = isCarousel
        self.headerContent = headerContent()
        self.tagsContent = tagsContent()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Media Area: applies page style automatically if isCarousel is active
            Group {
                if isCarousel {
                    TabView {
                        headerContent
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                } else {
                    headerContent
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(Color(.systemGray6))
            .clipped()
            
            // Text Body
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.4))
                
                if let textPrice = textPrice {
                    Text(textPrice)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                tagsContent
                    .padding(.top, 6)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}
