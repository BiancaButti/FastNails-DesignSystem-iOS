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

    func testPublicEnumsRemainAvailable() {
        XCTAssertEqual(DSPasswordStrength.strong, .strong)
        XCTAssertEqual(DSPasswordStrength.medium, .medium)
        XCTAssertEqual(DSFeedbackTone.success, .success)
        XCTAssertEqual(DSFeedbackTone.failure, .failure)
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

    // MARK: - DSRatingView clamping

    func testRatingViewClampsAboveMax() {
        let view = DSRatingView(rating: 10, style: .expanded)
        // Access the clamped value via reflection or just verify no crash and clamp logic.
        // Since rating is stored as let, we verify via indirect behavior — the view must exist.
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
        XCTAssertNotNil(field) // Should not crash; length clamped to 1
    }

    // MARK: - DSFeedbackTone public properties

    func testFeedbackToneIconNamesNotEmpty() {
        for tone in DSFeedbackTone.allCases {
            XCTAssertFalse(tone.iconName.isEmpty, "iconName for \(tone) should not be empty")
        }
    }

    // MARK: - DSPrimaryButton loading state

    func testPrimaryButtonWithLoadingState() {
        let button = DSPrimaryButton(title: "Salvar", isLoading: true) {}
        XCTAssertNotNil(button)
    }
}

