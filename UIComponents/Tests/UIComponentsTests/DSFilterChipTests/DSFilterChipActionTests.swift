import Testing
@testable import UIComponents

struct DSFilterChipActionTests {

    @Test("Filter chip executes its action when triggered")
    func executesAction() {
        var didTap = false

        let item = DSFilterChipItem(
            id: "hands",
            label: "Mãos",
            isActive: false,
            onTap: {
                didTap = true
            }
        )

        item.onTap()

        #expect(didTap)
    }
}
