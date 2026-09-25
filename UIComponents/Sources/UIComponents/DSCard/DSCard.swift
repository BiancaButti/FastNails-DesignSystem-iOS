import SwiftUI

// MARK: - DSCard

public struct DSCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @Environment(\.dsTheme) private var theme
    
    // Agora aceitamos uma Image genérica internamente
    private let image: Image?
    
    let alignment: HorizontalAlignment
    let background: Color?
    let borderColor: Color?
    let elevation: DSCardElevation

    /// Inicializador padrão (Designers/Devs passam a View Image montada)
    public init(
        image: Image? = nil,
        alignment: HorizontalAlignment = .center,
        background: Color? = nil,
        borderColor: Color? = nil,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.image = image
        self.alignment = alignment
        self.background = background
        self.borderColor = borderColor
        self.elevation = elevation
        self.content = content
    }

    /// NOVO: Inicializador prático usando o nome de uma imagem local do Asset Catalog
    public init(
        assetName: String,
        alignment: HorizontalAlignment = .center,
        background: Color? = nil,
        borderColor: Color? = nil,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: Image(assetName),
            alignment: alignment,
            borderColor: borderColor,
            elevation: elevation,
            content: content
        )
    }

    /// NOVO: Inicializador prático usando um SF Symbol nativo da Apple
    public init(
        systemIconName: String,
        alignment: HorizontalAlignment = .center,
        background: Color? = nil,
        borderColor: Color? = nil,
        elevation: DSCardElevation = .raised,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: Image(systemName: systemIconName),
            alignment: alignment,
            background: background,
            borderColor: borderColor,
            elevation: elevation,
            content: content
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DSRadius.mediumHuge, style: .continuous)
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: DSSpacing.lg) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: DSSize.jumbo)
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
                    shape.strokeBorder(borderColor,
                                       lineWidth: DSBorder.thin)
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
