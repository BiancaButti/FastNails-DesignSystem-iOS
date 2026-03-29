import SwiftUI

/// Botão principal de ação de largura total com suporte a estado de carregamento.
///
/// Ocupa toda a largura disponível e garante altura mínima de 44pt (guideline Apple HIG).
/// Quando `isLoading` é `true`, o texto é substituído por um `ProgressView` e
/// o botão fica não-interativo automaticamente.
///
/// ```swift
/// @State private var salvando = false
///
/// DSPrimaryButton(
///     title: "Salvar",
///     isLoading: salvando,
///     color: .appPink
/// ) {
///     Task {
///         salvando = true
///         await salvarDados()
///         salvando = false
///     }
/// }
/// ```
///
/// ## Estados visuais
/// | `isEnabled` | `isLoading` | Aparência |
/// |---|---|---|
/// | `true` | `false` | Cor cheia, texto visível, interativo |
/// | `true` | `true` | Cor cheia, spinner branco, não-interativo |
/// | `false` | qualquer | Cinza, texto secundário, não-interativo |
///
/// ## Acessibilidade
/// O `title` é sempre o `accessibilityLabel`. O `accessibilityHint` é aplicado
/// somente quando fornecido (evita pausas desnecessárias no VoiceOver).
public struct DSPrimaryButton: View {
    /// Texto exibido no botão e usado como `accessibilityLabel`.
    let title: String
    /// Quando `false`, o botão fica desabilitado e acinzentado. Padrão: `true`.
    var isEnabled: Bool = true
    /// Quando `true`, exibe um spinner e desabilita a interação. Padrão: `false`.
    var isLoading: Bool = false
    /// Cor de fundo do botão no estado ativo. Padrão: `.accentColor`.
    var color: Color = .accentColor
    /// Dica contextual lida pelo VoiceOver após o label. Omitida quando `nil`.
    var accessibilityHint: String? = nil
    /// Ação executada ao tocar no botão.
    let action: () -> Void

    /// Cria um `DSPrimaryButton`.
    /// - Parameters:
    ///   - title: Texto do botão.
    ///   - isEnabled: Se o botão é interativo (padrão `true`).
    ///   - isLoading: Se deve exibir spinner (padrão `false`).
    ///   - color: Cor de fundo ativa (padrão `.accentColor`).
    ///   - accessibilityHint: Dica para VoiceOver (opcional).
    ///   - action: Closure executada ao tocar.
    public init(
        title: String,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        color: Color = .accentColor,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.color = color
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    private var isInteractive: Bool { isEnabled && !isLoading }

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .padding(.vertical, 14)
            .background(isInteractive ? color : Color(.systemGray4))
            .foregroundStyle(isInteractive ? Color.white : Color(.systemGray))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isInteractive)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .accessibilityLabel(title)
        .modifier(OptionalAccessibilityHint(hint: accessibilityHint))
    }
}

// MARK: - Helper

private struct OptionalAccessibilityHint: ViewModifier {
    let hint: String?

    func body(content: Content) -> some View {
        if let hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}
