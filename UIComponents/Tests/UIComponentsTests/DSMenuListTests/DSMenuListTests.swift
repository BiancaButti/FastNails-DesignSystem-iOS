import XCTest
import SwiftUI
@testable import UIComponents

final class DSMenuListTests: XCTestCase {

    func test_menuRow_retainsInitializationParameters() {
        let expectedTitle = "Endereços salvos"
        let expectedBadge = "5"
        
        let sut = DSMenuRow(
            icon: Image(systemName: "mappin"),
            title: expectedTitle,
            badgeText: expectedBadge,
            showChevron: true
        )
        
        XCTAssertEqual(sut.title, expectedTitle)
        XCTAssertEqual(sut.badgeText, expectedBadge)
        XCTAssertTrue(sut.showChevron)
    }

    func test_menuRow_defaultsChevronToTrueAndBadgeToNil() {
        let sut = DSMenuRow(icon: Image(systemName: "star"), title: "Favoritos")
        
        XCTAssertNil(sut.badgeText)
        XCTAssertTrue(sut.showChevron)
    }

    func test_menuList_retainsSectionTitle() {
        let sut = DSMenuList(sectionTitle: "Segurança") {
            Text("Content")
        }
        
        XCTAssertEqual(sut.sectionTitle, "Segurança")
    }
}
