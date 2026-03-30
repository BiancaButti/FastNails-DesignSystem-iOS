import SwiftUI

/// Overlay de carregamento com spinner e mensagem de texto.
///
/// Exibe um `ProgressView` circular em tamanho `.large` acompanhado de
/// um texto descritivo. Quando nenhuma mensagem é fornecida, usa a string
/// localizada `"loadingDefault"` (ex.: _"Carregando…"_).
///
/// ```swift
/// DSLoadingView()                            // mensagem padrão
/// DSLoadingView(message: "Salvando dados…") // mensagem personalizada
/// ```
///
/// ## Acessibilidade
/// O componente colapsa sua árvore de acessibilidade em um único elemento com:
/// - `accessibilityLabel`: o texto da mensagem
/// - `.updatesFrequently`: sinaliza ao VoiceOver que o conteúdo pode mudar
public struct DSLoadingView: View {
	/// Texto descritivo exibido abaixo do spinner e lido pelo VoiceOver.
	var message: String

	@Environment(\.dsTheme) private var theme

	/// Cria um `DSLoadingView`.
	/// - Parameter message: Mensagem exibida abaixo do spinner.
	///   Quando `nil`, usa a string localizada `"loadingDefault"`.
	public init(message: String? = nil) {
		self.message = message ?? String(localized: "loadingDefault", bundle: .module)
	}

	public var body: some View {
		VStack(spacing: DSSpacing.md) {
			ProgressView()
				.progressViewStyle(.circular)
				.controlSize(.large)
				.tint(theme.brandColor)

			Text(message)
				.font(theme.feedbackFont)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity)
		.padding(DSSpacing.xl)
		.background(Color.dsSecondarySystemBackground)
		.clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
		.accessibilityElement(children: .ignore)
		.accessibilityLabel(message)
		.accessibilityAddTraits(.updatesFrequently)
	}
}
