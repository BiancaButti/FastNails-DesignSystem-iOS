import SwiftUI

// MARK: - DSCard

/// Cartão elevado que agrupa um bloco de conteúdo — tipicamente os campos de um
/// formulário sobre um fundo colorido.
///
/// A cor vem do `DSTheme` (`surfaceColor`), então trocar o tema reveste todos os
/// cartões de uma vez.
///
/// ```swift
/// DSCard {
///     DSTextField(label: "E-mail", placeholder: "seu@email.com", text: $email)
///     DSPrimaryButton(title: "Entrar") { }
/// }
/// ```
///
/// ## Acessibilidade
/// O cartão é puramente visual e não interfere na leitura — o VoiceOver navega
/// direto pelo conteúdo interno.
public struct DSCard<Content: View>: View {

    /// Espaçamento vertical entre os itens dentro do cartão.
    let spacing: CGFloat
    /// Espaçamento interno entre o conteúdo e a borda do cartão.
    let padding: CGFloat
    /// Raio dos cantos.
    let cornerRadius: CGFloat
    /// Cor de fundo. Quando `nil`, usa `surfaceColor` do tema.
    let background: Color?
    @ViewBuilder let content: () -> Content

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSCard`.
    /// - Parameters:
    ///   - spacing: Espaçamento entre os itens (padrão `DSSpacing.lg`, 16 pt).
    ///   - padding: Espaçamento interno (padrão 20 pt).
    ///   - cornerRadius: Raio dos cantos (padrão 24 pt — mais pronunciado que
    ///     `DSRadius.xl`, que serve para sheets e modais).
    ///   - background: Cor de fundo. Quando `nil`, usa `surfaceColor` do tema.
    ///     Informe para destacar um cartão do resto da tela — por exemplo, o
    ///     próximo agendamento preenchido com a cor da marca.
    ///   - content: Conteúdo do cartão.
    public init(
        spacing: CGFloat = DSSpacing.lg,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        background: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
        self.content = content
    }

    public var body: some View {
        VStack(spacing: spacing) {
            content()
        }
        .padding(padding)
        .background(background ?? theme.surfaceColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 18, y: 10)
    }
}
