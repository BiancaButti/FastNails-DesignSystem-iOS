import XCTest
import SwiftUI
@testable import UIComponents

final class DSUserHeaderCardTests: XCTestCase {

    /// Tests if properties passed down to the component retain stability.
    func test_init_retainsCorrectParameters() {
        let sut = DSProfileCard(
            name: "Bianca",
            description: "bianca@email.com",
            avatarInitial: "B"
        )
        
        XCTAssertEqual(sut.name, "Bianca")
        XCTAssertEqual(sut.description, "bianca@email.com")
        XCTAssertEqual(sut.avatarInitial, "B")
        XCTAssertNil(sut.avatarImage)
    }

    /// Tests that the component compiles securely when the optional description is omitted.
    func test_init_handlesOptionalDescriptionAsNil() {
        let sut = DSProfileCard(name: "Pedro", avatarInitial: "P")
        
        XCTAssertNil(sut.description)
    }
}
