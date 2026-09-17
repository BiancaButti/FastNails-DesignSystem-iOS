import Testing
import SwiftUI
@testable import UIComponents

struct DSTextFieldTests {

    @Test("TextField receive keyboard to insert email")
    func enabledKeyboardToWriteEmail() {
        #expect(DSTextFieldStyle.email.keyboardType == .emailAddress)
    }

    @Test("TextField receive keyboard to insert address")
    func enabledKeyboardToWriteAddress() {
        #expect(DSTextFieldStyle.address.keyboardType == .default)
    }
    
    @Test("TextField receive keyboard to insert telephone")
    func enabledKeyboardToWriteTelephone() {
        #expect(DSTextFieldStyle.telephone.keyboardType == .numberPad)
    }
    
    @Test("TextField receive keyboard to insert name")
    func enabledKeyboardToWriteName() {
        #expect(DSTextFieldStyle.name.keyboardType == .default)
    }

    @Test("Password requirements unmet below 8 characters")
    func passwordUnmetBelowMinimum() {
        #expect(DSTextField.passwordRequirementsMet(for: "1234567") == false)
    }

    @Test("Password requirements unmet between 8 and 11 characters")
    func passwordUnmetBelowStrong() {
        #expect(DSTextField.passwordRequirementsMet(for: "12345678") == false)
        #expect(DSTextField.passwordRequirementsMet(for: "12345678901") == false)
    }

    @Test("Password requirements met at 12 characters")
    func passwordMetAtTwelve() {
        #expect(DSTextField.passwordRequirementsMet(for: "123456789012") == true)
    }

    @Test("Password requirements met above 12 characters")
    func passwordMetAboveTwelve() {
        #expect(DSTextField.passwordRequirementsMet(for: "1234567890123456") == true)
    }

    @Test("Empty password does not meet requirements")
    func passwordEmptyUnmet() {
        #expect(DSTextField.passwordRequirementsMet(for: "") == false)
    }
}
