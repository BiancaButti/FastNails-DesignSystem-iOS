import SwiftUI

// MARK: - DSTag

/// Etiqueta pequena e discreta para um atributo — "Em casa", "No espaço dela",
/// "Aceita cartão".
///
/// Diferente do `DSStatusBadgeView`, que comunica **estado** com cor semântica
/// (verde para aberto, vermelho para fechado), a `DSTag` é **informativa**: usa
/// um fundo neutro tingido pela marca e não sugere bom nem ruim. Use badge para
/// dizer como algo está; use tag para dizer o que algo é.
///
/// ```swift
/// HStack {
///     DSTag(text: "Em casa")
///     DSTag(systemImage: "house", text: "No espaço dela")
/// }
/// ```
///
/// ## Acessibilidade
/// O ícone é decorativo e fica oculto; o VoiceOver lê apenas o texto.
public struct DSTag: View {

    /// SF Symbol opcional antes do texto.
    let systemImage: String?
    /// Texto da etiqueta.
    let text: String

    @Environment(\.dsTheme) private var theme

    /// Cria uma `DSTag`.
    /// - Parameters:
    ///   - systemImage: SF Symbol antes do texto. Padrão: nenhum.
    ///   - text: Texto da etiqueta.
    public init(systemImage: String? = nil, text: String) {
        self.systemImage = systemImage
        self.text = text
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .accessibilityHidden(true)
            }
            Text(text)
        }
        .font(theme.captionFont)
        .foregroundStyle(.secondary)
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, DSSpacing.xs)
        .background(theme.brandColor.opacity(0.12))
        .clipShape(Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
    }
}
