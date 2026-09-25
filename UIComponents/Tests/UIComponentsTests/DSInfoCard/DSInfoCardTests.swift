import XCTest
import SwiftUI
@testable import UIComponents

final class DSInfoCardTests: XCTestCase {
    func test_init_defaultValues() {
        let sut = DSInfoCard(title: "Quando") {
            Text("Test Content")
        }
        
        XCTAssertEqual(sut.title, "Quando")
        XCTAssertEqual(sut.alignment, .leading)
        XCTAssertNil(sut.background)  // Should be nil to trigger fallback (Color.paper) in body
        XCTAssertNil(sut.borderColor) // Should be nil to trigger fallback (Color.line) in body
    }

    func test_init_customValues() {
        let customBackground = Color.red
        let customBorderColor = Color.blue
        
        let sut = DSInfoCard(
            title: "Onde",
            alignment: .center,
            background: customBackground,
            borderColor: customBorderColor
        ) {
            Text("Custom Content")
        }
        
        XCTAssertEqual(sut.title, "Onde")
        XCTAssertEqual(sut.alignment, .center)
        XCTAssertEqual(sut.background, customBackground)
        XCTAssertEqual(sut.borderColor, customBorderColor)
    }
}
