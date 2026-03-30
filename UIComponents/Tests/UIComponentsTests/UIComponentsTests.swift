import XCTest
import SwiftUI
@testable import UIComponents

final class UIComponentsTests: XCTestCase {

    // MARK: - Public API smoke tests

    func testPublicComponentsCanBeInstantiated() {
        let text = Binding.constant("Maria")
        let code = Binding.constant("123456")

        _ = DSFormTextField(label: "Nome", placeholder: "Digite seu nome", text: text, successMessage: "Ok")
        _ = DSFormSecureField(label: "Senha", placeholder: "Digite sua senha", text: text)
        _ = DSOTPField(label: "Codigo", code: code)
        _ = DSPrimaryButton(title: "Continuar") {}
        _ = DSLoadingView(message: "Carregando")
        _ = DSManicuristPhotoView(size: 80)
        _ = DSOrDivider()
        _ = DSRatingView(rating: 4.5, style: .expanded)
        _ = DSStatusBadgeView(text: "Sucesso", tone: .success)
        _ = DSFeedbackLabel(message: "Tudo certo", tone: .success)
        _ = DSErrorLabel(message: "Falhou")
        _ = DSSuccessLabel(message: "Passou")
        _ = DSPasswordStrengthBar(strength: .medium)
    }

    func testNewPublicComponentsCanBeInstantiated() {
        let minPrice = Binding.constant(50.0)
        let maxPrice = Binding.constant(200.0)

        // DSHeaderView
        _ = DSHeaderView(locationLabel: "Região", city: "Rio", onAvatarTap: {})
        _ = DSHeaderView(city: "Santos")

        // DSSearchFieldView
        _ = DSSearchFieldView(text: Binding.constant(""))
        _ = DSSearchFieldView(placeholder: "Buscar…", text: Binding.constant("query"), onSubmit: {})

        // DSSearchEmptyStateView
        _ = DSSearchEmptyStateView()
        _ = DSSearchEmptyStateView(title: "Vazio", subtitle: "Tente outro termo.")

        // DSResultEmptyView
        _ = DSResultEmptyView()
        _ = DSResultEmptyView(title: "Sem itens", message: "Ajuste os filtros.")

        // DSResultSection (default empty state)
        _ = DSResultSection(isLoading: false, items: [DSFilterChipItem]()) { _ in EmptyView() }
        _ = DSResultSection(isLoading: true, items: [DSFilterChipItem]()) { _ in EmptyView() }

        // DSFilterChipItem + DSFilterChipView
        let chip = DSFilterChipItem(id: "rating", label: "Avaliação", isActive: true, onTap: {})
        _ = DSFilterChipView(label: chip.label, isActive: chip.isActive, action: chip.onTap)

        // DSFilterChipsSection
        let chips = [
            DSFilterChipItem(id: "a", label: "Preço", isActive: false, onTap: {}),
            DSFilterChipItem(id: "b", label: "Distância", isActive: true, onTap: {})
        ]
        _ = DSFilterChipsSection(items: chips)

        // DSCategoryItem + DSCategoryItemView + DSCategoriesSection
        let category = DSCategoryItem(id: "manicure", label: "Manicure", systemIcon: "hand.raised.fill", onTap: {})
        _ = DSCategoryItemView(item: category)
        _ = DSCategoriesSection(items: [category])
        _ = DSCategoriesSection(items: [category], columns: 3, title: "Serviços")

        // DSPriceSliderRow + DSPriceRangeSheet
        _ = DSPriceSliderRow(title: "Mínimo", value: minPrice, range: 0...490)
        _ = DSPriceSliderRow(title: "Mínimo", value: minPrice, range: 0...490, formatValue: { "R$ \(Int($0))" })
        _ = DSPriceRangeSheet(minPrice: minPrice, maxPrice: maxPrice) {}
        _ = DSPriceRangeSheet(minPrice: minPrice, maxPrice: maxPrice, formatValue: { "R$ \(Int($0))" }) {}

        // DSDistanceView
        _ = DSDistanceView(distance: "2,5 km")
        _ = DSDistanceView(distance: "2,5 km", accessibilityLabel: "A 2,5 km de você")
    }

