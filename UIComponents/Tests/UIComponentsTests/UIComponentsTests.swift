import XCTest
import SwiftUI
import UIComponents

final class UIComponentsTests: XCTestCase {
    func testPublicComponentsCanBeInstantiated() {
        let text = Binding.constant("Maria")
        let isVisible = Binding.constant(false)
        let code = Binding.constant("123456")

        let formTextField = FormTextField(
            label: "Nome",
            placeholder: "Digite seu nome",
            text: text,
            successMessage: "Ok"
        )
        let formSecureField = FormSecureField(
            label: "Senha",
            placeholder: "Digite sua senha",
            text: text,
            isVisible: isVisible
        )
        let otpField = OTPField(label: "Codigo", code: code)
        let primaryButton = PrimaryButton(title: "Continuar") {}
        let loadingView = LoadingView(message: "Carregando")
        let photoView = ManicuristPhotoView(size: 80)
        let divider = OrDivider()
        let ratingView = RatingView(rating: 4.5, style: .expanded)
        let badge = StatusBadgeView(text: "Sucesso", tone: .success)
        let feedbackLabel = FeedbackLabel(message: "Tudo certo", tone: .success)
        let errorLabel = ErrorLabel(message: "Falhou")
        let successLabel = SuccessLabel(message: "Passou")
        let strengthBar = PasswordStrengthBar(strength: .medium)

        XCTAssertNotNil(formTextField)
        XCTAssertNotNil(formSecureField)
        XCTAssertNotNil(otpField)
        XCTAssertNotNil(primaryButton)
        XCTAssertNotNil(loadingView)
        XCTAssertNotNil(photoView)
        XCTAssertNotNil(divider)
        XCTAssertNotNil(ratingView)
        XCTAssertNotNil(badge)
        XCTAssertNotNil(feedbackLabel)
        XCTAssertNotNil(errorLabel)
        XCTAssertNotNil(successLabel)
        XCTAssertNotNil(strengthBar)
    }

    func testPublicEnumsRemainAvailable() {
        XCTAssertEqual(PasswordStrength.strong, .strong)
        XCTAssertEqual(PasswordStrength.medium, .medium)
        XCTAssertEqual(FeedbackTone.success, .success)
        XCTAssertEqual(FeedbackTone.failure, .failure)
    }
}
