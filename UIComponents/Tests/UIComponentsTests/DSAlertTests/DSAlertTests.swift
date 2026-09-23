import XCTest
import SwiftUI
@testable import UIComponents

final class DSAlertTests: XCTestCase {

    func test_init_retainsInitializationParametersAndDestructiveToken() {
        let expectedTitle = "Deletar?"
        let expectedMessage = "Essa ação é irreversível."
        
        let sut = DSAlert(
            title: expectedTitle,
            message: expectedMessage,
            primaryButtonTitle: "Voltar",
            secondaryButtonTitle: "Apagar",
            isSecondaryDestructive: true,
            primaryAction: {},
            secondaryAction: {}
        )
        
        XCTAssertEqual(sut.title, expectedTitle)
        XCTAssertEqual(sut.message, expectedMessage)
        XCTAssertEqual(sut.primaryButtonTitle, "Voltar")
        XCTAssertEqual(sut.secondaryButtonTitle, "Apagar")
        XCTAssertTrue(sut.isSecondaryDestructive)
    }

    func test_init_defaultsDestructiveTokenToTrue() {
        let sut = DSAlert(
            title: "Título",
            message: "Mensagem",
            primaryButtonTitle: "A",
            secondaryButtonTitle: "B",
            primaryAction: {},
            secondaryAction: {}
        )
        
        XCTAssertTrue(sut.isSecondaryDestructive)
    }
}
