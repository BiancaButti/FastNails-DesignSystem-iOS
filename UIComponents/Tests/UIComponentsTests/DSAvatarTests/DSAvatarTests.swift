import XCTest
import SwiftUI
@testable import UIComponents

final class DSAvatarTests: XCTestCase {

    // MARK: - Initializer & Normalization Tests

    /// Tests if the initializer successfully normalizes a lowercase character to uppercase.
    func test_init_convertsInitialToUppercase() {
        let sut = DSAvatar(initial: "b")
        
        XCTAssertEqual(sut.initial, "B")
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.size, 48) // Verifies default size token is 48 pt
    }

    /// Tests if strings with multiple characters are safely truncated to the first letter only.
    func test_init_truncatesLongStringToOneCharacter() {
        let sut = DSAvatar(initial: "Bruna")
        
        XCTAssertEqual(sut.initial, "B")
    }

    /// Tests if empty strings or white spaces fallback safely to a question mark placeholder.
    func test_init_handlesEmptyWhitespaceSafely() {
        let sutEmpty = DSAvatar(initial: "   ")
        let sutVoid = DSAvatar(initial: "")
        
        XCTAssertEqual(sutEmpty.initial, "?")
        XCTAssertEqual(sutVoid.initial, "?")
    }

    /// Tests if custom size parameters are retained correctly.
    func test_init_retainsCustomSize() {
        let sut = DSAvatar(initial: "A", size: 64)
        
        XCTAssertEqual(sut.size, 64)
    }

    // MARK: - Image State Tests

    /// Tests if passing an optional Image retains the object property correctly.
    func test_init_retainsOptionalImageProperty() {
        // Uses a native system symbol image for testing encapsulation
        let testImage = Image(systemName: "person.fill")
        let sut = DSAvatar(initial: "B", image: testImage)
        
        XCTAssertNotNil(sut.image)
        XCTAssertEqual(sut.initial, "B") // Ensure placeholder value is still kept as fallback data
    }
    
    /// Tests that the default image state is absolutely nil when not provided.
    func test_init_defaultImagePropertyIsNil() {
        let sut = DSAvatar(initial: "B")
        
        XCTAssertNil(sut.image)
    }
}