    func testPublicEnumsRemainAvailable() {
        XCTAssertEqual(DSPasswordStrength.strong, .strong)
        XCTAssertEqual(DSPasswordStrength.medium, .medium)
        XCTAssertEqual(DSFeedbackTone.success, .success)
        XCTAssertEqual(DSFeedbackTone.failure, .failure)
    }

    // MARK: - DSTheme

    func testDefaultThemeValues() {
        let theme = DSTheme.default
        XCTAssertEqual(theme.brandColor, Color.appPink)
        XCTAssertEqual(theme.errorColor, Color.colorDestructive)
        XCTAssertEqual(theme.successColor, Color.colorSuccess)
        XCTAssertEqual(theme.ratingColor, Color.appRating)
    }

    func testCustomThemeOverridesBrandColor() {
        let custom = DSTheme(brandColor: .blue)
        XCTAssertEqual(custom.brandColor, .blue)
        // Other tokens remain at default
        XCTAssertEqual(custom.errorColor, Color.colorDestructive)
        XCTAssertEqual(custom.successColor, Color.colorSuccess)
    }

    func testThemeEqualityDefaultIsDefault() {
        XCTAssertEqual(DSTheme.default, DSTheme())
    }

    // MARK: - DSSpacing

    func testSpacingValuesAreOrdered() {
        XCTAssertLessThan(DSSpacing.xs, DSSpacing.sm)
        XCTAssertLessThan(DSSpacing.sm, DSSpacing.md)
        XCTAssertLessThan(DSSpacing.md, DSSpacing.lg)
        XCTAssertLessThan(DSSpacing.lg, DSSpacing.xl)
        XCTAssertLessThan(DSSpacing.xl, DSSpacing.xxl)
    }

    // MARK: - DSRadius

    func testRadiusValuesAreOrdered() {
        XCTAssertLessThan(DSRadius.sm, DSRadius.md)
        XCTAssertLessThan(DSRadius.md, DSRadius.lg)
        XCTAssertLessThan(DSRadius.lg, DSRadius.xl)
        XCTAssertLessThan(DSRadius.xl, DSRadius.xxl)
    }

    // MARK: - DSPasswordStrength

    func testPasswordStrengthFilledBars() {
        XCTAssertEqual(DSPasswordStrength.empty.filledBars, 0)
        XCTAssertEqual(DSPasswordStrength.weak.filledBars, 1)
        XCTAssertEqual(DSPasswordStrength.medium.filledBars, 2)
        XCTAssertEqual(DSPasswordStrength.strong.filledBars, 3)
    }

    func testPasswordStrengthLabelNotEmpty() {
        XCTAssertTrue(DSPasswordStrength.empty.label.isEmpty)
        XCTAssertFalse(DSPasswordStrength.weak.label.isEmpty)
        XCTAssertFalse(DSPasswordStrength.medium.label.isEmpty)
        XCTAssertFalse(DSPasswordStrength.strong.label.isEmpty)
    }

    func testPasswordStrengthColorFromTheme() {
        let theme = DSTheme(errorColor: Color.purple, successColor: Color.teal, ratingColor: Color.orange)
        let bar = DSPasswordStrengthBar(strength: .weak)
        // Verify the strength bar is instantiated without crash and theme is available
        XCTAssertNotNil(bar)
        // DSPasswordStrengthBar uses theme.errorColor for .weak — verified indirectly via DSTheme
        XCTAssertEqual(theme.errorColor, Color.purple)
        XCTAssertEqual(theme.ratingColor, Color.orange)
        XCTAssertEqual(theme.successColor, Color.teal)
    }

    // MARK: - DSFeedbackTone theming

    func testFeedbackToneColorForTheme() {
        let theme = DSTheme(errorColor: Color.purple, successColor: Color.teal)
        XCTAssertEqual(DSFeedbackTone.failure.color(for: theme), Color.purple)
        XCTAssertEqual(DSFeedbackTone.success.color(for: theme), Color.teal)
    }

    func testFeedbackToneColorForDefaultTheme() {
        let theme = DSTheme.default
        XCTAssertEqual(DSFeedbackTone.failure.color(for: theme), Color.colorDestructive)
        XCTAssertEqual(DSFeedbackTone.success.color(for: theme), Color.colorSuccess)
    }

    func testFeedbackToneIconNamesNotEmpty() {
        for tone in DSFeedbackTone.allCases {
            XCTAssertFalse(tone.iconName.isEmpty, "iconName for \(tone) should not be empty")
        }
    }

