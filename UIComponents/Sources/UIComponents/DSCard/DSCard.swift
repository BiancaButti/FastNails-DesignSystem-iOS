import SwiftUI

// MARK: - DSCard

public struct DSCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @Environment(\.dsTheme) private var theme
    
    // Agora aceitamos uma Image genérica internamente
    private let image: Image?
    
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let padding: CGFloat
    let cornerRadius: CGFloat
    let background: Color?
    let borderColor: Color?
    let borderWidth: CGFloat
    let elevation: DSCardElevation

    /// Inicializador padrão (Designers/Devs passam a View Image montada)
    public init(
        image: Image? = nil,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = DSSpacing.lg,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        background: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.image = image
        self.alignment = alignment
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.elevation = elevation
        self.content = content
    }

    /// NOVO: Inicializador prático usando o nome de uma imagem local do Asset Catalog
    public init(
        assetName: String,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = DSSpacing.lg,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        background: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: Image(assetName),
            alignment: alignment,
            spacing: spacing,
            padding: padding,
            cornerRadius: cornerRadius,
            background: background,
            borderColor: borderColor,
            borderWidth: borderWidth,
            elevation: elevation,
            content: content
        )
    }

    /// NOVO: Inicializador prático usando um SF Symbol nativo da Apple
    public init(
        systemIconName: String,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = DSSpacing.lg,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        background: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: Image(systemName: systemIconName),
            alignment: alignment,
            spacing: spacing,
            padding: padding,
            cornerRadius: cornerRadius,
            background: background,
            borderColor: borderColor,
            borderWidth: borderWidth,
            elevation: elevation,
            content: content
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 56)
                    .frame(maxWidth: .infinity, alignment: .center) 
            }
            
            content()
        }
        .padding(DSPadding.mediumLarge)
        .frame(maxWidth: .infinity,
               alignment: Alignment(horizontal: alignment, vertical: .center))
        .background(background ?? theme.surfaceColor)
        .clipShape(shape)
        .overlay(
            Group {
                if let borderColor {
                    shape.strokeBorder(borderColor, lineWidth: borderWidth)
                }
            }
        )
        .shadow(
            color: .black.opacity(elevation.opacity),
            radius: elevation.radius,
            y: elevation.offsetY
        )
    }
}
