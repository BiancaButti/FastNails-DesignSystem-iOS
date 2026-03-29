import SwiftUI

/// Tonalidade semântica de um `DSFeedbackLabel`.
///
/// Controla a cor e o ícone exibidos ao lado da mensagem.
public enum DSFeedbackTone: CaseIterable {
    /// Indica resultado positivo, campo válido ou ação bem-sucedida.
    case success
    /// Indica erro, campo inválido ou ação falha.
    case failure

    /// Cor semântica associada ao tom (`colorSuccess` ou `colorDestructive`).
    public var color: Color {
        switch self {
        case .success:
            return Color.colorSuccess
        case .failure:
            return Color.colorDestructive
        }
    }

    /// Nome do SF Symbol exibido ao lado da mensagem.
    public var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .failure:
            return "exclamationmark.circle.fill"
        }
    }

    var accessibilityPrefix: String {
        switch self {
        case .success:
            return String(localized: "accessibilitySuccess", bundle: .module)
        case .failure:
            return String(localized: "accessibilityError", bundle: .module)
        }
    }
}

/// Rótulo de feedback com ícone semântico colorido.
///
/// Exibe uma mensagem acompanhada de um ícone que indica o resultado de uma
/// ação ou validação. Usado principalmente abaixo de campos de formulário.
///
/// ```swift
/// DSFeedbackLabel(message: "E-mail inválido.", tone: .failure)
/// DSFeedbackLabel(message: "Dados salvos com sucesso.", tone: .success)
/// ```
///
/// - SeeAlso: `DSErrorLabel`, `DSSuccessLabel`
public struct DSFeedbackLabel: View {
    /// Texto descritivo exibido ao lado do ícone.
    let message: String
    /// Tom semântico que define cor e ícone.
    let tone: DSFeedbackTone

    /// Cria um `DSFeedbackLabel`.
    /// - Parameters:
    ///   - message: Texto da mensagem de feedback.
    ///   - tone: Tom semântico (`.success` ou `.failure`).
    public init(message: String, tone: DSFeedbackTone) {
        self.message = message
        self.tone = tone
    }

    public var body: some View {
        Label {
            Text(message)
        } icon: {
            Image(systemName: tone.iconName)
                .accessibilityHidden(true)
        }
        .font(.caption)
        .foregroundStyle(tone.color)
        .accessibilityLabel("\(tone.accessibilityPrefix): \(message)")
    }
}

/// Atalho para `DSFeedbackLabel(message:tone:.success)`.
///
/// ```swift
/// DSSuccessLabel(message: "Nome preenchido corretamente.")
/// ```
public struct DSSuccessLabel: View {
    let message: String

    /// Cria um `DSSuccessLabel`.
    /// - Parameter message: Texto da mensagem de sucesso.
    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        DSFeedbackLabel(message: message, tone: .success)
    }
}