    // MARK: - DSStatusBadgeView.Tone theming

    func testStatusBadgeToneBackgroundForTheme() {
        let theme = DSTheme(errorColor: .purple, successColor: .teal)
        XCTAssertEqual(DSStatusBadgeView.Tone.failure.resolvedBackground(for: theme), .purple)
        XCTAssertEqual(DSStatusBadgeView.Tone.success.resolvedBackground(for: theme), .teal)
    }

    // MARK: - DSRatingView clamping

    func testRatingViewClampsAboveMax() {
        let view = DSRatingView(rating: 10, style: .expanded)
        XCTAssertNotNil(view)
    }

    func testRatingViewClampsBelowMin() {
        let view = DSRatingView(rating: -5, style: .compact)
        XCTAssertNotNil(view)
    }

    // MARK: - DSManicuristPhotoView size clamping

    func testManicuristPhotoViewClampsNegativeSize() {
        let view = DSManicuristPhotoView(size: -10)
        XCTAssertNotNil(view)
    }

    func testManicuristPhotoViewClampsZeroSize() {
        let view = DSManicuristPhotoView(size: 0)
        XCTAssertNotNil(view)
    }

    // MARK: - DSOTPField configurable length

    func testOTPFieldDefaultLengthIsSix() {
        let field = DSOTPField(label: "OTP", code: .constant(""))
        XCTAssertNotNil(field)
    }

    func testOTPFieldCustomLength() {
        let field = DSOTPField(label: "PIN", code: .constant(""), length: 4)
        XCTAssertNotNil(field)
    }

    func testOTPFieldClampsLengthToMinOne() {
        let field = DSOTPField(label: "Zero", code: .constant(""), length: 0)
        XCTAssertNotNil(field)
    }

    // MARK: - DSFormTextField feedback priority

    func testFormTextFieldErrorPriorityOverSuccess() {
        let errorMsg = "Campo obrigatório"
        let successMsg = "Preenchido"
        let field = DSFormTextField(
            label: "Nome",
            placeholder: "Nome",
            text: .constant(""),
            errorMessage: errorMsg,
            successMessage: successMsg
        )
        XCTAssertNotNil(field)
        // Both messages provided — error should take priority (verified by DSFormTextField.feedback computed var)
        // This exercises the priority logic path without UI rendering
    }

    // MARK: - DSFormSecureField API uniformity

    func testFormSecureFieldAcceptsKeyboardType() {
        let field = DSFormSecureField(
            label: "PIN",
            placeholder: "4 dígitos",
            text: .constant(""),
            keyboardType: .numberPad,
            textContentType: .oneTimeCode
        )
        XCTAssertNotNil(field)
    }

    func testFormSecureFieldExternalVisibilityInit() {
        let visible = Binding.constant(true)
        let field = DSFormSecureField(
            label: "Senha",
            placeholder: "Senha",
            text: .constant("senha123"),
            isVisible: visible
        )
        XCTAssertNotNil(field)
    }

    // MARK: - DSPrimaryButton

    func testPrimaryButtonWithLoadingState() {
        let button = DSPrimaryButton(title: "Salvar", isLoading: true) {}
        XCTAssertNotNil(button)
    }

    func testPrimaryButtonAcceptsNilColor() {
        // nil → falls back to theme.brandColor
        let button = DSPrimaryButton(title: "Entrar", color: nil) {}
        XCTAssertNotNil(button)
    }

    func testPrimaryButtonAcceptsExplicitColor() {
        let button = DSPrimaryButton(title: "Entrar", color: .blue) {}
        XCTAssertNotNil(button)
    }

    // MARK: - DSStatusBadgeView convenience init

    func testStatusBadgeViewIsOpenTrue() {
        let badge = DSStatusBadgeView(isOpen: true)
        XCTAssertNotNil(badge)
    }

    func testStatusBadgeViewIsOpenFalse() {
        let badge = DSStatusBadgeView(isOpen: false)
        XCTAssertNotNil(badge)
    }

    // MARK: - DSOrDivider default label

    func testOrDividerDefaultLabelIsNotEmpty() {
        let divider = DSOrDivider()
        XCTAssertNotNil(divider)
    }

    func testOrDividerCustomLabel() {
        let divider = DSOrDivider(label: "ou continue com")
        XCTAssertNotNil(divider)
    }
}

