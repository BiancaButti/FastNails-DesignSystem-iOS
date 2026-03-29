import SwiftUI

// MARK: - DSOTPField

/// Campo de entrada de código OTP (One-Time Password) com caixas individuais por dígito.
///
/// Renderiza `length` caixas quadradas lado a lado e captura a entrada via um `TextField`
/// invisível sobreposto. Aceita apenas dígitos numéricos e limita automaticamente
/// ao comprimento configurado.
///
/// ```swift
/// @State private var codigo = ""
///
/// DSOTPField(
///     label: "Código de verificação",
///     code: $codigo,
///     length: 6,
///     errorMessage: codigo.count < 6 ? "Digite os 6 números enviados." : nil,
///     successMessage: codigo.count == 6 ? "Código correto!" : nil
/// )
/// ```
///
/// ## Comportamento
/// - Ao tocar em qualquer caixa, o campo invisível recebe foco e o teclado numérico aparece.
/// - Uma seta piscante indica a caixa ativa.
/// - Caracteres não numéricos são filtrados automaticamente.
///
/// ## Acessibilidade
/// O componente é tratado como elemento único pelo VoiceOver. O valor lido é
/// cada dígito separado por espaço (ex.: "1 2 3 4 5 6") ou "Vazio" quando vazio.
@available(macOS 12.0, iOS 15.0, *)
public struct DSOTPField: View {
    /// Texto do rótulo exibido acima das caixas.
    let label: String
    /// Binding bidirecional com o código digitado (somente dígitos, máx. `length` caracteres).
    @Binding var code: String
    /// Mensagem de erro exibida abaixo do campo. Tem prioridade sobre `successMessage`.
    var errorMessage: String? = nil
    /// Mensagem de sucesso exibida abaixo do campo.
    var successMessage: String? = nil

    @FocusState private var isFocused: Bool
    /// Número de dígitos do código. Clampeado a mínimo 1. Padrão: `6`.
    private let length: Int
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSOTPField`.
    /// - Parameters:
    ///   - label: Rótulo visível acima das caixas.
    ///   - code: Binding com o código digitado.
    ///   - length: Número de dígitos esperados (padrão `6`, mínimo `1`).
    ///   - errorMessage: Mensagem de erro.
    ///   - successMessage: Mensagem de sucesso.
    public init(
        label: String,
        code: Binding<String>,
        length: Int = 6,
        errorMessage: String? = nil,
        successMessage: String? = nil
    ) {
        self.label = label
        self._code = code
        self.length = max(1, length)
        self.errorMessage = errorMessage
        self.successMessage = successMessage
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

            HStack(spacing: DSSpacing.sm) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .frame(height: 48)
            .onTapGesture { isFocused = true }
            .overlay {
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .opacity(0)
                    .accessibilityHidden(true)
                    .onChange(of: code) { newValue in
                        let digits = String(newValue.filter(\.isNumber).prefix(length))
                        if code != digits { code = digits }
                    }
            }

            if let feedback {
                DSFeedbackLabel(message: feedback.message, tone: feedback.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(
            code.isEmpty
                ? String(localized: "otpFieldAccessibilityEmpty", bundle: .module)
                : code.map { String($0) }.joined(separator: " ")
        )
        .accessibilityHint(feedback?.message ?? String(localized: "otpFieldAccessibilityHint", bundle: .module))
        .accessibilityAddTraits(.allowsDirectInteraction)
    }

    // MARK: - Digit Box

    @ViewBuilder
    private func digitBox(at index: Int) -> some View {
        let chars = Array(code)
        let char = index < chars.count ? String(chars[index]) : ""
        let isCurrentBox = isFocused && index == min(code.count, length - 1)
        let hasFeedback = feedback != nil
        let feedbackColor = feedback.map { f in f.tone.color(for: theme).opacity(0.8) }

        ZStack {
            RoundedRectangle(cornerRadius: DSRadius.sm)
                .fill(Color(uiColor: .systemBackground))
                .overlay {
                    RoundedRectangle(cornerRadius: DSRadius.sm)
                        .stroke(
                            feedbackColor
                                ?? (isCurrentBox ? theme.brandColor : Color(uiColor: .systemGray4)),
                            lineWidth: hasFeedback || isCurrentBox ? 2 : 1
                        )
                }

            if char.isEmpty && isCurrentBox {
                BlinkingCursor(color: theme.brandColor)
            } else {
                Text(char)
                    .font(.title2.bold())
                    .foregroundStyle(feedbackColor ?? Color.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }
}

// MARK: - BlinkingCursor

@available(macOS 12.0, iOS 15.0, *)
private struct BlinkingCursor: View {
    var color: Color
    @State private var visible = true

    var body: some View {
        Rectangle()
            .frame(width: 2, height: DSSpacing.xxl)
            .foregroundStyle(color)
            .opacity(visible ? 1 : 0)
            .task {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    visible = false
                }
            }
    }
}
