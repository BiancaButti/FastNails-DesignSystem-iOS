import XCTest
import SwiftUI
@testable import UIComponents

final class DSSummaryCardTests: XCTestCase {
    
    func testInitialization_withAllSlotsProvided_shouldNotBeNil() {
        // Given
        let expectedLabel = "Total no atendimento"
        let expectedPrice = "R$ 100"
        
        // When
        let card = DSSummaryCard(
            totalLabel: expectedLabel,
            totalPrice: expectedPrice
        ) {
            Image(systemName: "house.fill")
        } headerContent: {
            VStack {
                Text("Ela vai até você")
                Text("R. Aurora, 120")
            }
        } detailsContent: {
            VStack {
                Text("Quem: Espaço Camila")
                Text("Quando: Quinta, 03/09")
            }
        }
        
        // Then
        XCTAssertNotNil(card, "DSSummaryCard should initialize successfully when given valid parameters and view builders.")
    }
}
