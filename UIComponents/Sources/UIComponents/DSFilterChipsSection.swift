import SwiftUI

/// Seção rolável horizontal de chips de filtro.
///
/// Renderiza um `ScrollView` horizontal com um `DSFilterChipView` por item.
/// O padding horizontal externo alinha o conteúdo à grade da tela.
///
/// ```swift
/// let chips = SearchFilter.allCases.map { filter in
///     DSFilterChipItem(
///         id: filter.rawValue,
///         label: filter.label,
///         isActive: viewModel.isActive(filter),
///         onTap: { viewModel.toggleFilter(filter) }
///     )
/// }
///
/// DSFilterChipsSection(items: chips)
/// ```
///
/// ## Acessibilidade
/// Cada chip é um botão independente com label e estado de seleção expostos
/// ao VoiceOver. O `ScrollView` em si é ignorado na árvore de acessibilidade,
/// deixando os chips individuais navegáveis por swipe horizontal.
///
/// - SeeAlso: `DSFilterChipView`, `DSFilterChipItem`
public struct DSFilterChipsSection: View {

    /// Lista ordenada de chips a exibir.
    let items: [DSFilterChipItem]

    /// Cria um `DSFilterChipsSection`.
    /// - Parameter items: Array de `DSFilterChipItem` com label, estado e ação de cada chip.
    public init(items: [DSFilterChipItem]) {
        self.items = items
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSSpacing.sm) {
                ForEach(items) { item in
                    DSFilterChipView(
                        label: item.label,
                        isActive: item.isActive,
                        action: item.onTap
                    )
                }
            }
            .padding(.horizontal, DSSpacing.lg)
        }
    }
}
