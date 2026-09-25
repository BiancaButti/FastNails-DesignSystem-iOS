import XCTest
import SwiftUI
@testable import UIComponents

final class DSNoticeCardTests: XCTestCase {

    func test_init_retainsCorrectParametersAndArrayBounds() {
        let items = [
            DSNoticeItem(systemIconName: "star", iconColor: .red, title: "Aviso 1"),
            DSNoticeItem(systemIconName: "heart", iconColor: .blue, title: "Aviso 2")
        ]
        
        let sut = DSNoticeCard(
            title: "Atenção",
            items: items
        )
        
        XCTAssertEqual(sut.title, "Atenção")
        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items.first?.systemIconName, "star")
    }
}
