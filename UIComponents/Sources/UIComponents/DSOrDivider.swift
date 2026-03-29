import SwiftUI

/// Divisor horizontal com rótulo textual centralizado.
///
/// Renderiza duas linhas horizontais separadas por um texto (ex.: _"ou"_).
/// Ideal para separar alternativas de ação em formulários de login/cadastro.
///
/// ```swift
/// VStack {
///     DSPrimaryButton(title: "Entrar com e-mail") { }
///     DSOrDivider()                        // exibe "ou" localizado
///     DSOrDivider(label: "ou continue com")
/// }
/// ```
///
/// ## Acessibilidade
/// As linhas decorativas são ocultas do VoiceOver. O `label` é exposto
/// como elemento acessível único, para que leitores de tela leiam
/// apenas o texto semanticamente relevante.
@available(macOS 12.0, iOS 15.0, *)
public struct DSOrDivider: View {
    /// Texto exibido entre as linhas divisórias e lido pelo VoiceOver.
    var label: String

    /// Cria um `DSOrDivider`.
    /// - Parameter label: Texto central. Quando `nil`, usa a string
    ///   localizada `"dividerOr"` (ex.: _"ou"_).
    public init(label: String? = nil) {
        self.label = label ?? String(localized: "dividerOr", bundle: .module)
    }

    public var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.secondary.opacity(0.4))
                .accessibilityHidden(true)
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, DSSpacing.sm)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.secondary.opacity(0.4))
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
    }
}
