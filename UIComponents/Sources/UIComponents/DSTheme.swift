import SwiftUI

// MARK: - DSSpacing

/// Escala global de espaçamento do design system.
///
/// Use sempre estes valores em vez de literais numéricos para garantir
/// consistência visual e facilitar ajustes globais.
///
/// ```swift
/// .padding(DSSpacing.md)
/// .padding(.horizontal, DSSpacing.lg)
/// VStack(spacing: DSSpacing.sm) { ... }
/// ```
public enum DSSpacing {
    /// 4 pt — espaçamento extra-pequeno (ex.: entre ícone e texto).
    public static let xs: CGFloat = 4
    /// 8 pt — espaçamento pequeno (ex.: entre elementos relacionados).
    public static let sm: CGFloat = 8
    /// 12 pt — espaçamento médio-pequeno (ex.: padding interno de campos).
    public static let md: CGFloat = 12
    /// 16 pt — espaçamento médio (ex.: padding de seção).
    public static let lg: CGFloat = 16
    /// 24 pt — espaçamento grande (ex.: padding de card ou tela).
    public static let xl: CGFloat = 24
    /// 32 pt — espaçamento extra-grande (ex.: separação entre blocos de conteúdo).
    public static let xxl: CGFloat = 32
}

// MARK: - DSRadius

/// Escala global de border-radius do design system.
///
/// ```swift
/// .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
/// ```
public enum DSRadius {
    /// 6 pt — arredondamento sutil (ex.: tag pequena).
    public static let sm: CGFloat = 6
    /// 10 pt — arredondamento padrão de campos de texto.
    public static let md: CGFloat = 10
    /// 12 pt — arredondamento de botões e cards.
    public static let lg: CGFloat = 12
    /// 16 pt — arredondamento pronunciado (ex.: sheet, modal).
    public static let xl: CGFloat = 16
    /// 20 pt — arredondamento extra (ex.: container de catálogo).
    public static let xxl: CGFloat = 20
}

// MARK: - DSTheme

/// Tokens visuais configuráveis do design system.
///
/// Injete um tema customizado via `.dsTheme(_:)` para sobrescrever
/// as cores e fontes em toda a subárvore de views.
///
/// ```swift
/// // Uso padrão — tema FastNails
/// ContentView()
///
/// // Tema customizado para whitelabel
/// ContentView()
///     .dsTheme(DSTheme(brandColor: .blue, errorColor: .red, successColor: .green))
/// ```
///
/// - SeeAlso: `View.dsTheme(_:)`, `EnvironmentValues.dsTheme`
@available(macOS 11.0, iOS 14.0, *)
public struct DSTheme: Equatable {
    /// Cor primária de marca (botões, destaques, cursor OTP). Padrão: `.appPink`.
    public var brandColor: Color
    /// Cor de erro/falha (bordas, ícones, labels de erro). Padrão: `.colorDestructive`.
    public var errorColor: Color
    /// Cor de sucesso (bordas, ícones, labels de sucesso). Padrão: `.colorSuccess`.
    public var successColor: Color
    /// Cor usada em avaliações e senha média. Padrão: `.appRating`.
    public var ratingColor: Color

    /// Escala tipográfica: rótulos de campo e textos secundários.
    public var labelFont: Font
    /// Escala tipográfica: textos de feedback (erro/sucesso).
    public var feedbackFont: Font
    /// Escala tipográfica: botão primário.
    public var buttonFont: Font
    /// Escala tipográfica: textos de legenda, avaliações e metadados.
    public var captionFont: Font
    /// Escala tipográfica: badge de status (ex.: Aberto / Fechado).
    public var badgeFont: Font

    /// Cria um `DSTheme`.
    /// - Parameters:
    ///   - brandColor: Cor primária (padrão `.appPink` quando `nil`).
    ///   - errorColor: Cor de erro (padrão `.colorDestructive` quando `nil`).
    ///   - successColor: Cor de sucesso (padrão `.colorSuccess` quando `nil`).
    ///   - ratingColor: Cor de avaliação (padrão `.appRating` quando `nil`).
    ///   - labelFont: Fonte de rótulo (padrão `.subheadline.weight(.medium)`).
    ///   - feedbackFont: Fonte de feedback (padrão `.caption`).
    ///   - buttonFont: Fonte do botão (padrão `.body.weight(.semibold)`).
    ///   - captionFont: Fonte de legenda/avaliação (padrão `.caption2`).
    ///   - badgeFont: Fonte do badge de status (padrão `.caption2.weight(.semibold)`).
    public init(
        brandColor: Color? = nil,
        errorColor: Color? = nil,
        successColor: Color? = nil,
        ratingColor: Color? = nil,
        labelFont: Font = .subheadline.weight(.medium),
        feedbackFont: Font = .caption,
        buttonFont: Font = .body.weight(.semibold),
        captionFont: Font = .caption2,
        badgeFont: Font = .caption2.weight(.semibold)
    ) {
        self.brandColor = brandColor ?? Color.appPink
        self.errorColor = errorColor ?? Color.colorDestructive
        self.successColor = successColor ?? Color.colorSuccess
        self.ratingColor = ratingColor ?? Color.appRating
        self.labelFont = labelFont
        self.feedbackFont = feedbackFont
        self.buttonFont = buttonFont
        self.captionFont = captionFont
        self.badgeFont = badgeFont
    }

    /// Tema padrão FastNails.
    public static let `default` = DSTheme()
}

// MARK: - EnvironmentKey

@available(macOS 11.0, iOS 14.0, *)
private struct DSThemeKey: EnvironmentKey {
    static let defaultValue = DSTheme.default
}

@available(macOS 11.0, iOS 14.0, *)
public extension EnvironmentValues {
    /// Tema ativo do design system na hierarquia de views.
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

// MARK: - View modifier

@available(macOS 11.0, iOS 14.0, *)
public extension View {
    /// Injeta um `DSTheme` customizado em toda a subárvore desta view.
    ///
    /// ```swift
    /// MyApp()
    ///     .dsTheme(DSTheme(brandColor: .indigo))
    /// ```
    func dsTheme(_ theme: DSTheme) -> some View {
        environment(\.dsTheme, theme)
    }
}
