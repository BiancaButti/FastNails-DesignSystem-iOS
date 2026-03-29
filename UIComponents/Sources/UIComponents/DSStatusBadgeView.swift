import SwiftUI

/// Cápsula colorida de status para exibir o estado de um estabelecimento ou entidade.
///
/// Oferece dois inicializadores: um de conveniência para status aberto/fechado
/// (com strings localizadas automáticas) e um genérico para texto e tom customizados.
///
/// ```swift
/// // Conveniência — "Aberto agora" ou "Fechado" localizado
/// DSStatusBadgeView(isOpen: true)
///
/// // Genérico — texto e cor arbitrários
/// DSStatusBadgeView(text: "Em andamento", tone: .success)
/// DSStatusBadgeView(text: "Cancelado",    tone: .failure)
/// ```
///
/// ## Acessibilidade
/// O badge é tratado como texto estático (`.isStaticText`). O VoiceOver
/// lê o conteúdo de `text` diretamente.
public struct DSStatusBadgeView: View {

    /// Tom de cor do badge.
    public enum Tone {
        /// Indica estado positivo (ex.: aberto, concluído). Usa `colorSuccess`.
        case success
        /// Indica estado negativo (ex.: fechado, cancelado). Usa `colorDestructive`.
        case failure

        /// Cor de fundo correspondente ao tom, derivada dos tokens do design system.
        public var backgroundColor: Color {
            switch self {
            case .success:
                return Color.colorSuccess
            case .failure:
                return Color.colorDestructive
            }
        }

        /// Cor de fundo resolvida usando as cores do `DSTheme` ativo.
        func resolvedBackground(for theme: DSTheme) -> Color {
            switch self {
            case .success: return theme.successColor
            case .failure: return theme.errorColor
            }
        }
    }

    /// Texto exibido no badge.
    let text: String
    /// Tom de cor do badge.
    let tone: Tone
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSStatusBadgeView` de conveniência para status aberto/fechado.
    ///
    /// As strings são resolvidas via `Bundle.module` com as chaves
    /// `"homeBadgeOpenNow"` e `"homeBadgeClosed"`.
    /// - Parameter isOpen: `true` para "Aberto agora" (verde); `false` para "Fechado" (vermelho).
    public init(isOpen: Bool) {
        self.text = isOpen
            ? String(localized: "homeBadgeOpenNow", bundle: .module)
            : String(localized: "homeBadgeClosed", bundle: .module)
        self.tone = isOpen ? .success : .failure
    }

    /// Cria um `DSStatusBadgeView` com texto e tom personalizados.
    /// - Parameters:
    ///   - text: Texto exibido no badge.
    ///   - tone: Tom de cor (`.success` ou `.failure`).
    public init(text: String, tone: Tone) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        Text(text)
            .font(theme.badgeFont)
            .foregroundStyle(.white)
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.xs)
            .background(tone.resolvedBackground(for: theme))
            .clipShape(Capsule())
            .accessibilityAddTraits(.isStaticText)
    }
}
