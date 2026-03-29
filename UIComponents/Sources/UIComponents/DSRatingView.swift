import SwiftUI

/// Exibição de avaliação por estrelas em dois estilos.
///
/// `DSRatingView` aceita um valor `Double` de `0.0` a `5.0` (valores fora do
/// intervalo são fixados automaticamente) e renderiza a avaliação de acordo
/// com o estilo escolhido.
///
/// ```swift
/// // Compacto — estrela única + número (ideal para listas)
/// DSRatingView(rating: 4.7, style: .compact)
///
/// // Expandido — cinco estrelas + número (ideal para perfis)
/// DSRatingView(rating: 4.7, style: .expanded)
/// ```
///
/// ## Acessibilidade
/// Ambos os estilos colapsam sua árvore em um único elemento acessível com
/// a label localizada `"manicuristProfileRatingAccessibility"` —
/// ex.: _"Avaliação: 4,7 estrelas"_.
public struct DSRatingView: View {

    /// Estilo de exibição da avaliação.
    public enum Style {
        /// Estrela única + número. Ideal para listas e cards compactos.
        case compact
        /// Cinco estrelas (cheia / meia / vazia) + número. Ideal para telas de perfil.
        case expanded
    }

    /// Nota de avaliação entre `0.0` e `5.0`. Valores fora do intervalo são fixados.
    let rating: Double
    /// Estilo de exibição: `.compact` ou `.expanded`.
    let style: Style

    /// Cria um `DSRatingView`.
    /// - Parameters:
    ///   - rating: Nota de `0.0` a `5.0`. Fixada aos extremos se necessário.
    ///   - style: Estilo de exibição (`.compact` ou `.expanded`).
    public init(rating: Double, style: Style) {
        self.rating = min(max(rating, 0), 5)
        self.style = style
    }

    public var body: some View {
        switch style {
        case .compact:
            compactView
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    String(
                        format: String(localized: "manicuristProfileRatingAccessibility", bundle: .module),
                        String(format: "%.1f", rating)
                    )
                )
        case .expanded:
            expandedView
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    String(
                        format: String(localized: "manicuristProfileRatingAccessibility", bundle: .module),
                        String(format: "%.1f", rating)
                    )
                )
        }
    }
}

// MARK: - Subviews

private extension DSRatingView {

    var compactView: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .foregroundStyle(Color.appRating)
                .font(.caption2)
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var expandedView: some View {
        HStack(spacing: 6) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: starIcon(for: index))
                        .foregroundStyle(Color.appRating)
                        .font(.subheadline)
                }
            }
            .accessibilityHidden(true)

            Text(String(format: "%.1f", rating))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Helpers

private extension DSRatingView {

    /// Returns the appropriate SF Symbol name for a star at `index` (1-based).
    func starIcon(for index: Int) -> String {
        let filled = rating.rounded(.down)
        let fraction = rating.truncatingRemainder(dividingBy: 1)

        if Double(index) <= filled {
            return "star.fill"
        } else if Double(index) - filled < 1 && fraction >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
