import SwiftUI

/// Campo de pesquisa com ícone de lupa integrado.
///
/// Exibe um `TextField` no estilo de busca com fundo cinza neutro e
/// borda de foco na cor de marca ao receber interação.
///
/// ```swift
/// // Placeholder localizado padrão
/// DSSearchFieldView(text: $query)
///
/// // Placeholder customizado + ação ao submeter
/// DSSearchFieldView(
///     placeholder: "Buscar manicure…",
///     text: $query,
///     onSubmit: { viewModel.search() }
/// )
/// ```
///
/// ## Acessibilidade
/// - O ícone de lupa é decorativo (`.accessibilityHidden(true)`).
/// - O `TextField` mantém sua acessibilidade nativa (placeholder + valor lidos pelo VoiceOver).
///
/// - SeeAlso: `DSTheme`, `DSSpacing`, `DSRadius`
public struct DSSearchFieldView: View {

    /// Texto de placeholder exibido enquanto o campo está vazio.
    var placeholder: String
    /// Binding bidirecional com o texto digitado.
    @Binding var text: String
    /// Closure chamada ao submeter a busca (tecla Search/Return).
    var onSubmit: () -> Void

    @FocusState private var isFocused: Bool
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSSearchFieldView`.
    /// - Parameters:
    ///   - placeholder: Texto de dica. Padrão: string localizada `"searchFieldPlaceholder"`.
    ///   - text: Binding com o valor digitado.
    ///   - onSubmit: Closure chamada ao pressionar a tecla de busca. Padrão: nenhuma ação.
    public init(
        placeholder: String? = nil,
        text: Binding<String>,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder ?? String(localized: "searchFieldPlaceholder", bundle: .module)
        self._text = text
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(isFocused ? theme.brandColor : Color.secondary)
                .accessibilityHidden(true)

            TextField(placeholder, text: $text)
                .submitLabel(.search)
                .focused($isFocused)
                .onSubmit(onSubmit)
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.md)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .overlay {
            RoundedRectangle(cornerRadius: DSRadius.lg)
                .stroke(
                    isFocused ? theme.brandColor.opacity(0.5) : Color.clear,
                    lineWidth: 1.5
                )
        }
    }
}
