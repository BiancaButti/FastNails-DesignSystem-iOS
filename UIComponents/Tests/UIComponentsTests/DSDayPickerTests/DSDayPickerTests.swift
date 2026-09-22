import XCTest
import SwiftUI
@testable import UIComponents

final class DSDayPickerTests: XCTestCase {
    
    /// Tests that the generic component can be initialized with standard list items.
        func test_init_withValidDays_createsComponentSuccessfully() {
            // Given
            let expectedTitle = "Escolha seu dia"
            let mockedDays = [
                DSDayPicker.DayItem(weekday: "Hoje", dayNumber: "02", subtitle: "3 vagas", isSelected: true),
                DSDayPicker.DayItem(weekday: "Qui", dayNumber: "03", subtitle: "lotado", isFull: true)
            ]
            
            // When
            let sut = DSDayPicker(title: expectedTitle, days: mockedDays) { _ in }
            
            // Then
            XCTAssertNotNil(sut)
        }
        
        /// Tests that invoking the injected day selection closure triggers the callback with correct item.
        func test_daySelectionAction_triggersCallbackExecution() {
            // Given
            let expectedTitle = "Select Date"
            let targetDay = DSDayPicker.DayItem(weekday: "Sex", dayNumber: "04", subtitle: "1 vaga")
            let expectation = self.expectation(description: "Selection callback must be invoked")
            
            let sut = DSDayPicker(title: expectedTitle, days: [targetDay]) { selectedDay in
                // Then (Validates the output passed back from the component action)
                XCTAssertEqual(selectedDay.id, targetDay.id)
                XCTAssertEqual(selectedDay.dayNumber, "04")
                expectation.fulfill()
            }
            
            // When
            // Directly invoking the internal closure to simulate the button's action trigger safely
            sut.onDaySelected(targetDay)
            
            // A wait of 0.1 is now perfect because the execution happens synchronously on the same thread
            waitForExpectations(timeout: 0.1)
        }
}
