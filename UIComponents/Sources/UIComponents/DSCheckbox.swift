import SwiftUI

/// Caixa de seleção (checkbox) com rótulo, temável via `DSTheme`.
///
/// A marca (o "check") usa a `brandColor` do tema do app; o rótulo entra como
/// conteúdo livre (`@ViewBuilder`), então dá pra passar texto simples ou um
/// `Text` estilizado — por exemplo, com trechos destacados de "Termos de Uso".
///
/// ```swift
/// DSCheckbox(isChecked: $aceitouTermos) {
///     Text("Li e aceito os Termos de Uso.")
///         .font(.footnote)
/// }
/// ```
///
/// ## Acessibilidade
/// O componente inteiro vira **um único elemento** (checkbox + rótulo) com o
/// traço de botão selecionável, então o VoiceOver anuncia o rótulo e o estado
/// (marcado / não marcado).
public struct DSCheckbox<Label: View>: View {

    @Binding private var isChecked: Bool
    private let label: Label

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSCheckbox`.
    /// - Parameters:
    ///   - isChecked: Binding com o estado marcado/desmarcado.
    ///   - label: Conteúdo do rótulo (texto simples ou `Text` estilizado).
    public init(
        isChecked: Binding<Bool>,
        @ViewBuilder label: () -> Label
    ) {
        self._isChecked = isChecked
        self.label = label()
    }

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isChecked.toggle()
            }
        } label: {
            HStack(alignment: .top, spacing: DSSpacing.sm) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isChecked ? theme.brandColor : Color.tinta60)

                label
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isChecked ? [.isButton, .isSelected] : .isButton)
    }
}
