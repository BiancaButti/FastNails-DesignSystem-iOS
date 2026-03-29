import SwiftUI

/// Campo seguro de senha com botão de mostrar/ocultar e feedback visual.
///
/// O estado de visibilidade da senha é gerenciado internamente por padrão,
/// eliminando a necessidade de `@State` no chamador. Use o init com `isVisible: Binding<Bool>`
/// apenas quando precisar ler ou controlar a visibilidade externamente.
///
/// Suporta dois estilos visuais (igual ao `DSFormTextField`):
/// - **Customizado** (padrão): fundo `secondarySystemBackground`, ícone preenchido.
/// - **Sistema** (`systemStyle: true`): borda nativa do iOS, ícone outline.
///
/// ```swift
/// @State private var senha = ""
///
/// DSFormSecureField(
///     label: "Senha",
///     placeholder: "Mínimo 6 caracteres",
///     text: $senha,
///     errorMessage: senha.count < 6 && !senha.isEmpty ? "Senha muito curta." : nil
/// )
/// ```
///
/// ## Acessibilidade
/// O `label` é exposto via `accessibilityLabel` do campo.
/// O botão de visibilidade anuncia "Mostrar senha" / "Ocultar senha" ao VoiceOver.
public struct DSFormSecureField: View {
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
    /// Política de autocapitalização. Padrão: `.never` (campos de senha nunca capitalizam).
    var autocapitalization: TextInputAutocapitalization = .never
    /// Tipo de conteúdo para autofill do iOS. Padrão: `.password`.
    var textContentType: UITextContentType? = .password
    /// Quando `true`, usa o estilo nativo `.roundedBorder`; quando `false` (padrão), usa o estilo customizado.
    var systemStyle: Bool = false
    /// Callback disparado quando o campo perde o foco. Ideal para validação ao sair.
    var onLostFocus: () -> Void = {}

    @FocusState private var isFocused: Bool
    @State private var internalVisible: Bool = false
    private var externalVisible: Binding<Bool>?
    @Environment(\.dsTheme) private var theme

    private var isVisible: Bool {
        externalVisible?.wrappedValue ?? internalVisible
    }

    private func setVisible(_ value: Bool) {
        if let ext = externalVisible {
            ext.wrappedValue = value
        } else {
            internalVisible = value
        }
    }

    /// Cria um `DSFormSecureField` com visibilidade gerenciada internamente (preferido).
    /// - Parameters:
    ///   - label: Rótulo visível acima do campo.
    ///   - placeholder: Texto de dica dentro do campo.
    ///   - text: Binding com o valor digitado.
    ///   - errorMessage: Mensagem de erro (tem prioridade sobre sucesso).
    ///   - successMessage: Mensagem de sucesso.
    ///   - keyboardType: Tipo de teclado (padrão `.default`).
    ///   - autocapitalization: Política de capitalização (padrão `.never`).
    ///   - textContentType: Tipo para autofill (padrão `.password`).
    ///   - systemStyle: Se `true`, usa estilo nativo do iOS.
    ///   - onLostFocus: Closure chamada ao perder foco.
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        successMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .never,
        textContentType: UITextContentType? = .password,
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
        self.externalVisible = nil
    }

    /// Cria um `DSFormSecureField` com visibilidade controlada externamente.
    ///
    /// Use esta variante apenas quando o chamador precisar ler ou alterar o estado
    /// de visibilidade da senha de fora do componente (ex.: sincronizar dois campos).
    /// - Parameters:
    ///   - label: Rótulo visível acima do campo.
    ///   - placeholder: Texto de dica dentro do campo.
    ///   - text: Binding com o valor digitado.
    ///   - isVisible: Binding externo que controla se o texto é visível.
    ///   - errorMessage: Mensagem de erro (tem prioridade sobre sucesso).
    ///   - successMessage: Mensagem de sucesso.
    ///   - keyboardType: Tipo de teclado (padrão `.default`).
    ///   - autocapitalization: Política de capitalização (padrão `.never`).
    ///   - textContentType: Tipo para autofill (padrão `.password`).
    ///   - systemStyle: Se `true`, usa estilo nativo do iOS.
    ///   - onLostFocus: Closure chamada ao perder foco.
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>,
        errorMessage: String? = nil,
        successMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .never,
        textContentType: UITextContentType? = .password,
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
        self.externalVisible = isVisible
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
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(theme.labelFont)
                .accessibilityHidden(true)

            if systemStyle {
                systemStyleField
            } else {
                customStyleField
            }

            if let feedback {
                DSFeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - System Style

    private var systemStyleField: some View {
        HStack(spacing: DSSpacing.sm) {
            inputField

            toggleVisibilityButton(filled: false)
        }
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, DSSpacing.sm)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
        .overlay {
            RoundedRectangle(cornerRadius: DSRadius.sm)
                .stroke(
                    feedback.map { f in f.tone.color(for: theme).opacity(0.8) }
                        ?? (isFocused ? theme.brandColor.opacity(0.5) : Color(.systemGray4)),
                    lineWidth: feedback != nil || isFocused ? 1.5 : 0.5
                )
        }
    }

    // MARK: - Custom Style

    private var customStyleField: some View {
        HStack(spacing: DSSpacing.sm) {
            inputField

            toggleVisibilityButton(filled: true)
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.md)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
        .overlay {
            RoundedRectangle(cornerRadius: DSRadius.md)
                .stroke(
                    feedback.map { f in f.tone.color(for: theme).opacity(0.8) }
                        ?? (isFocused ? theme.brandColor.opacity(0.5) : Color.clear),
                    lineWidth: 1.5
                )
        }
    }

    // MARK: - Shared subviews

    @ViewBuilder
    private var inputField: some View {
        Group {
            if isVisible {
                TextField(placeholder, text: $text)
            } else {
                SecureField(placeholder, text: $text)
            }
        }
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

    private func toggleVisibilityButton(filled: Bool) -> some View {
        Button {
            setVisible(!isVisible)
        } label: {
            let name = filled
                ? (isVisible ? "eye.slash.fill" : "eye.fill")
                : (isVisible ? "eye.slash" : "eye")
            Image(systemName: name)
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 24)
        }
        .accessibilityLabel(
            isVisible
                ? String(localized: "commonPasswordHide", bundle: .module)
                : String(localized: "commonPasswordShow", bundle: .module)
        )
    }
}

