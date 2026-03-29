import SwiftUI

/// Seção de resultados de busca com três estados: carregando, vazio e com itens.
///
/// Aceita qualquer tipo `Identifiable` como item e builders de view para o
/// conteúdo de cada linha e para o estado vazio. A navegação e o card de cada
/// item são responsabilidade do chamador.
///
/// ```swift
/// // Exemplo com NavigationLink e card customizado
/// DSResultSection(
///     isLoading: viewModel.isLoading,
///     items: viewModel.salons
/// ) { salon in
///     NavigationLink(destination: SalonDetailView(salon: salon)) {
///         SalonCardView(salon: salon)
///     }
///     .buttonStyle(.plain)
/// }
///
/// // Estado vazio customizado
/// DSResultSection(
///     isLoading: viewModel.isLoading,
///     items: viewModel.salons
/// ) { salon in
///     SalonCardView(salon: salon)
/// } emptyContent: {
///     Text("Sem manicures na sua região.")
/// }
/// ```
///
/// ## Estados
/// - **Carregando** (`isLoading == true`): exibe `ProgressView` centralizado.
/// - **Vazio** (`items.isEmpty`): exibe `emptyContent` — padrão com ícone, título e mensagem.
/// - **Com itens**: exibe cabeçalho de contagem + `LazyVStack` com `rowContent` por item.
///
/// ## Acessibilidade
/// - O spinner recebe `accessibilityLabel` configurável.
/// - O cabeçalho de contagem recebe o trait `.isHeader`.
/// - As linhas herdam a acessibilidade do `rowContent` fornecido.
///
/// - SeeAlso: `DSLoadingView`, `DSCategoriesSection`
public struct DSResultSection<Item: Identifiable, RowContent: View, EmptyContent: View>: View {

    /// `true` enquanto os dados estão sendo carregados.
    let isLoading: Bool
    /// Lista de itens a exibir.
    let items: [Item]
    /// Formato de contagem (ex.: `"%d resultados encontrados"`). Usa `String(format:count)`.
    let countFormat: String
    /// Label lida pelo VoiceOver quando o spinner está visível.
    let loadingAccessibilityLabel: String
    /// Builder para o conteúdo de cada linha.
    @ViewBuilder let rowContent: (Item) -> RowContent
    /// Builder para o estado vazio. Padrão: ícone + título + mensagem localizados.
    @ViewBuilder let emptyContent: () -> EmptyContent

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSResultSection` com estado vazio customizado.
    /// - Parameters:
    ///   - isLoading: `true` para exibir o spinner.
    ///   - items: Itens a renderizar.
    ///   - countFormat: Formato printf para a contagem. Padrão: `"resultsCount"` localizado.
    ///   - loadingAccessibilityLabel: Label VoiceOver do spinner. Padrão: `"resultsLoadingAccessibility"` localizado.
    ///   - rowContent: ViewBuilder chamado para cada item.
    ///   - emptyContent: ViewBuilder exibido quando `items` está vazio.
    public init(
        isLoading: Bool,
        items: [Item],
        countFormat: String? = nil,
        loadingAccessibilityLabel: String? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent
    ) {
        self.isLoading = isLoading
        self.items = items
        self.countFormat = countFormat ?? String(localized: "resultsCount", bundle: .module)
        self.loadingAccessibilityLabel = loadingAccessibilityLabel ?? String(localized: "resultsLoadingAccessibility", bundle: .module)
        self.rowContent = rowContent
        self.emptyContent = emptyContent
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, DSSpacing.xxl)
                    .tint(theme.brandColor)
                    .accessibilityLabel(loadingAccessibilityLabel)
            } else if items.isEmpty {
                emptyContent()
            } else {
                Text(String(format: countFormat, items.count))
                    .font(theme.buttonFont)
                    .padding(.horizontal, DSSpacing.lg)
                    .accessibilityAddTraits(.isHeader)

                LazyVStack(spacing: DSSpacing.md) {
                    ForEach(items, id: \.id) { item in
                        rowContent(item)
                    }
                }
            }
        }
    }
}

// MARK: - Default empty state convenience init

public extension DSResultSection where EmptyContent == DSResultEmptyView {

    /// Cria um `DSResultSection` com o estado vazio padrão (ícone + título + mensagem).
    /// - Parameters:
    ///   - isLoading: `true` para exibir o spinner.
    ///   - items: Itens a renderizar.
    ///   - countFormat: Formato printf para a contagem. Padrão: `"resultsCount"` localizado.
    ///   - loadingAccessibilityLabel: Label VoiceOver do spinner. Padrão: localizado.
    ///   - rowContent: ViewBuilder chamado para cada item.
    init(
        isLoading: Bool,
        items: [Item],
        countFormat: String? = nil,
        loadingAccessibilityLabel: String? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self.init(
            isLoading: isLoading,
            items: items,
            countFormat: countFormat,
            loadingAccessibilityLabel: loadingAccessibilityLabel,
            rowContent: rowContent,
            emptyContent: { DSResultEmptyView() }
        )
    }
}

// MARK: - DSResultEmptyView

/// Estado vazio padrão para `DSResultSection`.
///
/// Exibe um ícone de lupa riscada, um título e uma mensagem de sugestão.
/// Pode ser usada de forma independente ou substituída por `emptyContent` customizado.
///
/// ```swift
/// DSResultEmptyView()
/// DSResultEmptyView(title: "Sem manicures", message: "Tente outra região.")
/// ```
public struct DSResultEmptyView: View {

    let title: String
    let message: String

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSResultEmptyView`.
    /// - Parameters:
    ///   - title: Título do estado vazio. Padrão: `"resultsEmptyTitle"` localizado.
    ///   - message: Mensagem de sugestão. Padrão: `"resultsEmptyMessage"` localizado.
    public init(
        title: String? = nil,
        message: String? = nil
    ) {
        self.title = title ?? String(localized: "resultsEmptyTitle", bundle: .module)
        self.message = message ?? String(localized: "resultsEmptyMessage", bundle: .module)
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(theme.brandColor.opacity(0.4))
                .accessibilityHidden(true)

            Text(title)
                .font(theme.buttonFont)
                .foregroundStyle(.primary)

            Text(message)
                .font(theme.feedbackFont)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DSSpacing.xxl)
        .padding(.horizontal, DSSpacing.xl)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title). \(message)")
    }
}
