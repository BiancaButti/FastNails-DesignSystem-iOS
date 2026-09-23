import XCTest
import SwiftUI
@testable import UIComponents

final class DSUserHeaderCardTests: XCTestCase {

    /// Tests if properties passed down to the component retain stability.
    func test_init_retainsCorrectParameters() {
        let sut = DSProfileCard(
            name: "Bianca",
            description: "bianca@email.com",
            avatarInitial: "B",
            padding: 12,
            cornerRadius: 16
        )
        
        XCTAssertEqual(sut.name, "Bianca")
        XCTAssertEqual(sut.description, "bianca@email.com")
        XCTAssertEqual(sut.avatarInitial, "B")
        XCTAssertEqual(sut.padding, 12)
        XCTAssertEqual(sut.cornerRadius, 16)
        XCTAssertNil(sut.avatarImage)
    }

    /// Tests that the component compiles securely when the optional description is omitted.
    func test_init_handlesOptionalDescriptionAsNil() {
        let sut = DSProfileCard(name: "Pedro", avatarInitial: "P")
        
        XCTAssertNil(sut.description)
    }
}
