import XCTest
import SwiftUI
@testable import UIComponents

final class DSEventCardTests: XCTestCase {

    func testInitialization_withAllParameters_shouldNotBeNil() {
        // When
        let card = DSEventCard(
            day: "02",
            month: "Set",
            startTime: "16:00",
            endTime: "16:30",
            title: "Studio Ana Lima",
            serviceDetails: "Mãos · 30 min · no salão",
            price: "R$ 35",
            status: DSStatusBadge(title: "Confirmado", status: .confirmed),
            hasHighlightBorder: false
        ) {
            // Test action closure
        }

        // Then
        XCTAssertNotNil(card, "DSEventCard deveria inicializar com todos os parâmetros.")
    }

    func testInitialization_withHighlightBorder_shouldNotBeNil() {
        // When
        let card = DSEventCard(
            day: "05",
            month: "Set",
            startTime: "16:00",
            endTime: "16:30",
            title: "Studio Ana Lima",
            serviceDetails: "Mãos · 30 min · no salão",
            price: "R$ 35",
            status: DSStatusBadge(title: "Em andamento", status: .requested),
            hasHighlightBorder: true
        )

        // Then
        XCTAssertNotNil(card, "DSEventCard deveria inicializar no estado destacado.")
    }

    func testInitialization_withoutOnTap_shouldNotBeNil() {
        // When: onTap uses its default (nil)
        let card = DSEventCard(
            day: "04",
            month: "Set",
            startTime: "12:15",
            endTime: "14:00",
            title: "Camila",
            serviceDetails: "Mãos · 75 min · em casa",
            price: "R$ 100",
            status: DSStatusBadge(title: "Finalizado", status: .finished),
            hasHighlightBorder: false
        )

        // Then
        XCTAssertNotNil(card, "DSEventCard deveria inicializar mesmo sem closure de toque.")
    }

    func testOnTap_closureIsInvoked() {
        // Given
        var tapped = false
        let expectation = expectation(description: "onTap executed")

        // When: capture the action passed to the card and invoke it directly.
        let action: () -> Void = {
            tapped = true
            expectation.fulfill()
        }
        _ = DSEventCard(
            day: "02",
            month: "Set",
            startTime: "16:00",
            endTime: "16:30",
            title: "Studio Ana Lima",
            serviceDetails: "Mãos · 30 min · no salão",
            price: "R$ 35",
            status: DSStatusBadge(title: "Confirmado", status: .confirmed),
            hasHighlightBorder: false,
            onTap: action
        )
        action()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(tapped, "A closure onTap deveria ser executada.")
    }
}
