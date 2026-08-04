import SwiftUI

// MARK: - DSResendButton

/// Ação de reenviar um código, com espera (_cooldown_) entre as tentativas.
///
/// Alterna entre dois estados:
/// - **Esperando** (`secondsRemaining > 0`): mostra um texto discreto com a
///   contagem regressiva e não é tocável.
/// - **Disponível** (`secondsRemaining == 0`): mostra um botão na cor da marca.
///   Durante `isLoading` o botão vira um indicador de progresso e fica desabilitado.
///
/// O componente é puramente visual: quem controla a contagem é a tela, que passa
/// `secondsRemaining` a cada segundo. Isso mantém o cronômetro junto das regras de
/// negócio (limite de envios, o que fazer ao falhar) em vez de escondê-lo na UI.
///
/// ```swift
/// DSResendButton(
///     secondsRemaining: viewModel.resendCooldown,
///     isLoading: viewModel.isResending,
///     title: "Reenviar e-mail"
/// ) {
///     Task { await viewModel.resend() }
/// }
/// ```
///
/// ## Acessibilidade
/// Durante a espera, o VoiceOver lê a contagem por extenso ("Aguarde 45 segundos…")
/// em vez do texto abreviado. Enquanto envia, anuncia o estado de carregamento.
public struct DSResendButton: View {

    /// Segundos restantes até liberar o reenvio. `0` (ou menos) libera o botão.
    let secondsRemaining: Int
    /// Indica que o reenvio está em andamento — troca o rótulo por um progresso.
    let isLoading: Bool
    /// Rótulo do botão quando o reenvio está disponível.
    var title: String
    /// Dica de acessibilidade do botão.
    var accessibilityHint: String?
    /// Executado ao tocar no botão.
    let action: () -> Void

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSResendButton`.
    /// - Parameters:
    ///   - secondsRemaining: Segundos restantes de espera. Valores negativos
    ///     são tratados como `0`. Padrão: `0` (disponível).
    ///   - isLoading: Se o reenvio está em andamento. Padrão: `false`.
    ///   - title: Rótulo do botão. Quando `nil`, usa a string localizada
    ///     `"resendButtonTitle"` (ex.: _"Reenviar código"_).
    ///   - accessibilityHint: Dica lida pelo VoiceOver. Opcional.
    ///   - action: Ação executada ao tocar.
    public init(
        secondsRemaining: Int = 0,
        isLoading: Bool = false,
        title: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.secondsRemaining = max(0, secondsRemaining)
        self.isLoading = isLoading
        self.title = title ?? String(localized: "resendButtonTitle", bundle: .module)
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    private var isWaiting: Bool { secondsRemaining > 0 }

    public var body: some View {
        if isWaiting {
            Text(
                String(
                    format: String(localized: "resendCooldown", bundle: .module),
                    Int64(secondsRemaining)
                )
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
            .accessibilityLabel(
                String(
                    format: String(localized: "resendCooldownAccessibility", bundle: .module),
                    Int64(secondsRemaining)
                )
            )
        } else {
            Button(action: action) {
                if isLoading {
                    ProgressView()
                        .tint(theme.brandColor)
                } else {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(theme.brandColor)
                }
            }
            .disabled(isLoading)
            .accessibilityLabel(
                isLoading
                    ? String(localized: "resendLoading", bundle: .module)
                    : title
            )
            .accessibilityHint(accessibilityHint ?? "")
        }
    }
}
