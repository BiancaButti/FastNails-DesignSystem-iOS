import XCTest
import SwiftUI
@testable import UIComponents

final class DSTimeSlotPickerTests: XCTestCase {
    
    func test_init_withValidSlots_createsComponentSuccessfully() {
        // Given
        let expectedTitle = "TARDE"
        let mockedSlots = [
            DSTimeSlotPickerItem(time: "13:00", isAvailable: false),
            DSTimeSlotPickerItem(time: "16:00", isSelected: true)
        ]
        
        // When
        let sut = DSTimeSlotPicker(sectionTitle: expectedTitle, slots: mockedSlots) { _ in }
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func test_timeSlotAction_triggersSelectionCallback() {
        // Given
        let expectedTitle = "MANHÃ"
        let targetSlot = DSTimeSlotPickerItem(time: "09:00", isAvailable: true)
        let expectation = self.expectation(description: "Slot selection block must execute")
        
        let sut = DSTimeSlotPicker(sectionTitle: expectedTitle, slots: [targetSlot]) { selectedSlot in
            // Then
            XCTAssertEqual(selectedSlot.id, targetSlot.id)
            XCTAssertEqual(selectedSlot.time, "09:00")
            XCTAssertTrue(selectedSlot.isAvailable)
            expectation.fulfill()
        }
        
        // When
        sut.onSlotSelected(targetSlot)
        
        waitForExpectations(timeout: 0.1)
    }
}
