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
}
