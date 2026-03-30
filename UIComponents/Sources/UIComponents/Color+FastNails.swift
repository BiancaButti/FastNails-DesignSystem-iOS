import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Tokens de cor do design system FastNails.
///
/// Todas as cores adaptam automaticamente ao modo claro e escuro via `UIColor`
/// dynamic provider (iOS/iPadOS) ou valor estático de fallback (macOS/outros).
///
/// ## Hierarquia de tokens
/// - **Marca**: `appPink`
/// - **Avaliações**: `appRating`
/// - **Semânticas de estado**: `colorSuccess`, `colorDestructive`
/// - **Aliases legados**: `appOpenBadge`, `appClosedBadge`
extension Color {
    // MARK: - Brand / Primary
    /// Cor rosa da marca. Mais clara no modo escuro para manter contraste adequado.
    static let appPink: Color = {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0.96, green: 0.51, blue: 0.68, alpha: 1)
                : UIColor(red: 0.92, green: 0.35, blue: 0.56, alpha: 1)
        })
        #else
        return Color(red: 0.92, green: 0.35, blue: 0.56)
        #endif
    }()

    // MARK: - Semantic / Rating
    /// Cor dourada para estrelas de avaliação. Mais saturada no modo escuro.
    static let appRating: Color = {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 1.00, green: 0.82, blue: 0.35, alpha: 1)
                : UIColor(red: 0.96, green: 0.72, blue: 0.18, alpha: 1)
        })
        #else
        return Color(red: 0.96, green: 0.72, blue: 0.18)
        #endif
    }()

    // MARK: - Semantic / Status
    /// Cor semântica de sucesso — usada em badges, rótulos de feedback e barras de senha.
    static let colorSuccess: Color = {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0.22, green: 0.78, blue: 0.49, alpha: 1)
                : UIColor(red: 0.17, green: 0.63, blue: 0.39, alpha: 1)
        })
        #else
        return Color(red: 0.17, green: 0.63, blue: 0.39)
        #endif
    }()

    /// Cor semântica de erro/destrutivo — usada em validações, badges fechados e barras de senha fraca.
    static let colorDestructive: Color = {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 1.00, green: 0.42, blue: 0.38, alpha: 1)
                : UIColor(red: 0.86, green: 0.27, blue: 0.24, alpha: 1)
        })
        #else
        return Color(red: 0.86, green: 0.27, blue: 0.24)
        #endif
    }()

    // MARK: - Legacy aliases (kept for backwards compatibility)
    /// Alias de `colorSuccess`. Prefer `colorSuccess` em novo código.
    static let appOpenBadge: Color = .colorSuccess
    /// Alias de `colorDestructive`. Prefer `colorDestructive` em novo código.
    static let appClosedBadge: Color = .colorDestructive

    // MARK: - Empty state
    /// Cor neutra para ícones de estado vazio. Cinza médio que adapta ao modo escuro.
    static let appEmptyState: Color = {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0.60, green: 0.60, blue: 0.65, alpha: 1)
                : UIColor(red: 0.70, green: 0.70, blue: 0.73, alpha: 1)
        })
        #else
        return Color(red: 0.70, green: 0.70, blue: 0.73)
        #endif
    }()
}

// MARK: - Cross-platform system colors (internal)

extension Color {
    static var dsSystemBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #else
        Color(NSColor.windowBackgroundColor)
        #endif
    }

    static var dsSecondarySystemBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
        #else
        Color(NSColor.controlBackgroundColor)
        #endif
    }

    static var dsSystemGray: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemGray)
        #else
        Color(NSColor.systemGray)
        #endif
    }

    static var dsSystemGray4: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemGray4)
        #else
        Color(NSColor.separatorColor)
        #endif
    }

    static var dsSystemGray5: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemGray5)
        #else
        Color(NSColor.underPageBackgroundColor)
        #endif
    }
}