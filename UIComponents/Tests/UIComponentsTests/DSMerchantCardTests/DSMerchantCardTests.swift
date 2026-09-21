import XCTest
import SwiftUI
@testable import UIComponents

final class DSMerchantCardTests: XCTestCase {
    
    func testInitialization_withAllParameters_shouldNotBeNil() {
        // Given
        let title = "Espaço Camila"
        let subtitle = "A partir de R$ 45"
        let textPrice = "800 m"
        let isCarousel = true
        
        // When
        let card = DSMerchantCard(
            title: title,
            subtitle: subtitle,
            textPrice: textPrice,
            isCarousel: isCarousel
        ) {
            Text("Imagem de Teste")
        } tagsContent: {
            Text("Tag de Teste")
        }
        
        // Then
        XCTAssertNotNil(card, "O componente DSMerchantCard deveria inicializar corretamente.")
    }
    
    func testInitialization_withOptionalTextPriceAsNil_shouldNotBeNil() {
        // Given
        let title = "Studio Ana Lima"
        let subtitle = "A partir de R$ 35"
        
        // When
        let card = DSMerchantCard(
            title: title,
            subtitle: subtitle,
            textPrice: nil, // Parâmetro opcional
            isCarousel: false
        ) {
            Text("Imagem")
        } tagsContent: {
            Text("Tag")
        }
        
        // Then
        XCTAssertNotNil(card, "O componente deveria inicializar mesmo com o textPrice sendo nulo.")
    }
}
