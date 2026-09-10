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
public struct DSFormTextField: View {
    /// Texto do rótulo exibido acima do campo.
    let label: String
    /// Texto de placeholder exibido enquanto o campo está vazio.
    let placeholder: String
    /// Binding bidirecional com o texto digitado.
    @Binding var text: String
    /// Mensagem de erro a exibir abaixo do campo. Tem prioridade sobre `successMessage`.
    var errorMessage: String? = nil
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
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.textContentType = textContentType
        self.systemStyle = systemStyle
        self.onLostFocus = onLostFocus
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            headerLabel
            systemTextField
            
            if let feedback {
                DSFeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        ).padding()
    }
}

extension DSFormTextField {
   private var headerLabel: some View {
        Text(label)
            .font(theme.labelFont)
            .accessibilityHidden(true)
    }

    private var systemTextField: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(autocapitalization)
            .textContentType(textContentType)
            .autocorrectionDisabled()
            .focused($isFocused)
            .accessibilityLabel(label)
            .accessibilityValue(feedback?.message ?? "")
            .onChange(of: isFocused) { newValue in
                if !newValue { onLostFocus() }
            }
    }

    private var feedback: (message: String, tone: DSFeedbackTone)? {
        if let errorMessage, !errorMessage.isEmpty {
            return (errorMessage, .failure)
        }
        return nil
    }
}
