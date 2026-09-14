import Testing
@testable import UIComponents

struct DSSelectableOptionTests {

    @Test
    func initStoresProvidedValues() {
        let option = SelectableOption(
            id: "hands",
            title: "Hands",
            description: "Manicure, from 30 min"
        )

        #expect(option.id == "hands")
        #expect(option.title == "Hands")
        #expect(option.description == "Manicure, from 30 min")
    }

    @Test
    func optionsWithSameValuesAreEqual() {
        let first = SelectableOption(
            id: "hands",
            title: "Hands",
            description: "Manicure, from 30 min"
        )

        let second = SelectableOption(
            id: "hands",
            title: "Hands",
            description: "Manicure, from 30 min"
        )

        #expect(first == second)
    }

    @Test
    func optionsWithDifferentIdsAreDifferent() {
        let first = SelectableOption(
            id: "hands",
            title: "Hands",
            description: "Manicure, from 30 min"
        )

        let second = SelectableOption(
            id: "feet",
            title: "Hands",
            description: "Manicure, from 30 min"
        )

        #expect(first != second)
    }

    @Test
    func optionCanBeStoredInSet() {
        let hands = SelectableOption(
            id: "hands",
            title: "Hands",
            description: "Manicure, from 30 min"
        )

        let feet = SelectableOption(
            id: "feet",
            title: "Feet",
            description: "Pedicure, from 45 min"
        )

        let options: Set<SelectableOption> = [hands, feet, hands]

        #expect(options.count == 2)
        #expect(options.contains(hands))
        #expect(options.contains(feet))
    }
}
