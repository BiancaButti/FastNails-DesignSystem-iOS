import SwiftUI

/// Estado vazio de busca com ícone grande, título e subtítulo.
///
/// Use quando uma busca não retorna resultados. O ícone usa `Color.appEmptyState`
/// (cinza neutro) para comunicar ausência de conteúdo sem usar cores semânticas.
///
/// ```swift
/// // Strings localizadas padrão
/// DSSearchEmptyStateView()
///
/// // Strings customizadas
/// DSSearchEmptyStateView(
///     title: "Sem manicures na região",
///     subtitle: "Expanda o raio de busca e tente novamente."
/// )
/// ```
///
/// ## Acessibilidade
/// O ícone é decorativo (`.accessibilityHidden(true)`). O componente inteiro
/// é colapsado em um único elemento com label composta de título + subtítulo.
///
/// - SeeAlso: `DSResultSection`, `DSResultEmptyView`
public struct DSSearchEmptyStateView: View {

    /// Título exibido abaixo do ícone.
    let title: String
    /// Subtítulo de sugestão exibido abaixo do título.
    let subtitle: String

    /// Cria um `DSSearchEmptyStateView`.
    /// - Parameters:
    ///   - title: Título do estado vazio. Padrão: `"searchEmptyTitle"` localizado.
    ///   - subtitle: Subtítulo de sugestão. Padrão: `"searchEmptySubtitle"` localizado.
    public init(
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.title = title ?? String(localized: "searchEmptyTitle", bundle: .module)
        self.subtitle = subtitle ?? String(localized: "searchEmptySubtitle", bundle: .module)
    }

    @Environment(\.dsTheme) private var theme

    public var body: some View {
        VStack(spacing: DSSpacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 56))
                .foregroundStyle(Color.appEmptyState)
                .accessibilityHidden(true)

            Text(title)
                .font(theme.buttonFont)
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(theme.labelFont)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(DSSpacing.xxl)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title). \(subtitle)")
    }
}
