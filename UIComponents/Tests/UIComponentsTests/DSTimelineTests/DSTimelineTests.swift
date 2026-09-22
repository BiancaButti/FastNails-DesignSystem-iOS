import XCTest
import SwiftUI
@testable import UIComponents

final class DSTimelineTests: XCTestCase {
    
    func test_init_withValidSequence_buildsComponentInterface() {
        // Given
        let mockedSteps = [
            DSTimelineStepItem(title: "Step 1", subtitle: "Done", state: .completed),
            DSTimelineStepItem(title: "Step 2", subtitle: "Active", state: .current),
            DSTimelineStepItem(title: "Step 3", subtitle: nil, state: .pending)
        ]
        
        // When
        let sut = DSTimeline(steps: mockedSteps)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func test_stepItemDataModel_retainsCorrectAssignedStates() {
        // Given
        let uuidString = "test-id-123"
        let title = "Pedido Confirmado"
        let subtitle = "10:00"
        
        // When
        let sutItem = DSTimelineStepItem(
            id: uuidString,
            title: title,
            subtitle: subtitle,
            state: .current
        )
        
        // Then
        XCTAssertEqual(sutItem.id, uuidString)
        XCTAssertEqual(sutItem.title, title)
        XCTAssertEqual(sutItem.subtitle, subtitle)
        XCTAssertEqual(sutItem.state, .current)
    }
}
