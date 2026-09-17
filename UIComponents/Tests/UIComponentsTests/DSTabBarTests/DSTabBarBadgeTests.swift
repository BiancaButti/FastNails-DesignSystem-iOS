import Testing
@testable import UIComponents

struct DSTabBarBadgeTests {

    // MARK: Display text

    @Test("No display text without a positive count")
    func displayTextHiddenWhenEmpty() {
        #expect(DSTabBarBadge.displayText(nil) == nil)
        #expect(DSTabBarBadge.displayText(0) == nil)
        #expect(DSTabBarBadge.displayText(-3) == nil)
    }

    @Test("Display text shows the raw count up to 99")
    func displayTextShowsCount() {
        #expect(DSTabBarBadge.displayText(1) == "1")
        #expect(DSTabBarBadge.displayText(99) == "99")
    }

    @Test("Display text caps at 99+")
    func displayTextCaps() {
        #expect(DSTabBarBadge.displayText(100) == "99+")
        #expect(DSTabBarBadge.displayText(1000) == "99+")
    }

    // MARK: Accessibility value

    @Test("No accessibility value without a positive count")
    func accessibilityValueHiddenWhenEmpty() {
        #expect(DSTabBarBadge.accessibilityValue(nil) == nil)
        #expect(DSTabBarBadge.accessibilityValue(0) == nil)
        #expect(DSTabBarBadge.accessibilityValue(-1) == nil)
    }

    @Test("Accessibility value uses the singular for one")
    func accessibilityValueSingular() {
        #expect(DSTabBarBadge.accessibilityValue(1) == "1 novo")
    }

    @Test("Accessibility value uses the plural for more than one")
    func accessibilityValuePlural() {
        #expect(DSTabBarBadge.accessibilityValue(2) == "2 novos")
        #expect(DSTabBarBadge.accessibilityValue(150) == "150 novos")
    }
}
