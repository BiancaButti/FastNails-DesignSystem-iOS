import XCTest
import SwiftUI
@testable import UIComponents

final class DSInlineMessageCardTests: XCTestCase {
    
    func testInitialization_withActionTitle_shouldNotBeNil() {
        // Given
        let title = "Onde você está?"
        let description = "Com sua localização, mostramos os salões mais perto."
        let actionTitle = "Informar localização"
        
        // When
        let card = DSInlineMessageCard(
            title: title,
            description: description,
            actionTitle: actionTitle,
            style: .info
        ) {
            Image(systemName: "mappin.and.ellipse")
        } action: {
            // Test action closure
        }
        
        // Then
        XCTAssertNotNil(card, "DSInlineMessageCard should successfully initialize with an action button.")
    }
    
    func testInitialization_withoutActionTitle_shouldNotBeNil() {
        // Given
        let title = "Esse horário acabou de ser reservado"
        let description = "Alguém marcou as 16:00 enquanto você conferia."
        
        // When
        let card = DSInlineMessageCard(
            title: title,
            description: description,
            actionTitle: nil,
            style: .error
        ) {
            Image(systemName: "exclamationmark.triangle")
        }
        
        // Then
        XCTAssertNotNil(card, "DSInlineMessageCard should successfully initialize without an action button.")
    }
    
    /// Validates that the Style mapping returns the exact colors from the Design System tokens.
    func testStyleMapping_shouldReturnCorrectTokens() {
        // Given
        let infoStyle = DSInlineMessageStyle.info
        let warningStyle = DSInlineMessageStyle.warning
        let errorStyle = DSInlineMessageStyle.error
        
        // Then & Expected token verifications
        XCTAssertEqual(infoStyle.backgroundColor, Color.paper, "Info background must map to Color.paper")
        XCTAssertEqual(infoStyle.borderColor, Color.line, "Info border must map to Color.line")
        XCTAssertEqual(infoStyle.actionColor, Color.enamel, "Info action must map to Color.enamel")
        
        XCTAssertEqual(warningStyle.actionColor, Color.amber, "Warning action must map to Color.amber")
        XCTAssertEqual(errorStyle.actionColor, Color.terracota, "Error action must map to Color.terracota")
    }
}
