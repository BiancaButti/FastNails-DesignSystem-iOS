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
