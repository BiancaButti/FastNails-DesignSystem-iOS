import Testing
@testable import UIComponents

struct DSFilterChipTests {

    @Test("Filter chip preserves its label")
    func preservesLabel() {
        let item = DSFilterChipItem(
            id: "hands",
            label: "Mãos",
            isActive: true,
            onTap: {}
        )

        #expect(item.label == "Mãos")
    }

    @Test("Filter chip preserves its active state")
    func preservesActiveState() {
        let active = DSFilterChipItem(
            id: "hands",
            label: "Mãos",
            isActive: true,
            onTap: {}
        )

        let inactive = DSFilterChipItem(
            id: "salon",
            label: "Salão",
            isActive: false,
            onTap: {}
        )

        #expect(active.isActive)
        #expect(!inactive.isActive)
    }

    @Test("Filter chip preserves its system image")
    func preservesSystemImage() {
        let item = DSFilterChipItem(
            id: "accessible",
            label: "Acessível",
            isActive: false,
            systemImage: "accessibility",
            onTap: {}
        )

        #expect(item.systemImage == "accessibility")
    }

    @Test("Filter chip system image is optional")
    func systemImageIsOptional() {
        let item = DSFilterChipItem(
            id: "hands",
            label: "Mãos",
            isActive: true,
            onTap: {}
        )

        #expect(item.systemImage == nil)
    }

    @Test("Filter chip preserves its identifier")
    func preservesIdentifier() {
        let item = DSFilterChipItem(
            id: "price",
            label: "Até R$ 90",
            isActive: false,
            onTap: {}
        )

        #expect(item.id == "price")
    }
}
