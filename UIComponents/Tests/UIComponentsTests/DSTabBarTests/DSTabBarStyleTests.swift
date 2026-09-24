import SwiftUI
import Testing
@testable import UIComponents

struct DSTabBarStyleTests {

    @Test("Default style uses the Fast Nails tokens")
    func defaultTokens() {
        let style = DSTabBarStyle.default
        #expect(style.selectedColor == DSColor.legacyBrand)
        #expect(style.unselectedColor == DSColor.legacyContentTertiary)
        #expect(style.background == DSColor.surface)
        #expect(style.dividerColor == DSColor.divider)
    }

    @Test("Custom values override only what is passed")
    func customOverrides() {
        let style = DSTabBarStyle(selectedColor: .indigo)
        #expect(style.selectedColor == .indigo)
        // Untouched tokens keep their defaults.
        #expect(style.unselectedColor == DSColor.legacyContentTertiary)
        #expect(style.background == DSColor.surface)
        #expect(style.dividerColor == DSColor.divider)
    }

    @Test("Divider can be removed with nil")
    func dividerCanBeHidden() {
        let style = DSTabBarStyle(dividerColor: nil)
        #expect(style.dividerColor == nil)
    }
}
