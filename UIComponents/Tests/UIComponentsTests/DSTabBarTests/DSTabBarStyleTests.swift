import SwiftUI
import Testing
@testable import UIComponents

struct DSTabBarStyleTests {

    @Test("Default style uses the Fast Nails tokens")
    func defaultTokens() {
        let style = DSTabBarStyle.default
        #expect(style.selectedColor == .brand)
        #expect(style.unselectedColor == .contentTertiary)
        #expect(style.background == .surface)
        #expect(style.dividerColor == .divider)
    }

    @Test("Custom values override only what is passed")
    func customOverrides() {
        let style = DSTabBarStyle(selectedColor: .indigo)
        #expect(style.selectedColor == .indigo)
        // Untouched tokens keep their defaults.
        #expect(style.unselectedColor == .contentTertiary)
        #expect(style.background == .surface)
        #expect(style.dividerColor == .divider)
    }

    @Test("Divider can be removed with nil")
    func dividerCanBeHidden() {
        let style = DSTabBarStyle(dividerColor: nil)
        #expect(style.dividerColor == nil)
    }
}
