import Testing
import SwiftUI
@testable import UIComponents

/// Cobertura completa da resolução de aparência do `DSButton`.
///
/// `DSButtonAppearance` traduz cada combinação de `DSButtonAppearance` × `DSButtonTone`
/// nos tokens do `DSTheme` (fundo, cor de texto e borda). Os testes usam um tema
/// com cores propositalmente distintas para que cada asserção seja inequívoca.
struct DSButtonAppearanceTests {

    /// Tema com cores distintas em cada slot, evitando falsos positivos por
    /// coincidência de valores.
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

    // MARK: - Primary

    @Test("Primary/brand: fundo de marca, texto branco, sem borda")
    func primaryBrand() {
        let a = DSButtonAppearance(style: .primary, tone: .brand, theme: theme)
        #expect(a.background == theme.brandColor)
        #expect(a.textColor == .white)
        #expect(a.borderColor == nil)
    }

    @Test("Primary/neutral: fundo com a cor de título, texto branco, sem borda")
    func primaryNeutral() {
        let a = DSButtonAppearance(style: .primary, tone: .neutral, theme: theme)
        #expect(a.background == theme.titleColor)
        #expect(a.textColor == .white)
        #expect(a.borderColor == nil)
    }

    @Test("Primary/destructive: inverte para superfície com texto e borda de erro")
    func primaryDestructive() {
        let a = DSButtonAppearance(style: .primary, tone: .destructive, theme: theme)
        #expect(a.background == theme.surfaceColor)
        #expect(a.textColor == theme.errorColor)
        #expect(a.borderColor == theme.errorColor)
    }

    // MARK: - Secondary

    @Test("Secondary/brand: superfície, texto de marca, borda de marca")
    func secondaryBrand() {
        let a = DSButtonAppearance(style: .secondary, tone: .brand, theme: theme)
        #expect(a.background == theme.surfaceColor)
        #expect(a.textColor == theme.brandColor)
        #expect(a.borderColor == theme.brandColor)
    }

    @Test("Secondary/neutral: superfície, texto de título, borda padrão do tema")
    func secondaryNeutral() {
        let a = DSButtonAppearance(style: .secondary, tone: .neutral, theme: theme)
        #expect(a.background == theme.surfaceColor)
        #expect(a.textColor == theme.titleColor)
        #expect(a.borderColor == theme.borderColor)
    }

    @Test("Secondary/destructive: superfície, texto e borda de erro")
    func secondaryDestructive() {
        let a = DSButtonAppearance(style: .secondary, tone: .destructive, theme: theme)
        #expect(a.background == theme.surfaceColor)
        #expect(a.textColor == theme.errorColor)
        #expect(a.borderColor == theme.errorColor)
    }

    // MARK: - Tertiary

    @Test("Tertiary/brand: transparente, texto de marca, sem borda")
    func tertiaryBrand() {
        let a = DSButtonAppearance(style: .tertiary, tone: .brand, theme: theme)
        #expect(a.background == .clear)
        #expect(a.textColor == theme.brandColor)
        #expect(a.borderColor == nil)
    }

    @Test("Tertiary/neutral: transparente, texto secundário, sem borda")
    func tertiaryNeutral() {
        let a = DSButtonAppearance(style: .tertiary, tone: .neutral, theme: theme)
        #expect(a.background == .clear)
        #expect(a.textColor == theme.secondaryColor)
        #expect(a.borderColor == nil)
    }

    @Test("Tertiary/destructive: transparente, texto de erro, sem borda")
    func tertiaryDestructive() {
        let a = DSButtonAppearance(style: .tertiary, tone: .destructive, theme: theme)
        #expect(a.background == .clear)
        #expect(a.textColor == theme.errorColor)
        #expect(a.borderColor == nil)
    }

    // MARK: - Invariantes de estilo

    @Test("Tertiary nunca tem borda, em qualquer tom", arguments: [DSButtonTone.brand, .neutral, .destructive])
    func tertiaryNeverHasBorder(tone: DSButtonTone) {
        let a = DSButtonAppearance(style: .tertiary, tone: tone, theme: theme)
        #expect(a.borderColor == nil)
    }

    @Test("Tertiary é sempre transparente, em qualquer tom", arguments: [DSButtonTone.brand, .neutral, .destructive])
    func tertiaryAlwaysClear(tone: DSButtonTone) {
        let a = DSButtonAppearance(style: .tertiary, tone: tone, theme: theme)
        #expect(a.background == .clear)
    }

    @Test("Secondary sempre usa a superfície como fundo, em qualquer tom", arguments: [DSButtonTone.brand, .neutral, .destructive])
    func secondaryAlwaysSurface(tone: DSButtonTone) {
        let a = DSButtonAppearance(style: .secondary, tone: tone, theme: theme)
        #expect(a.background == theme.surfaceColor)
    }
}
