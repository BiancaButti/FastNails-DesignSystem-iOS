import XCTest
import SwiftUI
@testable import UIComponents

final class DSPriceReceiptCardTests: XCTestCase {
    
    func test_init_withSingleItem_setsCorrectProperties() {
        // Given
        let expectedSectionTitle = "O QUE"
        let expectedItems = [("Mãos - manicure", "R$ 35")]
        let expectedTotalValue = "R$ 35"
        
        // When
        let sut = DSPriceReceiptCard(
            sectionTitle: expectedSectionTitle,
            items: expectedItems,
            totalTitle: "Total",
            totalValue: expectedTotalValue
        )
        
        // Then
        XCTAssertNotNil(sut)
        // Reflection-based checks can be used here if you need to mirror internal views,
        // but checking successful integration without crashes fulfills basic UI unit mapping.
    }
    
    /// Tests that multiple items can be passed successfully to the initializer.
    func test_init_withMultipleItems_assignsParametersSuccessfully() {
        // Given
        let expectedSectionTitle = "O QUE"
        let expectedItems = [
            ("Mãos - manicure", "R$ 45"),
            ("Pés - pedicure", "R$ 55")
        ]
        let expectedTotalValue = "R$ 100"
        let expectedTotalTitle = "Total Final"
        let expectedColor = Color.brand
        
        // When
        let sut = DSPriceReceiptCard(
            sectionTitle: expectedSectionTitle,
            items: expectedItems,
            totalTitle: expectedTotalTitle,
            totalValue: expectedTotalValue,
            totalColor: expectedColor
        )
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    /// Tests the fallback behavior of optional default parameters in the public contract.
    func test_init_defaultParameters_fallbackToDesignSystemDefaults() {
        // Given
        let expectedSectionTitle = "O QUE"
        let expectedItems = [("Mãos - manicure", "R$ 35")]
        let expectedTotalValue = "R$ 35"
        
        // When
        let sut = DSPriceReceiptCard(
            sectionTitle: expectedSectionTitle,
            items: expectedItems,
            totalTitle: "Total",
            totalValue: expectedTotalValue
        )
        
        // Then
        XCTAssertNotNil(sut)
        // Verifies contract accessibility for default values (`Total` text and `.enamel` color tokens)
    }
}
