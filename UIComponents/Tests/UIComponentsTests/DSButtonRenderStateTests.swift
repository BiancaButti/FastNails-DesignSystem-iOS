import Testing
import SwiftUI
@testable import UIComponents

/// Cobertura da resolução de cores do `DSButton` conforme o estado de interação
/// (habilitado, desabilitado e carregando).
struct DSButtonRenderStateTests {

    private let theme = DSTheme(
        brandColor: .red,
        errorColor: .orange,
        successColor: .green,
        warningColor: .yellow,
        surfaceColor: .white,
        backgroundColor: .gray,
        titleColor: .black,
        secondaryColor: .purple,
        borderColor: .blue
    )

    /// Aparência base de referência (primary/brand: fundo de marca, sem borda).
    private var brandAppearance: DSButtonAppearance {
        DSButtonAppearance(style: .primary, tone: .brand, theme: theme)
    }

    /// Aparência com borda (secondary/brand) para cobrir o caminho de borda.
    private var borderedAppearance: DSButtonAppearance {
        DSButtonAppearance(style: .secondary, tone: .brand, theme: theme)
    }

    // MARK: - Habilitado

    @Test("Habilitado e sem loading mantém as cores base intactas")
    func enabledUsesBaseColors() {
        let render = DSButtonRenderState(
            appearance: borderedAppearance,
            isEnabled: true,
            isLoading: false,
            theme: theme
        )
        #expect(render.background == borderedAppearance.background)
        #expect(render.borderColor == borderedAppearance.borderColor)
        #expect(render.textColor == borderedAppearance.textColor)
    }

    // MARK: - Carregando

    @Test("Carregando reduz a opacidade do fundo, mantendo o texto")
    func loadingDimsBackground() {
        let render = DSButtonRenderState(
            appearance: brandAppearance,
            isEnabled: true,
            isLoading: true,
            theme: theme
        )
        #expect(render.background == brandAppearance.background.opacity(0.6))
        #expect(render.textColor == brandAppearance.textColor)
    }

    @Test("Carregando reduz a opacidade da borda quando ela existe")
    func loadingDimsBorder() {
        let render = DSButtonRenderState(
            appearance: borderedAppearance,
            isEnabled: true,
            isLoading: true,
            theme: theme
        )
        #expect(render.borderColor == borderedAppearance.borderColor?.opacity(0.6))
    }

    @Test("Carregando sem borda base continua sem borda")
    func loadingKeepsNilBorder() {
        let render = DSButtonRenderState(
            appearance: brandAppearance,
            isEnabled: true,
            isLoading: true,
            theme: theme
        )
        #expect(render.borderColor == nil)
    }

    // MARK: - Desabilitado

    @Test("Desabilitado usa fundo esmaecido, sem borda e texto esmaecido")
    func disabledUsesDimmedTokens() {
        let render = DSButtonRenderState(
            appearance: borderedAppearance,
            isEnabled: false,
            isLoading: false,
            theme: theme
        )
        #expect(render.background == theme.secondaryColor.opacity(0.35))
        #expect(render.borderColor == nil)
        #expect(render.textColor == theme.titleColor.opacity(0.45))
    }

    @Test("Desabilitado tem prioridade sobre o loading")
    func disabledOverridesLoading() {
        let disabledLoading = DSButtonRenderState(
            appearance: borderedAppearance,
            isEnabled: false,
            isLoading: true,
            theme: theme
        )
        let disabledOnly = DSButtonRenderState(
            appearance: borderedAppearance,
            isEnabled: false,
            isLoading: false,
            theme: theme
        )
        #expect(disabledLoading == disabledOnly)
    }
}
