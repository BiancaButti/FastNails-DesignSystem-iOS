import SwiftUI

// MARK: - DSCategoryItem

/// Modelo de dados para um item de categoria.
///
/// Construa um array de `DSCategoryItem` a partir do seu enum de categorias e
/// passe-o para `DSCategoriesSection`.
///
/// ```swift
/// let items = SearchCategory.allCases.map { category in
///     DSCategoryItem(
///         id: category.rawValue,
///         label: category.label,
///         systemIcon: category.iconName,
///         onTap: { viewModel.selectCategory(category) }
///     )
/// }
/// ```
public struct DSCategoryItem: Identifiable {
    public let id: String
    /// Texto exibido abaixo do ícone.
    public let label: String
    /// Nome do SF Symbol representando a categoria.
    public let systemIcon: String
    /// Ação executada ao tocar no item.
    public let onTap: () -> Void

    public init(id: String, label: String, systemIcon: String, onTap: @escaping () -> Void) {
        self.id = id
        self.label = label
        self.systemIcon = systemIcon
        self.onTap = onTap
    }
}

// MARK: - DSCategoryItemView

/// Célula de categoria com ícone circular e label abaixo.
///
/// Exibe um SF Symbol centralizado sobre um fundo circular na cor de marca,
/// com um texto de caption abaixo.
///
/// ```swift
/// DSCategoryItemView(item: DSCategoryItem(
///     id: "manicure",
///     label: "Manicure",
///     systemIcon: "hand.raised.fill",
///     onTap: { }
/// ))
/// ```
///
/// ## Acessibilidade
/// Toda a célula é um botão com `accessibilityLabel` igual ao `label` do item.
/// O ícone é marcado como decorativo.
///
/// - SeeAlso: `DSCategoriesSection`, `DSCategoryItem`
public struct DSCategoryItemView: View {

    let item: DSCategoryItem
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSCategoryItemView`.
    /// - Parameter item: Modelo com label, ícone e ação do item.
    public init(item: DSCategoryItem) {
        self.item = item
    }

    public var body: some View {
        Button(action: item.onTap) {
            VStack(spacing: DSSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(theme.brandColor.opacity(0.12))
                    Image(systemName: item.systemIcon)
                        .font(theme.labelFont)
                        .foregroundStyle(theme.brandColor)
                        .accessibilityHidden(true)
                }
                .frame(width: 52, height: 52)

                Text(item.label)
                    .font(theme.captionFont)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .accessibilityLabel(item.label)
    }
}

// MARK: - DSCategoriesSection

/// Seção de categorias em grade com título e quatro colunas.
///
/// Renderiza um título de seção seguido de um `LazyVGrid` com `columns`
/// colunas flexíveis. O número de colunas é configurável (padrão: 4).
///
/// ```swift
/// let items = SearchCategory.allCases.map { category in
///     DSCategoryItem(
///         id: category.rawValue,
///         label: category.label,
///         systemIcon: category.iconName,
///         onTap: { viewModel.selectCategory(category) }
///     )
/// }
///
/// DSCategoriesSection(items: items)
///
/// // Grade com 3 colunas
/// DSCategoriesSection(items: items, columns: 3)
/// ```
///
/// ## Acessibilidade
/// O título da seção recebe o trait `.isHeader` para navegação por VoiceOver.
/// Cada célula é um botão acessível independente.
///
/// - SeeAlso: `DSCategoryItemView`, `DSCategoryItem`
public struct DSCategoriesSection: View {

    /// Itens a exibir na grade.
    let items: [DSCategoryItem]
    /// Número de colunas da grade.
    let columns: Int
    /// Título da seção. Padrão: string localizada `"categoriesSectionTitle"`.
    let title: String

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSCategoriesSection`.
    /// - Parameters:
    ///   - items: Array de `DSCategoryItem` com label, ícone e ação de cada célula.
    ///   - columns: Número de colunas da grade. Padrão: `4`.
    ///   - title: Título exibido acima da grade. Padrão: string localizada `"categoriesSectionTitle"`.
    public init(
        items: [DSCategoryItem],
        columns: Int = 4,
        title: String? = nil
    ) {
        self.items = items
        self.columns = max(columns, 1)
        self.title = title ?? String(localized: "categoriesSectionTitle", bundle: .module)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(theme.buttonFont)
                .accessibilityAddTraits(.isHeader)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: DSSpacing.md), count: columns),
                spacing: 0
            ) {
                ForEach(items) { item in
                    DSCategoryItemView(item: item)
                }
            }
        }
    }
}
