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
        XCTAssertEqual(sut.spacing, 8)
        XCTAssertEqual(sut.padding, 16)
        XCTAssertEqual(sut.cornerRadius, 16)
        XCTAssertNil(sut.background)  // Should be nil to trigger fallback (Color.paper) in body
        XCTAssertNil(sut.borderColor) // Should be nil to trigger fallback (Color.line) in body
        XCTAssertEqual(sut.borderWidth, 1)
    }

    func test_init_customValues() {
        let customBackground = Color.red
        let customBorderColor = Color.blue
        
        let sut = DSInfoCard(
            title: "Onde",
            alignment: .center,
            spacing: 12,
            padding: 20,
            cornerRadius: 24,
            background: customBackground,
            borderColor: customBorderColor,
            borderWidth: 2
        ) {
            Text("Custom Content")
        }
        
        XCTAssertEqual(sut.title, "Onde")
        XCTAssertEqual(sut.alignment, .center)
        XCTAssertEqual(sut.spacing, 12)
        XCTAssertEqual(sut.padding, 20)
        XCTAssertEqual(sut.cornerRadius, 24)
        XCTAssertEqual(sut.background, customBackground)
        XCTAssertEqual(sut.borderColor, customBorderColor)
        XCTAssertEqual(sut.borderWidth, 2)
    }
}
