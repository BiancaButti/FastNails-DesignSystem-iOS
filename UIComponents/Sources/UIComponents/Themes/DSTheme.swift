import SwiftUI



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
///     .dsTheme(DSTheme(brandColor: .confirmed))   // só para experimentar
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
        successColor: Color = .confirmed,
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
