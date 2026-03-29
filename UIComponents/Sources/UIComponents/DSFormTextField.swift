import SwiftUI

/// Campo de texto reutilizável com label, placeholder, validação e feedback visual.
///
/// Suporta dois estilos visuais:
/// - **Customizado** (padrão): fundo `secondarySystemBackground`, borda colorida por estado.
/// - **Sistema** (`systemStyle: true`): usa `TextField` com estilo `.roundedBorder` nativo do iOS.
///
/// O feedback de validação é exibido abaixo do campo como `DSFeedbackLabel`. Se `errorMessage`
/// estiver preenchido, ele tem prioridade sobre `successMessage`.
///
/// ```swift
/// @State private var nome = ""
/// @State private var erro: String? = nil
///
/// DSFormTextField(
///     label: "Nome",
///     placeholder: "Digite seu nome completo",
///     text: $nome,
///     errorMessage: erro,
///     onLostFocus: {
///         erro = nome.isEmpty ? "Preencha o nome." : nil
///     }
/// )
/// ```
///
/// ## Acessibilidade
/// O `label` é composto no `accessibilityLabel` do campo para que o VoiceOver
/// continue anunciando o contexto mesmo após o placeholder desaparecer.
/// O feedback de validação é exposto via `accessibilityValue`.
@available(macOS 12.0, iOS 15.0, *)
public struct DSFormTextField: View {
    /// Texto do rótulo exibido acima do campo.
    let label: String
    /// Texto de placeholder exibido enquanto o campo está vazio.
    let placeholder: String
    /// Binding bidirecional com o texto digitado.
    @Binding var text: String
    /// Mensagem de erro a exibir abaixo do campo. Tem prioridade sobre `successMessage`.
    var errorMessage: String? = nil
    /// Mensagem de sucesso a exibir abaixo do campo.
    var successMessage: String? = nil
    /// Tipo de teclado a apresentar. Padrão: `.default`.
    var keyboardType: UIKeyboardType = .default
    /// Política de autocapitalização. Padrão: `.words`.
    var autocapitalization: TextInputAutocapitalization = .words
    /// Tipo de conteúdo para autofill do iOS (ex.: `.name`, `.emailAddress`).
    var textContentType: UITextContentType? = nil
    /// Quando `true`, usa o estilo nativo `.roundedBorder`; quando `false` (padrão), usa o estilo customizado do design system.
    var systemStyle: Bool = false
    /// Callback disparado quando o campo perde o foco. Ideal para validação ao sair.
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSFormTextField`.
    /// - Parameters:
    ///   - label: Rótulo visível acima do campo.
    ///   - placeholder: Texto de dica dentro do campo.
    ///   - text: Binding com o valor digitado.
    ///   - errorMessage: Mensagem de erro (tem prioridade sobre sucesso).
    ///   - successMessage: Mensagem de sucesso.
    ///   - keyboardType: Tipo de teclado (padrão `.default`).
    ///   - autocapitalization: Política de capitalização (padrão `.words`).
    ///   - textContentType: Tipo para autofill (opcional).
    ///   - systemStyle: Se `true`, usa estilo nativo do iOS.
    ///   - onLostFocus: Closure chamada ao perder foco.
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        successMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .words,
        textContentType: UITextContentType? = nil,
        systemStyle: Bool = false,
        onLostFocus: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.successMessage = successMessage
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textContentType = textContentType
        self.systemStyle = systemStyle
        self.onLostFocus = onLostFocus
    }

    private var feedback: (message: String, tone: DSFeedbackTone)? {
        if let errorMessage, !errorMessage.isEmpty {
            return (errorMessage, .failure)
        }

        if let successMessage, !successMessage.isEmpty {
            return (successMessage, .success)
        }

        return nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(label)
                .font(theme.labelFont)
                .accessibilityHidden(true)

            if systemStyle {
                systemTextField
            } else {
                customTextField
            }

            if let feedback {
                DSFeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var systemTextField: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(autocapitalization)
            .textContentType(textContentType)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .focused($isFocused)
            .accessibilityLabel(label)
            .accessibilityValue(feedback?.message ?? "")
            .onChange(of: isFocused) { newValue in
                if !newValue { onLostFocus() }
            }
    }

    private var customTextField: some View {
        let borderColor = feedback.map { f in f.tone.color(for: theme).opacity(0.8) }
            ?? (isFocused ? theme.brandColor.opacity(0.5) : Color.clear)
        return TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(autocapitalization)
            .textContentType(textContentType)
            .autocorrectionDisabled()
            .focused($isFocused)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.md)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .accessibilityLabel(label)
            .accessibilityValue(feedback?.message ?? "")
            .onChange(of: isFocused) { newValue in
                if !newValue { onLostFocus() }
            }
    }
}
