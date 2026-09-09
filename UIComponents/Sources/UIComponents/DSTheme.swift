import SwiftUI

// MARK: - DSSpacing

/// Escala de espaçamento.
///
/// Use sempre estes valores em vez de números soltos: ajuste global vira
/// uma linha, e o espaçamento fica consistente entre telas.
///
/// ```swift
/// .padding(DSSpacing.md)
/// VStack(spacing: DSSpacing.sm) { ... }
/// ```
public enum DSSpacing {
    /// 4 pt — entre ícone e texto.
    public static let xs: CGFloat = 4
    /// 8 pt — entre elementos relacionados.
    public static let sm: CGFloat = 8
    /// 12 pt — dentro de campos e células.
    public static let md: CGFloat = 12
    /// 16 pt — margem lateral padrão das telas.
    public static let lg: CGFloat = 16
    /// 24 pt — dentro de cartões, entre blocos.
    public static let xl: CGFloat = 24
    /// 32 pt — separação entre seções.
    public static let xxl: CGFloat = 32
}

// MARK: - DSRadius

/// Escala de arredondamento.
///
/// Os quatro valores da documentação, nomeados pelo uso e não pelo tamanho.
public enum DSRadius {
    /// 999 pt — pílula. Chips, etiquetas, seletores.
    public static let pilula: CGFloat = 999
    /// 12 pt — controle. Botões e campos.
    public static let controle: CGFloat = 12
    /// 14 pt — superfície. Cartões e blocos.
    public static let superficie: CGFloat = 14
    /// 20 pt — topo da folha modal.
    public static let folha: CGFloat = 20

    // Nomes antigos
    @available(*, deprecated, renamed: "controle") public static let sm: CGFloat = 6
    @available(*, deprecated, renamed: "controle") public static let md: CGFloat = 10
    @available(*, deprecated, renamed: "controle") public static let lg: CGFloat = 12
    @available(*, deprecated, renamed: "superficie") public static let xl: CGFloat = 16
    @available(*, deprecated, renamed: "folha") public static let xxl: CGFloat = 20
}

// MARK: - DSTheme

/// Tokens visuais do design system.
///
/// **Sem variação de modo escuro.** O app tem uma aparência só.
///
/// A injeção pelo ambiente continua existindo, mas hoje serve para prévia e
/// teste — não para tema alternativo:
///
/// ```swift
/// ComponenteView()
///     .dsTheme(DSTheme(brandColor: .agua))   // só para experimentar
/// ```
public struct DSTheme: Equatable {

    // MARK: Cores

    /// A única cor de ação: botão principal, link, seleção. Padrão: Esmalte.
    public var brandColor: Color
    /// Erro e ação destrutiva. Padrão: Alerta.
    public var errorColor: Color
    /// Confirmado, disponível. Padrão: Água.
    public var successColor: Color
    /// Atenção sem erro. Padrão: Âmbar.
    public var warningColor: Color
    /// Fundo de cartão e campo. Padrão: branco.
    public var surfaceColor: Color
    /// Fundo da tela. Padrão: Papel.
    public var backgroundColor: Color
    /// Texto principal. Padrão: Tinta.
    public var titleColor: Color
    /// Texto secundário. Padrão: Tinta 60.
    public var secondaryColor: Color
    /// Bordas e divisórias. Padrão: Linha.
    public var borderColor: Color

    // MARK: Tipografia

    /// Título de tela.
    public var titleFont: Font
    /// Cabeçalho de seção.
    public var sectionFont: Font
    /// Texto padrão.
    public var bodyFont: Font
    /// Rótulo de campo e texto secundário.
    public var labelFont: Font
    /// Explicação e mensagem de erro.
    public var feedbackFont: Font
    /// Botão principal.
    public var buttonFont: Font
    /// Metadado e legenda.
    public var captionFont: Font
    /// Etiqueta de status dentro de cartão.
    public var badgeFont: Font
    /// Preço, horário, contagem.
    public var numberFont: Font

    public init(
        brandColor: Color = .esmalte,
        errorColor: Color = .alerta,
        successColor: Color = .agua,
        warningColor: Color = .ambar,
        surfaceColor: Color = .dsSurface,
        backgroundColor: Color = .papel,
        titleColor: Color = .tinta,
        secondaryColor: Color = .tinta60,
        borderColor: Color = .linha,
        titleFont: Font = DSFont.titulo,
        sectionFont: Font = DSFont.secao,
        bodyFont: Font = DSFont.corpo,
        labelFont: Font = DSFont.rotulo,
        feedbackFont: Font = DSFont.apoio,
        buttonFont: Font = DSFont.botao,
        captionFont: Font = DSFont.legenda,
        badgeFont: Font = DSFont.selo,
        numberFont: Font = DSFont.numero
    ) {
        self.brandColor = brandColor
        self.errorColor = errorColor
        self.successColor = successColor
        self.warningColor = warningColor
        self.surfaceColor = surfaceColor
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.secondaryColor = secondaryColor
        self.borderColor = borderColor
        self.titleFont = titleFont
        self.sectionFont = sectionFont
        self.bodyFont = bodyFont
        self.labelFont = labelFont
        self.feedbackFont = feedbackFont
        self.buttonFont = buttonFont
        self.captionFont = captionFont
        self.badgeFont = badgeFont
        self.numberFont = numberFont
    }

    /// Tema do Fast Nails.
    public static let `default` = DSTheme()
}

// MARK: - Ambiente

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue = DSTheme.default
}

public extension EnvironmentValues {
    /// Tema ativo na hierarquia de views.
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

public extension View {
    /// Injeta um tema na subárvore desta view.
    func dsTheme(_ theme: DSTheme) -> some View {
        environment(\.dsTheme, theme)
    }
}
