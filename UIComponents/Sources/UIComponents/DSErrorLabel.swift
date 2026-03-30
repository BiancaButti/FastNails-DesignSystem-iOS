import SwiftUI

/// Atalho para `DSFeedbackLabel(message:tone:.failure)`.
///
/// ```swift
/// DSErrorLabel(message: "Preencha este campo.")
/// ```
///
/// - SeeAlso: `DSFeedbackLabel`, `DSSuccessLabel`
public struct DSErrorLabel: View {
    let message: String

    /// Cria um `DSErrorLabel`.
    /// - Parameter message: Texto da mensagem de erro.
    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        DSFeedbackLabel(message: message, tone: .failure)
    }
}
